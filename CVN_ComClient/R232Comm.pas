//=================================================================================

//���ʹ�ø�ģ���뱣����ע�ͣ�������޸Ļ�༭�뽫�޸ĺ�Ĵ��뷢��һ�ݸ���

//��д������Ӣ

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
  bSendFinish:boolean=True;//�������־
  iRecvLen:DWORD=0;
  RecvBuff,TempBuff:PChar;
  SendCommand,RecvCommand:String;//���ͺͽ��յ�������
  RecvFinish:BOOL=False;
  RecvBuffInit:BOOL=False;
  SendCommandSuccess:BOOL; //�л�̨����ɹ����ͱ�־

function  InitR12CommDev(comNo:PChar):String;  //��ʼ���л�̨���ڣ�����״̬�ַ�
procedure SwitchR12(WriteBuffer:PChar);//���л�̨�����л�����
procedure SwitchR12Byte(WriteBuffer:Byte);
procedure CommSendNotify;//���ڽ��յ��ַ��¼���Ӧ����
procedure CommRecvNotify; //���ڷ��ͻ��������¼���Ӧ����
procedure CommWatchThread(var lpdwParam:DWORD);//ͨ�ſڼ����߳�
function  ConInfo :String;

implementation
var
  //comMask,comBuf,ComState:Integer;
  dcb:_DCB; //DCB�ṹ�������ô��ڣ��������漰���������£�
            //DWORD DCBlength :DCB�ṹ��С
            //DWORD BaudRate :  ������
            //DWORD fBinary  : 1 ������ģʽ
            //DWORD fParity  : 1 ������żУ��
            //BYTE  ByteSize: �ַ�λ�� 4~8
            //BYTE  Parity:   ��żУ��λ 0-4�ֱ��ʾ�ޡ��桢ż�����š��պ�У��
            //BYTE  StopBits: ֹͣλ�� 0-2�ֱ��ʾ 1��1.5��2��ֹͣλ
            //WORD  XonLim ��XON ��ֵ
            //WORD  XoffLim  XOFF ��ֵ
            //char  XonChar�� XON �ַ�
            //char  XoffChar: XOFF �ַ�
            //char  EvtChar:  �¼��ַ�
  comStat:_COMSTAT; //COMSTAT�ṹ���ڴ���й�ͨ���豸�ĵ�ǰ��Ϣ
                    //�������漰���������£�
                    //cbInQue :���ջ��������ַ�����
                    //cbOutQue:���ͻ��������ַ�����
  dwErrorFlag:LongWord;
  hCommDev,comThreadHwnd:Thandle;//ͨ�Ŵ��ھ����ͨ�ż����߳̾��
  comMask,comBuf,comState:BOOL;
  read_os,write_os:_OVERLAPPED;  //OVERLAPPED �ṹ�������첽������Win32������
                                //�������漰���������£�
                                //DWORD Interval ����������ϵͳʹ��
                                //DWORD IntervalHigh ����������ϵͳʹ��
                                //DOWD  hEvent ��I/O�������ʱ������Ϊ���ź�״̬
                                //���¼���������ReadFile��WriteFile����֮ǰ����
                                //�ý������ø��¼�
  postRecvEvent,postSendEvent:Thandle;//���ͻ������պͽ��յ��ַ��¼����
  dwThreadID1:DWORD; //ͨ�ż����߳�ID��

///���ڳ�ʼ������
//�ú�����Ҫ��ɴ��ڳ�ʼ�����ú�ͨ���̵߳�����
//��ڲ��������ں�
//����ֵ����ʼ���Ƿ�ɹ���״̬�ַ�
function  InitR12CommDev(comNo:PChar) :String;
begin
   ///�򿪴���
   hCommDev:=CreateFile(comNo,   //���ں�
                       GENERIC_READ or GENERIC_WRITE,//�Դ����Զ�д��ʽ��
                       0,
                       nil,
                       OPEN_EXISTING,
                       FILE_ATTRIBUTE_NORMAL or FILE_FLAG_OVERLAPPED,//�����ص�����
                       0
                       );
   if hCommDev=INVALID_HANDLE_VALUE then
        InitR12CommDev:='�л�̨ͨѶ�˿ڳ�ʼ��ʧ��.'
   else
      InitR12CommDev:='�л�̨ͨѶ�˿ڳ�ʼ���ɹ�.';
   comMask:=SetCommMask(hCommDev,EV_RXFLAG);//�����¼�����
   //comBuf:=SetupComm(hCommDev,4096,4096);//���ý��պͷ��ͻ�������С��Ϊ4096�ֽ�
   comBuf:=SetupComm(hCommDev,1,1);//���ý��պͷ��ͻ�������С��Ϊ4096�ֽ�
   if  comBuf=False then
         InitR12CommDev:='�л�̨ͨѶ�˿ڳ�ʼ��ʧ��.'
   else
      begin
         InitR12CommDev:='�л�̨ͨѶ�˿ڳ�ʼ���ɹ�.';
         //��ջ�����
         PurgeComm(hCommDev,PURGE_TXABORT or PURGE_RXABORT or
                                      PURGE_TXCLEAR or PURGE_RXCLEAR ) ;
      end;

   //���¶Դ��ڽ�������
   dcb.DCBlength:=sizeof(_DCB);
   comState:=GetCommState(hCOmmDev,dcb);  //�õ�ȱʡ����
   if  comState=False then
         InitR12CommDev:='�л�̨ͨѶ�˿ڳ�ʼ��ʧ��.'
   else
       InitR12CommDev:='�л�̨ͨѶ�˿ڳ�ʼ���ɹ�.';
   dcb.BaudRate:=9600;  //������ 9600
   dcb.ByteSize:=8;//7;  //���ݳ���7λ
   dcb.Parity:=NOPARITY;//ODDPARITY; //У�鷽ʽ ��У��
   dcb.StopBits:=ONESTOPBIT; //ֹͣλ 1 λ

   dcb.Flags := 0;         // Enable fBinary
   dcb.Flags := dcb.Flags or 2;          // Enable parity check
   dcb.XonChar:= chr($00) ;
   dcb.XoffChar:= chr($00) ;
   dcb.XonLim:= 100 ;
   dcb.XoffLim:= 100 ;
   dcb.EvtChar := Char($ff);

   comState:=SetCommState(hCommDev,dcb);  //���ô���
   if comState=False then
         InitR12CommDev:='�л�̨ͨѶ�˿ڳ�ʼ��ʧ��.'
   else
      InitR12CommDev:='�л�̨ͨѶ�˿ڳ�ʼ���ɹ�.';
     //����ͨ�Ž��յ��ַ��¼����
   postRecvEvent:=CreateEvent(NIL,
                              TRUE,//�ֹ������¼�
                              TRUE, //��ʼ��Ϊ���ź�״̬
                              NIL
                              );
   //���ö��첽I/O�����¼����
   read_os.hEvent:=CreateEvent(NIL,
                              TRUE,//�ֹ������¼�
                              FALSE, //��ʼ��Ϊ���ź�״̬
                              NIL
                              );
   //���÷��ͻ��������¼����
   postSendEvent:=CreateEvent(NIL,
                              TRUE,//�ֹ������¼�
                              TRUE, //��ʼ��Ϊ���ź�״̬
                              NIL);
   //����д�첽I/O�����¼����
   write_os.hEvent:=CreateEvent(NIL,
                              TRUE,//�ֹ������¼�
                              FALSE,//��ʼ��Ϊ���ź�״̬
                              NIL);
   //����ͨ�ż����߳�
   comThreadHwnd:=CreateThread(NIL,
                         0,
                         @CommWatchThread, //ͨ���̺߳����ĵ�ַ
                         nil,
                         0,   //��������������
                         dwThreadID1);//ͨ���߳�ID��
   if comThreadHwnd=INVALID_HANDLE_VALUE  then
      InitR12CommDev:='INITR12COMM_FAILURE'
   else
      InitR12CommDev:='�л�̨ͨѶ�˿ڳ�ʼ���ɹ�.';
end;

///�л�̨�л����ƺ���
///����������л������ַ���
procedure SwitchR12(WriteBuffer:PChar);
var
 dwWriteByte,TxCount:DWORD;
 bl:BOOL;
 dwError:DWORD;

begin
     //WriteBuffer:=chr($0D)+03A00;
     TxCount:=StrLen(WriteBuffer);
     if bSendFinish=True then  //���ͻ������շ���
     begin
         dwWriteByte:=0;
         bSendFinish:=False;
         bl:=WriteFile(hCommDev,Byte(WriteBuffer^),TxCount,dwWriteByte,@write_os);
         if bl=True then
         begin
          bSendFinish:=True;
          PurgeComm(hCommDev,PURGE_TXCLEAR );//���������ɣ��û������ձ�־������ջ�����
         end;
         if bl=False then
         begin
           dwError:=GetLastError();
           if (dwError=ERROR_IO_PENDING) or (dwError=ERROR_IO_INCOMPLETE) then
           begin
             bl:=GetOverLappedResult(hCommDev,
                             write_os,dwWriteByte,TRUE);//���δ�����������ַ�
                                                    //�ȴ��������
             if bl=True then
             begin
                bSendFinish:=True;
                PurgeComm(hCommDev,PURGE_TXCLEAR ); //������� �û������ձ�־������ջ�����
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
     if bSendFinish=True then  //���ͻ������շ���
     begin
         dwWriteByte:=0;
         bSendFinish:=False;
         bl:=WriteFile(hCommDev,WriteBuffer,TxCount,dwWriteByte,@write_os);
         if bl=True then
         begin
          bSendFinish:=True;
          PurgeComm(hCommDev,PURGE_TXCLEAR );//���������ɣ��û������ձ�־������ջ�����
         end;
         if bl=False then
         begin
           dwError:=GetLastError();
           if (dwError=ERROR_IO_PENDING) or (dwError=ERROR_IO_INCOMPLETE) then
           begin
             bl:=GetOverLappedResult(hCommDev,
                             write_os,dwWriteByte,TRUE);//���δ�����������ַ�
                                                    //�ȴ��������
             if bl=True then
             begin
                bSendFinish:=True;
                PurgeComm(hCommDev,PURGE_TXCLEAR ); //������� �û������ձ�־������ջ�����
                //Result:=True;
             end;
           end;
         end;
     end;
     //Result:=True;
end;

////ͨ�ż����߳�
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

    comMask:=SetCommMask(hCommDev,EV_RXCHAR or EV_TXEMPTY);//���ü��ӵ��¼�Ϊ��
                                                        //�յ��ַ����ͻ�������
    if comMask=True then
    begin
        while True do
        begin
           dwEvtMask:=0;
           bl:=WaitCommEvent(hCommDev,dwEvtMask,@os); //��ѯ�����ӵ�ͨ���¼��Ƿ�
                                                       //�Ѿ�����
           if bl=False then
           begin
             dwError:=GetLastError();
             if dwError=ERROR_IO_PENDING then
                GetOverlappedResult(hCOmmDev,os,dwTransfer,TRUE);//��δ��⵽ͨ���¼�
                                           //���ڴ˵ȴ��¼�����
           end;
           //���¼����������´���
           if (dwEvtMask and EV_RXCHAR)=EV_RXCHAR then //�ж��Ƿ�Ϊ���յ� �ַ��¼�
           begin
              WaitForSingleObject(postRecvEvent,$FFFFFFFF);//�ȴ������¼����Ϊ��
                                                      //�ź�״̬
              ResetEvent(postRecvEvent); //�ý����¼����Ϊ���ź�״̬���������
                                        //������������
              CommRecvNotify; //���ý��յ��ַ�������
              continue; //����������ַ����������ͨ���¼�
           end;
           if (dwEvtMask and EV_TXEMPTY)=EV_TXEMPTY then //�ж��Ƿ�Ϊ���ͻ��������¼�
           begin
              WaitForSingleObject(postSendEvent,$FFFFFFFF);//�ȴ������¼����Ϊ��
                                                           //�ź�״̬
              ResetEvent(postSendEvent); //�÷����¼����Ϊ���ź�״̬�������ⷢ��
                                        //������������
              CommSendNotify; //���÷��ͻ������մ�����
              continue;//�����꣬�������ͨ���¼�
           end;
        end;
    end;
    CloseHandle(os.hEvent);
end;

//���ͻ������մ������
procedure CommSendNotify;
begin
    SetEvent(postSendEvent);//�÷����¼�δ���ź�״̬���Ա������һ�η���
end;

///���յ��ַ�������
procedure CommRecvNotify;
var
     RxCount,dwReadByte:DWORD;
     inData :Byte;
begin
     ClearCommError(hCommDev,dwErrorFlag,@ComStat);
     RxCount:=ComStat.cbInQue; //��ȡ���ջ��������ַ�����
     if RxCount>0 then
     begin
       if not RecvBuffInit then
       begin
          StrCopy(RecvBuff,'');
          RecvBuffInit:=True;
       end;
       StrCopy(TempBuff,'');
       ReadFile(hCommDev,Byte(TempBuff^),RxCount,dwReadByte,@read_os);//���ַ�����
                                                                      //��ʱ��������
       iRecvLen:=iRecvLen+dwReadByte; //���յ��ַ�����ͳ��

       if iRecvLen >=1 then
       begin
            inData := Byte(TempBuff^);
            if inData = $D9 then
            begin
                 SendCommandSuccess:=True;  //���״̬һ�£����øñ�־Ϊ�棬��־�л��ɹ�
            end
            else
            begin
                 SendCommandSuccess:=False;//�����øñ�־Ϊ�٣���ʾ�л�ʧ��
            end;

            iRecvLen:=0;
            StrCopy(RecvBuff,'');
            RecvBuffInit:=False;
            PurgeComm(hCommDev,PURGE_RXCLEAR ); //��ս��ջ�����
       end
    end;
    ////////////////
    SetEvent(postRecvEvent); //�ý����¼����Ϊ���ź�״̬���Ա�������ַ�

end;

function ConInfo :String;
begin
     if  SendCommandSuccess =True then
     begin
          Result :=' �л����������ɹ���';
     end
     else
     begin
          Result :=' �л����������ʧ�ܣ�';
     end;
end;

{
procedure CommSendNotify;
begin
    SetEvent(postSendEvent);//�÷����¼�δ���ź�״̬���Ա������һ�η���
end;

///���յ��ַ�������
{procedure CommRecvNotify;
var
     RxCount,dwReadByte:DWORD;
     inData :Byte;
begin
     ClearCommError(hCommDev,dwErrorFlag,@ComStat);
     RxCount:=ComStat.cbInQue; //��ȡ���ջ��������ַ�����
     if RxCount>0 then
     begin
       if not RecvBuffInit then
       begin
          StrCopy(RecvBuff,);
          RecvBuffInit:=True;
       end;
       StrCopy(TempBuff,);
       ReadFile(hCommDev,Byte(TempBuff^),RxCount,dwReadByte,@read_os);//���ַ�����
       //ReadFile(hCommDev,Byte(TempBuff^),RxCount,dwReadByte,@read_os);//���ַ�����
                                              //��ʱ��������
       iRecvLen:=iRecvLen+dwReadByte; //���յ��ַ�����ͳ��
       {
       if iRecvLen<13 then
       begin
          strcat(Recvbuff,TempBuff); //�����յ����л�̨״̬�ַ�С��13����
                          //����ʱ�������е��ַ��������������������׼��������
       end
       else
       begin
         strcat(Recvbuff,TempBuff);
         RecvCommand:=RecvBuff;
         //�����յ�13���л�̨״̬�ַ��������´���
         if (RecvCommand[7]=P)
            and(RecvCommand[8]=SendCommand[7])     //�Ƚ϶�����л�̨�˿�״̬
            and  (RecvCommand[9]=SendCommand[8])   //�Ƿ����л�ָ�����л��Ķ˿�
            and (RecvCommand[10]=SendCommand[9])   //һ��
            and (RecvCommand[11]=SendCommand[10])  then

         begin
            SendCommandSuccess:=True;  //���״̬һ�£����øñ�־Ϊ�棬��־�л��ɹ�
         end
         else
         begin
           SendCommandSuccess:=False;//�����øñ�־Ϊ�٣���ʾ�л�ʧ��
         end;
         iRecvLen:=0;
         StrCopy(RecvBuff,);
         RecvBuffInit:=False;
         PurgeComm(hCommDev,PURGE_RXCLEAR ); //��ս��ջ�����
       end;
       }
       {
       if iRecvLen >=1 then
       begin
            inData := Byte(TempBuff^);
            if inData = $D9 then
            begin
                 SendCommandSuccess:=True;  //���״̬һ�£����øñ�־Ϊ�棬��־�л��ɹ�

            end
            else
            begin
                 SendCommandSuccess:=False;//�����øñ�־Ϊ�٣���ʾ�л�ʧ��
            end;

            iRecvLen:=0;
            StrCopy(RecvBuff,);
            RecvBuffInit:=False;
            PurgeComm(hCommDev,PURGE_RXCLEAR ); //��ս��ջ�����
       end
    end;
    ////////////////
    SetEvent(postRecvEvent); //�ý����¼����Ϊ���ź�״̬���Ա�������ַ�

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




