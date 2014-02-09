unit w3header;

interface

uses
  W3System, W3Components, w3label, w3toolbutton;

type

  TW3HeaderControl = class(TW3CustomControl)
  private
    FLabel: TW3Label;
    FSpacing: Integer;
    FBackBtn: TW3ToolButton;
    FNextBtn: TW3ToolButton;
  protected
    procedure Resize; override;
    procedure InitializeObject; override;
    procedure FinalizeObject; override;
  public
    class function supportAdjustment:Boolean;override;
    property BackButton: TW3ToolButton read FBackBtn;
    property NextButton: TW3ToolButton read FNextBtn;
    property Title: TW3Label read FLabel;
  end;

Implementation

{ **************************************************************************** }
{ TW3HeaderControl                                                             }
{ **************************************************************************** }

class function TW3HeaderControl.supportAdjustment:Boolean;
Begin
  Result:=False;
end;

procedure TW3HeaderControl.InitializeObject;
begin
  inherited;
  FSpacing := 4;

  FLabel := TW3Label.Create$4(Self);
  FLabel.Font.Name$4 := 'verdana';
  FLabel.Font.Color$1 := RGBToColor($FF,$FF,$FF);
  FLabel.Font.Weight := 'bold';
  FLabel.Font.Size := 18;

  FLabel.Caption$2 := ClassName;
  FLabel.AlignText := taLeft;

  FBackBtn := TW3ToolButton.Create$4(Self);
  FBackBtn.Caption := 'Back';
  FBackBtn.Visible$1 := true;

  FNextBtn := TW3ToolButton.Create$4(Self);
  FNextBtn.Caption := 'Next';
  FNextBtn.Visible$1 := false;
end;

procedure TW3HeaderControl.FinalizeObject;
begin
  FLabel.Free;
  FBackBtn.Free;
  FNextBtn.Free;
  inherited;
end;

procedure TW3HeaderControl.Resize;
var
  wd,hd:  Integer;
  mTemp:  Integer;
  dx,dy:  Integer;
begin
  wd := ClientWidth;
  hd := ClientHeight;
  dx := FSpacing;

  (* [left ---- Right]  margin *)
  mTemp := wd;
  Dec(mTemp,FSpacing * 2);

  (* position back button *)
  dy := (hd div 2) - (FBackBtn.Height$1 div 2);
  FBackBtn.MoveTo(FSpacing,dy);

  (* position next button *)
  dy := (hd div 2) - (FNextBtn.Height$1 div 2);
  FNextBtn.MoveTo(wd-(FSpacing + FNextBtn.Width$1),dy);

  (* Take back-button into concideration? *)
  if FBackBtn.Visible$1=true then
  begin
    Inc(dx,FBackBtn.Width$1);
    Inc(dx,FSpacing);
    Dec(mTemp,FBackBtn.Width$1);
    Dec(mTemp,FSpacing);
  end;

  (* offset label *)
  FLabel.MoveTo(dx,FSpacing);

  (* take right button into concideration *)
  if FNextBtn.Visible$1 then
  begin
    Dec(mTemp,FNextBtn.Width$1);
    Dec(mTemp,FSpacing);
    Dec(mTemp,FSpacing);
  end;

  (* finalize label position *)
  FLabel.SetBounds(FLabel.Left$1,FSpacing,mTemp,hd-(FSpacing * 2));
end;





end.
