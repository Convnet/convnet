//=================================================================================

//如果使用该模块请保留该注释，如果被修改或编辑请将修改后的代码发送一份给我

//编写：戴琪英

//E_Mail:qiyingdai@163.com

//2000-09-01

//=================================================================================

unit R232Comm;

interface
uses
  Windows,SysUtils;
const
  INITR12COMM_SUCCESS=0;
  INITR12COMM_FAILURE=-1;
var
  bSendFinish:boolean=True;//发送完标志
  iRecvLen:DWORD=0;
  RecvBuff,TempBuff:PChar;
  SendCommand,RecvCommand:String;//发送和接收到的命令
  RecvFinish:BOOL=False;
  RecvBuffInit:BOOL=False;
  SendCommandSuccess:BOOL; //切换台命令被成功发送标志

function  InitR12CommDev(comNo:PChar):String;  //初始化切换台串口，返回状态字符
procedure SwitchR12(WriteBuffer:PChar);//对切换台进行切换函数
procedure SwitchR12Byte(WriteBuffer:Byte);
procedure CommSendNotify;//串口接收到字符事件响应过程
procedure CommRecvNotify; //串口发送缓冲区空事件响应过程
procedure CommWatchThread(var lpdwParam:DWORD);//通信口监视线程
function  ConInfo :String;

implementation
var
  //comMask,comBuf,ComState:Integer;
  dcb:_DCB; //DCB结构用于配置串口，程序中涉及各域含义如下：
            //DWORD DCBlength :DCB结构大小
            //DWORD BaudRate :  波特率
            //DWORD fBinary  : 1 二进制模式
            //DWORD fParity  : 1 进行奇偶校验
            //BYTE  ByteSize: 字符位数 4~8
            //BYTE  Parity:   奇偶校验位 0-4分别表示无、奇、偶、传号、空号校验
            //BYTE  StopBits: 停止位数 0-2分别表示 1、1.5、2个停止位
            //WORD  XonLim ：XON 阈值
            //WORD  XoffLim  XOFF 阈值
            //char  XonChar： XON 字符
            //char  XoffChar: XOFF 字符
            //char  EvtChar:  事件字符
  comStat:_COMSTAT; //COMSTAT结构用于存放有关通信设备的当前信息
                    //程序中涉及各域含义如下：
                    //cbInQue :接收缓冲区中字符个数
                    //cbOutQue:发送缓冲区中字符个数
  dwErrorFlag:LongWord;
  hCommDev,comThreadHwnd:Thandle;//通信串口句柄和通信监视线程句柄
  comMask,comBuf,comState:BOOL;
  read_os,write_os:_OVERLAPPED;  //OVERLAPPED 结构，用于异步操作的Win32函数中
                                //程序中涉及各域含义如下：
                                //DWORD Interval 保留给操作系统使用
                                //DWORD IntervalHigh 保留给操作系统使用
                                //DOWD  hEvent 当I/O操作完成时被设置为有信号状态
                                //的事件；当调用ReadFile和WriteFile函数之前，调
                                //用进程设置该事件
  postRecvEvent,postSendEvent:Thandle;//发送缓冲区空和接收到字符事件句柄
  dwThreadID1:DWORD; //通信监视线程ID号

///串口初始化函数
//该函数主要完成串口初始化设置和通信线程的启动
//入口参数：串口号
//返回值；初始化是否成功的状态字符
function  InitR12CommDev(comNo:PChar) :String;
begin
   ///打开串口
   hCommDev:=CreateFile(comNo,   //串口好
                       GENERIC_READ or GENERIC_WRITE,//对串口以读写方式打开
                       0,
                       nil,
                       OPEN_EXISTING,
                       FILE_ATTRIBUTE_NORMAL or FILE_FLAG_OVERLAPPED,//允许重叠操作
                       0
                       );
   if hCommDev=INVALID_HANDLE_VALUE then
        InitR12CommDev:='切换台通讯端口初始化失败.'
   else
      InitR12CommDev:='切换台通讯端口初始化成功.';
   comMask:=SetCommMask(hCommDev,EV_RXFLAG);//设置事件掩码
   //comBuf:=SetupComm(hCommDev,4096,4096);//设置接收和发送缓冲区大小皆为4096字节
   comBuf:=SetupComm(hCommDev,1,1);//设置接收和发送缓冲区大小皆为4096字节
   if  comBuf=False then
         InitR12CommDev:='切换台通讯端口初始化失败.'
   else
      begin
         InitR12CommDev:='切换台通讯端口初始化成功.';
         //清空缓冲区
         PurgeComm(hCommDev,PURGE_TXABORT or PURGE_RXABORT or
                                      PURGE_TXCLEAR or PURGE_RXCLEAR ) ;
      end;

   //以下对串口进行配置
   dcb.DCBlength:=sizeof(_DCB);
   comState:=GetCommState(hCOmmDev,dcb);  //得到缺省设置
   if  comState=False then
         InitR12CommDev:='切换台通讯端口初始化失败.'
   else
       InitR12CommDev:='切换台通讯端口初始化成功.';
   dcb.BaudRate:=9600;  //波特率 9600
   dcb.ByteSize:=8;//7;  //数据长度7位
   dcb.Parity:=NOPARITY;//ODDPARITY; //校验方式 奇校验
   dcb.StopBits:=ONESTOPBIT; //停止位 1 位

   dcb.Flags := 0;         // Enable fBinary
   dcb.Flags := dcb.Flags or 2;          // Enable parity check
   dcb.XonChar:= chr($00) ;
   dcb.XoffChar:= chr($00) ;
   dcb.XonLim:= 100 ;
   dcb.XoffLim:= 100 ;
   dcb.EvtChar := Char($ff);

   comState:=SetCommState(hCommDev,dcb);  //设置串口
   if comState=False then
         InitR12CommDev:='切换台通讯端口初始化失败.'
   else
      InitR12CommDev:='切换台通讯端口初始化成功.';
     //设置通信接收到字符事件句柄
   postRecvEvent:=CreateEvent(NIL,
                              TRUE,//手工重置事件
                              TRUE, //初始化为有信号状态
                              NIL
                              );
   //设置读异步I/O操作事件句柄
   read_os.hEvent:=CreateEvent(NIL,
                              TRUE,//手工重置事件
                              FALSE, //初始化为无信号状态
                              NIL
                              );
   //设置发送缓冲区空事件句柄
   postSendEvent:=CreateEvent(NIL,
                              TRUE,//手工重置事件
                              TRUE, //初始化为有信号状态
                              NIL);
   //设置写异步I/O操作事件句柄
   write_os.hEvent:=CreateEvent(NIL,
                              TRUE,//手工重置事件
                              FALSE,//初始化为无信号状态
                              NIL);
   //创建通信监视线程
   comThreadHwnd:=CreateThread(NIL,
                         0,
                         @CommWatchThread, //通信线程函数的地址
                         nil,
                         0,   //创建后立即运行
                         dwThreadID1);//通信线程ID号
   if comThreadHwnd=INVALID_HANDLE_VALUE  then
      InitR12CommDev:='INITR12COMM_FAILURE'
   else
      InitR12CommDev:='切换台通讯端口初始化成功.';
end;

///切换台切换控制函数
///输入参数；切换命令字符串
procedure SwitchR12(WriteBuffer:PChar);
var
 dwWriteByte,TxCount:DWORD;
 bl:BOOL;
 dwError:DWORD;

begin
     //WriteBuffer:=chr($0D)+03A00;
     TxCount:=StrLen(WriteBuffer);
     if bSendFinish=True then  //发送缓冲区空发送
     begin
         dwWriteByte:=0;
         bSendFinish:=False;
         bl:=WriteFile(hCommDev,Byte(WriteBuffer^),TxCount,dwWriteByte,@write_os);
         if bl=True then
         begin
          bSendFinish:=True;
          PurgeComm(hCommDev,PURGE_TXCLEAR );//如果发送完成，置缓冲区空标志，并清空缓冲区
         end;
         if bl=False then
         begin
           dwError:=GetLastError();
           if (dwError=ERROR_IO_PENDING) or (dwError=ERROR_IO_INCOMPLETE) then
           begin
             bl:=GetOverLappedResult(hCommDev,
                             write_os,dwWriteByte,TRUE);//如果未发送完命令字符
                                                    //等待发送完成
             if bl=True then
             begin
                bSendFinish:=True;
                PurgeComm(hCommDev,PURGE_TXCLEAR ); //发送完成 置缓冲区空标志，并清空缓冲区
                //Result:=True;
             end;
           end;
         end;
     end;
     //Result:=True;
end;

procedure SwitchR12Byte(WriteBuffer:Byte);
var
 dwWriteByte,TxCount:DWORD;
 bl:BOOL;
 dwError:DWORD;

begin
     //WriteBuffer:=chr($0D)+03A00;
     TxCount:= 1 ;//StrLen(WriteBuffer);
     if bSendFinish=True then  //发送缓冲区空发送
     begin
         dwWriteByte:=0;
         bSendFinish:=False;
         bl:=WriteFile(hCommDev,WriteBuffer,TxCount,dwWriteByte,@write_os);
         if bl=True then
         begin
          bSendFinish:=True;
          PurgeComm(hCommDev,PURGE_TXCLEAR );//如果发送完成，置缓冲区空标志，并清空缓冲区
         end;
         if bl=False then
         begin
           dwError:=GetLastError();
           if (dwError=ERROR_IO_PENDING) or (dwError=ERROR_IO_INCOMPLETE) then
           begin
             bl:=GetOverLappedResult(hCommDev,
                             write_os,dwWriteByte,TRUE);//如果未发送完命令字符
                                                    //等待发送完成
             if bl=True then
             begin
                bSendFinish:=True;
                PurgeComm(hCommDev,PURGE_TXCLEAR ); //发送完成 置缓冲区空标志，并清空缓冲区
                //Result:=True;
             end;
           end;
         end;
     end;
     //Result:=True;
end;

////通信监视线程
procedure CommWatchThread(var lpdwParam:DWORD);
var
    dwTransfer,dwEvtMask,dwError:DWORD;
    os:_OVERLAPPED;
    bl:boolean;

begin
    os.hEvent:=CreateEvent(nil,
                          TRUE,
                          FALSE,
                          NIL);

    comMask:=SetCommMask(hCommDev,EV_RXCHAR or EV_TXEMPTY);//设置监视的事件为接
                                                        //收到字符或发送缓冲区空
    if comMask=True then
    begin
        while True do
        begin
           dwEvtMask:=0;
           bl:=WaitCommEvent(hCommDev,dwEvtMask,@os); //查询所监视的通信事件是否
                                                       //已经发生
           if bl=False then
           begin
             dwError:=GetLastError();
             if dwError=ERROR_IO_PENDING then
                GetOverlappedResult(hCOmmDev,os,dwTransfer,TRUE);//若未监测到通信事件
                                           //则在此等待事件发生
           end;
           //有事件，进行如下处理
           if (dwEvtMask and EV_RXCHAR)=EV_RXCHAR then //判断是否为接收到 字符事件
           begin
              WaitForSingleObject(postRecvEvent,$FFFFFFFF);//等待接收事件句柄为有
                                                      //信号状态
              ResetEvent(postRecvEvent); //置接收事件句柄为无信号状态，以免接收
                                        //缓冲区被覆盖
              CommRecvNotify; //调用接收到字符处理函数
              continue; //处理完接收字符，继续监测通信事件
           end;
           if (dwEvtMask and EV_TXEMPTY)=EV_TXEMPTY then //判断是否为发送缓冲区空事件
           begin
              WaitForSingleObject(postSendEvent,$FFFFFFFF);//等待发送事件句柄为有
                                                           //信号状态
              ResetEvent(postSendEvent); //置发送事件句柄为无信号状态，，以免发送
                                        //缓冲区被覆盖
              CommSendNotify; //调用发送缓冲区空处理函数
              continue;//处理完，继续监测通信事件
           end;
        end;
    end;
    CloseHandle(os.hEvent);
end;

//发送缓冲区空处理过程
procedure CommSendNotify;
begin
    SetEvent(postSendEvent);//置发送事件未有信号状态，以便进行下一次发送
end;

///接收到字符处理函数
procedure CommRecvNotify;
var
     RxCount,dwReadByte:DWORD;
     inData :Byte;
begin
     ClearCommError(hCommDev,dwErrorFlag,@ComStat);
     RxCount:=ComStat.cbInQue; //获取接收缓冲区的字符个数
     if RxCount>0 then
     begin
       if not RecvBuffInit then
       begin
          StrCopy(RecvBuff,'');
          RecvBuffInit:=True;
       end;
       StrCopy(TempBuff,'');
       ReadFile(hCommDev,Byte(TempBuff^),RxCount,dwReadByte,@read_os);//读字符存入
                                                                      //临时缓冲区中
       iRecvLen:=iRecvLen+dwReadByte; //接收到字符个数统计

       if iRecvLen >=1 then
       begin
            inData := Byte(TempBuff^);
            if inData = $D9 then
            begin
                 SendCommandSuccess:=True;  //如果状态一致，则置该标志为真，标志切换成功
            end
            else
            begin
                 SendCommandSuccess:=False;//否则，置该标志为假，表示切换失败
            end;

            iRecvLen:=0;
            StrCopy(RecvBuff,'');
            RecvBuffInit:=False;
            PurgeComm(hCommDev,PURGE_RXCLEAR ); //清空接收缓冲区
       end
    end;
    ////////////////
    SetEvent(postRecvEvent); //置接收事件句柄为有信号状态，以便接收新字符

end;

function ConInfo :String;
begin
     if  SendCommandSuccess =True then
     begin
          Result :=' 切换器联机监测成功！';
     end
     else
     begin
          Result :=' 切换器联机监测失败！';
     end;
end;

{
procedure CommSendNotify;
begin
    SetEvent(postSendEvent);//置发送事件未有信号状态，以便进行下一次发送
end;

///接收到字符处理函数
{procedure CommRecvNotify;
var
     RxCount,dwReadByte:DWORD;
     inData :Byte;
begin
     ClearCommError(hCommDev,dwErrorFlag,@ComStat);
     RxCount:=ComStat.cbInQue; //获取接收缓冲区的字符个数
     if RxCount>0 then
     begin
       if not RecvBuffInit then
       begin
          StrCopy(RecvBuff,);
          RecvBuffInit:=True;
       end;
       StrCopy(TempBuff,);
       ReadFile(hCommDev,Byte(TempBuff^),RxCount,dwReadByte,@read_os);//读字符存入
       //ReadFile(hCommDev,Byte(TempBuff^),RxCount,dwReadByte,@read_os);//读字符存入
                                              //临时缓冲区中
       iRecvLen:=iRecvLen+dwReadByte; //接收到字符个数统计
       {
       if iRecvLen<13 then
       begin
          strcat(Recvbuff,TempBuff); //若接收到的切换台状态字符小于13个，
                          //将临时缓冲区中的字符拷贝到接收命令缓冲区，准备继续读
       end
       else
       begin
         strcat(Recvbuff,TempBuff);
         RecvCommand:=RecvBuff;
         //若接收到13个切换台状态字符进行如下处理
         if (RecvCommand[7]=P)
            and(RecvCommand[8]=SendCommand[7])     //比较读入的切换台端口状态
            and  (RecvCommand[9]=SendCommand[8])   //是否与切换指令中切换的端口
            and (RecvCommand[10]=SendCommand[9])   //一致
            and (RecvCommand[11]=SendCommand[10])  then

         begin
            SendCommandSuccess:=True;  //如果状态一致，则置该标志为真，标志切换成功
         end
         else
         begin
           SendCommandSuccess:=False;//否则，置该标志为假，表示切换失败
         end;
         iRecvLen:=0;
         StrCopy(RecvBuff,);
         RecvBuffInit:=False;
         PurgeComm(hCommDev,PURGE_RXCLEAR ); //清空接收缓冲区
       end;
       }
       {
       if iRecvLen >=1 then
       begin
            inData := Byte(TempBuff^);
            if inData = $D9 then
            begin
                 SendCommandSuccess:=True;  //如果状态一致，则置该标志为真，标志切换成功

            end
            else
            begin
                 SendCommandSuccess:=False;//否则，置该标志为假，表示切换失败
            end;

            iRecvLen:=0;
            StrCopy(RecvBuff,);
            RecvBuffInit:=False;
            PurgeComm(hCommDev,PURGE_RXCLEAR ); //清空接收缓冲区
       end
    end;
    ////////////////
    SetEvent(postRecvEvent); //置接收事件句柄为有信号状态，以便接收新字符

end;
}

initialization
    RecvBuff:=StrAlloc(50*sizeof(Char));
    TempBuff:=StrAlloc(50*sizeof(Char));
Finalization
    StrDispose(RecvBuff);
    StrDispose(TempBuff);
    CloseHandle(PostRecvEvent);
    CloseHandle(read_os.hEvent);
    CloseHandle(PostSendEvent);
    CloseHandle(write_os.hEvent);
end.




