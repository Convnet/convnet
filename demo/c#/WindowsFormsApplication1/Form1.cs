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
        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_Login(string cvnurl, string username, string password);

        [DllImport("cvn_main.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_Logout();

        [DllImport("cvn_main.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
        private static extern int CVN_getUDPc2cport();

        [DllImport("cvn_main.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_Message(DelegateGetCVNmessage Address);
        //private static extern void CVN_Message(int Address);

        [DllImport("cvn_main.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
        private static extern bool CVN_InitEther();

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern string GetCVNIPByUserID(int userid);
        
        [DllImport("cvn_main.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_InitClientServer(int tcpport, int udpport);

        [DllImport("cvn_main.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_ConnectUser(int Userid, string password);

        [DllImport("cvn_main.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
        private static extern void CVN_FreeRes();

        [DllImport("cvn_main.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        private static extern string CVN_GetUserinfo();
        
        
        public Form1()
        {
            InitializeComponent();
            RichTextBox.CheckForIllegalCrossThreadCalls = false;
        }

        delegate void DelegateGetCVNmessage(int messagetype, string messagestring);

        private void button1_Click(object sender, EventArgs e)
        {
            CVN_Login("gtmap.cn:822", "asd", "asd");
        }


        void GetCVNmessage(int messagetype, string messagestring)
        {
            { string tmpstr = string.Empty;}
            List<string> strlist = new List<string>();
            int i = 0;

            richTextBox1.Text += messagetype.ToString() + " :" +messagestring + "\r\n";
            //if (assigned(form1.Memo1))
            //{
            //    form1.Memo1.Lines.Add(inttostr(messagetype)+' :'+mmessagestring);
            //}
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            //GCHandle handle = GCHandle.Alloc(原数组, GCHandleType.Pinned);
            //void* pArray = handle.AddrOfPinnedObject().ToPointer();
            DelegateGetCVNmessage dgcvn = new DelegateGetCVNmessage(GetCVNmessage);

            try
            {
                CVN_Message(dgcvn);
                CVN_InitClientServer(60, 50);//初始化客户端端口以及一些必要的资源，释放使用CVN_FreeRes，暂时没写
                if (!CVN_InitEther())   //初始化网卡信息
                {
                    richTextBox1.Text += "网卡没有安装";
                }
            }
            catch (Exception ex)
            { MessageBox.Show(ex.Message + "\r\n" + ex.StackTrace); }
           
        }

        private void button2_Click(object sender, EventArgs e)
        {
            CVN_ConnectUser(1,"");
        }
            
        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            CVN_Logout();
            CVN_FreeRes();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            richTextBox1.Text += CVN_GetUserinfo();
        }
    }
}
