program FMXPrinterSample;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainUnit in 'MainUnit.pas' {Form1},
  PrinterHelper in 'Infrastructure\PrinterHelper.pas',
  IniHelper in 'Infrastructure\IniHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
