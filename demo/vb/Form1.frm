VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  '窗口缺省
   Begin VB.TextBox Text1 
      Height          =   1095
      Left            =   240
      TabIndex        =   3
      Text            =   "Text1"
      Top             =   960
      Width           =   2895
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Command3"
      Height          =   495
      Left            =   2760
      TabIndex        =   2
      Top             =   120
      Width           =   1215
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Command2"
      Height          =   495
      Left            =   1320
      TabIndex        =   1
      Top             =   120
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   495
      Left            =   0
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Declare Sub CVN_Login Lib "cvn_main.dll" (ByVal cvnurl As String, ByVal username As String, ByVal password As String)
Private Declare Sub CVN_Logout Lib "cvn_main.dll" ()
Private Declare Sub CVN_FreeRes Lib "cvn_main.dll" ()
Private Declare Function CVN_getUDPc2cport Lib "cvn_main.dll" () As Long
Private Declare Sub CVN_Message Lib "cvn_main.dll" (ByVal Address As Long, ByVal std As Boolean)
Private Declare Function CVN_InitEther Lib "cvn_main.dll" () As Boolean
Private Declare Sub CVN_InitClientServer Lib "cvn_main.dll" (ByVal tcpport As Long, ByVal udpport As Long)
Private Declare Sub CVN_ConnectUser Lib "cvn_main.dll" (ByVal Userid As Long, ByVal password As String)

Private Sub Command1_Click()

 Dim a As String
 Dim b As String
 Dim c As String
 
 a = "gtmap.cn:822"
 b = "zgkwd5"
 c = "000000"
 
 If CVN_InitEther Then '初始化网卡信息
    Call CVN_Login(a, b, c)
 End If
 
 
End Sub
Private Sub Command2_Click()

    Call CVN_Logout

End Sub
Private Sub Command3_Click()
    CVN_ConnectUser 1, ""
End Sub

Private Sub Form_Load()
   CVN_Message AddressOf GetCVNmessage, True
   
   CVN_InitClientServer 123, 123 '初始化本地服务端口
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    Call CVN_Logout '登出
    Call CVN_FreeRes '释放资源
End Sub

