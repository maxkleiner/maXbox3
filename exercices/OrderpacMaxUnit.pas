unit OrderpacMaxUnit;

interface

uses
  System.ComponentModel,
  System.Collections,
  Borland.Eco.Services,
  Borland.Eco.ObjectRepresentation,
  Borland.Eco.ObjectImplementation,
  Borland.Eco.UmlRt,
  Borland.Eco.UmlCodeAttributes;

type
  OrderMax = class;
  [UmlElement('Package', Id='F3086C49-3E92-4BE5-B4A2-447EBDF020A7')]
  [EcoCodeGenVersion('2.0')]
  [UmlMetaAttribute('ownedElement', TypeOf(OrderMax))]
  OrderpacMax = class
  end;

  [assembly: RuntimeRequired(TypeOf(OrderpacMax))]
  IOrderMaxList = interface;
  
  [UmlCollection(TypeOf(OrderMax))]
  IOrderMaxList = interface(ICollection)
    {$REGION 'ECO generated code'}
    function get_Item(index: Integer): OrderMax;
    procedure set_Item(index: Integer; Value: OrderMax);
    property Item[index: Integer]: OrderMax read get_Item write set_Item; default;
    function Add(value: OrderMax): Integer;
    function Contains(value: OrderMax): Boolean;
    function IndexOf(value: OrderMax): Integer;
    procedure Insert(index: Integer; value: OrderMax);
    procedure Remove(value: OrderMax);
    procedure Clear;
    procedure RemoveAt(index: Integer);
    {$ENDREGION 'ECO generated code'}
  end;
  
  [UmlElement(Id='28229368-6fff-48ce-8427-849ac1a0086d')]
  [StateMachine('OrderMax', '<?xml version="1.0" encoding="utf-16"?><StateMa' +
  'chine xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.' +
  'w3.org/2001/XMLSchema-instance" Name="OrderMax" StateAttribute="order_sta' +
  'te"><Transitions><Transition Guard="self.total&lt;500" Source="Pending" T' +
  'arget="approved" Trigger="approve" Effect="" /><Transition Source="Pendin' +
  'g" Target="denied" Trigger="deny" Effect="" /><Transition Source="referre' +
  'd" Target="denied" Trigger="deny" Effect="" /><Transition Source="Pending' +
  '" Target="referred" Trigger="refer" Effect="" /><Transition Guard="self.t' +
  'otal&lt;750" Source="referred" Target="approved" Trigger="approve" Effect' +
  '="" /><Transition Source="Initial_1" Target="Pending" Trigger="" Effect="' +
  '" /></Transitions><Vertexes><Vertex Name="Pending" Kind="RegularState" En' +
  'try="" Exit="" Representation=""><Regions /></Vertex><Vertex Name="approv' +
  'ed" Kind="RegularState" Entry="" Exit="" Representation=""><Regions /></V' +
  'ertex><Vertex Name="denied" Kind="RegularState" Entry="" Exit="" Represen' +
  'tation=""><Regions /></Vertex><Vertex Name="referred" Kind="RegularState"' +
  ' Entry="" Exit="" Representation=""><Regions /></Vertex><Vertex Name="Ini' +
  'tial_1" Kind="InitialState" Entry="" Exit="" Representation=""><Regions /' +
  '></Vertex></Vertexes></StateMachine>')]
  OrderMax = class(System.Object, ILoopBack)
    {$REGION 'ECO generated code'}
  public
  type
    Eco_LoopbackIndices = class
    public
    const
      Eco_FirstMember = 0;
    const
      Eco_MemberCount = (Eco_FirstMember + 5);
    const
      units = Eco_FirstMember;
    const
      order_state = (Eco_LoopbackIndices.units + 1);
    const
      description = (Eco_LoopbackIndices.order_state + 1);
    const
      price = (Eco_LoopbackIndices.description + 1);
    const
      total = (Eco_LoopbackIndices.price + 1);
    end;

    OrderMaxListAdapter = class(ObjectListAdapter, IOrderMaxList)
    public
      constructor Create(source: IList);
      function get_Item(index: Integer): OrderMax;
      procedure set_Item(index: Integer; Value: OrderMax);
      property Item[index: Integer]: OrderMax read get_Item write set_Item; default;
      function Add(value: OrderMax): Integer;
      function Contains(value: OrderMax): Boolean;
      function IndexOf(value: OrderMax): Integer;
      procedure Insert(index: Integer; value: OrderMax);
      procedure Remove(value: OrderMax);
    end;
    
  strict protected
    eco_Content: IContent;
  strict private
    function IObjectProvider.AsIObject = IObjectProvider_AsIObject;
    function IObjectProvider_AsIObject: IObject;
  public
    function AsIObject: IObjectInstance;
    procedure set_MemberByIndex(index: Integer; value: System.Object); virtual;
    function get_MemberByIndex(index: Integer): System.Object; virtual;
    function get_description: string;
    procedure set_description(Value: string);
    [UmlElement(Id='8a5edf96-5406-4698-a16e-71eef2cb5ac6', Index=Eco_LoopbackIndices.description)]
    property description: string read get_description write set_description;
    function get_units: Integer;
    procedure set_units(Value: Integer);
    [UmlElement(Id='02901ef4-964a-45a2-967c-dde5e55ba343', Index=Eco_LoopbackIndices.units)]
    property units: Integer read get_units write set_units;
    function get_price: Integer;
    procedure set_price(Value: Integer);
    [UmlElement(Id='9584ccb4-7512-4822-8e99-d28ead0c2d84', Index=Eco_LoopbackIndices.price)]
    property price: Integer read get_price write set_price;
    function get_total: Integer;
    [UmlElement(Id='a6a063fc-e80a-4658-b0bd-002c98765407', Index=Eco_LoopbackIndices.total)]
    [UmlTaggedValue('persistence', 'transient')]
    [UmlTaggedValue('derived', 'True')]
    [UmlTaggedValue('Eco.DerivationOCL', 'units * price')]
    property total: Integer read get_total;
    [UmlElement(Id='ac59ca13-15cf-4d23-9c5a-e8db112e27d7')]
    [UmlTaggedValue('Eco.IsTrigger', 'True')]
    procedure deny;
    [UmlElement(Id='d5e89213-2674-4d30-a0ab-9f114cf1733b')]
    [UmlTaggedValue('Eco.IsTrigger', 'True')]
    procedure approve;
    [UmlElement(Id='c4d94b20-37fc-4a0f-baad-1b96e775996e')]
    [UmlTaggedValue('Eco.IsTrigger', 'True')]
    procedure refer;
    function get_order_state: string;
    [UmlElement(Id='0e916962-eae9-4175-b61c-e1d271871ae2', Index=Eco_LoopbackIndices.order_state)]
    [UmlTaggedValue('Eco.IsStateAttribute', 'True')]
    property order_state: string read get_order_state;
  strict protected
    procedure Deinitialize(serviceProvider: IEcoServiceProvider);
    procedure Initialize(serviceProvider: IEcoServiceProvider);
    /// <summary>For Framework Internal use only</summary>
  public
    constructor Create(content: IContent); overload;
    {$ENDREGION 'ECO generated code'}
    constructor Create(serviceProvider: IEcoServiceProvider); overload;
  end;

implementation

function OrderMax.IObjectProvider_AsIObject: IObject;
begin
  Result := Self.eco_Content.AsIObject;
end;

function OrderMax.AsIObject: IObjectInstance;
begin
  Result := Self.eco_Content.AsIObject;
end;

procedure OrderMax.set_MemberByIndex(index: Integer; value: System.Object);
begin
  raise System.IndexOutOfRangeException.Create;
end;

function OrderMax.get_MemberByIndex(index: Integer): System.Object;
begin
  raise System.IndexOutOfRangeException.Create;
end;

procedure OrderMax.Deinitialize(serviceProvider: IEcoServiceProvider);
var
  factory: IInternalObjectContentFactory;
begin
  if (Self.eco_Content <> nil) then
  begin
    factory := (IInternalObjectContentFactory(serviceProvider.GetEcoService(TypeOf(IInternalObjectContentFactory))));
    factory.CreateContentFailed(Self.eco_Content, Self);
    Self.eco_Content := nil;
  end;
end;

procedure OrderMax.Initialize(serviceProvider: IEcoServiceProvider);
var
  factory: IInternalObjectContentFactory;
begin
  if (Self.eco_Content = nil) then
  begin
    factory := (IInternalObjectContentFactory(serviceProvider.GetEcoService(TypeOf(IInternalObjectContentFactory))));
    Self.eco_Content := factory.CreateContent(Self);
    Self.eco_Content.LoopbackValid;
  end;
end;

/// <summary>For Framework Internal use only</summary>
constructor OrderMax.Create(content: IContent);
begin
  inherited Create;
  Self.eco_Content := content;
  content.AssertLoopbackUnassigned;
end;

{$ENDREGION 'ECO generated code'}

constructor OrderMax.Create(serviceProvider: IEcoServiceProvider);
begin
  inherited Create;
  Self.Initialize(serviceProvider);
  try
    // User code here
  except
    on System.Exception do
    begin
      Self.Deinitialize(serviceProvider);
      raise;
    end;
  end;
end;

function OrderMax.get_order_state: string;
begin
  Result := (string(Self.eco_Content.get_MemberByIndex(Eco_LoopbackIndices.order_state)));
end;

procedure OrderMax.refer;
type
  TArrayOfobject = array of &object;
begin
  Self.AsIObject.Invoke('refer', New(TArrayOfobject, 0));
end;

procedure OrderMax.approve;
type
  TArrayOfobject = array of &object;
begin
  Self.AsIObject.Invoke('approve', New(TArrayOfobject, 0));
end;

procedure OrderMax.deny;
type
  TArrayOfobject = array of &object;
begin
  Self.AsIObject.Invoke('deny', New(TArrayOfobject, 0));
end;

function OrderMax.get_total: Integer;
begin
  Result := (Integer(Self.eco_Content.get_MemberByIndex(Eco_LoopbackIndices.total)));
end;

function OrderMax.get_price: Integer;
begin
  Result := (Integer(Self.eco_Content.get_MemberByIndex(Eco_LoopbackIndices.price)));
end;

procedure OrderMax.set_price(Value: Integer);
begin
  Self.eco_Content.set_MemberByIndex(Eco_LoopbackIndices.price, (System.Object(Value)));
end;

function OrderMax.get_units: Integer;
begin
  Result := (Integer(Self.eco_Content.get_MemberByIndex(Eco_LoopbackIndices.units)));
end;

procedure OrderMax.set_units(Value: Integer);
begin
  Self.eco_Content.set_MemberByIndex(Eco_LoopbackIndices.units, (System.Object(Value)));
end;

function OrderMax.get_description: string;
begin
  Result := (string(Self.eco_Content.get_MemberByIndex(Eco_LoopbackIndices.description)));
end;

procedure OrderMax.set_description(Value: string);
begin
  Self.eco_Content.set_MemberByIndex(Eco_LoopbackIndices.description, (System.Object(Value)));
end;

constructor OrderMax.OrderMaxListAdapter.Create(source: IList);
begin
  inherited Create(source);
end;

function OrderMax.OrderMaxListAdapter.get_Item(index: Integer): OrderMax;
begin
  Result := (OrderMax(inherited Adaptee[index]));
end;

procedure OrderMax.OrderMaxListAdapter.set_Item(index: Integer; Value: OrderMax);
begin
  inherited Adaptee[index] := value;
end;

function OrderMax.OrderMaxListAdapter.Add(value: OrderMax): Integer;
begin
  Result := Self.Adaptee.Add(value);
end;

function OrderMax.OrderMaxListAdapter.Contains(value: OrderMax): Boolean;
begin
  Result := Self.Adaptee.Contains(value);
end;

function OrderMax.OrderMaxListAdapter.IndexOf(value: OrderMax): Integer;
begin
  Result := Self.Adaptee.IndexOf(value);
end;

procedure OrderMax.OrderMaxListAdapter.Insert(index: Integer; value: OrderMax);
begin
  Self.Adaptee.Insert(index, value);
end;

procedure OrderMax.OrderMaxListAdapter.Remove(value: OrderMax);
begin
  Self.Adaptee.Remove(value);
end;

end.
