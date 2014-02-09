unit cryptobox;

interface

uses
  SysUtils, Windows, Messages, Classes, Controls;
  
//------------------------example of client--------
// crString:=edtGeheim.text;
// with TCryptoDecorator.create(TCrypto.create) do begin
//   setCryptKey(23);
//   edtGeheim.text:=encrypt(crstring);
//   free; 
// end;
  
  
type

//MMWIN:ENDEXPAND
  {:
  }
  TCrypto = class (TObject)
  private
    FcryptKey: LongInt;
    FReferenceCnt: Integer;
  protected
    function Referenced: Boolean;
    procedure SetcryptKey(const Value: LongInt);
    procedure SetReferenced(IsReferenced: Boolean);
  public
    procedure AddReference;
    function encrypt(const cstring: string): string;
    procedure RemoveReference;
    property cryptKey: LongInt read FcryptKey write SetcryptKey;
  end;
  
  {:
  }
  TCryptoDecorator = class (TCrypto)
  private
    FCrypto: TCrypto;
    FOwnsCrypto: Boolean;
    function GetCrypto: TCrypto;
    procedure SetCrypto(Value: TCrypto);
  protected
    function Referenced: Boolean;
  public
    constructor Create(ACrypto: TCrypto);
    destructor Destroy; override;
    procedure AddReference;
    function encrypt(const cstring: string): string;
    procedure RemoveReference;
    procedure SetcryptKey(const Value: LongInt);
    property Crypto: TCrypto read GetCrypto write SetCrypto;
    property OwnsCrypto: Boolean read FOwnsCrypto write FOwnsCrypto;
  end;
  

//TCryptoDecorator
  {:
  }
  ECryptError = class (exception)
  end;
  
  {:
  }
  TCryptoDecorator2 = class (TCrypto)
  private
    FCrypto2: TCrypto;
    FOwnsCrypto: Boolean;
  protected
    function GetCrypto2: TCrypto;
    procedure SetCrypto2(Value: TCrypto);
  public
    constructor Create(ACrypto2: TCrypto);
    destructor Destroy; override;
    function encrypt(const cstring: string): string;
    procedure SetcryptKey(const Value: LongInt);
    property Crypto2: TCrypto read GetCrypto2 write SetCrypto2;
    property OwnsCrypto: Boolean read FOwnsCrypto write FOwnsCrypto;
  end;
  
//MMWIN:STARTEXPAND


procedure Register;

implementation

procedure Register;
begin
end;

{
*********************************** TCryptoDecorator2 ************************************
}
constructor TCryptoDecorator2.Create(ACrypto2: TCrypto);
begin
  inherited Create;
  Crypto2 := ACrypto2;
end;

destructor TCryptoDecorator2.Destroy;
begin
  crypto2.free;
  Crypto2 := nil;
  inherited Destroy;
end;

function TCryptoDecorator2.encrypt(const cstring: string): string;
begin
  Result := Crypto2.encrypt(cstring);
end;

procedure TCryptoDecorator2.SetcryptKey(const Value: LongInt);
begin
  crypto2.FcryptKey := Value;
end;

function TCryptoDecorator2.GetCrypto2: TCrypto;
begin
  Result := FCrypto2;
end;

procedure TCryptoDecorator2.SetCrypto2(Value: TCrypto);
begin
  if Value <> FCrypto2 then
  begin
    if OwnsCrypto then FCrypto2.Free;
    FCrypto2 := Value;
  end;
end;

{
**************************************** TCrypto *****************************************
}
procedure TCrypto.AddReference;
begin
  //profilingStart(TCrypto.AddReference)
  Inc(FReferenceCnt);
  if FReferenceCnt = 1 then SetReferenced(True);
  // profilingStop(TCrypto.AddReference)
end;

function TCrypto.encrypt(const cstring: string): string;
var
  s: string[255];
  c: array[0..255] of byte absolute s;
  i: Integer;
  
 procedure subtest;
  begin
    //cKey:= 23; //key initialize
     // for i:= 1 to ord(cstring[0]) do c[i]:= c[i] XOR cKey;
  end;
  
begin
  //profilingStart(TCrypto.encrypt)
  s:=cstring;
    for i:= 1 to length(s) do c[i]:= c[i] XOR FcryptKey;
    result:= s;
  // profilingStop(TCrypto.encrypt)
end;

function TCrypto.Referenced: Boolean;
begin
  Result := (FReferenceCnt <> 0);
end;

procedure TCrypto.RemoveReference;
begin
  Dec(FReferenceCnt);
  if FReferenceCnt = 0 then SetReferenced(False);
end;

procedure TCrypto.SetReferenced(IsReferenced: Boolean);
begin
  if not Referenced then Free;
end;

procedure TCrypto.SetcryptKey(const Value: LongInt);
begin
  FcryptKey := Value;
end;

{
************************************ TCryptoDecorator ************************************
}
constructor TCryptoDecorator.Create(ACrypto: TCrypto);
begin
  inherited Create;
  Crypto := ACrypto;
end;

destructor TCryptoDecorator.Destroy;
begin
  crypto.free;
  Crypto := nil;
  inherited Destroy;
end;

procedure TCryptoDecorator.AddReference;
begin
  Crypto.AddReference;
end;

function TCryptoDecorator.encrypt(const cstring: string): string;
var
  cryptoF: TextFile;
begin
  if (length(cstring) > 255) then raise
    ECryptError.create('only shortstring possible');
  result:= Crypto.encrypt(cstring);
  AssignFile(cryptoF, 'mycrypt.txt');
  Rewrite(cryptoF);
  writeln(cryptoF,result);
  CloseFile(cryptoF);
end;

function TCryptoDecorator.Referenced: Boolean;
begin
  Result := Crypto.Referenced;
end;

procedure TCryptoDecorator.RemoveReference;
begin
  Crypto.RemoveReference;
end;

procedure TCryptoDecorator.SetcryptKey(const Value: LongInt);
begin
  crypto.FcryptKey := Value;
end;

function TCryptoDecorator.GetCrypto: TCrypto;
begin
  Result := FCrypto;
end;

procedure TCryptoDecorator.SetCrypto(Value: TCrypto);
begin
  if Value <> FCrypto then
  begin
    if OwnsCrypto then FCrypto.Free;
    FCrypto := Value;
  end;
end;


initialization
end.
