unit w3memo;

interface

uses
  W3System, W3Components;

type

  TW3MemoScrollbarOption = (soNone, soAuto, soScroll);

  TW3Memo = class(TW3CustomControl)
  protected
    function  makeElementTagObj: THandle; override;
    function  getHOpt: TW3MemoScrollbarOption;
    procedure setHOpt(const aValue: TW3MemoScrollbarOption);
    function  getVOpt: TW3MemoScrollbarOption;
    procedure setVOpt(const aValue: TW3MemoScrollbarOption);
    procedure setText(aValue: String); virtual;
    function  getText: String; virtual;
    procedure StyleTagObject; override;
  public
    property  ScrollH: TW3MemoScrollbarOption read getHOpt write setHOpt;
    property  ScrollV: TW3MemoScrollbarOption read getVopt write setVopt;
  published
    property  Text: String read getText write setText;
  end;

implementation


{ **************************************************************************** }
{ TW3Memo                                                                      }
{ **************************************************************************** }

function TW3Memo.makeElementTagObj:THandle;
begin
  Result := w3_createHtmlElement('textarea');
end;

procedure TW3Memo.StyleTagObject;
begin
  inherited;
  w3_setStyle(Handle,'overflow','scroll');
  w3_setStyle(Handle,'overflow-x','scroll');
  w3_setStyle(Handle,'overflow-y','scroll');
end;

function TW3Memo.getHOpt: TW3MemoScrollbarOption;
var
  mData:  Variant;
begin
  Result := soNone;
  mData := w3_getStyle(Handle,'overflow-x');
  if VarIsValidRef(mData) then
  begin
    case LowerCase(TVariant.AsString(mData)) of
    'auto': Result := soAuto;
    'scroll': Result := soScroll;
    end;
  end;
end;

procedure TW3Memo.setHOpt(const aValue: TW3MemoScrollbarOption);
begin
  case aValue of
  soNone:   w3_setStyle(Handle,'overflow-x','');
  soAuto:   w3_setStyle(Handle,'overflow-x','auto');
  soScroll: w3_setStyle(Handle,'overflow-x','scroll');
  end;
end;

function  TW3Memo.getVOpt: TW3MemoScrollbarOption;
var
  mData:  Variant;
begin
  Result := soNone;
  mData := w3_getStyle(Handle,'overflow-y');
  if VarIsValidRef(mData) then
  begin
    case LowerCase(TVariant.AsString(mData)) of
    'auto': Result := soAuto;
    'scroll': Result := soScroll;
    end;
  end;
end;

procedure TW3Memo.setVOpt(const aValue: TW3MemoScrollbarOption);
begin
  case aValue of
  soNone:   w3_setStyle(Handle,'overflow-y','');
  soAuto:   w3_setStyle(Handle,'overflow-y','auto');
  soScroll: w3_setStyle(Handle,'overflow-','scroll');
  end;
end;

procedure TW3Memo.setText(aValue: String);
begin
  Handle.value := aValue;
end;

function TW3Memo.getText: String;
begin
  //if varisValidRef(Handle) then
  if (Handle) then
  begin
    //if varIsValidRef(Handle.value) then
    if (Handle.value) then
    Result := w3_getPropertyAsStr(Handle,'value');
  end;
end;


end.
