unit w3toolbar;

interface

uses
  W3System, W3Components, w3image;

type


  TW3ToolbarButton = class(TW3CustomControl)
  private
    FGlyph: TW3Image;
    FCaption: String;
  protected
    procedure ChangeCaption(aNewCaption: String); virtual;
    procedure HandleGlyphReady(Sender: TObjectTObject);
    procedure SetCaption(aNewCaption: String); virtual;
    procedure InitializeObject; override;
    procedure FinalizeObject; override;
    function makeElementTagObj: THandle; override;
  published
    property Glyph: TW3Image read FGlyph;
    property Caption: String read FCaption write setCaption;
  end;

  TW3Toolbar = class(TW3CustomControl)
  private
    FBtnWidth: Integer;
    FBtnHeight: Integer;
    FBtnSpacing: Integer;
  protected
    procedure setBtnWidth(Value: Integer); virtual;
    procedure setBtnHeight(Value: Integer); virtual;
    procedure setBtnSpacing(Value: Integer); virtual;
    procedure Resize; override;
    procedure InitializeObject; override;
  public
    function add: TW3ToolbarButton;
  published
    property ButtonSpace: Integer read FBtnSpacing write setBtnSpacing;
    property ButtonWidth: Integer read FBtnWidth write setBtnWidth;
    property ButtonHeight: Integer read FBtnHeight write setBtnHeight;
  end;

Implementation

{ **************************************************************************** }
{ TW3ToolbarButton                                                             }
{ **************************************************************************** }

procedure TW3ToolbarButton.InitializeObject;
begin
  inherited;
  FGlyph := TW3Image.Create$4(nil);
  FGlyph.OnLoad := HandleGlyphReady;
end;

procedure TW3ToolbarButton.ChangeCaption(aNewCaption: String);
var
  mHtml:  String;
begin
  FCaption := aNewCaption;

  if FGlyph.Ready then
  begin
    mHtml := mHtml + '<img src="' + FGlyph.Url + '" width=16px height=16px>';
    mHtml := mHtml + '<br>';
  end;
  mHtml := mHtml + FCaption;

  InnerHTML := mHtml;
end;

procedure TW3ToolbarButton.FinalizeObject;
begin
  FGlyph.Free;
  inherited;
end;

procedure TW3ToolbarButton.HandleGlyphReady(Sender: TObjectTObject);
var
  mTemp:  String;
begin
  mTemp := FCaption;
  FCaption := '';
  ChangeCaption(mTemp);
end;

procedure TW3ToolbarButton.setCaption(aNewCaption: String);
begin
  if aNewCaption<>FCaption then
    ChangeCaption(aNewCaption);
end;

function TW3ToolbarButton.makeElementTagObj:THandle;
begin
  Result := w3_createHtmlElement('button');
end;

{ **************************************************************************** }
{ TW3Toolbar                                                                   }
{ **************************************************************************** }

procedure TW3Toolbar.InitializeObject;
begin
  inherited;
  FBtnWidth := 100;
  FBtnHeight := 36;
  FBtnSpacing := 2;
end;

procedure TW3Toolbar.setBtnWidth(Value: Integer);
begin
  Value := TInteger.EnsureRange(Value,16,MAX_INT);
  if Value<>FBtnWidth then
  begin
    BeginUpdate;
    FBtnWidth := Value;
    SetWasSized;
    EndUpdate;
  end;
end;

procedure TW3Toolbar.setBtnHeight(Value: Integer);
begin
  if ObjectReady then
  Value := TInteger.EnsureRange(Value,16,Height$1) else
  Value := TInteger.EnsureRange(Value,16,MAX_INT);

  if Value<>FBtnHeight then
  begin
    BeginUpdate;
    FBtnHeight := Value;
    SetWasSized;
    EndUpdate;
  end;
end;

procedure TW3Toolbar.setBtnSpacing(Value: Integer);
begin
  Value := TInteger.EnsureRange(Value,1,MAX_INT);
  if Value<>FBtnSpacing then
  begin
    FBtnSpacing := Value;
    LayoutChildren;
  end;
end;

procedure TW3Toolbar.resize;
var
  x:  Integer;
  dx,dy: Integer;
  mChild: TObject;
begin
  dx := FBtnSpacing;
  for x := 0 to GetChildCount-1 do
  begin
    mChild := GetChildObject(x);
    if (mChild is TW3ToolbarButton) then
    begin
      //dy := (Height div 2) - (TW3ToolbarButton(mChild).Height div 2);
      dy:=0;
      TW3ToolbarButton(mChild).SetBounds(dx,dy,FBtnWidth,Height$1);
      Inc(dx,FBtnWidth + FBtnSpacing);
    end;
  end;
end;

function TW3Toolbar.Add: TW3ToolbarButton;
begin
  BeginUpdate;
  try

    try
      Result := TW3ToolbarButton.Create$4(Self);
    except
      on e: Exception do
      begin
        Result := nil;
        raise ;
      end;
    end;

    Result.Height$1 := FBtnHeight;
    Result.Width$1 := FBtnWidth;

  finally
    SetWasSized;
    EndUpdate;
  end;
end;



end.
