{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvPlaylist.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is Sébastien Buysse [sbuysse att buypin dott com]
Portions created by Sébastien Buysse are Copyright (C) 2001 Sébastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck att bigfoot dott com].

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvPlaylist.pas 12461 2009-08-14 17:21:33Z obones $

unit JvPlaylist;

//{$I jvcl.inc}

interface

//uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  //SysUtils, Classes, Messages, Controls, StdCtrls,
  //JvCtrls, JvListBox;
  
{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL: https://jvcl.svn.sourceforge.net/svnroot/jvcl/branches/JVCL3_40_PREPARATION/run/JvPlaylist.pas $';
    Revision: '$Revision: 12461 $';
    Date: '$Date: 2009-08-14 19:21:33 +0200 (ven., 14 aoÃ»t 2009) $';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}
  

  var
    FShowNumbers: Boolean;
    FItems: TStringList;
    FShowExtension, multiselect: Boolean;
    FRefresh: Boolean;
    FShowDrive: Boolean;
    mylistbox: TJvListbox;
    mystrings, items: TStrings;
    
    
procedure TJvPlaylist_Create(AOwner: TComponent);

procedure {destructor} TJvPlaylist_Destroy;

function TJvPlaylist_GetPath(Value: string; Position: Integer): string;

procedure TJvPlaylist_AddItem(Item: string; AObject: TObject);

procedure TJvPlaylist_AddItems(Value: TStrings);

function TJvPlaylist_GetItem(Index: Integer): string;

procedure TJvPlaylist_DeleteDeadFiles;

procedure TJvPlaylist_SortBySongName;

procedure TJvPlaylist_SortByPath;

procedure TJvPlaylist_ReverseOrder;

procedure TJvPlaylist_SortByPathInverted;

procedure TJvPlaylist_SortBySongNameInverted;

procedure TJvPlaylist_RandomOrder;

procedure TJvPlaylist_SavePlaylist(FileName: string);

procedure TJvPlaylist_LoadPlaylist(FileName: string);

procedure TJvPlaylist_Refresh;

procedure TJvPlaylist_SetShowNumbers(const Value: Boolean);

function TJvPlaylist_GetItems: TStrings;

procedure TJvPlaylist_SetItems(const Value: TStrings);

procedure TJvPlaylist_SetShowExtension(const Value: Boolean);

procedure TJvPlaylist_ItemsChanged(Sender: TObject);

procedure TJvPlaylist_LBDeleteString(var Msg: TMessage);

procedure TJvPlaylist_Changed;

procedure TJvPlaylist_MoveSelectedDown;

procedure TJvPlaylist_MoveSelectedUp;

procedure TJvPlaylist_SetShowDrive(const Value: Boolean);
  

{type
  TJvPlaylist = class(TJvListBox)
  private
    FShowNumbers: Boolean;
    FItems: TStringList;
    FShowExtension: Boolean;
    FRefresh: Boolean;
    FShowDrive: Boolean;
    function GetItems: TStrings;
    procedure SetShowNumbers(const Value: Boolean);
    procedure SetItems(const Value: TStrings);
    procedure SetShowExtension(const Value: Boolean);
    procedure SetShowDrive(const Value: Boolean);
  protected
    procedure LBDeleteString(var Msg: TMessage); message LB_DELETESTRING;
    procedure Changed; override;
    function GetPath(Value: string; Position: Integer): string;
    procedure Refresh;
    procedure ItemsChanged(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddItem(Item: string; AObject: TObject); override;
    procedure AddItems(Value: TStrings);
    function GetItem(Index: Integer): string;
    procedure DeleteDeadFiles;
    procedure SortBySongName;
    procedure SortByPath;
    procedure SortByPathInverted;
    procedure SortBySongNameInverted;
    procedure ReverseOrder;
    procedure RandomOrder;
    procedure MoveSelectedUp; override;
    procedure MoveSelectedDown; override;
    procedure SavePlaylist(FileName: string);
    procedure LoadPlaylist(FileName: string);
  published
    property ShowDrive: Boolean read FShowDrive write SetShowDrive default True;
    property ShowNumbers: Boolean read FShowNumbers write SetShowNumbers default False;
    property ShowExtension: Boolean read FShowExtension write SetShowExtension default False;
    property Items: TStrings read GetItems write SetItems;
  end; }


implementation


// (rom) better simplify by eliminating FItems altogether

procedure TJvPlaylist_Create(AOwner: TComponent);
begin
  //inherited Create(AOwner);
  FShowDrive := True;
  FShowNumbers := False;
  FShowExtension := False;
  FRefresh := False;
  FItems := TStringList.Create;
  //FItems.OnChange := ItemsChanged;
end;

procedure {destructor} TJvPlaylist_Destroy;
begin
  FItems.Free;
  //inherited Destroy;
end;

function TJvPlaylist_GetPath(Value: string; Position: Integer): string;
var
  I: Integer;
begin
  Result := Value;
  if not FShowDrive then begin
    I := Pos(':', Result);
    if I > 0 then
      Result := Copy(Result, I + 1, Length(Result));
  end;
  if not FShowExtension then
    Result := ChangeFileExt(Result, '');
  if FShowNumbers then
    Result := IntToStr(Position + 1) + '. ' + Result;
end;

procedure TJvPlaylist_AddItem(Item: string; AObject: TObject);
begin
  mystrings.AddObject(Item, AObject);
end;

procedure TJvPlaylist_AddItems(Value: TStrings);
begin
  mystrings.AddStrings(Value);
end;

function TJvPlaylist_GetItem(Index: Integer): string;
begin
  Result := mystrings[Index];
end;

procedure TJvPlaylist_DeleteDeadFiles;
var
  I: Integer;
begin
  for I := mystrings.Count - 1 downto 0 do
    if not FileExists(mystrings[I]) then
      mystrings.Delete(I);
end;

procedure TJvPlaylist_SortBySongName;
var
  A, B, C: Integer;
begin
  FRefresh := True;
  for A := 0 to Items.Count - 1 do
  begin
    C := A;
    for B := A to Items.Count - 1 do
      if ExtractFileName(Items[B]) < ExtractFileName(Items[C]) then
        C := B;
    Items.Exchange(A, C);
  end;
  FRefresh := False;
  //mylistbox.Refresh;
end;

procedure TJvPlaylist_SortByPath;
begin
  FItems.Sort;
end;

procedure TJvPlaylist_ReverseOrder;
var
  I, J: Integer;
begin
  J:= FItems.Count - 1;
  for I := 0 to FItems.Count div 2 - 1 do
    //FItems.Exchange(I, J - I);
end;


procedure TJvPlaylist_SortByPathInverted;
begin
  FItems.Sort;
  TJvPlaylist_ReverseOrder;
end;

procedure TJvPlaylist_SortBySongNameInverted;
begin
  TJvPlaylist_SortBySongName;
  TJvPlaylist_ReverseOrder;
end;


procedure TJvPlaylist_RandomOrder;
var
  I, J, K: Integer;
begin
  Randomize;
  for I := 0 to FItems.Count div 2 do begin
    J := Random(FItems.Count);
    K := Random(FItems.Count);
    Items.Exchange(J, K);
  end;
end;

procedure TJvPlaylist_SavePlaylist(FileName: string);
begin
  FItems.SaveToFile(FileName);
end;

procedure TJvPlaylist_LoadPlaylist(FileName: string);
var
  St, St2: string;
  I: Integer;
begin
  FItems.LoadFromFile(FileName);
  // was commented
  FItems.Clear;
  with TStringList.Create do begin
    LoadFromFile(FileName);
    for I := 0 to Count - 1 do
    begin
      St := Strings[I];
      if Length(St) > 0 then
        if St[1] <> '#' then begin
          St2 := ExtractFilePath(FileName);
          if St2[Length(St2)] <> '\' then
            St2 := St2 + '\';
          if (not FileExists(St)) or (Pos('\', St) = 0) then
            if FileExists(St2 + St) then
              St := St2 + St;
          FItems.Add(St);
        end;
    end;
    Free;
  end;
  
end;

procedure TJvPlaylist_Refresh;
var
  I: Integer;
begin
  FRefresh := True;
  Items.BeginUpdate;
  if Items.Count <> Items.Count then
  begin
    Items.Clear;
    for I := 0 to Items.Count - 1 do
      Items.Add(TJvPlaylist_GetPath(Items[I], I));
  end
  else
    for I := 0 to Items.Count - 1 do
      Items[I] := TJvPlaylist_GetPath(Items[I], I);
  Items.EndUpdate;
  FRefresh := False;
end;

procedure TJvPlaylist_SetShowNumbers(const Value: Boolean);
begin
  if Value <> FShowNumbers then
  begin
    FShowNumbers := Value;
    TJvPlaylist_Refresh;
  end;
end;

function TJvPlaylist_GetItems: TStrings;
begin
  Result := FItems;
end;

procedure TJvPlaylist_SetItems(const Value: TStrings);
begin
  FItems.Assign(Value);
  TJvPlaylist_Refresh;
end;

procedure TJvPlaylist_SetShowExtension(const Value: Boolean);
begin
  if Value <> FShowExtension then
  begin
    FShowExtension := Value;
    TJvPlaylist_Refresh;
  end;
end;

procedure TJvPlaylist_ItemsChanged(Sender: TObject);
begin
  TJvPlaylist_Refresh;
end;


procedure TJvPlaylist_LBDeleteString(var Msg: TMessage);
begin
  //inherited;
  if not FRefresh then begin
    FItems.OnChange := nil;
    Items.Delete(Longint(Msg.WParam));
    FItems.OnChange := @TJvPlaylist_ItemsChanged;
  end;
end;


procedure TJvPlaylist_Changed;
begin
  TJvPlaylist_Refresh;
end;

var itemindex, selcount: integer;

procedure TJvPlaylist_MoveSelectedDown;
var
  I: Integer;
begin
  if MultiSelect = False then begin
    if (ItemIndex <> -1) and (ItemIndex < Items.Count - 1) then begin
      Items.Exchange(ItemIndex, ItemIndex + 1);
      ItemIndex := ItemIndex + 1;
    end;
    Exit;
  end;
  FItems.OnChange := nil;
  FRefresh := True;
 { if (Items.Count > 0) and (SelCount > 0) and not Selected[Items.Count - 1] then begin
    I := Items.Count - 2;
    while I >= 0 do
    begin
      if Selected[I] then begin
        Items.Exchange(I, I + 1);
        Selected[I + 1] := True;
      end;
      Dec(I);
    end;
  end; }
  FRefresh := False;
  FItems.OnChange := @TJvPlaylist_ItemsChanged;
  TJvPlaylist_Refresh;
end;

procedure TJvPlaylist_MoveSelectedUp;
var
  I: Integer;
begin
  if MultiSelect = False then
  begin
    if ItemIndex > 1 then
    begin
      Items.Exchange(ItemIndex, ItemIndex - 1);
      ItemIndex := ItemIndex - 1;
    end;
    Exit;
  end;
  FItems.OnChange := nil;
  FRefresh := True;
 { if (Items.Count > 0) and (SelCount > 0) and not Selected[0] then begin
    I := 1;
    while I < Items.Count do
    begin
      if Selected[I] then
      begin
        Items.Exchange(I, I - 1);
        Selected[I - 1] := True;
      end;
      Inc(I);
    end;
  end;}
  FRefresh := False;
  FItems.OnChange := @TJvPlaylist_ItemsChanged;
  TJvPlaylist_Refresh;
end;

procedure TJvPlaylist_SetShowDrive(const Value: Boolean);
begin
  if FShowDrive <> Value then begin
    FShowDrive := Value;
    TJvPlaylist_Refresh;
  end;
end;

{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING} 

//begin
end.
