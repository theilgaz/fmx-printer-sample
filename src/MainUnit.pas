unit MainUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.Bluetooth, System.Bluetooth.Components,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls, PrinterHelper,
  IniHelper, FMX.ScrollBox, FMX.Memo;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    cbPrinterList: TComboBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    GroupBox1: TGroupBox;
    rbCpi12: TRadioButton;
    rbCpi15: TRadioButton;
    rbCpi17: TRadioButton;
    Memo1: TMemo;
    TabItem3: TTabItem;
    Button4: TButton;
    StatusBar1: TStatusBar;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    procedure GetBluetoothDevices;
    procedure PrintText;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  GetBluetoothDevices;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if cbPrinterList.ItemIndex <> -1 then
    WriteValue('FMXPrinterSample', 'Printer', cbPrinterList.Selected.Text);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  // Initialize
  Prepare;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  // Print desired data
  PrintText;
  // Terminate after your works done
  Terminate;
end;

procedure TForm1.GetBluetoothDevices;
var
  I: Integer;
  btManager: TBluetoothManager;
  btDeviceList: TBluetoothDeviceList;
begin

  { ======== Get Connected Bluetooth Devices ======== }

  btManager := TBluetoothManager.Current;
  btManager.SocketTimeout := 50000;

  btDeviceList := TBluetoothDeviceList.Create();
  btDeviceList := btManager.GetPairedDevices();

  for I := 0 to Pred(btDeviceList.Count) do
  begin
    cbPrinterList.Items.Add(btDeviceList[i].DeviceName);
  end;

  if cbPrinterList.Items.Count > 0 then
    cbPrinterList.ItemIndex := 0;

end;

procedure TForm1.PrintText;
var
  i: Integer;
begin

  if rbCpi12.IsChecked then
    SetCpi(12);
  if rbCpi15.IsChecked then
    SetCpi(15);
  if rbCpi17.IsChecked then
    SetCpi(17);

  PrintEmptyLn(7);

  for i := 0 to Pred(Memo1.Lines.Count) do
  begin
    PrintLn(Memo1.Lines[i]);
  end;

end;

end.
