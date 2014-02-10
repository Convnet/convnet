using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;

namespace WindowsFormsApplication1
{
    public unsafe partial class Form1 : Form
    {
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
        //没有问题的函数
        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern int CVN_getUDPc2cport();

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern int CVN_getTCPc2cport();

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_Login(string cvnurl, string username, string password);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_Message(DelegateGetCVNmessage Address);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_InitClientServer(int tcpport, int udpport);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_Logout();

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_ConnectUser(int Userid, string password);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_DisConnectUser(int Userid);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern long CVN_CountSend();

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern long CVN_CountRecive();

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_FreeRes();

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern bool CVN_InitEther();

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern bool diduserinlist(int userid);//返回值一直是true？

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern string GetCVNIPByUserID(int userid);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern string CVN_GetOnlineUserinfo();

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern string CVN_GetUserinfo();

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_ApplyForPeer(int peerid, string allpyinfo);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_ApplyForJoinGroup(int groupid, string allpyinfo);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_ConfirmJoinPeer(int peerid);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_ConfirmJoinGroup(int userid, int groupid);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_RegistUser(string serverurl, string username, string password, string nick, string desc);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_QuitGroup(int groupid);

        //以下函数有问题 各种报错
        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern TUserInfo getuFriendByID(int userid);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern TPeerGroupInfo getGroupByID(int groupid);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern TUserInfo getUserByMAC(string mac);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern IntPtr getUserByIDex(int userid);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern TUserInfo getuserByName(string userName);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern TUserInfo getUserByID(int userid);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_SendCmd(string str);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern bool CVN_ConnecttoServer(string url);

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern TPeerGroupInfo CVN_AllUserInfo();

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern TPeerGroupInfo[] CVN_GetUserList();

        //以下不知道参数和返回值，胡乱写的
        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern bool CVN_testdissconnect();

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern string CVN_GetEtherName();

        public static string 字符串 = "";

        public delegate void DelegateGetCVNmessage(int messagetype, string messagestring);

        public DelegateGetCVNmessage dgcvn = new DelegateGetCVNmessage(GetCVNmessage);

        public string 帐号 = "zgkwd" + ((short)new Random().Next()).ToString("X4");

        public Form1()
        {
            InitializeComponent();

            CVN_Message(dgcvn);
            CVN_InitClientServer(60, 50);
            CVN_InitEther();

            textBox1.Text = "小小香道空";
            textBox2.Text = "000000";
            textBox3.Text = "5";

            GC.KeepAlive(dgcvn);
        }







        static void GetCVNmessage(int messagetype, string messagestring)
        {
            { string tmpstr = string.Empty; }
            List<string> strlist = new List<string>();

            字符串 += messagetype.ToString() + " :" + messagestring + "\r\n";
        }




        private void timer1_Tick(object sender, EventArgs e)
        {
            richTextBox1.Text = 字符串;

        }






























        private void button4_Click(object sender, EventArgs e)//注册
        {
            CVN_RegistUser("zgkfwq.gnway.net:822", textBox1.Text, "000000", textBox1.Text, "备注");//返回值在回调函数中
        }
        private void button1_Click(object sender, EventArgs e)//登录
        {
            CVN_Login("zgkfwq.gnway.net:822", textBox1.Text, textBox2.Text);
        }
        private void button5_Click(object sender, EventArgs e)//注销
        {
            CVN_Logout();
        }
        private void button2_Click(object sender, EventArgs e)//建立连接                    (无效了)
        {
            CVN_ConnectUser(int.Parse(textBox3.Text), "000000");
        }
        private void button3_Click(object sender, EventArgs e)//断开连接
        {
            CVN_DisConnectUser(int.Parse(textBox3.Text));
        }
        private void button17_Click(object sender, EventArgs e)//退出前释放资源
        {
            CVN_FreeRes();
        }
        private void button12_Click(object sender, EventArgs e)//获取好友信息和组信息       
        {
            MessageBox.Show(CVN_GetUserinfo());
        }
        private void button14_Click(object sender, EventArgs e)//加入用户组
        {
            CVN_ApplyForJoinGroup(1, "8294809");
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
    }
}
