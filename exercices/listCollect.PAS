{ ****************************************************************
  Source:       C:\Dokumente\Entwickl\comdll\listCollect.PAS
  Typ:  	Collection-Unit
  Autor:  	max kleiner
  Descript:  	Vollständig abgeleitete Klasse
  Modell:	C:\Dokumente\Entwickl\comdll\Income5.mpb
  Besonderes: 	Indexoperator für items ist default
  Revisionen:   07.11.99 inherited als Typisierung
		02.02.00 freeElement
		07.05.01 MMRedesign
 **************************************************************** }

unit listCollect;

interface

uses Classes;

type
  TBrokerRec = record
    intVal: integer;
    strVal: string;
    ptrStr: pChar;
  end;
  PBrok = ^TBrokerRec;

  {:
  OOPolitische Version, clear, delete und remove
  rufen freeElement auf, sind somit echte
  Erweiterungen, der Rest dient der Typisierung
  07.05.01 Purpose: 
  }
  TBrokerList = class (TList)
  protected
    procedure freeElement(elem: PBrok);
    function GetItems(Index: Integer): PBrok;
    procedure SetItems(Index: Integer; item: PBrok);
  public
    destructor destroy; override;
    function Add(Item: PBrok): Integer;
    procedure Delete(index: integer);
    function First: PBrok;
    function indexOf(item: PBrok): Integer;
    procedure Insert(index: integer; item: PBrok);
    function Last: PBrok;
    procedure pClear;
    function Remove(item: PBrok): Integer;
    property Items[Index: Integer]: PBrok read GetItems write SetItems;
  end;
  

procedure Register;

implementation

procedure Register;
begin
end;

{:
Purpose: 
}
{
************************************** TBrokerList ***************************************
}
destructor TBrokerList.destroy;
begin
  clear;
  inherited Destroy;
end;

function TBrokerList.Add(Item: PBrok): Integer;
begin
  result:= inherited Add(Item);
end;

procedure TBrokerList.Delete(index: integer);
begin
  freeElement(items[index]);
  inherited delete(index);
end;

function TBrokerList.First: PBrok;
begin
  result:= inherited First;
end;

{:
TBrokerList.freeElement
(elem)
Freigabe eines Elements ohne Löschen aus der Liste
via clear, delete und remove
}
procedure TBrokerList.freeElement(elem: PBrok);
begin
  if elem <> NIL then dispose(elem);
end;

function TBrokerList.indexOf(item: PBrok): Integer;
begin
  result:= inherited indexOf(item);
end;

procedure TBrokerList.Insert(index: integer; item: PBrok);
begin
  inherited insert(index,item);
end;

function TBrokerList.Last: PBrok;
begin
  result:= inherited Last;
end;

{:
TBrokerList.pClear
TList.clear ist kein fortlaufendes Remove, 
sondern count:=0 und capacitiy:=0;
}
procedure TBrokerList.pClear;
var
  x: Integer;
begin
  for  x:= 0 to count-1 do freeElement(items[x]);
  inherited clear;
end;

{:
TBrokerList.Remove
(item)
direkte Implementation
}
function TBrokerList.Remove(item: PBrok): Integer;
begin
  result:= indexOf(item);
  if Result <> -1 then delete(result);
end;

function TBrokerList.GetItems(Index: Integer): PBrok;
begin
  result:= inherited get(index);
end;

procedure TBrokerList.SetItems(Index: Integer; item: PBrok);
begin
  inherited put(index, item);
end;


initialization
end.
