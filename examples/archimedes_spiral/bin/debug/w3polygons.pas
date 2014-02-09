{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3Polygons;

interface

uses 
  W3System;

type
  TPolygonHelper = helper for TPointArray
    procedure Rotate(const angle : Float; const centerX,centerY:Float);
    procedure Scale(factor : Float; const centerX,centerY:Float);
    function  Bounds$1 : TRect;
    function  FindCenter : TPoint;
  end;

  TPolygonFHelper = helper for TPointArrayF
    procedure Rotate(const angle : Float; const centerX,centerY:Float);
    procedure Scale(factor : Float; const centerX,centerY:Float);
    function  Bounds : TRectF;
    function  FindCenter : TPointF;
  end;

implementation

{ TPolygonHelper }

function TPolygonHelper.Bounds$1 : TRect;
var
   pt$1 : TPoint;
begin
   if Self$9.Length=0 then exit;
   pt$1 := Self$9.Peek;
   Result.Left$3 := pt$1.X$1;
   Result.Top$3 := pt$1.Y$1;
   Result.Right$1 := pt$1.X$1;
   Result.Bottom$1 := pt$1.Y$1;
   for pt$1 in Self$9 do begin
      if pt$1.X$1<Result.Left$3 then
         Result.Left$3 := pt$1.X$1
      else if pt$1.X$1>Result.Right$1 then
         Result.Right$1 := pt$1.X$1;
      if pt$1.Y$1<Result.Top$3 then
         Result.Top$3 := pt$1.Y$1
      else if pt$1.Y$1>Result.Bottom$1 then
         Result.Bottom$1 := pt$1.Y$1;
   end;
end;

function TPolygonHelper.FindCenter:TPoint;
begin
   if self.Length>0 then
      Result := Bounds$1.CenterPoint$1
   else Result := TPoint.Create$16(-1,-1);
end;

procedure TPolygonHelper.Rotate(const angle:Float;
         const centerX,centerY:Float);
var
   i : Integer;
   c, s, dx, dy : Float;
begin
   c := Cos(angle);
   s := Sin(angle);
   for i := self.low to self.high do begin
      dx := Self[i].X$1 - centerX;
      dy := Self[i].Y$1 - centerY;
      Self[i].X$1 := Round(centerX + dx*c - dy*s);
      Self[i].Y$1 := Round(centerY + dx*s + dy*c);
   end;
end;

procedure TPolygonHelper.Scale(factor:Float; const centerX,centerY:Float);
var
   i : Integer;
   dx, dy : Float;
begin
   dx := centerX * (1-factor);
   dy := centerY * (1-factor);
   for i := Self.Low to Self.High do begin
      Self[i].X$1 := Round( Self[i].X$1 * factor + dx );
      Self[i].Y$1 := Round( Self[i].Y$1 * factor + dy );
   end;
end;

{ TPolygonFHelper }

function TPolygonFHelper.Bounds : TRectF;
var
   pt : TPointF;
begin
   if Self$8.Length=0 then exit;
   pt := Self$8.Peek;
   Result.Left$2 := pt.X;
   Result.Top$2 := pt.Y;
   Result.Right := pt.X;
   Result.Bottom := pt.Y;
   for pt in Self$8 do begin
      if pt.X<Result.Left$2 then
         Result.Left$2 := pt.X
      else if pt.X>Result.Right then
         Result.Right := pt.X;
      if pt.Y<Result.Top$2 then
         Result.Top$2 := pt.Y
      else if pt.Y>Result.Bottom then
         Result.Bottom := pt.Y;
   end;
end;

function TPolygonFHelper.FindCenter : TPointF;
begin
   if self.Length>0 then
      Result := Bounds.CenterPoint
   else Result := TPointF.Create$15(-1,-1);
end;

procedure TPolygonFHelper.Rotate(const angle:Float;
         const centerX,centerY:Float);
var
   i : Integer;
   c, s, dx, dy : Float;
begin
   c := Cos(angle);
   s := Sin(angle);
   for i := self.low to self.high do begin
      dx := Self[i].X - centerX;
      dy := Self[i].Y - centerY;
      Self[i].X := centerX + dx*c - dy*s;
      Self[i].Y := centerY + dx*s + dy*c;
   end;
end;

procedure TPolygonFHelper.Scale(factor:Float; const centerX,centerY:Float);
var
   i : Integer;
   dx, dy : Float;
begin
   dx := centerX * (1-factor);
   dy := centerY * (1-factor);
   for i := Self.Low to Self.High do begin
      Self[i].X := Self[i].X * factor + dx;
      Self[i].Y := Self[i].Y * factor + dy;
   end;
end;

end.
