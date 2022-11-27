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
  RotatingCube.Form1.Create();
  Application.Scaled:=True;
  Application.Initialize;
  Application.Run;
end.

