unit w3editbox;

interface

uses
  W3System, W3Components, w3label;

type

  TW3InputType = (itNone,
                  itColor,
                  itDate,
                  itDateTime,
                  itDateTimeLocal,
                  itEmail,
                  itMonth,
                  itNumber,
                  itRange,
                  itSearch,
                  itTel,
                  itTime,
                  itUrl,
                  itWeek,
                  itPassword);

  TW3EditBox = class(TW3CustomControl)
  protected
    function  getTextAlign: TTextAlign; virtual;
    procedure setTextAlign(const aValue: TTextAlignTTextAlign); virtual;
    function  getType: TW3InputType; virtual;
    procedure setType(const aValue: TW3InputType); virtual;
    function  getText: String; virtual;
    procedure setText(aValue: String); virtual;
    function  getPlaceHolder: String; virtual;
    procedure setPlaceHolder(const aValue: String); virtual;
    function  getAutoCorrect: Boolean; virtual;
    procedure setAutoCorrect(const aValue: Boolean); virtual;
    function  getAutoCapitalize: Boolean; virtual;
    procedure setAutoCapitalize(const aValue: Boolean); virtual;
    function  makeElementTagObj: THandle; override;
    procedure StyleTagObject; override;
  public
    function  getMin: Variant; virtual;
    procedure setMin(const aValue: Variant); virtual;
    function  getMax: Variant; virtual;
    procedure setMax(const aValue: Variant); virtual;

    function  getRange: Variant; virtual;
    procedure setRange(const aValue: Variant); virtual;
  published
    Property  Range:Variant read getRange write setRange;
    property TextAlign: TTextAlign read getTextAlign write setTextAlign;
    property InputType: TW3InputType read getType write setType;
    property AutoCapitalize: Boolean read getAutoCapitalize write setAutoCapitalize;
    property AutoCorrect: Boolean read getAutoCorrect write setAutoCorrect;
    property PlaceHolder: String read getPlaceHolder write setPlaceHolder;
    property Text: String read getText write setText;
    Property Value:variant read getRange write setRange;
  end;

implementation

{ **************************************************************************** }
{ TW3EditBox                                                                   }
{ **************************************************************************** }

function TW3EditBox.makeElementTagObj:THandle;
begin
  Result := w3_createHtmlElement('input');

  if (Result) then
  w3_setAttrib(Result,'type','text');
end;

procedure TW3EditBox.styleTagObject;
begin
  w3_setAttrib(Handle,'autocorrect','off');
  w3_setAttrib(Handle,'autocapitalize','off');
  w3_setAttrib(Handle,'placeholder','');
  w3_setStyle(Handle,'textAlign','left');
  inherited;
end;

function TW3EditBox.getTextAlign:TTextAlign;
var
  mText:  String;
begin
  mText := LowerCase(w3_getStyleAsStr(Handle,'textAlign'));
  if mText='left' then Result := taLeft else
  if mText='center' then Result := taCenter else
  if mText='right' then Result := taRight;
end;

procedure TW3EditBox.setTextAlign(const aValue:TTextAlignTTextAlign);
var
  mToWrite: String;
begin
  case aValue of
    taLeft:   mToWrite := 'left';
    taCenter: mToWrite := 'center';
    taRight:  mToWrite := 'right';
  end;

  if (Handle) then
  w3_setStyle(Handle,'textAlign',mToWrite) else
  raise EW3Exception.CreateFmt
  (CNT_ERR_METHOD,[{$I %FUNCTION%},ClassName,'Invalid handle error']);
end;

function TW3EditBox.getMin:Variant;
begin
  if (Handle) then
  Result := w3_getAttrib(Handle,'min') else
  raise EW3Exception.CreateFmt
  (CNT_ERR_METHOD,[{$I %FUNCTION%},ClassName,'Invalid handle error']);
end;

procedure TW3EditBox.setMin(const aValue:Variant);
begin
  if (Handle) then
  w3_setAttrib(Handle,'min',aValue) else
  raise EW3Exception.CreateFmt(CNT_ERR_METHOD,
  [{$I %FUNCTION%},ClassName,'Invalid handle error']);
end;

function  TW3EditBox.getMax:Variant;
begin
  if (Handle) then
  Result := w3_getAttrib(Handle,'max') else
  raise EW3Exception.CreateFmt(CNT_ERR_METHOD,
  [{$I %FUNCTION%},ClassName,'Invalid handle error']);
end;

procedure TW3EditBox.setMax(const aValue:Variant);
begin
  if (Handle) then
  w3_setAttrib(Handle,'max',aValue) else
  raise EW3Exception.CreateFmt(CNT_ERR_METHOD,
  [{$I %FUNCTION%},ClassName,'Invalid handle error']);
end;

function  TW3EditBox.getRange:Variant;
begin
  if (Handle) then
  Result := Handle.value else
  raise EW3Exception.CreateFmt(CNT_ERR_METHOD,
  [{$I %FUNCTION%},ClassName,'Invalid handle error']);
end;

procedure TW3EditBox.setRange(const aValue:Variant);
begin
  if (Handle) then
  Handle.value:=aValue else
  raise EW3Exception.CreateFmt(CNT_ERR_METHOD,
  [{$I %FUNCTION%},ClassName,'Invalid handle error']);
end;

function TW3EditBox.getType: TW3InputType;
var
  mText:  String;
begin
  mText := LowerCase(w3_getAttribAsStr(Handle,'type'));
  if mText='' then Result := itNone else
  if mText='color' then Result := itColor else
  if mText='date' then Result := itDate else
  if mText='datetime' then Result := itDateTime else
  if mText='datetime-local' then Result := itDateTimeLocal else
  if mText='email' then Result := itEmail else
  if mText='month' then Result := itMonth else
  if mText='number' then Result := itNumber else
  if mText='range' then Result := itRange else
  if mText='search' then Result := itSearch else
  if mText='tel' then Result := itTel else
  if mText='time' then Result := itTime else
  if mText='url' then Result := itUrl else
  if mText='week' then Result := itWeek else
  if mText='password' then Result := itPassword;
end;

procedure TW3EditBox.setType(const aValue: TW3InputType);
var
  mToWrite: String;
begin
  if (Handle) then
  begin
    case aValue of
      itNone:           mToWrite := '';
      itColor:          mToWrite := 'color';
      itDate:           mToWrite := 'date';
      itDateTime:       mToWrite := 'datetime';
      itDateTimeLocal:  mToWrite := 'datetime-local';
      itEmail:          mToWrite := 'email';
      itMonth:          mToWrite := 'month';
      itNumber:         mToWrite := 'number';
      itRange:          mToWrite := 'range';
      itSearch:         mToWrite := 'search';
      itTel:            mToWrite := 'tel';
      itTime:           mToWrite := 'time';
      itUrl:            mToWrite := 'url';
      itWeek:           mToWrite := 'week';
      itPassword:       mToWrite := 'password';
    end;
    w3_setAttrib(Handle,'type',mToWrite);
  end else
  raise EW3Exception.CreateFmt(CNT_ERR_METHOD,
  [{$I %FUNCTION%},ClassName,'Invalid handle error']);
end;

function TW3EditBox.getPlaceHolder: String;
begin
  Result := w3_getAttribAsStr(Handle,'placeholder');
end;

procedure TW3EditBox.setPlaceHolder(const aValue: String);
begin
  if (Handle) then
  w3_setAttrib(Handle,'placeholder',aValue) else
  raise EW3Exception.CreateFmt(CNT_ERR_METHOD,
  [{$I %FUNCTION%},ClassName,'Invalid handle error']);
end;

function TW3EditBox.getAutoCorrect: Boolean;
var
  mTemp:  String;
begin
  Result := False;
  mTemp := w3_getAttribAsStr(Handle,'autocorrect');
  if Length(mTemp)>0 then
    Result := LowerCase(mTemp)='on';
end;

procedure TW3EditBox.setAutoCorrect(const aValue:Boolean);
begin
  if (Handle) then
  begin
    case aValue of
      false:  w3_setAttrib(Handle,'autocorrect','off');
      true:   w3_setAttrib(Handle,'autocorrect','on');
    end;
  end
  else
    raise EW3Exception.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'Invalid handle error']);
end;

function TW3EditBox.getAutoCapitalize: Boolean;
var
  mTemp:  String;
begin
  Result := False;
  mTemp := w3_getAttribAsStr(Handle,'autocapitalize');
  if Length(mTemp)>0 then
    Result := LowerCase(mTemp)='on';
end;

procedure TW3EditBox.setAutoCapitalize(const aValue:Boolean);
begin
  if (Handle) then
  begin
    case aValue of
      false:  w3_setAttrib(Handle,'autocapitalize','off');
      true:   w3_setAttrib(Handle,'autocapitalize','on');
    end;
  end else
  raise EW3Exception.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName, 'Invalid handle error']);
end;

function TW3EditBox.getText: String;
begin
  Result := w3_getPropertyAsStr(Handle,'value');
end;

procedure TW3EditBox.setText(aValue: String);
begin
  w3_setProperty(Handle,'value',aValue);
end;


end.
