unit w3image;

interface

uses
  W3System, w3graphics, W3Components;

type

  TW3Image = class(TW3CustomControl)
  private
    FOnLoad: TNotifyEvent;
    procedure _setOnLoad(aValue$65: TNotifyEventTNotifyEvent);
  protected
    procedure CBOnLoad; virtual;
    function makeElementTagObj: THandle; override;
    // Image element does not support disabled attribute
    function getEnabled: Boolean; override;
    function GetWidth: Integer; override;
    function GetHeight: Integer; override;
    function getReady: Boolean; virtual;
    function getSrc: String;
    procedure setSrc(Value$8: String);
  public
    property  Ready: Boolean read getReady;
    function  toDataUrl: String;
    function  toImageData: TW3ImageData;
    procedure LoadFromURL(aURL: String);
  published
    property Url: String read getSrc write setSrc;
    property OnLoad: TNotifyEvent read FOnLoad write _setOnLoad;
  end;


implementation


{ **************************************************************************** }
{ TW3Image                                                                     }
{ **************************************************************************** }

function TW3Image.makeElementTagObj:THandle;
begin
  Result := w3_createHtmlElement('img');
end;

function TW3Image.getReady: Boolean;
begin
  if (Handle) then
  //if varIsValidRef(Handle) then
  Result := (Handle.complete=true)
  and (Handle.naturalWidth>0)
  and (Handle.naturalHeight>0);
end;

function TW3Image.getSrc: String;
begin
  if (Handle) then
  //if varIsValidRef(Handle) then
    Result := Handle.src;
end;

function TW3Image.getEnabled: Boolean;
begin
  //The image tag does not support the disabled attribute,
  //so to avoid screwing up event blocking, we have to override this method
  Result := true;
end;

function TW3Image.GetWidth: Integer;
begin
  (* if an image is loaded "offscreen", i.e: not injected into the DOM,
     then the browsers calculated width/height will not work and return NaN.
     So we insert a little test here just to be sure *)
  Result := inherited GetWidth;

  (* Valid number? not zero? *)
  if TVariant.IsNAN(Result)
  or (not TVariant.IsNumber(Result))
  or (Result=0) then
  begin
    (* Probably offscreen, use "normal" property access *)
    if (Handle) then
      Result := Handle.width
    else Result := 0;
  end;
end;

function TW3Image.GetHeight: Integer;
begin
  (* see getWidth for more information *)
  Result := inherited GetHeight;

  (* Valid number? not zero? *)
  if TVariant.IsNAN(Result)
  or (not TVariant.IsNumber(Result))
  or (Result=0) then
  begin
    (* Probably offscreen, use "normal" property access *)
    if (Handle) then
    Result := Handle.height else
    Result := 0;
  end;
end;

procedure TW3Image._setOnLoad(aValue$65:TNotifyEventTNotifyEvent);
var
  mRef$25: TProcedureRef;
begin
  FOnLoad := aValue$65;
  case Assigned(aValue$65) of
    true:  mRef$25 := CBOnLoad;
    false: mRef$25 := CBNoBehavior;
  end;
  w3_bind2(Handle,'onload',mRef$25);
end;

procedure TW3Image.CBOnLoad;
begin
  if Assigned(FOnLoad) then
    FOnLoad(Self);
end;

procedure TW3Image.LoadFromURL(aURL: String);
begin
  w3_setAttrib(Handle, 'src', aURL);
end;

procedure TW3Image.setSrc(Value$8: String);
begin
  if Value$8<>getSrc then
    LoadFromURL(Value$8);
end;

function TW3Image.toImageData: TW3ImageData;
var
  mContext: TW3GraphicContext;
  mCanvas:  TW3Canvas;
begin
  Result := nil;
  if  (Handle)
  and getReady then
  begin
    mContext := TW3GraphicContext.Create$29(Null);
    try
      mContext.Allocate(Width$1,Height$1);
      mCanvas := TW3Canvas.Create$32(mContext);
      try
        mCanvas.DrawImageF(Handle,0,0);
        Result := mCanvas.ToImageData;
      finally
        mCanvas.Free;
      end;
    finally
      mContext.Free;
    end;
  end;
end;

function TW3Image.toDataUrl: String;
var
  mContext: TW3GraphicContext;
  mCanvas: TW3Canvas;
begin
  if  (Handle)
  and getReady then
  begin
    mContext := TW3GraphicContext.Create$29(Null);
    try
      mContext.Allocate(Width$1,Height$1);
      mCanvas := TW3Canvas.Create$32(mContext);
      try
        mCanvas.DrawImageF(Handle,0,0);
        Result := mCanvas.ToDataURL('');
      finally
        mCanvas.Free;
      end;
    finally
      mContext.Free;
    end;
  end;
end;


end.
