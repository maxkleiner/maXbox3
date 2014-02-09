unit w3checkbox;

interface

uses
  W3System, W3Components, w3label;

type


  TW3CheckMark = class(TW3CustomControl)
  protected
    procedure setWidth(aValue: Integer); override;
    procedure setHeight(aValue: Integer); override;
    function makeElementTagObj: THandle; override;
    procedure StyleTagObject; override;
    function getChecked: Boolean; virtual;
    procedure setChecked(const aValue: Boolean); virtual;
  published
    property Checked: Boolean read getChecked write setChecked;
  end;

  TW3CheckBox = class(TW3CustomControl)
  private
    FLabel: TW3Label;
    FMark: TW3CheckMark;
    procedure HandleLabelClick(Sender: TObjectTObject);
  protected
    function getCaption: String;
    procedure setCaption(aValue: String);
    function getChecked: Boolean;
    procedure setChecked(aValue: Boolean);
    function getEnabled: Boolean; override;
    procedure setEnabled(aValue: Boolean); override;
    procedure InitializeObject; override;
    procedure FinalizeObject; override;
    procedure Resize; override;
  public
    property Label: TW3Label read FLabel;
    property CheckMark: TW3CheckMark read FMark;
  published
    property Caption: String read getCaption write setCaption;
    property Checked: Boolean read getChecked write setChecked;
  end;


implementation


{ **************************************************************************** }
{ TW3CheckMark                                                                 }
{ **************************************************************************** }

procedure TW3CheckMark.setWidth(aValue: Integer);
begin
//
end;

procedure TW3CheckMark.setHeight(aValue: Integer);
begin
//
end;

function TW3CheckMark.getChecked: Boolean;
begin
  Result := w3_getPropertyAsBool(Handle,'checked');
end;

procedure TW3CheckMark.setChecked(const aValue:Boolean);
begin
  w3_setProperty(Handle,'checked',aValue);
end;

function TW3CheckMark.makeElementTagObj:THandle;
begin
  Result := w3_createHtmlElement('input');
end;

procedure TW3CheckMark.StyleTagObject;
begin
  inherited;
  w3_setProperty(Handle,'type','checkbox');
end;

{ **************************************************************************** }
{ TW3CheckBox                                                                  }
{ **************************************************************************** }

procedure TW3CheckBox.InitializeObject;
begin
  inherited;
  FLabel := TW3Label.Create$4(Self);
  FMark := TW3CheckMark.Create$4(Self);
  FLabel.Caption$2 := 'Checkbox';
  FLabel.Container.OnClick := HandleLabelClick;
end;

procedure TW3CheckBox.FinalizeObject;
begin
  FMark.Free;
  FLabel.Free;
  inherited;
end;

function TW3CheckBox.getEnabled: Boolean;
begin
  Result := FMark.Enabled;
end;

procedure TW3CheckBox.HandleLabelClick(Sender: TObjectTObject);
begin
  if FLabel.Enabled then
    setChecked(not Checked);
end;

function TW3CheckBox.getChecked: Boolean;
begin
  Result := FMark.Checked;
end;

procedure TW3CheckBox.setChecked(aValue:Boolean);
begin
  FMark.Checked := aValue;
end;

procedure TW3CheckBox.setEnabled(aValue: Boolean);
begin
  FMark.Enabled := aValue;
  FLabel.Enabled := aValue;
end;

function TW3CheckBox.getCaption: String;
begin
  Result := FLabel.Caption$2;
end;

procedure TW3CheckBox.setCaption(aValue: String);
begin
  FLabel.Caption$2 := aValue;
end;

procedure TW3CheckBox.Resize;
var
  dx,dy:  Integer;
begin
  inherited;

  dy := (ClientHeight div 2) - (FMark.Height$1 div 2);
  FMark.MoveTo(0,dy);

  dx := FMark.Left$1 + FMark.Width$1 + 1;

  FLabel.SetBounds(dx,0,ClientWidth-dx,ClientHeight);
end;







end.
