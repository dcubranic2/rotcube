program rotcube;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, RotatingCube
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.CreateForm(TForm1, Form1);
  Application.Scaled:=True;
  Application.Initialize;
  Application.Run;
end.

