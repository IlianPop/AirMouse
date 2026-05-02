object Form2: TForm2
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'AirMouse'
  ClientHeight = 305
  ClientWidth = 118
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 7
    Width = 16
    Height = 15
    Caption = '0 X'
  end
  object Label2: TLabel
    Left = 8
    Top = 28
    Width = 16
    Height = 15
    Caption = '0 Y'
  end
  object Label3: TLabel
    Left = 31
    Top = 53
    Width = 59
    Height = 15
    Caption = '0.8 smooth'
  end
  object Label4: TLabel
    Left = 8
    Top = 125
    Width = 91
    Height = 15
    Caption = '0.8 normalization'
  end
  object Label5: TLabel
    Left = 31
    Top = 197
    Width = 42
    Height = 15
    Caption = '0.8 click'
  end
  object TrackBar1: TTrackBar
    Left = 0
    Top = 74
    Width = 113
    Height = 45
    Max = 20
    TabOrder = 0
    OnChange = TrackBar1Change
  end
  object TrackBar2: TTrackBar
    Left = 0
    Top = 146
    Width = 113
    Height = 45
    Max = 19
    TabOrder = 1
    OnChange = TrackBar2Change
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 272
    Width = 97
    Height = 17
    Caption = #1050#1077#1088#1091#1074#1072#1085#1085#1103
    TabOrder = 2
    OnClick = CheckBox1Click
  end
  object TrackBar3: TTrackBar
    Left = -3
    Top = 221
    Width = 113
    Height = 45
    Max = 19
    TabOrder = 3
    OnChange = TrackBar3Change
  end
  object PythonEngine1: TPythonEngine
    AutoLoad = False
    DllName = 'python311.dll'
    APIVersion = 1013
    RegVersion = '3.11'
    UseLastKnownVersion = False
    Left = 264
    Top = 40
  end
  object PythonModule1: TPythonModule
    Engine = PythonEngine1
    OnInitialization = PythonModule1Initialization
    ModuleName = 'air_mouse'
    Errors = <>
    Left = 256
    Top = 104
  end
end
