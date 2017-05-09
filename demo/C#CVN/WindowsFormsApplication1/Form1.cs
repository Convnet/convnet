using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;
using System.Globalization;


namespace WindowsFormsApplication1
{


  


    public unsafe partial class Form1 : Form
    {



        void GetCVNmessage(int messagetype, [MarshalAs(UnmanagedType.LPWStr)] string messagestring)
        {
            Control.CheckForIllegalCrossThreadCalls = false;
           // char[] destination = { 'T', 'h', 'e', ' ', 'i', 'n', 'i', 't', 'i', 'a', 'l', ' ', 'a', 'r', 'r', 'a', 'y', 'T', 'h', 'e', ' ', 'i', 'n', 'i', 't', 'i', 'a', 'l', ' ', 'a', 'r', 'r', 'a', 'T', 'h', 'e', ' ', 'i', 'n', 'i', 't', 'i', 'a', 'l', ' ', 'a', 'r', 'r', 'a', 'T', 'h', 'e', ' ', 'i', 'n', 'i', 't', 'i', 'a', 'l', ' ', 'a', 'r', 'r', 'a' };
          //  messagestring.CopyTo(0, destination, 0, length);
          //  richTextBox1.Text += messagetype.ToString() + " :" + DCSW.D2C2(destination,length) + "\r\n";
            richTextBox1.Text += messagetype.ToString() + " :" + messagestring + "\r\n";  
        }

        struct TPeerGroupInfo
        {
            int GroupID;
            int Creator;    
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 12)]
            string GroupName;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 30)]
            string GroupDes;
            bool NeedPass;
        }
        struct TUserInfo
        {
            bool connecting;
            int UserID;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 12)]
            string UserName;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 12)]
            string AhthorPassword;
            bool ISOnline;
            bool Connected;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 12)]
            string MacAddress;

            int Con_ConnectionType;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 15)]
            string Con_IP;
            int Con_port;
            int Con_RetryTime;
            long Con_send;
            long Con_recv;
            int tvUserReconn;
            int peerport;
            void* con_AContext;
            DateTime con_Lastrecv;
            void* clientDM;

            public void TryConnect_start() { }
            public void RefInfo_whenConnect(string ip, int port, string Mac) { }
            public void DissconnectPeer() { }
            public void sendtopeer(char[] buffer, int buflength) { }
            public void RetryTimer(object Sender) { }
        }


        /// <summary>  
        /// 普通字符串与UniCode字符串间转换  
        /// </summary>  
        public static class DCSW        //delphi和C#字符串转换
        {
            /// <summary>  
            /// 字符串转为UniCode码字符串  
            /// </summary>  
            /// <param name="s"></param>  
            /// <returns></returns>  
            public static string C2D(string s)
            {
                byte[] buffer = Encoding.Unicode.GetBytes(s);
                return Encoding.GetEncoding("GB2312").GetString(buffer); ;
            }
            /// <summary>  
            /// Unicode字符串转为正常字符串  
            /// </summary>  
            /// <param name="srcText"></param>  
            /// <returns></returns>  
            public static string D2C(string s, int length)
            {
                
                Encoding ec = Encoding.GetEncoding("GB2312");
                byte[] btArr = ec.GetBytes(s.ToString());
                return Encoding.Unicode.GetString(btArr);
            }
            public static string D2C2(char[] s, int length)
            {

                Encoding ec = Encoding.GetEncoding("GB2312");

                byte[] btArr = ec.GetBytes(s,0,length);
                return Encoding.Unicode.GetString(btArr);
            }
        }   

        //没有问题的函数
        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern int CVN_getUDPc2cport();

        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern int CVN_getTCPc2cport();

        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_Login(
            [MarshalAs(UnmanagedType.LPWStr)] string cvnurl,
            [MarshalAs(UnmanagedType.LPWStr)] string username,
            [MarshalAs(UnmanagedType.LPWStr)] string password);

        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_Message(DelegateGetCVNmessage Address);

        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_InitClientServer(int tcpport, int udpport);

        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_Logout();

       
        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_DisConnectUser(int Userid);

        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern long CVN_CountSend();

        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern long CVN_CountRecive();

        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_FreeRes();

        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern bool CVN_InitEther();

        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern bool diduserinlist(int userid);//返回值一直是true？

        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        private static extern string GetCVNIPByUserID(int userid);

        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        private static extern string CVN_GetOnlineUserinfo();

        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        private static extern string CVN_GetUserinfo();

        //好友申请,allpyinfo可做直接入组密码匹配
        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_TryAddFriend(int peerid, [MarshalAs(UnmanagedType.LPWStr)] string allpyinfo);

        //入组申请,allpyinfo可做直接入组密码匹配
        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_TryJoinGroup(int groupid, [MarshalAs(UnmanagedType.LPWStr)] string allpyinfo);

        //确认好友
        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_FriendConfirm(int peerid);

        //确认入组，管理员有效
        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_ConfirmJoinGroup(int userid, int groupid);

        //注册
        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_RegistUser(  [MarshalAs(UnmanagedType.LPWStr)] string serverurl,
                                                    [MarshalAs(UnmanagedType.LPWStr)] string username,
                                                    [MarshalAs(UnmanagedType.LPWStr)] string password, 
                                                    [MarshalAs(UnmanagedType.LPWStr)] string nick, 
                                                    [MarshalAs(UnmanagedType.LPWStr)] string desc);
        //退出组
        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_QuitGroup(int groupid);




         //查询组，querytype 1、名称查询，2备注查询
        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_QueryGroupByName(int querytype, [MarshalAs(UnmanagedType.LPWStr)] string name);
        //查询好友 querytype 1、昵称，2、用户名，3、备注
        [DllImport("cvn_main.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_QueryUserByName(int querytype, [MarshalAs(UnmanagedType.LPWStr)] string name);
        //其他函数调用参考delphi示例


        public static string messagestring = "";

        
        delegate void DelegateGetCVNmessage(int messagetype, [MarshalAs(UnmanagedType.LPWStr)] string messagestring);

        public string 帐号 = "zgkwd" + ((short)new Random().Next()).ToString("X4");

        public Form1()
        {
            DelegateGetCVNmessage dgcvn = new DelegateGetCVNmessage(GetCVNmessage);

            InitializeComponent();

            CVN_Message(dgcvn);
            CVN_InitClientServer(610, 520);
            CVN_InitEther();

            textBox1.Text = "asd";
            textBox2.Text = "firefox";
            textBox3.Text = "5";

            GC.KeepAlive(dgcvn);
        }


        private void button4_Click(object sender, EventArgs e)//注册
        {
            CVN_RegistUser("sh.convnet.net:23",
                textBox1.Text,
                "000000", 
                textBox1.Text,
                "备注");//返回值在回调函数中
        }
        private void button1_Click(object sender, EventArgs e)//登录
        {
            CVN_Login("sh.convnet.net:23",textBox1.Text,textBox2.Text);
        }
        private void button5_Click(object sender, EventArgs e)//注销
        {
            CVN_Logout();
        }
       
     
        private void button12_Click(object sender, EventArgs e)//获取好友信息和组信息       
        {
            MessageBox.Show(CVN_GetUserinfo());
        }

        private void button14_Click(object sender, EventArgs e)//加入用户组
        {
            CVN_TryJoinGroup(1, "申请理由");
        }
        private void button10_Click(object sender, EventArgs e)//获取虚拟IP
        {
            MessageBox.Show(GetCVNIPByUserID(int.Parse(textBox3.Text)));
        }
        private void button6_Click(object sender, EventArgs e)//发送的流量
        {
            MessageBox.Show(CVN_CountSend().ToString());
        }
        private void button7_Click(object sender, EventArgs e)//获取的流量
        {
            MessageBox.Show(CVN_CountRecive().ToString());
        }

        private void button8_Click(object sender, EventArgs e)
        {
            MessageBox.Show(CVN_GetOnlineUserinfo());
        }

        private void button9_Click(object sender, EventArgs e)
        {
            CVN_QuitGroup(1);
        }

        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            CVN_FreeRes();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            CVN_QueryUserByName(1, textBox4.Text);
        }
    }
}
