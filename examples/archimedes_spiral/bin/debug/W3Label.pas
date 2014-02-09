unit w3label;

interface

uses
  W3System, W3Components;

type

  TTextAlign = (taLeft, taCenter, taRight);

  TW3LabelText = class(TW3CustomControl)
  end;

  TW3Label = class(TW3CustomControl)
  private
    FCaption$1: String;
    FTextAlign: TTextAlign;
    FContainer: TW3LabelText;
  protected
    function makeElementTagObj: THandle; override;
    procedure setCaption$1(const aValue$62: String); virtual;
    procedure setEnabled(aValue$63: Boolean); override;
    procedure setTextAlign$1(aNewAlignment: TTextAlignTTextAlign); virtual;
    procedure Resize; override;
    procedure InitializeObject; override;
    procedure FinalizeObject; override;
  public
    property Container: TW3LabelText read FContainer;
    class function supportAdjustment:Boolean;override;
  published
    property AlignText: TTextAlign read FTextAlign write setTextAlign$1;
    property Caption$2: String read FCaption$1 write setCaption$1;
  end;


implementation

{ **************************************************************************** }
{ TW3Label                                                                     }
{ **************************************************************************** }

procedure TW3Label.InitializeObject;
begin
  inherited InitializeObject;
  FContainer := TW3LabelText.Create$4(Self);

  w3_setStyle(FContainer.Handle, 'textOverflow', 'ellipsis');
  w3_setStyle(FContainer.Handle, 'whiteSpace', 'nowrap');
  w3_setStyle(FContainer.Handle, 'overflow', 'hidden');

  w3_setStyle(FContainer.Handle,w3_CSSPrefixDef('vertical-align'),'middle');

  setCaption$1('Label');
  Height$1 := 12;
end;

class function TW3Label.supportAdjustment:Boolean;
Begin
  Result:=false;
end;

function TW3Label.makeElementTagObj: Variant;
begin
  Result := w3_createHtmlElement('fieldset');
end;

procedure TW3Label.Resize;
var
  dx$1,dy$1: Integer;
  wd$1,hd$1:  Integer;
begin
  inherited;

  FContainer.BeginUpdate;

  FContainer.SetBounds(0,0,2,2);
  wd$1 := ClampInt(FContainer.ScrollInfo.ScrollWidth + 2, 0, ClientWidth);
  hd$1 := ClampInt(FContainer.ScrollInfo.ScrollHeight, 0, ClientHeight);

  case FTextAlign of
    taLeft:
      begin
        dy$1 := (ClientHeight div 2) - (hd$1 div 2);
        FContainer.SetBounds(0,dy$1,wd$1,hd$1);
      end;
    taCenter:
      begin
        dx$1 := (ClientWidth div 2) - (wd$1 div 2);
        dy$1 := (ClientHeight div 2) - (hd$1 div 2);
        FContainer.SetBounds(dx$1,dy$1,wd$1,hd$1);
      end;
    taRight:
      begin
        dx$1 := ClientWidth - wd$1;
        dy$1 := (ClientHeight div 2) - (hd$1 div 2);
        FContainer.SetBounds(dx$1, dy$1, wd$1, hd$1);
      end;
  end;
  FContainer.EndUpdate;
end;

procedure TW3Label.FinalizeObject;
begin
  FContainer.Free;
  inherited;
end;

procedure TW3Label.setCaption$1(const aValue$62: String);
begin
  if aValue$62<>FCaption$1 then
  begin
    BeginUpdate;
    FCaption$1 := aValue$62;
    FContainer.InnerHTML := aValue$62;
    SetWasSized;
    SetWasMoved;
    EndUpdate;
  end;
end;

procedure TW3Label.setEnabled(aValue$63: Boolean);
begin
  inherited setEnabled(aValue$63);
  FContainer.Enabled := aValue$63;
end;

procedure TW3Label.setTextAlign$1(aNewAlignment:TTextAlignTTextAlign);
var
  mToWrite: String;
begin
  BeginUpdate;
  FTextAlign := aNewAlignment;

  case aNewAlignment of
    taLeft:   mToWrite := 'left';
    taCenter: mToWrite := 'center';
    taRight:  mToWrite := 'right';
  end;

  w3_setStyle(FContainer.Handle,'text-align',mToWrite);
  SetWasSized;
  SetWasMoved;
  EndUpdate;
end;


end.
