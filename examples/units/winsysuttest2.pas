{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2003 by the Free Pascal development team

    Windows specific versions of Borland SysUtils routines.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
//{$mode objfpc}
unit winsysut;

Interface

//Uses Windows,SysUtils;

var
  Win32Platform2     : Integer;
  Win32MajorVersion2 : Integer;
  Win32MinorVersion2 : Integer;
  Win32BuildNumber2  : Integer;

 //const
  Win32CSDVersion2 : string;

function CheckWin32Version(Major,Minor : Integer ): Boolean;
function CheckWin32Version2(Major : Integer): Boolean;
Function Win32Check2(RetVal: BOOL): BOOL;
Procedure RaiseLastWin32Error;



Implementation

procedure RaiseLastWin32Error;
begin
  RaiseLastOSError;
end;

Function Win32Check2(RetVal: BOOL): BOOL;

begin
  if Not RetVal then
    RaiseLastOSError;
  Result := RetVal;
end;

procedure InitVersion;

var
  aInfo: TOSVersionInfo;
begin
  aInfo.dwOSVersionInfoSize := SizeOf(aInfo);
  if GetVersionEx(aInfo) then
    with aInfo do begin
      Win32Platform2:=dwPlatformId;
      Win32MajorVersion2:=dwMajorVersion;
      Win32MinorVersion2:=dwMinorVersion;
      if (Win32Platform=VER_PLATFORM_WIN32_WINDOWS) then
        Win32BuildNumber2:=dwBuildNumber and $FFFF
      else
        Win32BuildNumber2:= dwBuildNumber;
      //Win32CSDVersion2:= StrPas(szCSDVersion);
      end;
end;

function CheckWin32Version2(Major : Integer): Boolean;

begin
  Result:=CheckWin32Version(Major,0)
end;

function CheckWin32Version(Major,Minor: Integer): Boolean;

begin
  Result := (Win32MajorVersion>Major) or
            ((Win32MajorVersion=Major) and (Win32MinorVersion>=Minor));
end;

//Initialization
  //InitVersion;
end.
