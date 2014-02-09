unit EcomaxEcoSpace;

interface

uses
  System.Threading,
  Borland.Eco.Services,
  Borland.Eco.UmlCodeAttributes,
  Borland.Eco.Handles,
  Package_1Unit, OrderpacMaxUnit;

type
  [EcoSpace]
  [EcoSpacePackage(TypeOf(OrderpacMaxUnit.OrderpacMax))]
  TEcomaxEcoSpace = class(Borland.Eco.Handles.DefaultEcoSpace)
  private
    procedure InitializeComponent;
    class var fTypeSystemProvider: ITypeSystemService;
    class var fTypeSystemProviderLock: Tobject;
  strict protected
    function GetTypeSystemProvider: ITypeSystemService; override;
  public
    constructor Create;
    class constructor Create;
    class function GetTypeSystemService: ITypeSystemService; static;
    procedure UpdateDatabase;
    function get_PersistenceService: IPersistenceService;
    property PersistenceService: IPersistenceService read get_PersistenceService;
    function get_DirtyListService: IDirtyListService;
    property DirtyListService: IDirtyListService read get_DirtyListService;
    function get_UndoService: IUndoService;
    property UndoService: IUndoService read get_UndoService;
    function get_TypeSystemService: ITypeSystemService;
    property TypeSystemService: ITypeSystemService read get_TypeSystemService;
    function get_OclService: IOclService;
    property OclService: IOclService read get_OclService;
    function get_ObjectFactoryService: IObjectFactoryService;
    property ObjectFactoryService: IObjectFactoryService read get_ObjectFactoryService;
    function get_VariableFactoryService: IVariableFactoryService;
    property VariableFactoryService: IVariableFactoryService read get_VariableFactoryService;
  end;

  [assembly: RuntimeRequired(TypeOf(TEcomaxEcoSpace))]

implementation
{$AUTOBOX ON}

constructor TEcomaxEcoSpace.Create;
begin
  inherited Create;
  InitializeComponent;
  // TODO: Add any constructor code here
end;

class constructor TEcomaxEcoSpace.Create;
begin
  fTypeSystemProviderLock := TObject.Create;
end;

procedure TEcomaxEcoSpace.InitializeComponent;
begin
end;

class function TEcomaxEcoSpace.GetTypeSystemService: ITypeSystemService;
begin
  if not Assigned(fTypeSystemProvider) then
  begin
    try
      Monitor.Enter(fTypeSystemProviderLock);
      if not Assigned(fTypeSystemProvider) then
        fTypeSystemProvider := MakeTypeService(typeOf(TEcomaxEcoSpace));
    finally
      Monitor.Exit(fTypeSystemProviderLock);
    end;
  end;
  Result := fTypeSystemProvider;
end;

function TEcomaxEcoSpace.GetTypeSystemProvider: ITypeSystemService;
begin
  Result := TEcomaxEcoSpace.GetTypeSystemService;
end;

procedure TEcomaxEcoSpace.UpdateDatabase;
begin
  if Assigned(PersistenceService) and Assigned(DirtyListService) then
    PersistenceService.UpdateDatabaseWithList(DirtyListService.AllDirtyObjects);
end;

function TEcomaxEcoSpace.get_PersistenceService: IPersistenceService;
begin
  Result := GetEcoService(typeof(IPersistenceService)) as IPersistenceService;
end;

function TEcomaxEcoSpace.get_DirtyListService: IDirtyListService;
begin
  Result := GetEcoService(typeof(IDirtyListService)) as IDirtyListService;
end;

function TEcomaxEcoSpace.get_UndoService: IUndoService;
begin
  Result := GetEcoService(typeof(IUndoService)) as IUndoService;
end;

function TEcomaxEcoSpace.get_TypeSystemService: ITypeSystemService;
begin
  Result := GetEcoService(typeof(ITypeSystemService)) as ITypeSystemService;
end;

function TEcomaxEcoSpace.get_OclService: IOclService;
begin
  Result := GetEcoService(typeof(IOclService)) as IOclService;
end;

function TEcomaxEcoSpace.get_ObjectFactoryService: IObjectFactoryService;
begin
  Result := GetEcoService(typeof(IObjectFactoryService)) as IObjectFactoryService;
end;

function TEcomaxEcoSpace.get_VariableFactoryService: IVariableFactoryService;
begin
  Result := GetEcoService(typeof(IVariableFactoryService)) as IVariableFactoryService;
end;

end.
