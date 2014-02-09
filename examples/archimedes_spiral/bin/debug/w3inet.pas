{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ Copyright (c) Eric Grange, Creative IT. All rights reserved.                 }
{ Licensed to Optimale Systemer AS.                                            }
{                                                                              }
{ **************************************************************************** }

unit W3Inet;

{------------------------------------------------------------------------------}
{ Author:    Jon Lennart Aasenden                                              }
{ Updated:   2012.04.24 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}
{ Resources: http://www.w3.org/TR/XMLHttpRequest/                              }
{------------------------------------------------------------------------------}

interface

uses
  W3System;

type
  TW3HttpRequest = class;

  THttpRequestEvent THttpRequestEventr: TW3HttpRequestTW3HttpRequest);

  THttpRequestReadyState = (rrsUnsent          = 0,
                            rrsOpened          = 1,
                            rrsHeadersReceived = 2,
                            rrsLoading         = 3,
                            rrsDone            = 4);

  { TW3HttpRequest }
  TW3HttpRequest = class(TObject)
  private
    FReqObj: THandle;
    FOnDataReady$1: THttpRequestEvent;
    FOnReadyStateChange: THttpRequestEvent;

  protected
    procedure HandleReadyStateChange;

  public
    constructor Create$58; virtual;
    destructor Destroy; override;

    procedure Get(aURL: String);
    procedure Open(aMeth, aURL: String);
    procedure SetRequestHeader(headerName, value : String);
    procedure Send; overload;
    procedure Send(textData : String); overload;
    procedure Abort;

    function Status: Integer;
    function StatusText: String;
    function ResponseXML: Variant;
    function ResponseText: String;
    function ReadyState: THttpRequestReadyState;

    property Handle: THandle read FReqObj;
    property RequestHeaders[headerName: String]: String write SetRequestHeader;

    property OnDataReady: THttpRequestEvent read FOnDataReady write FOnDataReady;
    property OnReadyStateChange: THttpRequestEvent read FOnReadyStateChange write FOnReadyStateChange;
  end;

  { TW3JSONP }
  TW3JSONP = class;
  TW3JSONPEvent TW3JSONPEventender: TW3JSONPTW3JSONP);
  TW3JSONP = class
  private
    FAllocated: Boolean;
    FID: Integer;
    FHandle$6: THandle;
    FData$2: Variant;
    FOnDataReady: TW3JSONPEvent;
  protected
    class var vJSON_ID: Integer;
    function GetURL: String;
    procedure DoCallback(data: Variant); virtual;
  public
    constructor Create$57;
    destructor Destroy; override;

    procedure Request(url: String);
    procedure Allocate;
    procedure Release$1;

    property Allocated: Boolean read FAllocated;
    property Handle: THandle read FHandle;
    property URL: String read GetURL write Request;
    property Data: Variant read FData;
    property OnDataReady: TW3JSONPEvent read FOnDataReady write FOnDataReady;
  end;

implementation

{ **************************************************************************** }
{ Local procedures/functions                                                   }
{ **************************************************************************** }

function CreateScriptElement : Variant;
var
   doc, head : Variant;
begin
  asm
    @doc = document;
  end;
  head := doc.getElementsByTagName("head")[0];
  Result := doc.createElement('script');
  Result.&type := 'text/javascript';
  head.appendChild(Result);
end;



{ **************************************************************************** }
{ TW3JSONP                                                                     }
{ **************************************************************************** }

constructor TW3JSONP.Create$57;
begin
  FID := Inc(vJSON_ID);
end;

destructor TW3JSONP.Destroy;
begin
  Release$1;
  inherited;
end;

procedure TW3JSONP.Request(url : String);
begin
  Allocate;
  FData := Null;
  FHandle.src := url+'_TJSONP['+IntToStr(FID)+']';
end;

function TW3JSONP.GetURL : String;
begin
  if Allocated then
    Result := FHandle.src
  else
    Result := '';
end;

procedure TW3JSONP.Allocate;
var
  cb: procedure (data: Variant);
begin
  if FAllocated then exit;

  FHandle := CreateScriptElement;
  cb := @Self.DoCallback;
  asm
    if (!window._TJSONP) window._TJSONP=[];
    window._TJSONP[@Self.FID]=@cb;
  end;
end;

procedure TW3JSONP.Release$1;
begin
  if not FAllocated then exit;

  FData$2 := Null;
  FHandle$6.parent.removeChild(FHandle$6);
  FHandle$6 := Null;
  FAllocated := False;
end;

procedure TW3JSONP.DoCallback(data : Variant);
begin
  FData := data;
  if Assigned(FOnDataReady) then
    FOnDataReady(Self);
end;



{ **************************************************************************** }
{ TW3HttpRequest                                                               }
{ **************************************************************************** }

constructor TW3HttpRequest.Create$58;
begin
  inherited Create;
  var mCallback := @Self.HandleReadyStateChange;
  asm
    @Self.FReqObj = new XMLHttpRequest();
    (@Self.FReqObj).onreadystatechange = @mCallback;
  end;
end;

destructor TW3HttpRequest.Destroy;
begin
  // detach handler so no more events wikl be received during destruction
  FReqObj.OnReadyStateChange := Null;
  FReqObj := Null;
  inherited;
end;

procedure TW3HttpRequest.HandleReadyStateChange;
begin
  if (FReqObj.readyState=rrsDone) and Assigned(FOnDataReady$1) then
    FOnDataReady$1(Self);

  if Assigned(FOnReadyStateChange) then
    FOnReadyStateChange(Self);
end;

procedure TW3HttpRequest.get(aURL: String);
begin
  Open('GET', aURL);
  Send;
end;

procedure TW3HttpRequest.Open(aMeth, aURL : String);
begin
  FReqObj.open(aMeth, aURL);
end;

procedure TW3HttpRequest.Send;
begin
  FReqObj.send();
end;

procedure TW3HttpRequest.Send(textData : String);
begin
  FReqObj.send(textData);
end;

procedure TW3HttpRequest.Abort;
begin
  FReqObj.abort();
end;

procedure TW3HttpRequest.SetRequestHeader(headerName, value : String);
begin
  FReqObj.setRequestHeader(headerName, value);
end;

function TW3HttpRequest.Status : Integer;
begin
  Result := FReqObj.status;
end;

function TW3HttpRequest.StatusText : String;
begin
  Result := FReqObj.statusText;
end;

function TW3HttpRequest.ResponseXML : Variant;
begin
  Result := FReqObj.responseXML;
end;

function TW3HttpRequest.ResponseText : String;
begin
  var r := FReqObj.responseText;

  if r=Null then
    Result := ''
  else
    Result := r;
end;

function TW3HttpRequest.ReadyState : THttpRequestReadyState;
begin
   Result := FReqObj.readyState;
end;

end.

