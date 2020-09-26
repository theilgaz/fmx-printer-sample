unit IniHelper;

interface

uses System.SysUtils, IniFiles;

function ReadValue(ASection, AKey, AValue: String): String;
function WriteValue(ASection, AKey, AValue: String): Boolean;

implementation

function ReadValue(ASection, AKey, AValue: String): String;
var
  AFile: TIniFile;
  AFileName: String;
begin
  AFileName := GetHomePath + 'FMXPrinterSample.ini';
  AFile := TIniFile.Create(AFileName);

  Result := AFile.ReadString(ASection, AKey, AValue);
  AFile.Free;

end;

function WriteValue(ASection, AKey, AValue: String): Boolean;
var
  AFile: TIniFile;
  AFileName: String;
begin

  Result := False;

  AFileName := GetHomePath + 'FMXPrinterSample.ini';
  AFile := TIniFile.Create(AFileName);
  try

    AFile.WriteString(ASection, AKey, AValue);

  finally
    AFile.Free;
    Result := True;

  end;

end;

end.
