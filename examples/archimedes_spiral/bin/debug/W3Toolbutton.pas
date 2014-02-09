unit w3toolbutton;

interface

uses
  W3System, W3Components;

type


  TW3ToolButton = class(TW3CustomControl)
  protected
    function  getCaption: String; virtual;
    procedure setCaption(aNewCaption: String); virtual;
    function makeElementTagObj: THandle; override;
    procedure StyleTagObject; override;
    procedure InitializeObject; override;
  public
    property Caption: String read getCaption write setCaption;
  end;

Implementation


{ **************************************************************************** }
{ TW3ToolButton                                                                }
{ **************************************************************************** }

procedure TW3ToolButton.InitializeObject;
begin
  inherited InitializeObject;
  Width$1 := 70;
  Height$1 := 30;
end;

function TW3ToolButton.makeElementTagObj:THandle;
begin
  Result := w3_createHtmlElement('button');
end;

procedure TW3ToolButton.StyleTagObject;
begin
  inherited;
  w3_setStyle(Handle,'fontSmooth','always');
end;

function TW3ToolButton.getCaption: String;
begin
  Result := w3_getPropertyAsStr(Handle,'innerHTML');
end;

procedure TW3ToolButton.setCaption(aNewCaption: String);
begin
  w3_setProperty(Handle,'innerHTML',aNewCaption);
end;


end.
