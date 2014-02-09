{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3Forms;

{------------------------------------------------------------------------------}
{ Author:    Jon Lennart Aasenden                                              }
{ Updated:   2012.04.24 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

interface

uses
  W3System, W3Lists, W3Components, W3Graphics;

type
  { TW3CustomForm }
  TW3CustomForm = class(TW3CustomControl)
  private
    FCaption$2: String;
    procedure setCaption$2(Value$10: String);
  protected
    procedure StyleTagObject; override;
  public
    procedure FormActivated; virtual;
    procedure FormDeActivated; virtual;
  published
    property Caption$3: String read FCaption$2 write setCaption$2;
  end;
  TW3CustomFormClass = class of TW3CustomForm;

  { TW3Form }
  TW3Form = class(TW3CustomForm)
  end;



implementation



{ **************************************************************************** }
{ TW3CustomForm                                                                }
{ **************************************************************************** }

procedure TW3CustomForm.StyleTagObject;
begin
  inherited;
  (* Indicate to webkit that we want hardware support of possible *)
  w3_setStyle(Handle,w3_CSSPrefix('Transform'),'none');
  StyleClass := 'TW3CustomForm';
end;

procedure TW3CustomForm.setCaption$2(Value$10: String);
begin
  FCaption$2 := Value$10;
end;

procedure TW3CustomForm.FormActivated;
var
  x$23:    Integer;
  mCount$4: Integer;
  mObj$21: TObject;
  mControl: TW3CustomControl;
begin
  if ObjectReady then
  begin
    mCount$4 := GetChildCount;
    for x$23 := 0 to mCount$4-1 do
    begin
      mObj$21 := GetChildObject(x$23);
      if (mObj$21 is TW3CustomControl) then
      begin
        mControl := TW3CustomControl(mObj$21);
        if mControl.ObjectReady then
        begin
          if mControl.Visible$1 then
          mControl.LayoutChildren;
        end;
      end;
    end;
  end;
end;

procedure TW3CustomForm.FormDeActivated;
begin
//
end;

end.
