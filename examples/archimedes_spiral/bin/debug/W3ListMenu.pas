unit w3listmenu;

interface

uses
  W3System, W3Components, w3lists;

type

  TW3ListItem = class(TW3CustomControl)
  private
    FText: String;
    procedure setText(aValue: String);
  protected
    function makeElementTagObj: THandle; override;
    procedure StyleTagObject; override;
    function getEnabled: Boolean; override;
  public
    property Text: String read FText write setText;
  end;

  TW3ListItems = class(TW3OwnedObject)
  private
    FObjects$1: TObjectList;
    function getCount: Integer;
    function getItem(index: Integer): TW3ListItem;
  protected
    function AcceptParent(aObject$6: TObjectTObject): Boolean; override;
  public
    property Items[index: Integer]: TW3ListItem read getItem; default;
    property Count: Integer read getCount;
    function Add: TW3ListItem;
    procedure Remove(index: Integer);
    procedure RemoveByRef(aItem: TW3ListItemTW3ListItem);
    function indexOf(aItem: TW3ListItemTW3ListItem): Integer;
    procedure Clear$5;
    constructor Create$7(AOwner$7: TObjectTObject); override;
    destructor Destroy; override;
  end;

  TW3ListMenu = class(TW3CustomControl)
  private
    FItems: TW3ListItems;
  protected
    function makeElementTagObj: THandle; override;
    procedure InitializeObject; override;
    procedure FinalizeObject; override;
    procedure StyleTagObject; override;
  public
    property Items: TW3ListItems read FItems;
  end;


implementation


{ **************************************************************************** }
{ TW3ListMenu                                                                  }
{ **************************************************************************** }

procedure TW3ListMenu.InitializeObject;
begin
  inherited;
  FItems := TW3ListItems.Create$7(Self);
end;

procedure TW3ListMenu.FinalizeObject;
begin
  FItems.Free;
  inherited;
end;

function TW3ListMenu.makeElementTagObj:THandle;
begin
  Result := w3_createHtmlElement('ul');
end;

procedure TW3ListMenu.StyleTagObject;
begin
  inherited StyleTagObject;
  StyleClass := 'ul';
end;


{ **************************************************************************** }
{ TW3ListItem                                                                  }
{ **************************************************************************** }

procedure TW3ListItem.setText(aValue: String);
begin
  if aValue<>FText then
  begin
    FText := aValue;

    InnerHTML := FText
    + '<img valign="middle" align="right" alt=""'
    + 'src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA'
    + 'ABkAAAAUCAYAAAB4d5a9AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccll'
    + 'PAAAAKVJREFUeNpi/P//PwOtARMDHcDwsYQFRJSXl8P4dVC6CZvizs5O8i1BsqARid9E'
    + 'i+BiQ2KDLKumhSU1QNyKxG+hlkXoEQ+yqAPNogpapK5KNIvaKbUIVxKeAsTvkPg5QCxE'
    + 'TUukgfgAkqFPgdgBzVKKLIFZoIJmwR1qBRdNLEC2BJQpV9LCAmRL/gBxAtRwqlqAXqzc'
    + 'gRrOQE0LQIBxtNIiBQAEGAA7xCa2yF9zEgAAAABJRU5ErkJggg==" />';
  end;
end;

function TW3ListItem.makeElementTagObj:THandle;
begin
  Result := w3_createHtmlElement('li');
end;

procedure TW3ListItem.StyleTagObject;
begin
  StyleClass := 'li';
end;

function TW3ListItem.getEnabled: Boolean;
begin
  Result := True;
end;



{ **************************************************************************** }
{ TW3ListItems                                                                 }
{ **************************************************************************** }

constructor TW3ListItems.Create$7(AOwner$7:TObjectTObject);
begin
  inherited Create$7(AOwner$7);
  FObjects$1 := TObjectList.Create$17;
end;

destructor TW3ListItems.Destroy;
begin
  Clear$5;
  FObjects$1.Free;
  inherited;
end;

function TW3ListItems.AcceptParent(aObject$6:TObjectTObject): Boolean;
begin
  Result := Assigned(aObject$6) and (aObject$6 is TW3ListMenu);
end;

procedure TW3ListItems.Clear$5;
var
  x$19:  Integer;
begin
  for x$19 := 0 to FObjects$1.Count-1 do
    FObjects$1[x$19].Free;
  FObjects$1.Clear;
end;

function TW3ListItems.getCount: Integer;
begin
  Result := FObjects.Count;
end;

function TW3ListItems.getItem(index: Integer): TW3ListItem;
begin
  Result := TW3ListItem(FObjects[index]);
end;

function TW3ListItems.Add: TW3ListItem;
begin
  Result := TW3ListItem.Create$4(TW3ListMenu(Owner$1));
  FObjects.Add(Result);
end;

procedure TW3ListItems.Remove(index: Integer);
begin
  TW3ListItem(FObjects[index]).Free;
  FObjects.Remove(index);
end;

procedure TW3ListItems.RemoveByRef(aItem: TW3ListItem);
begin
  Remove(FObjects.IndexOf(aItem));
end;

function TW3ListItems.IndexOf(aItem: TW3ListItem): Integer;
begin
  Result := FObjects.IndexOf(aItem);
end;


end.
