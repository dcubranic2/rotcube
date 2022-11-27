unit RotatingCube;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, FPImage,
  LCLProc, Menus, Buttons, ComCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItemPerspective: TMenuItem;
    MenuItemExit: TMenuItem;
    MenuItemStartStop: TMenuItem;
    PaintBox1: TPaintBox;
    Separator1: TMenuItem;
    Timer1: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure MenuItemExitClick(Sender: TObject);
    procedure MenuItemPerspectiveClick(Sender: TObject);
    procedure PaintBox1Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure MenuItemStartStopClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

  private

  public

  end;

var
  Form1: TForm1;
  mStartRotation: boolean;
  mPerspective : boolean;
  x, color1: integer;
  vertex: array[1..8, 1..3] of real;
  rotvert: array[1..8, 1..3] of real;
  screenWidth, screenHeight: integer;
  scale, phi, theta, zed, F : real;

implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.FormActivate(Sender: TObject);
begin
  DebugLn('FormActivate');
end;

procedure TForm1.FormDeactivate(Sender: TObject);
begin
  DebugLn('FormDeactivate');
  Timer1.Enabled:=false;
end;

procedure TForm1.MenuItemExitClick(Sender: TObject);
begin
  Form1.Close();
end;

procedure TForm1.MenuItemPerspectiveClick(Sender: TObject);
begin
     mPerspective := not mPerspective;
     MenuItemPerspective.Checked := mPerspective;
end;

procedure TForm1.PaintBox1Click(Sender: TObject);
begin
     MenuItemStartStopClick(Sender);
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  temp: integer;
  rotx1, roty1, rotz1, rotx2, roty2, rotz2: real;
begin
  DebugLn('PaintBoxPaint');
  screenWidth := Form1.Width;
  screenHeight := Form1.Height- MainMenu1.Height;

  begin
    {clear frame}
    PaintBox1.Canvas.Clear();
    Form1.Invalidate();

    {precalculation}
    for x := 1 to 8 do
    begin
         if mStartRotation then
         begin
         rotvert[x,1] := (vertex[x, 1] * scale * cos(zed)*cos(theta)) +
                         (vertex[x, 2] * scale * (cos(zed)*sin(theta)*sin(phi)-(sin(zed)*cos(phi))))+
                         (vertex[x, 3] * scale * (cos(zed)*sin(theta)*cos(phi)+(sin(zed)*sin(phi))));

         rotvert[x,2] := (vertex[x, 1] * scale * sin(zed)*cos(theta)) +
                         (vertex[x, 2] * scale * (sin(zed)*sin(theta)*sin(phi)+(cos(zed)*cos(phi)))) +
                         (vertex[x, 3] * scale * (sin(zed)*sin(theta)*cos(phi)-(cos(zed)*sin(phi))));

         rotvert[x,3] := -(vertex[x, 1] * scale *sin(theta))+
                         (vertex[x, 2] * scale *cos(theta)*sin(phi))+
                         (vertex[x, 3] * scale *cos(theta)*cos(phi));
         end;

    end;
    {drawing front + back squares}
    for x := 1 to 8 do
    begin
      if x mod 4 = 0 then
          temp := x - 3 // for x = 4 -> 1, for x = 8 ->5
      else
          temp := x + 1;

      DebugLn(IntToStr(temp));

      if mStartRotation then
      begin
           if mPerspective then rotz1 := F / (rotvert[x,3]+F) else rotz1 := 1;
           rotx1 := rotvert[x,1] * rotz1 + (screenWidth / 2);
           roty1 := rotvert[x,2] * rotz1 + (screenHeight / 2);

           if mPerspective then rotz2 := F / (rotvert[temp,3]+F) else rotz2 := 1;
           rotx2 := rotvert[temp,1] * rotz2 + (screenWidth / 2);
           roty2 := rotvert[temp,2] * rotz2 + (screenHeight / 2);

      end
      else
      begin
           rotx1 := (vertex[x, 1] * scale) + (screenWidth / 2);
           roty1 := (vertex[x, 2] * scale) + (screenHeight / 2);
           rotx2 := (vertex[temp, 1] * scale) + (screenWidth / 2);
           roty2 := (vertex[temp, 2] * scale) + (screenHeight / 2);
      end;

      DebugLn(FloatToStr(rotx1), ' ', FloatToStr(roty1), ' ',
        FloatToStr(rotx2), ' ', FloatToStr(roty2));

      with  PaintBox1.Canvas do
      begin
        if x <= 4 then
           Pen.Color := RGBToColor(255, 0, 0)
        else
           Pen.Color := RGBToColor(0, 255, 0);

        Line(Round(rotx1), Round(roty1), Round(rotx2), Round(roty2));
      end;
    end;
    { draw lines between front and back squares}
    for x := 1 to 4 do
    begin
         temp := x + 4;
         if mPerspective then rotz1 := F / (rotvert[x,3]+F) else rotz1 := 1;
         rotx1 := rotvert[x,1] * rotz1 + (screenWidth / 2);
         roty1 := rotvert[x,2] * rotz1 + (screenHeight / 2);

         if mPerspective then rotz2 := F / (rotvert[temp,3]+F) else rotz2 := 1;
         rotx2 := rotvert[temp,1] * rotz2 + (screenWidth / 2);
         roty2 := rotvert[temp,2] * rotz2 + (screenHeight / 2);
         with  PaintBox1.Canvas do
         begin
            Pen.Color := RGBToColor(0, 0, 255);
            Line(Round(rotx1), Round(roty1), Round(rotx2), Round(roty2));
         end;
    end;

    //zed := zed + 0.05;
    theta := theta + 0.05;
    //phi := phi + 0.05;

    //color1 := color1 +20;
  end;
end;




procedure TForm1.MenuItemStartStopClick(Sender: TObject);
begin
  DebugLn('MenuItemStartStopClick');
  mStartRotation := not mStartRotation;
  Timer1.Enabled := mStartRotation;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  DebugLn('Timer');
  PaintBox1Paint(Sender);
end;

initialization
  mStartRotation := False;
  mPerspective := False;
  { x is looking from left to right}
  { y is looking from top to bottom }
  { z is looking from the screen }
  { left hand coordinate system }
  { points 1 to 4 in back of screen clockwise - red color}
  { points 5 to 8 in front of screen clockwise  - green colors}
  { camera is in the front of screen at the point F}
  { cube is projected in the x - y plane , z=0 }
  vertex[1, 1] := -50;
  vertex[1, 2] := 50;
  vertex[1, 3] := -50;
  vertex[2, 1] := 50;
  vertex[2, 2] := 50;
  vertex[2, 3] := -50;
  vertex[3, 1] := 50;
  vertex[3, 2] := -50;
  vertex[3, 3] := -50;
  vertex[4, 1] := -50;
  vertex[4, 2] := -50;
  vertex[4, 3] := -50;
  vertex[5, 1] := -50;
  vertex[5, 2] := 50;
  vertex[5, 3] := 50;
  vertex[6, 1] := 50;
  vertex[6, 2] := 50;
  vertex[6, 3] := 50;
  vertex[7, 1] := 50;
  vertex[7, 2] := -50;
  vertex[7, 3] := 50;
  vertex[8, 1] := -50;
  vertex[8, 2] := -50;
  vertex[8, 3] := 50;
  scale := 1.7;

  phi := 0;
  theta := 0;
  zed := 0;
  F := 300;
  color1 := 0;
end.
end.
