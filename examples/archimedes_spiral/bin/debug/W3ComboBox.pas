unit w3combobox;

interface

uses
  W3System, W3Components;

type

  TW3ComboBox = class(TW3CustomControl)
  protected
    function makeElementTagObj: THandle; override;
    function getCount: Integer;
    function getItem(index: Integer): String;
    procedure setItem(index: Integer; aValue: String);
    function getValue(index: Integer): Variant;
    procedure setValue(index: Integer; aValue: Variant);
    function getSelIndex: Integer;
    procedure setSelIndex(aValue: Integer);
  public
    procedure Clear;
    function add(aValue: String): Integer;
    procedure Remove(aIndex: Integer);
    function indexOf(aValue: String): Integer;
    property Items[index: Integer]: String read getItem write setItem;
    property Values[index: Integer]: Variant read getValue write setValue;
    property Count: Integer read getCount;
    property SelectedIndex: Integer read getSelIndex write setSelIndex;
  end;

implementation


{ **************************************************************************** }
{ TW3ComboBox                                                                   }
{ **************************************************************************** }

function TW3ComboBox.makeElementTagObj:THandle;
begin
  Result := w3_createHtmlElement('select');
end;

procedure TW3ComboBox.setSelIndex(aValue: Integer);
begin
  if (Handle) then
  begin
    try
      Handle.selectedIndex := aValue;
    except
      on E: Exception do
        raise EW3Exception.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName, E.Message]);
    end;
  end else
  raise EW3Exception.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'Invalid handle error']);
end;

function TW3ComboBox.getSelIndex: Integer;
begin
  if (Handle) then
  begin
    try
      Result := TVariant.AsInteger(Handle.selectedIndex);
    except
      on E: Exception do
        raise EW3Exception.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName, E.Message]);
    end;
  end else
    raise EW3Exception.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'Invalid handle error']);
end;

function TW3ComboBox.add(aValue: String): Integer;
var
  mObj: THandle;
begin
  if (Handle) then
  begin
    mObj := w3_createHtmlElement('option');
    mObj.text := aValue;

    BeginUpdate;
    try
      Handle.add(mObj)
    finally
      EndUpdate;
    end;
    Result := getCount-1;
  end else
  raise EW3Exception.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'Invalid error']);
end;

function TW3ComboBox.getValue(index: Integer):Variant;
begin
  if (Handle) then
  begin
    try
      Result := Handle.options[index].value;
    except
      on E: Exception do
      raise EW3Exception.CreateFmt(CNT_ERR_METHOD,
      [{$I %FUNCTION%},ClassName, E.Message]);
    end;
  end else
  raise EW3Exception.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'invalid handle error']);
end;

procedure TW3ComboBox.setValue(index: Integer;aValue:Variant);
begin
  if (Handle) then
  begin
    try
      Handle.options[index].value := aValue;
    except
      on E: Exception do
        raise EW3Exception.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName, E.Message]);
    end;
  end else
  raise EW3Exception.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'invalid handle error']);
end;

function TW3ComboBox.getItem(index: Integer): String;
begin
  if (Handle) then
  begin
    try
      Result := Handle.options[index].text;
    except
      on E: Exception do
      raise EW3Exception.CreateFmt(CNT_ERR_METHOD,
      [{$I %FUNCTION%},ClassName, E.Message]);
    end;
  end else
  raise EW3Exception.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'invalid handle error']);
end;

procedure TW3ComboBox.setItem(index: Integer;aValue: String);
begin
  if (Handle) then
  begin
    try
      Handle.options[index].text := aValue;
    except
      on E: Exception do
      raise EW3Exception.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName, E.Message]);
    end;
  end else
  raise EW3OwnedObject.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'invalid handle error']);
end;

procedure TW3ComboBox.Remove(aIndex: Integer);
begin
  //if varIsValidRef(Handle) then
  if (Handle) then
  begin
    try
      Handle.options.remove(aIndex);
    except
      on E: Exception do
      raise EW3Exception.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName, E.Message]);
    end;
  end else
  raise EW3Exception.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'invalid handle error']);
end;

function TW3ComboBox.indexOf(aValue: String): Integer;
var
  x:  Integer;
begin
  Result := -1;
  for x := 0 to Count-1 do
  begin
    if getItem(x)=aValue then
    begin
      Result := x;
      break;
    end;
  end;
end;

function TW3ComboBox.getCount: Integer;
begin
  //if varIsValidRef(Handle) then
  if (Handle) then
  begin
    try
      Result := Handle.options.length;
    except
      on E: Exception do
      raise EW3Exception.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName, E.Message]);
    end;
  end else
  raise EW3Exception.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'invalid handle error']);
end;

procedure TW3ComboBox.Clear;
begin
  BeginUpdate;
  try
    while Count>0 do
      Self.Remove(0);
  finally
    SetWasSized;
    EndUpdate;
  end;
end;


end.
