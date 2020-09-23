VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3390
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5895
   LinkTopic       =   "Form1"
   ScaleHeight     =   3390
   ScaleWidth      =   5895
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox Picture1 
      Height          =   495
      Left            =   2640
      Picture         =   "Form1.frx":0000
      ScaleHeight     =   435
      ScaleWidth      =   555
      TabIndex        =   5
      Top             =   2880
      Visible         =   0   'False
      Width           =   615
   End
   Begin VB.ListBox List1 
      Height          =   2790
      Left            =   2280
      TabIndex        =   6
      Top             =   240
      Width           =   3375
   End
   Begin VB.CommandButton Command5 
      Caption         =   "Change Icon"
      Height          =   495
      Left            =   120
      TabIndex        =   4
      Top             =   2040
      Width           =   2055
   End
   Begin VB.CommandButton Command4 
      Caption         =   "Hide PopUp"
      Height          =   495
      Left            =   120
      TabIndex        =   3
      Top             =   1440
      Width           =   2055
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Show PopUp"
      Height          =   495
      Left            =   120
      TabIndex        =   2
      Top             =   840
      Width           =   2055
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Remove Icon from Systray"
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Top             =   2640
      Width           =   2055
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Add Icon to SysTray"
      Height          =   495
      Left            =   120
      TabIndex        =   0
      Top             =   240
      Width           =   2055
   End
   Begin Project1.ctxSysTray ctxSysTray1 
      Left            =   2280
      Top             =   3120
      _ExtentX        =   450
      _ExtentY        =   450
      TrayIcon        =   "Form1.frx":0E42
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
ctxSysTray1.AddIconToSystray "He had a lot to say"
End Sub

Private Sub Command2_Click()
ctxSysTray1.RemoveIconFromSystray
End Sub

Private Sub Command3_Click()
ctxSysTray1.Popup "He had a voice that was strong and loud.", "Eulogy", Warning
End Sub

Private Sub Command4_Click()
ctxSysTray1.HidePopUp
End Sub

Private Sub Command5_Click()
Set ctxSysTray1.TrayIcon = Picture1.Picture
ctxSysTray1.UpdateIcon "He had a lot of nothing to say we'll miss him"
End Sub

Private Sub ctxSysTray1_DblClick(Button As Integer)
List1.AddItem "[Mouse DblClick: Btn " & Button & "]"
List1.TopIndex = List1.ListCount - 1
End Sub

Private Sub ctxSysTray1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
List1.AddItem "[Mouse Down: Btn " & Button & "]"
List1.TopIndex = List1.ListCount - 1
End Sub

Private Sub ctxSysTray1_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
List1.AddItem "[Mouse Up: Btn " & Button & "]"
List1.TopIndex = List1.ListCount - 1
End Sub
