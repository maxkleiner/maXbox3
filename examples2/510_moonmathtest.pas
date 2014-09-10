{**********************************************************************
 Package pl_GeoGisComp.pkg
 From PilotLogic Software House
 for CodeTyphon Project (http://www.pilotlogic.com/)
 This unit is part of CodeTyphon Project

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

***********************************************************************}


unit MoonMath;

interface   

function tan(x:extended):extended;
function arctan2(a,b:extended):extended;
function arcsin(x:extended):extended;
function arccos(x:extended):extended;

function deg2rad(x:extended):extended;
function rad2deg(x:extended):extended;

function sin_d(x:extended):extended;
function cos_d(x:extended):extended;
function tan_d(x:extended):extended;
function arctan2_d(a,b:extended):extended;
function arcsin_d(x:extended):extended;
function arccos_d(x:extended):extended;
function arctan_d(x:extended):extended;


function put_in_360(x:extended):extended;

function adjusted_mod(a,b:integer):integer;

implementation

//uses  math;

function deg2rad(x:extended):extended;
begin
  result:=x/180*pi;
  end;

function rad2deg(x:extended):extended;
begin
  result:=x*180/pi;
end;

function tan(x:extended):extended;
begin
  result:=tan(x);
end;

function arctan2(a,b:extended):extended;
begin
  result:=arctan2(a,b);
end;

function arcsin(x:extended):extended;
begin
  result:=arcsin(x);
end;

function arccos(x:extended):extended;
begin
  result:=arccos(x);
end;

function sin_d(x:extended):extended;
begin
  result:=sin(deg2rad(put_in_360(x)));
  end;

function cos_d(x:extended):extended;
begin
  result:=cos(deg2rad(put_in_360(x)));
end;

function tan_d(x:extended):extended;
begin
  result:=tan(deg2rad(put_in_360(x)));
end;

function arctan2_d(a,b:extended):extended;
begin
  result:=rad2deg(arctan2(a,b));
end;

function arcsin_d(x:extended):extended;
begin
  result:=rad2deg(arcsin(x));
end;

function arccos_d(x:extended):extended;
begin
  result:=rad2deg(arccos(x));
end;

function arctan_d(x:extended):extended;
begin
  result:=rad2deg(arctan(x));
end;

function put_in_360(x:extended):extended;
begin
  result:=x-round(x/360)*360;
  while result<0 do result:=result+360;
end;

function adjusted_mod(a,b:integer):integer;
begin
  result:=a mod b;
  while result<1 do
    result:=result+b;
  end;

begin

  writeln(inttostr(adjusted_mod(27,10)));

    //isArray
    //TLineInfo
      //TLineBreaker
      //isFunc
      //GetFuncParam
        //TFuncParam
      //TNameKind
      //jcountchar
      //TMapViewer
        {TArea = record
    top, left, bottom, right: Int64;
  end;   }

  {TRealArea = record
    top, left, bottom, right: Extended;
  end;}

  {TIntPoint = record
    X, Y: Int64;
  end;}

  {TRealPoint = record
    X, Y: Extend   }
    //TOnBeforeDownloadEvent = procedure(Url: string; str: TStream; var CanHandle: Boolean) of object;
  //TOnAfterDownloadEvent 
     //TMapSource
     //TArea
      
      
      
      
      
      
end.

