{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3Dialogs;

{------------------------------------------------------------------------------}
{ Author:    Jon Lennart Aasenden                                              }
{ Updated:   2012.04.24 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

interface

uses
  W3System, W3Components, W3Graphics, w3label, w3button;

const
  CNT_DIALOG_BUTTON_PADDING = 8;

type
  TW3AlertOptions = (aoYes, aoNo, aoYesNo, aoOK, aoCancel, aoOKCancel);
  TW3AlertResult = (roYes, roNo, roOK, roCancel);

  TW3AlertSelectEvent TW3AlertSelectEvent TObjectTObject; aResult: TW3AlertResultTW3AlertResult);

  TW3AlertButton = class(TW3Button)
  end;

  IW3AlertDialog = interface
    procedure SetupDialog(aTitle: String; aText: String; aOptions: TW3AlertOptionsTW3AlertOptions);
  end;

  TW3AlertDialog = class(TW3CustomControl, IW3AlertDialog)
  private
    FTitle: TW3Label;
    FText: TW3Label;
    FYes: TW3AlertButton;
    FNo: TW3AlertButton;
    FOptions: TW3AlertOptions;
    FReady: Boolean;
    FOnSelect: TW3AlertSelectEvent;
  protected
    procedure SetupDialog(aTitle: String; aText$2: String; aOptions: TW3AlertOptionsTW3AlertOptions);
    procedure HandleYesClick(Sender$6: TObjectTObject); virtual;
    procedure HandleNoClick(Sender$5: TObjectTObject); virtual;
    procedure Resize; override;
    procedure InitializeObject; override;
    procedure FinalizeObject; override;
    procedure StyleTagObject; override;
  public
    property Ready: Boolean read FReady;
    property Options: TW3AlertOptions read FOptions;
  published
    property OnSelect: TW3AlertSelectEvent read FOnSelect write FOnSelect;
  end;



implementation



{ **************************************************************************** }
{ TW3AlertDialog                                                               }
{ **************************************************************************** }

procedure TW3AlertDialog.InitializeObject;
begin
  inherited;
  FYes := TW3AlertButton.Create$4(Self);
  FYes.SetSize(120,42);
  FYes.Caption$4 := 'OK';
  FYes.OnClick := HandleYesClick;
  FYes.Visible$1 := False;

  FNo := TW3AlertButton.Create$4(Self);
  FNo.SetSize(120,42);
  FNo.Caption$4 := 'Cancel';
  FNo.OnClick := HandleNoClick;
  FNo.Visible$1 := False;

  FTitle := TW3Label.Create$4(Self);
  FText := TW3Label.Create$4(Self);
end;

procedure TW3AlertDialog.FinalizeObject;
begin
  FTitle.Free;
  FText.Free;
  FYes.Free;
  FNo.Free;
  inherited;
end;

procedure TW3AlertDialog.StyleTagObject;
begin
  inherited StyleTagObject;
end;

procedure TW3AlertDialog.HandleYesClick(Sender$6: TObjectTObject);
begin
  if Assigned(FOnSelect) then
  begin
    case FOptions of
    aoYes,aoYesNo,aoNo:       FOnSelect(Self,roYes);
    aoOK,aoCancel,aoOKCancel: FOnSelect(Self,roOK);
    end;
  end;
end;

procedure TW3AlertDialog.HandleNoClick(Sender$5: TObjectTObject);
begin
  if Assigned(FOnSelect) then
  begin
    case FOptions of
    aoYes,aoYesNo,aoNo:       FOnSelect(Self,roNo);
    aoOK,aoCancel,aoOKCancel: FOnSelect(Self,roCancel);
    end;
  end;
end;

procedure TW3AlertDialog.SetupDialog(aTitle: String; aText$2: String; aOptions: TW3AlertOptionsTW3AlertOptions);
begin
  if not FReady then
  begin
    BeginUpdate;
    try

      FOptions := aOptions;
      FTitle.Caption$2 := aTitle;
      FText.Caption$2 := aText$2;

      (* setup button visibility *)
      case FOptions of
      aoYes,aoOK:
        begin
          FYes.Visible$1 := True;
          FNo.Visible$1 := False;
        end;
      aoNo,aoCancel:
        begin
          FNo.Visible$1 := True;
          FYes.Visible$1 := false;
        end;
      aoYesNo,aoOKCancel:
        begin
          FYes.Visible$1 := True;
          FNo.Visible$1 := True;
        end;
      end;

      (* setup button captions *)
      case FOptions of
      aoYes:    FYes.Caption$4 := 'Yes';
      aoNo:     FNo.Caption$4 := 'No';
      aoOK:     FYes.Caption$4 := 'OK';
      aoCancel: FNo.Caption$4 := 'Cancel';
      aoYesNo:
        begin
          FYes.Caption$4 := 'Yes';
          FNo.Caption$4 := 'No';
        end;
      aoOKCancel:
        begin
          FYes.Caption$4 := 'OK';
          FNo.Caption$4 := 'Cancel';
        end;
      end;

      FTitle.Font.Name$4 := 'Helvetica, Arial, sans-serif';
      FTitle.Font.Weight := 'bold';
      FTitle.Font.Size := 24;
      FTitle.AlignText := taCenter;
      FTitle.Font.Color$1 := clWhite;
      FTitle.Container.Handle.style['text-shadow'] := '0 -1px 0 rgba(0,0,0,.8)';

      FText.Font.Size := 16;
      FText.Font.Name$4 := 'Helvetica, Arial, sans-serif';
      FText.AlignText := taCenter;


      FReady := True;

    finally
      SetWasSized;
      SetWasMoved;
      EndUpdate;
    end;

  end;
end;

procedure TW3AlertDialog.Resize;
var
  hd$3: Integer;
  wd$3: Integer;
  dx$4: Integer;
  dy$5: Integer;
begin
  inherited;

  wd$3 := Self.ScrollInfo.ScrollWidth;
  hd$3 := Self.ScrollInfo.ScrollHeight;

  FTitle.SetBounds(CNT_DIALOG_BUTTON_PADDING,CNT_DIALOG_BUTTON_PADDING,
    wd$3-(CNT_DIALOG_BUTTON_PADDING*2),32);

  FText.SetBounds(CNT_DIALOG_BUTTON_PADDING,
  FTitle.Top$1 + FTitle.Height$1 + 2,wd$3-(CNT_DIALOG_BUTTON_PADDING*2),
  100-CNT_DIALOG_BUTTON_PADDING);

  if ObjectReady
  and FReady then
  begin

    //wd := width;
    Dec(wd$3,CNT_DIALOG_BUTTON_PADDING * 2); //10px on each side

    if (FOptions in [aoYesNo,aoOKCancel]) then
      Dec(wd$3,CNT_DIALOG_BUTTON_PADDING);

    // Single button ?
    if (FOptions in [aoYes,aoOK,aoNo,aoCancel]) then
    begin
      if (FOptions in [aoYes,aoOK]) then
      begin
        dy$5 := Height$1-(FYes.Height$1+20);
        FYes.SetBounds(10,dy$5,wd$3,FYes.Height$1);
      end else
      if (FOptions in [aoNo,aoCancel]) then
      begin
        dy$5 := Height$1-(FNo.Height$1+20);
        FNo.SetBounds(10,dy$5,wd$3,FNo.Height$1);
      end;
    end else
    if (FOptions in [aoYesNo,aoOKCancel]) then
    begin
      dy$5 := hd$3-(FYes.Height$1+CNT_DIALOG_BUTTON_PADDING);
      FYes.SetBounds(CNT_DIALOG_BUTTON_PADDING,dy$5,wd$3 div 2, FYes.Height$1);

      dx$4 := (ScrollInfo.ScrollWidth-(wd$3 div 2));
      Dec(dx$4,CNT_DIALOG_BUTTON_PADDING);
      FNo.SetBounds( dx$4,dy$5,wd$3 div 2,FNo.Height$1);
    end;

  end;
end;

end.

