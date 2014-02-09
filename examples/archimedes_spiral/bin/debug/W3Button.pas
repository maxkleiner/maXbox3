  unit w3button;

  interface

  uses W3System, W3Components;

  type

  TW3Button = class(TW3CustomControl)
  private
    function getCaption$1: String;
    procedure setCaption$3(Value$9: String);
  protected
    function makeElementTagObj: THandle; override;
    procedure InitializeObject; override;
  published
    property Caption$4: String read getCaption$1 write setCaption$3;
  end;


implementation

{ **************************************************************************** }
{ TW3Button                                                                    }
{ **************************************************************************** }

procedure TW3Button.InitializeObject;
begin
  inherited InitializeObject;
  Width$1 := 100;
  Height$1 := 32;
end;

function TW3Button.makeElementTagObj:THandle;
begin
  Result := w3_createHtmlElement('button');
end;

function TW3Button.getCaption$1: String;
begin
  if (Handle) then
  Result := Handle.innerHTML;
end;

procedure TW3Button.setCaption$3(Value$9: String);
begin
  if (Handle) then
  Handle.innerHTML := Value$9;
end;



end.
