VERSION 5.00
Begin VB.Form frmMain 
   BackColor       =   &H80000008&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "X-EnO Soft - Xcaptarea"
   ClientHeight    =   5835
   ClientLeft      =   45
   ClientTop       =   360
   ClientWidth     =   5445
   ClipControls    =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5835
   ScaleWidth      =   5445
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdStop 
      Caption         =   "&Opreste"
      Height          =   375
      Left            =   1680
      TabIndex        =   2
      Top             =   4920
      Width           =   1935
   End
   Begin VB.CommandButton cmdStart 
      Caption         =   "&Captureaza"
      Height          =   375
      Left            =   1680
      TabIndex        =   1
      Top             =   4560
      Width           =   1935
   End
   Begin VB.Timer tmrMain 
      Enabled         =   0   'False
      Interval        =   200
      Left            =   960
      Top             =   240
   End
   Begin VB.PictureBox picOutput 
      BackColor       =   &H00FFFFFF&
      Height          =   4335
      Left            =   120
      ScaleHeight     =   4275
      ScaleWidth      =   5115
      TabIndex        =   0
      Top             =   120
      Width           =   5175
   End
   Begin VB.Label lblWarning 
      Caption         =   "NOTE: If running this through IDE, VB may crash upon termination. (Works fine when compiled)"
      Height          =   15
      Left            =   5400
      TabIndex        =   3
      Top             =   5880
      Width           =   2655
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub cmdStart_Click()
cmdStart.Enabled = False
cmdStop.Enabled = True
'Setup a capture window (You can replace "WebcamCapture" with watever you want)
mCapHwnd = capCreateCaptureWindow("WebcamCapture", 0, 0, 0, 320, 240, Me.hwnd, 0)
'Connect to capture device
DoEvents: SendMessage mCapHwnd, CONNECT, 0, 0
tmrMain.Enabled = True
End Sub

Private Sub cmdStop_Click()
cmdStart.Enabled = True
cmdStop.Enabled = False
tmrMain.Enabled = False
'Make sure to disconnect from capture source!!!
DoEvents: SendMessage mCapHwnd, DISCONNECT, 0, 0
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
If cmdStop.Enabled = False Then

'Make sure to disconnect from capture source - if it is connected upon termination the program can become unstable
DoEvents: SendMessage mCapHwnd, DISCONNECT, 0, 0
End If
End Sub

Private Sub tmrMain_Timer()
On Error Resume Next
'Get Current Frame
        SendMessage mCapHwnd, GET_FRAME, 0, 0
'Copy Current Frame to ClipBoard
        SendMessage mCapHwnd, COPY, 0, 0
'Put ClipBoard's Data to picOutput
        picOutput.Picture = Clipboard.GetData
'Clear ClipBoard
        Clipboard.Clear
End Sub
