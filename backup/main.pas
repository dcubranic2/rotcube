unit RotatingCube;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, FPImage,
  LCLProc, Menus;

type

  { TForm1 }

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItemStartStop: TMenuItem;
    PaintBox1: TPaintBox;
    procedure PaintBox1Paint(Sender: TObject);
    procedure MenuItemStartStopClick(Sender: TObject);

  private

  public

  end;

var
  Form1: TForm1;
  mStartRotation: boolean;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.PaintBox1Paint(Sender: TObject);
var x,color1,temp:integer;
var vertex: array[1..8,1..3] of real;
var screenWidth,screenHeight:integer;
var scale,phi,theta,zed,rotx1,roty1,rotx2,roty2:real;
begin
  { z is looking towards screen }
  { points 1 to 4 in front of screen clockwise }
  { points 5 to 8 in back of screen clockwise }
  vertex[1,1] := -50;
  vertex[1,2] := 50;
  vertex[1,3] := -50;
  vertex[2,1] := 50;
  vertex[2,2] := 50;
  vertex[2,3] := -50;
  vertex[3,1] := 50;
  vertex[3,2] := -50;
  vertex[3,3] := -50;
  vertex[4,1] := -50;
  vertex[4,2] := -50;
  vertex[4,3] := -50;
  vertex[5,1] := -50;
  vertex[5,2] := 50;
  vertex[5,3] := 50;
  vertex[6,1] := 50;
  vertex[6,2] := 50;
  vertex[6,3] := 50;
  vertex[7,1] := 50;
  vertex[7,2] := -50;
  vertex[7,3] := 50;
  vertex[8,1] := -50;
  vertex[8,2] := -50;
  vertex[8,3] := 50;

  screenWidth := Form1.Width;
  screenHeight := Form1.Height;
  scale := 2.0;

  zed :=0;
  color1 :=0;
  PaintBox1.Canvas.Clear();
  Form1.Invalidate();
  while zed <= 3.14 / 4 do
  begin
       for x:=1 to 4 do
           begin
                if (x+1) mod 4 = 4 then temp := 1 else temp := x + 1;
                if mStartRotation then
                begin
                     rotx1 := (vertex[x,1]*scale*cos(zed))-(vertex[x,2]*scale*sin(zed))+(screenWidth/2);
                     roty1 := (vertex[x,1]*scale*sin(zed))+(vertex[x,2]*scale*sin(zed))+(screenHeight/2);
                     rotx2 := (vertex[temp,1]*scale*cos(zed))-(vertex[temp,2]*scale*sin(zed))+(screenWidth/2);
                     roty2 := (vertex[temp,1]*scale*sin(zed))+(vertex[temp,2]*scale*sin(zed))+(screenHeight/2);
                end
                else
                begin
                     rotx1 := (vertex[x,1]*scale)+(screenWidth/2);
                     roty1 := (vertex[x,2]*scale)+(screenHeight/2);
                     rotx2 := (vertex[temp,1]*scale)+(screenWidth/2);
                     roty2 := (vertex[temp,2]*scale)+(screenHeight/2);
                end;

                DebugLn(FloatToStr(rotx1),' ',FloatToStr(roty1),' ',FloatToStr(rotx2),' ',FloatToStr(roty2));

                With  PaintBox1.Canvas do
                begin
                     Pen.Color := RGBToColor(color1,0,0);
                     Line(Round(rotx1),Round(roty1),Round(rotx2),Round(roty2));
                end;
           end;
       //zed:=zed+0.005;
       zed := zed + 5;
       color1 := color1 +20;
  end;
end;


procedure TForm1.MenuItemStartStopClick(Sender: TObject);
begin
   mStartRotation:= not mStartRotation;
   PaintBox1Paint(Sender);
end;

initialization
  mStartRotation := false;
end.












  PaintBox1.Canvas.Line(0,0,Form1.Width,Form1.Height);
end;

procedure TForm1.MenuItemStartStopClick(Sender: TObject);
begin

end;

end.

