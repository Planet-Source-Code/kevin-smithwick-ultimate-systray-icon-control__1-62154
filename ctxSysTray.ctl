VERSION 5.00
Begin VB.UserControl ctxSysTray 
   ClientHeight    =   255
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   255
   InvisibleAtRuntime=   -1  'True
   Picture         =   "ctxSysTray.ctx":0000
   ScaleHeight     =   255
   ScaleWidth      =   255
End
Attribute VB_Name = "ctxSysTray"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' Written 2004 - Tako
' quid erat demonstrandum

Private Type NOTIFYICONDATA
   cbSize As Long
   hwnd As Long
   uID As Long
   uFlags As Long
   uCallbackMessage As Long
   hIcon As Long
   szTip As String * 128
   dwState As Long
   dwStateMask As Long
   szInfo As String * 256
   uTimeout As Long
   szInfoTitle As String * 64
   dwInfoFlags As Long
End Type

Public Enum PopupType
    None = &H0
    Warning = &H2
    Error = &H3
    Information = &H1
    CurrentIcon = &H4
End Enum

Private Const NIM_ADD = &H0
Private Const NIM_MODIFY = &H1
Private Const NIM_DELETE = &H2

Private Const NIF_MESSAGE = &H1
Private Const NIF_ICON = &H2
Private Const NIF_INFO = &H10
Private Const NIF_TIP = &H4&

Private Const WM_MOUSEMOVE = &H200
Private Const WM_LBUTTONDOWN = &H201
Private Const WM_LBUTTONUP = &H202
Private Const WM_LBUTTONDBLCLK = &H203
Private Const WM_RBUTTONDOWN = &H204
Private Const WM_RBUTTONUP = &H205
Private Const WM_RBUTTONDBLCLK = &H206

Public Event MouseMouse(X As Single, Y As Single)
Public Event MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
Public Event MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
Public Event DblClick(Button As Integer)

Private pTrayIcon As StdPicture
Private m_IconData As NOTIFYICONDATA

Private Declare Function Shell_NotifyIcon Lib "shell32" Alias "Shell_NotifyIconA" (ByVal dwMessage As Long, pnid As NOTIFYICONDATA) As Boolean

Public Property Get TrayIcon() As StdPicture
Set TrayIcon = pTrayIcon
End Property

Public Property Set TrayIcon(newPic As StdPicture)
Set pTrayIcon = newPic
Set UserControl.Picture = pTrayIcon
UserControl.Refresh
End Property

Public Sub AddIconToSystray(ToolTip As String)
With m_IconData
    .cbSize = Len(m_IconData)
    .hwnd = UserControl.hwnd
    .uID = vbNull
    .uFlags = NIF_ICON Or NIF_INFO Or NIF_MESSAGE Or NIF_TIP
    .uCallbackMessage = WM_MOUSEMOVE
    .hIcon = pTrayIcon
    .szTip = ToolTip & vbNullChar
    .dwState = 0
    .dwStateMask = 0
End With

Shell_NotifyIcon NIM_ADD, m_IconData
End Sub

Public Sub UpdateIcon(ToolTip As String)
With m_IconData
    .hwnd = UserControl.hwnd
    .uFlags = NIF_ICON Or NIF_TIP
    .hIcon = pTrayIcon
    .szTip = ToolTip & vbNullChar
End With

Shell_NotifyIcon NIM_MODIFY, m_IconData
End Sub

Public Sub RemoveIconFromSystray()
m_IconData.hwnd = UserControl.hwnd
Shell_NotifyIcon NIM_DELETE, m_IconData
End Sub

Public Sub Popup(Message As String, Title As String, IconType As PopupType)
With m_IconData
    .hwnd = UserControl.hwnd
    .uFlags = NIF_ICON Or NIF_INFO Or NIF_MESSAGE Or NIF_TIP
    .szInfo = Message & Chr(0)
    .szInfoTitle = Title & Chr(0)
    .dwInfoFlags = IconType
End With

Shell_NotifyIcon NIM_MODIFY, m_IconData
End Sub

Public Sub HidePopUp()
With m_IconData
    .hwnd = UserControl.hwnd
    .uFlags = NIF_ICON Or NIF_INFO Or NIF_MESSAGE Or NIF_TIP
    .szInfo = Chr(0)
    .szInfoTitle = Chr(0)
    .dwInfoFlags = &H0
End With

Shell_NotifyIcon NIM_MODIFY, m_IconData
End Sub

Private Sub UserControl_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Dim theMessage As Single
theMessage = X / Screen.TwipsPerPixelX

Select Case theMessage
    Case WM_MOUSEMOVE: RaiseEvent MouseMouse(X, Y)
    
    Case WM_LBUTTONDOWN: RaiseEvent MouseDown(1, Shift, X, Y)
    Case WM_LBUTTONUP: RaiseEvent MouseUp(1, Shift, X, Y)
    Case WM_LBUTTONDBLCLK: RaiseEvent DblClick(1)
    
    Case WM_RBUTTONDOWN: RaiseEvent MouseDown(2, Shift, X, Y)
    Case WM_RBUTTONUP: RaiseEvent MouseUp(2, Shift, X, Y)
    Case WM_RBUTTONDBLCLK: RaiseEvent DblClick(2)
End Select
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
Set pTrayIcon = PropBag.ReadProperty("TrayIcon", UserControl.Picture)
Set UserControl.Picture = pTrayIcon
UserControl.Refresh
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
Call PropBag.WriteProperty("TrayIcon", pTrayIcon)
End Sub

Private Sub UserControl_Resize()
UserControl.Width = 250
UserControl.Height = 250
End Sub

Private Sub UserControl_Terminate()
Call RemoveIconFromSystray
End Sub
