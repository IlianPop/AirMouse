unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, PythonEngine, Math, IniFiles,
  Vcl.PythonGUIInputOutput, Vcl.ComCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    PythonEngine1: TPythonEngine;
    PythonModule1: TPythonModule;
    Button2: TButton;
    Label2: TLabel;
    Label3: TLabel;
    TrackBar1: TTrackBar;
    Label4: TLabel;
    TrackBar2: TTrackBar;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure PythonModule1Initialization(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TMyPythonThread = class(TPythonThread)
  protected
    procedure ExecuteWithPython; override;
  end;

var
  Form2: TForm2;
  oldX, oldY:Double;
  smoothCoef:Double=0.2;
  normalCoef:Double=0.2;
  controlOn:Integer=0;
implementation

{$R *.dfm}
procedure TMyPythonThread.ExecuteWithPython;
var pyEngine:TPythonEngine;
begin
  pyEngine := GetPythonEngine;
  FreeOnTerminate := true;
  pyEngine.ExecFile(ExtractFilePath(Application.ExeName)+'test.py');
end;
function normalizePosition(value :Double):Double;
begin
  if value > (1-normalCoef) then value := 1 - normalCoef;
  if value < normalCoef then value := normalCoef;
  Result := (value - normalCoef) / (1 - 2 * normalCoef);
end;
function mouseControl(Self, Args:PPyObject):PPyObject;cdecl;
var
  pyEngine:TPythonEngine;
  x, y: double;
begin
  pyEngine := GetPythonEngine;
  pyEngine.PyArg_ParseTuple(Args, 'dd', @x, @y);
  x := normalizePosition(x);
  y := normalizePosition(y);
  x := x * Screen.Width;
  y := y * Screen.Height;
  oldX := (oldX * (1-smoothCoef)+x*smoothCoef);
  oldY := (oldY * (1-smoothCoef)+y*smoothCoef);
  TThread.Queue(nil, procedure
  begin
    Form2.Label1.Caption := FloatToStr(Round(x)) + ' X';
    Form2.Label2.Caption := FloatToStr(Round(y)) + ' Y';
  end);
  if controlOn = 1 then
  begin
    SetCursorPos(Round(oldX), Round(oldY));
  end;
  Result := pyEngine.Py_None;
  pyEngine.Py_INCREF(Result);
end;
function minimazeWindows(Self, Args:PPyObject):PPyObject;cdecl;
var pyEngine:TPythonEngine;
begin
  pyEngine := GetPythonEngine;
  if controlOn = 1 then
  begin
    keybd_event(VK_LWIN, 0, 0, 0);
    keybd_event(ord('D'), 0, 0, 0);
    keybd_event(ord('D'), 0, KEYEVENTF_KEYUP, 0);
    keybd_event(VK_LWIN, 0, KEYEVENTF_KEYUP, 0);
  end;
  Result := pyEngine.Py_None;
  pyEngine.Py_INCREF(Result);
end;
function leftClick(Self, Args:PPyObject):PPyObject;cdecl;
var pyEngine:TPythonEngine;
begin
  pyEngine := GetPythonEngine;
  if controlOn = 1 then
  begin
    mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
  end;
  Result := pyEngine.Py_None;
  pyEngine.Py_INCREF(Result);
end;
function leftUnClick(Self, Args:PPyObject):PPyObject;cdecl;
var pyEngine:TPythonEngine;
begin
  pyEngine := GetPythonEngine;
  if controlOn = 1 then
  begin
    mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
  end;
  Result := pyEngine.Py_None;
  pyEngine.Py_INCREF(Result);
end;
function rightClick(Self, Args:PPyObject):PPyObject;cdecl;
var pyEngine:TPythonEngine;
begin
  pyEngine := GetPythonEngine;
  if controlOn = 1 then
  begin
    mouse_event(MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0);
    Sleep(50);
    mouse_event(MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0);
  end;
  Result := pyEngine.Py_None;
  pyEngine.Py_INCREF(Result);
end;
procedure TForm2.Button1Click(Sender: TObject);
begin
  PythonEngine1.PyEval_SaveThread;
  TMyPythonThread.Create(false);
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  PythonEngine1.ExecFile(ExtractFilePath(Application.ExeName)+'test.py');
end;

procedure TForm2.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.checked then controlOn := 1
  else controlOn := 0;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
var Ini:TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'setings.ini');
  Ini.WriteString('settings', 'smoothCoef', FloatToStr(smoothCoef));
  Ini.WriteString('settings', 'normalCoef', FloatToStr(normalCoef));
  Ini.WriteString('settings', 'controlOn', IntToStr(controlOn));
  Ini.Free;
end;

procedure TForm2.FormCreate(Sender: TObject);
var Ini:TIniFile;
begin
  PythonEngine1.UseLastKnownVersion := False;
  PythonEngine1.DllPath := ExtractFilePath(Application.ExeName) + 'python_env\';
  PythonEngine1.SetPythonHome(ExtractFilePath(Application.ExeName) + 'python_env\');
  PythonEngine1.LoadDll;
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'setings.ini');
  smoothCoef := StrToFloat(Ini.ReadString('settings', 'smoothCoef', '0.2'));
  normalCoef := StrToFloat(Ini.ReadString('settings', 'normalCoef', '0.2'));
  controlOn := StrToInt(Ini.ReadString('settings', 'controlOn', '0'));
  Ini.Free;
  if controlOn = 1 then CheckBox1.Checked := True
  else CheckBox1.Checked := False;
  TrackBar1.Position := Round((1 - smoothCoef) * 20);
  TrackBar2.Position := Round(normalCoef * 60);
  Left := Screen.Width - Width;
  Top := Screen.WorkAreaHeight - Height;
end;

procedure TForm2.PythonModule1Initialization(Sender: TObject);
begin
  PythonModule1.AddMethod('minimaze_window', minimazeWindows, 'minimaze all windows');
  PythonModule1.AddMethod('left_click', leftClick, 'left click');
  PythonModule1.AddMethod('left_un_click', leftUnClick, 'left unclick');
  PythonModule1.AddMethod('right_click', rightClick, 'right click');
  PythonModule1.AddMethod('set_cursor', mouseControl, 'set cursor');
end;

procedure TForm2.TrackBar1Change(Sender: TObject);
begin
  Label3.Caption := FloatToStr(TrackBar1.Position / 20) + ' Smooth';
  smoothCoef := 1 - TrackBar1.Position / 20;
end;
procedure TForm2.TrackBar2Change(Sender: TObject);
begin
  Label4.Caption := FloatToStr(TrackBar2.Position / 20) + ' Normalization';
  normalCoef := TrackBar2.Position / 60;
end;
end.
