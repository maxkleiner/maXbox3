{ ****************************************************************
  Sourcefile     :  DBopen.PAS
  Typ            :  Form-Unit
  Engineer       :  Max Kleiner
  Erstellt am    :  10.01.1997
  Compiler       :  Delphi 1.2, Betriebssystem :  Win95
  Beschreibung   :  Ermöglicht Suche und Oeffnen einer Schatzung
                    Basiert komplett auf SQL
  Revisionen     :  25.10.96 Erster dialog zum Oeffnen einer Schatzung
                    29.10.96 Überarbeitet mit Query
                    10.01.97 Suchdialog und SQL Editor implementiert
 **************************************************************** }


unit DBOPEN1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, DB, DBTables,
  DBLookup;

type
  TdbOpenDlg = class(TForm)
    lblBis: TLabel;
    lblVon: TLabel;
    edtEndDate: TEdit;
    edtBeginDate: TEdit;
    lblStichtag: TLabel;
    CalBtnTo: TSpeedButton;
    Bevel1: TBevel;
    edtSchSuchen: TEdit;
    lblTop: TLabel;
    GrundSource: TDataSource;
    DBGrid1: TDBGrid;
    btnCancel: TBitBtn;
    tblGrund: TQuery;
    tblGrundSite: TIntegerField;
    tblGrundSchatzNr: TIntegerField;
    edtTitel: TEdit;
    lblObName: TLabel;
    lblObjadress: TLabel;
    lblOrt: TLabel;
    lblEigen: TLabel;
    lblTitel: TLabel;
    lblSchNr: TLabel;
    edtname: TEdit;
    edtadress: TEdit;
    edtOrt: TEdit;
    SQLStatements: TMemo;
    tblGrundStichtag: TDateTimeField;
    btnSuchen: TBitBtn;
    edtArt: TEdit;
    lblSchArt: TLabel;
    btnLoad: TBitBtn;
    CalBtnFrom: TSpeedButton;
    QueryCount: TQuery;
    btnSQL: TBitBtn;
    btnAlle: TBitBtn;
    tblGrundObjektort: TStringField;
    tblGrundObjektstrasse: TStringField;
    tblGrundTitel: TStringField;
    tblGrundObjektname: TStringField;
    hlpBitBtn: TBitBtn;
    dScrAuftrag: TDataSource;
    tblGrundAuftragNr: TIntegerField;
    LookupQuery: TQuery;
    LookupSource: TDataSource;
    ComboBox1: TComboBox;
    procedure CalBtnToClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ShowRecordsClick(Sender: TObject);
    procedure ShowSQLClick(Sender: TObject);
    procedure edtSchSuchenExit(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure CalBtnFromClick(Sender: TObject);
    procedure hlpBitBtnClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure edtAuftragDblClick(Sender: TObject);
  private
    function GetFromDate: TDateTime;
    function GetToDate: TDateTime;
    procedure SetFromDate(NewDate: TDateTime);
    procedure SetToDate(NewDate: TDateTime);
    procedure getHausObjekte;
    function GetSQLRecordCount: integer;
    function SomeEntries:Boolean;
  protected
    procedure BuildSQLString(var TheQuery: TStringList);
    procedure AddCondition(var TheQuery: TStringList;
                        const field, comparison, value: String);
  public
    function IsDate(Source: TEdit) :Boolean;
    property BeginDate: TDateTime read GetFromDate write SetFromDate;
    property EndDate: TDateTime read GetToDate write SetToDate;
  end;

var
  dbOpenDlg: TdbOpenDlg;

implementation

{$R *.DFM}

uses Pickdate;

procedure TdbOpenDlg.FormCreate(Sender: TObject);
begin
  tblGrund.open;
   beginDate:=StrToDate('01.01.1984');
  endDate:=Date;
  {edtAuftrag.LookupDisplay := 'Nachname;FirmenName';}
  activeControl:=edtSchSuchen;  {first with schatzNr}
  lblTop.caption:='Mandant suchen und laden';
  //IntToStr(getSQLRecordCount);
end;

procedure TdbOpenDlg.FormDestroy(Sender: TObject);
begin

  tblGrund.close;

end;

procedure TdbOpenDlg.btnCancelClick(Sender: TObject);
begin
 {GlobSchatzNr:=tblGrundSchatzNr.value;}             {debug}
  close;
end;



{property Methoden}

procedure TdbOpenDlg.SetFromDate(NewDate: TDateTime);
begin
  edtBeginDate.Text := DateToStr(NewDate);
end;

procedure TdbOpenDlg.SetToDate(NewDate: TDateTime);
begin
  edtEndDate.Text := DateToStr(NewDate);
end;

function TdbOpenDlg.GetFromDate: TDateTime;
begin
  if edtBeginDate.Text = '' then Result := 0
  else Result := StrToDate(edtBeginDate.Text);
end;

function TdbOpenDlg.GetToDate: TDateTime;
begin
  if edtEndDate.Text = '' then Result := 0
  else Result := StrToDate(edtEndDate.Text);
end;


procedure TdbOpenDlg.CalBtnFromClick(Sender: TObject);
begin
  try
    BrDateForm:= TBRDateForm.create(owner);
    if not (beginDate = 0) then
    BrDateForm.Date:= beginDate;
    if brDateForm.showModal = mrOK then
    BeginDate:= BrDateForm.Date;
  finally
    brDateForm.release;
  end;
end;

procedure TdbOpenDlg.CalBtnToClick(Sender: TObject);
begin
  try
    BrDateForm:= TBRDateForm.create(owner);
    if not (EndDate = 0) then
    BrDateForm.Date := EndDate;
    if BrDateForm.ShowModal = mrOk then
    EndDate:= BrDateForm.Date;
  finally
    brDateForm.release;
  end;
end;


procedure TdbOpenDlg.AddCondition(var TheQuery: TStringList;
                        const field, comparison, value: String);
begin
  if TheQuery.Count > 2 then
  {When Count > 2, there is already at least one condition}
   TheQuery.Add('AND '+field+comparison+value)
  else
   TheQuery.Add(field+comparison+value)
end;

function TdbOpenDlg.IsDate(Source: TEdit) :Boolean;
{This function returns True if a TEdit contains a date}
begin
  try
    StrToDate(TEdit(Source).Text);   {typecast of checking}
    result := True
  except
    result := False;
  end;
end;

function TdbOpenDlg.SomeEntries:Boolean;
begin
 Result:=
 not ((edtSchsuchen.text = '') and
      (edtName.Text = '') and (edtTitel.text = '') and (edtAdress.text = '') and
      (edtOrt.text = '') and (BeginDate = 0) and (EndDate = 0) and
      (edtArt.text = '') and (comboBox1.text = ''));
end;

procedure TdbOpenDlg.BuildSQLString(var TheQuery: TStringList);
begin
  if BeginDate <> 0 then
  if not IsDate(edtBeginDate) then begin
    edtBeginDate.SetFocus;
    raise Exception.Create('Date value expected');
  end;
  if EndDate <> 0 then
  if not IsDate(edtEndDate) then begin
    edtEndDate.SetFocus;
    raise Exception.Create('Date value expected');
  end;
  {if edtEigen.text <> '' then}
 { theQuery.Add('SELECT * FROM GRUNDDAT G, AUFTRAGG A') else}   {once will be a join}
  TheQuery.Add('SELECT * FROM GRUNDDAT') ;
  if SomeEntries then begin
    TheQuery.Add('WHERE');
      addCondition(theQuery,'Typ','<>','2');
   (* if edtEigen.text <> '' then                                 {join}
      addCondition(TheQuery,'A.AuftragNr','=',edtEigen.text);*)
    if edtSchSuchen.text <> '' then
      addCondition(TheQuery,'SchatzNr','=',edtSchSuchen.text);
    if edtTitel.text <> '' then                    {#39 is '}
      addCondition(theQuery,'UPPER'+'('+'Titel'+')',
                 'LIKE ',#39 + uppercase(edtTitel.text)+'%'#39);
    if edtName.Text <> '' then
      AddCondition(TheQuery,'UPPER'+'('+'Objektname'+')',
                 'LIKE',#39 + uppercase(edtName.Text)+'%'#39);
    if edtAdress.text <> '' then
      addCondition(theQuery,'UPPER'+'('+'Objektstrasse'+')',
                    'LIKE',#39 + uppercase(edtAdress.text)+'%'#39);
    if edtOrt.text <> '' then
      addCondition(theQuery,'UPPER'+'('+'Objektort'+')',
                    'LIKE',#39 + uppercase(edtOrt.text)+'%'#39);
//    if edtAuftrag.text <> '' then                      {Lookup}
  //    addCondition(theQuery,'AuftragNr','=',intToStr(tblAuftragAuftragNr.value));
    if edtArt.text <> '' then
      addcondition(theQuery,'UPPER'+'('+'Schatzart'+')',
                    'LIKE',#39 + uppercase(edtArt.text)+'%'#39);
    if BeginDate <> 0 then             {because DateTime is not a string}
        AddCondition(TheQuery,'Stichtag','>=',
                       ':BeginDate');
    if EndDate <> 0 then
        AddCondition(TheQuery,'Stichtag','<=',
                       ':EndDate');
  end; {if not empty strings}
end;

procedure TdbOpenDlg.ShowRecordsClick(Sender: TObject);
var
  TheQuery: TStringList;
begin
  TheQuery := TStringList.Create;
  theQuery.clear;
  try                             {ev close clear}
   if not someEntries then begin
    modalresult:=mrOK;
    Exit;
   end;
   BuildSQLString(TheQuery);
   {Query is built. Process it dear megamax}
   screen.cursor:= crSQLWait;
    with tblGrund do begin
      Close;
      SQL.Clear;
      SQL := TheQuery;
      if beginDate <> 0 then
      ParamByName('beginDate').AsDateTime:=beginDate;
      if endDate <> 0 then
      ParamByName('endDate').AsDateTime:=endDate;
      Open;
    end;
  finally
    TheQuery.Free;
    screen.Cursor:= crDefault;
  end;
end;




procedure TdbOpenDlg.ShowSQLClick(Sender: TObject);
var
  TheQuery: TStringList;
begin
  TheQuery := TStringList.Create;
  try
    if (SQLStatements.Lines[1] <> '') then
    theQuery.assign(SQLStatements.Lines
    )else begin
      BuildSQLString(TheQuery);
      {Query is built. Process it}
      SQLStatements.Lines := TheQuery;
    end;
    with SQLStatements do begin
    if (SQLStatements.visible=false) then SQLStatements.visible:= true else
    SQLStatements.visible:=false;
  end;
  finally
   TheQuery.Free;
  end;
end;


procedure TdbOpenDlg.edtSchSuchenExit(Sender: TObject);
begin
  try
    showRecordsClick(sender);
  except
    showmessage('schatzung not found');
    {tblGrund.findNearest([edtSchSuchen]);}
  end;
end;

function TdbOpenDlg.GetSQLRecordCount: integer;
begin
  with QueryCount do begin
    try
      Close; SQL.Clear;
      SQL.Add('Select Count(*)'+                           { PARAORA}
              ' from Grunddat where typ <> 2');
      open;
      result:=fields[0].asInteger;
      { SQL.Add('Select Count(*) As Anz'+                   ORA
              ' from Grunddat where typ <> 2');
      open;
      result:=fieldByName('Anz').asInteger;}
    finally;
      close;
    end;
  end; {with}
end;

procedure TdbOpenDlg.btnAllClick(Sender: TObject);
begin
  try                             {ev close clear}
    with tblGrund do begin
      Close;
      SQL.Clear;
      SQL.Add('Select Site,SchatzNr,AuftragNr,Titel,Objektname,Objektstrasse,Objektort,Stichtag'+
              ' from grunddat where typ <> 2'+
              'order by Site, SchatzNr');
      Open;
    end;
  finally
    end;
end;


procedure TdbOpenDlg.hlpBitBtnClick(Sender: TObject);
begin
 Application.HelpContext(31);
end;

procedure TdbOpenDlg.DBGrid1DblClick(Sender: TObject);
begin
  ModalResult:=mrOK;
end;

procedure TdbOpenDlg.btnLoadClick(Sender: TObject);
begin
 showRecordsClick(sender);
end;

procedure TdbOpenDlg.edtAuftragDblClick(Sender: TObject);
begin
  getHausObjekte;
  while not LookupSource.dataSet.EOF do begin
    combobox1.items.add(lookupSource.dataSet.fieldValues['Objektname']);
    lookupSource.dataSet.next;
  end;

end;

procedure TdbOpenDlg.getHausObjekte;
begin
  with lookupQuery do begin
      Close;
      SQL.Clear;
      SQL.Add('Select Site,SchatzNr,AuftragNr,Titel,Objektname,Objektstrasse,Objektort,Stichtag'+
              ' from grunddat where typ <> 2'+
              'order by Site, SchatzNr');
      Open;
  end;
end;

end.
