unit PrinterHelper;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Forms, System.Bluetooth, System.Bluetooth.Components,
  IniHelper;

procedure Prepare;
procedure PrintEmptyLn(LineCount: Integer);
procedure PrintLn(S: String);
procedure Print(S: String);
procedure SetProperty(S: String);
procedure SetCpi(i: integer);
function StrToByteArr(strData: String): TArray<Byte>;
function FillItem(S: String; Ln: Integer; Align: Char): String;
procedure Terminate;

var
  fBTManager: TBluetoothManager;
  fBTDeviceList: TBluetoothDeviceList;
  bsSocket: TBluetoothSocket;
  bslServices: TBluetoothServiceList;

implementation

{$REGION 'Printer Legend'}

const
  CRLF = #13 + #10;
  // CR carriage return, LF line feed (başa dön, yeni satıra geç)

  // Font sizes (0 for largest, 9 for smallest)
  TXT_ZERO = #27 + #33 + #0;
  TXT_ONE = #27 + #33 + '1';
  TXT_TWO = #27 + #33 + '2';
  TXT_THREE = #27 + #33 + '3';
  TXT_FOUR = #27 + #33 + '4';
  TXT_FIVE = #27 + #33 + '5';
  TXT_SIX = #27 + #33 + '6';
  TXT_SEVEN = #27 + #33 + '7';
  TXT_EIGHT = #27 + #33 + '8';
  TXT_NINE = #27 + #33 + '9';

  STRIKE_F = #27 + #71 + #0;
  STRIKE_T = #27 + #71 + #1; // double strike

  ALIGN_L = #27 + #97 + '0'; // align left
  ALIGN_C = #27 + #97 + '1'; // align center
  ALIGN_R = #27 + #97 + '2'; // align right

  CPI_12 = #27 + #58 + ''; // Cpi 12
  CPI_15 = #27 + #103 + ''; // Cpi 15
  CPI_17 = #27 + #15 + ''; // Cpi 17

{$ENDREGION}

procedure Prepare;
var

  i, SelectedDevice: Integer;
  IsPrinterFound: Boolean;
  CurrentPrinter: String;
begin

  CurrentPrinter := ReadValue('FMXPrinterSample', 'Printer', 'NOTFOUND');
  fBTManager := TBluetoothManager.Create;
  fBTManager := TBluetoothManager.Current;
  bslServices := TBluetoothServiceList.Create;

  fBTDeviceList := TBluetoothDeviceList.Create();
  fBTManager.SocketTimeout := 50000;
  try
    fBTDeviceList := fBTManager.GetPairedDevices();
  Except
    Exit;
  end;

  if CurrentPrinter = 'NOTFOUND' then
    Exit;

  for I := 0 to fBTDeviceList.Count - 1 do
    if fBTDeviceList[i].DeviceName = CurrentPrinter then
    begin
      IsPrinterFound := True;
      SelectedDevice := i;
      bslServices := fBTDeviceList[SelectedDevice].GetServices;
      break;
    end;

  if not IsPrinterFound then
    Exit;

  if bslServices.Count > 0 then
  begin
    for i := 0 to bslServices.Count - 1 do
    begin
      bsSocket := fBTDeviceList[SelectedDevice].CreateClientSocket
        (bslServices[i].UUID, False);
      try
        if not bsSocket.Connected then
          bsSocket.Connect;
        Sleep(250);
        Print(#27 + '@'); // printer initialize
        Sleep(250);
      except
        on ex: Exception do
        begin
          // ShowMessage(ex.Message);
        end;
      end;
    end;
  end
  else
  begin
    Exit;
  end;
end;

{
  Converts string to byte array
}
function StrToByteArr(strData: String): TArray<Byte>;
begin
  Result := TEncoding.Unicode.GetBytes(strData);
end;

{
 Sends data to printer
}
procedure Print(S: String);
begin
  bsSocket.SendData(StrToByteArr(S));
end;

{
    Turkish character fixer
}

function Latin5(S: string): string;
const
  list1: string = 'İĞÜŞÖÇöçşğüi';
  list2: string = 'IGUSOCocsgui';
var
  j: Byte;
begin
  for j := 1 to length(list1) do
    while pos(list1[j], S) > 0 do
      S[pos(list1[j], S)] := list2[j];
  Result := S;
end;

procedure PrintLn(S: String);
begin
  bsSocket.SendData(StrToByteArr(Latin5(S) + CRLF));
end;

{
 Print empty line
}
procedure PrintEmptyLn(LineCount: Integer);
var
  I: Integer;
begin
  for I := 1 to LineCount do
    PrintLn('');

end;

{
  Set your custom properties
}
procedure SetProperty(S: String);
begin
  bsSocket.SendData(StrToByteArr(S));
end;

{
  Set character per inch value (12,15,17)
}
procedure SetCpi(i: integer);
var
  S: string;
begin
  case i of
    12:
      S := #27 + #58 + '';
    15:
      S := #27 + #103 + '';
    17:
      S := #27 + #15 + '';
  end;
  bsSocket.SendData(StrToByteArr(S));
end;

{
  Fills field with desired alignment and length.
}
function FillItem(S: String; Ln: Integer; Align: Char): String;
var
  i: Integer;
begin
  for I := length(S) to Ln do
    case Align of
      'L':
        S := S + ' ';
      'R':
        S := ' ' + S;
      'C':
        if odd(i) then
          S := S + ' '
        else
          S := ' ' + S;
    end;
  case Align of
    'L':
      Result := Copy(S, 1, Ln);
    'R':
      Result := Copy(S, length(S) - Ln + 1, Ln);
    'C':
      Result := Copy(S, 1, Ln);
  end;
end;

procedure Terminate;
begin
  bsSocket.Free;
  bslServices.Destroy;
end;

end.
