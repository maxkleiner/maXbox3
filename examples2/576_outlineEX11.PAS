{
 Designer: Craig Ward, 100554.7compuserve.com
 Date:     9/11/95   Max 2015  20 Years!
 Version:  1.0

 Function: Example of how to use a TOutline component inconjunction with a table.

 Notes:    TOutlines can not be made to be data-aware simply because you can not
           actually get at the text in a TOutline, though this might be different
           in Delphi32 where you have the addition of the Win95 Tree component
           (I'm not sure about this, so please check!). Therefore you have to
           programmatically populate a TOutline with data from a table, let the user
           play around with the TOutlines, and then write the amended data back to
           the tables.

           Clearly you'll need methods for reading and writing to\from the tables,
           and the obvious place to put these would be on the form's  activate and
           close events.
*******************************************************************************}
unit outlineEx11;

interface

{uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Grids, Outline, DB, DBTables, DBGrids;
 }
//type
  //TForm1 = class(TForm)
  var  
    tabMasterDetail: TTable;
    tabMasterDetailParent: TStringField;
    tabMasterDetailChild: TStringField;
    Outline1: TOutline;
    DataSource1: TDataSource;
    Outline2: TOutline;
    tabMaster: TTable;
    tabMasterParent: TStringField;
    tabDetail: TTable;
    tabDetailChild: TStringField;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Database1: TDatabase;
    procedure Outline2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Outline1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Outline1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Outline2EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    //procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  //private
    { Private declarations }
    procedure fillOutline1;
    procedure fillOutline2;
    procedure WriteTabMasterDetail;
  //public
    { Public declarations }
  //end;

var
  Frm1: TForm;
   DBTreeView1: TDBTreeView;

implementation

//{$R *.DFM}

{***populate outline with table data*******************************************}

{read tables to populate first outline}
procedure FillOutline1;
var
 i: integer;
begin
 outline1.clear;
 tabMaster.first;
 {***}
 with Outline1 do begin
   {read from master table}
   while not tabMaster.eof do begin
     i := add(0,tabMasterPARENT.value);
     tabMasterDetail.first;
     {read from masterDetail table}
     while not tabMasterDetail.eof do begin
       if tabMasterDetailPARENT.value = tabMasterPARENT.value then
        addChild(i,tabMasterDetailCHILD.value);
       tabMasterDetail.next;
      end;
    tabMaster.next;
    end;
  end;
end;


{read tables to populate second outline}
procedure FillOutline2;
var
 i: integer;
begin
 outline2.clear;
 tabDetail.first;
 {***}
 with Outline2 do begin
   {read from detail table}
   while not tabDetail.eof do begin
     i := add(0,tabDetailCHILD.value);
     tabMasterDetail.first;
     {read from masterDetail table}
     while not tabMasterDetail.eof do begin
       if tabMasterDetailCHILD.value = tabDetailCHILD.value then
        addChild(i,tabMasterDetailPARENT.value);
       tabMasterDetail.next;
      end;
    tabDetail.next;
    end;
  end;
end;


procedure FillOutlineFromQuery;
var
 i: integer;
begin
 outline2.clear;
 tabMasterDetail.first;
 {***}
 with Outline2 do begin
   {read from detail table}
   while not tabmasterDetail.eof do begin
     i:= add(0,tabmasterDetail.Fields[1].asString);
     //tabMasterDetail.first;
     {read from masterDetail table}
       //if tabMasterDetailCHILD.value = tabDetailCHILD.value then
      addChild(i,tabMasterDetail.Fields[2].asstring);
    tabMasterDetail.next;
    //tabDetail.next;
    end;
    fullexpand;
  end;
end;


 procedure TfrmMain_Outline2DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Node: TOutlineNode;
  NodeIdx: Integer;
  Offset: Integer;
  NowBitmap: TBitmap;
  NowAstValue: string;
  //outline2: TOutline;
begin
  //outline2.ondrawitem
  NodeIdx := Outline2.GetItem(Rect.Left, Rect.Top);
  Node := Outline2.Items[NodeIdx];
  //NowAstValue := PAstRec(Outline2.Items[NodeIdx].Data)^.AstValue;
  with Outline2.Canvas do begin
    Font.Name := 'MS Sans Serif';
    Font.Size := 8;
    Offset := MulDiv(Font.Size, 150, 100);
    fillRect(Rect);
    Rect.Left := Rect.Left + ((Node.Level - 1) * Offset + 2);
    if Node.HasItems then begin
      if Node.Expanded then
        NowBitmap := getbitmap(Exepath+'\examples\brightfullmoon.bmp')//Outline2.PictureMinus
      else
        //NowBitmap := Outline2.PicturePlus;
      {?????? ??????}
      BrushCopy(Rect, NowBitmap,
        Bounds(0, 0, Rect.Right - Rect.Left, Rect.Bottom -
        Rect.Top),
        NowBitmap.TransparentColor);
    end;
    Rect.Left := Rect.Left + Offset + 2;
    {??????? ?????}
    TextOut(Rect.left, Rect.Top, Node.Text);
    {??????? ??????????? ??????? ? ?????? ?????????????}
    Rect.Left := Rect.Right - TextWidth(NowAstValue) - 2;
    TextOut(Rect.Left, Rect.Top, NowAstValue);
  end;
end;
 


{***populate table with outline data*******************************************}
procedure WriteTabMasterDetail;
var
 i, iFin: integer;
 sP, sC: string;
begin

 {clear table}
 try
  tabMasterDetail.close;
  tabMasterDetail.emptyTable;
 except
  //on EDatabaseError do
   begin
    messageDlg('Could not empty table. Are you running this from Delphi? If so, close down the project,'+
                      ' and run the EXE file from Program\File Manager. All changes will be cancelled.',mtWarning,[mbOK],0);
    exit;
   end;
 end;
  tabMasterDetail.open;

 {write to table}
 try
  begin
   iFin := outline2.itemCount;
   tabMasterDetail.first;
   for i := 1 to (iFin) do
    begin
     if outline2.items[i].level > 1 then begin
        tabMasterDetail.InsertRecord([outline2.items[i].text, 
                 outline2.items[i].parent.text]);
        tabMasterDetail.next;
       end;
    end;
  end;
 except
  //on EDatabaseError do
   begin
    messageDlg('Could not write to table. All changes to data will be cancelled.',mtWarning,[mbOK],0);
    exit;
   end;
 end;
end;

{***drag methods***************************************************************}

{set beginDrag}
procedure Outline2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 {drag on the usual left mouse-button}
 if button = mbLeft then
 {drag only if a parent value is selected}
 if outline2.items[outline2.getItem(x,y)].level <> 1 then
  exit
 else
  with Sender {as TOutline)} do begin
     //TOutline(sender).BeginDrag(False);
   end;
end;

{accept drag}
procedure Outline1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
 if source is TOutline then
  accept := true;
end;

{drag drop}
procedure Outline1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
 sText, sNew, sOld: string;
 i, iFin, iD, iChild: integer;
begin
 if source is TOutline then
  begin
  {only allow item to be added if parent, and not a child}
  if outline1.items[outline1.getItem(x,y)].level <> 1 then
   exit;

  {find data on item begin dragged}
  i := outline2.selectedItem;                                 {index}
  sText := outline2.lines.strings[i - 1];                     {text}
  sNew := outline1.lines.strings[outline1.GetItem(x,y)-1];    {new child text}
  sOld := outline2.items[i+1].text;                           {old child text}

  outline1.beginUpdate;                                       {turn off screen repainting}
  try
   begin
    iChild := 0;
    iChild := (outline1.GetItem(x,y));
    {making sure that the user adds to an existing parent, and does not create a new parent}
    if iChild = 0 then
     iChild := 1;
    outline1.addChild(iChild,sText);
   end;

  {delete old item}
   begin
   iFin := outline1.itemCount;
   {loop to find sChild in outline1}
    for i := 1 to (iFin) do
     begin
      {find the child item, and then remove it}
       if outline1.items[i].text = sText then
       if outline1.items[i].parent.text = sOld then
        iD := (outline1.items[i].index)-1;       {minus 1, because Lines indices start from 0, and not 1}
     end;
    outline1.lines.delete(iD);
   end;

  finally
   outline1.endUpdate;
   //outline1.invalidate;           //update;
  end;


  {must update outline2 to keep in synch with outline1}
  begin
   outline2.items[(outline2.selectedItem)+1].text := sNew; {plus 1, because Lines indices start from 0, and not 1}
   //outline2.update;
  end;

  end;
end;


{end drag}
procedure Outline2EndDrag(Sender, Target: TObject; X, Y: Integer);
var alck: TADOLockType;
  apt: TParameter;
  copt: TCursorOption;
  upmode: TUpdateMode;
  //acc: TTestCaseClass;
  aflat: TFlatlist;
begin
 with TADOCommand.create(self) do begin
  // Create(AOwner: TComponent); override;
    free //destructor Destroy; override;
    //Assign(Source: TPersistent); override;
     Cancel;
    //Execute: _Recordset; overload;
    //function Execute(const Parameters: OleVariant): _Recordset; overload;
   // function Execute(var RecordsAffected: Integer; const Parameters: OleVariant): _Recordset; overload;
    //CommandObject: _Command read FCommandObject;
    //Properties: Properties read GetProperties;
    //States: TObjectStates read GetState;
  //published
    //CommandText: WideString read FCommandText write SetCommandText;
    //CommandTimeout: Integer read GetCommandTimeOut write SetCommandTimeOut default 30;
    //CommandType: TCommandType read GetCommandType write SetComandType default cmdText;
    //Connection: TADOConnection read FConnection write SetConnection;
    //ConnectionString: WideString read FConnectionString write SetConnectionString;
    //ExecuteOptions: TExecuteOptions read FExecuteOptions write FExecuteOptions default [];
    //prepared: WordBool read GetPrepared write SetPrepared default False;
   // Parameters: TParameters read FParameters write SetParameters;
   // ParamCheck: Boolean read FParamCheck write FParamCheck default True;
 end;
 //if target <> nil then outline2.update;
end;


{***form's preferences*********************************************************}

procedure FormActivate(Sender: TObject);
begin
 fillOutline1;
 fillOutline2;
end;

procedure CloseClick(Sender: TObject; var action: TCloseAction);
begin
 //FRM1.close;
 outline1.free;
 outline2.free;
 if assigned(DataSource1) then begin
   DataSource1.Free;
   tabMasterDetail.close;
   tabMasterDetail.Free;
 end;  
 //DBTreeView1.Free;
 
end;

procedure BitBtn2Click(Sender: TObject);
begin
 writeTabMasterDetail;
 //close;
end;

function GetFontWidth(acomp: TEdit {TWinControl}): integer;
var  metrics: TTextmetric;
  dc: hdc;
  savefont: HFont;
  //mye: TEdit;
  res: integer;
begin
  dc:= getDC(0);
  savefont:= selectobject(DC, acomp.font.handle);
  gettextMetrics(DC, Metrics);
  selectobject(DC, savefont)
  releaseDC(0,DC)
  result:= metrics.tmMaxCharWidth;
end;  

 //const  SQLQueryExec = 'ALTER TABLE TREE_1 ADD AText2 varchar(40)';
 const  SQLQueryExec = 'Select * from TREE_1';
 // const   SQLQueryExec = 'INSERT INTO TREE_1 (Parent, Child) '+ 
                                //'VALUES (''parent11'',''child11'')';
// const SQLQueryExec = 'UPDATE TREE_1 SET AText'+
                             // '= ''maXbox11111111'' WHERE child=''child11''';
  


procedure DoExecQuery2(aDB: TTable);
var dQuery: TQuery;
begin
   dQuery:= TQuery.create(self);                                                
   with dQuery do begin
   DatabaseName:= aDB.DataBaseName;
    writeln('reccount of querytable '+intToStr(adb.recordcount))
     //tablename
     try
       try
        writeln('DB Q '+'C:\maXbook\maxbox3\mX3999\rblexe32\mX39999\'+DatabaseName)
        writeln('');
        writeln('exec the query for DB starts: ');
        SQL.Clear;
        SQL.Text:= SQLQueryExec;
        writeln('exec sql ready to run: ');
       // Writeln(inttostr(RecordCount)+' Records found: ')
      // ExecSQL;
        Open;
        Writeln(inttostr(RecordCount)+' !Records found: ')
        
        FillOutlineFromQuery;
        //Writeln(inttostr(RecordCount)+' Records found: ')
        except
         //raiselastexception;
         showmessagebig('E: exec query 2 raiselastexception');
         writeln('E: exec query 2 raiselastexception');
        end
       finally
         //raiselastexception;
         Close;
         Free;
         showmessagebig('Exec query 2 success!');
      
         //CloseDataBase(aDB)
       end;
    end   
end; 




procedure setdboutlineFRM(Sender: TObject);
var
  c, r, _r, _g, _b: integer;
  DrawCount: Integer;
  SaveTime: Cardinal;
  // statistics: string;
    // inFrm: TForm;
begin
  DrawCount := 0;
  SaveTime := GetTickCount;
  // ST_EndDemo:= false;
  //STSwitch:= false;
  Frm1:= TForm.Create(self);
    with frm1 do begin
    caption:= '******** OUTLINEDB MATRIX DEMO 2************';  
    height:= 720;
    width:= 980;
    color:= clnavy;
    Position:= poScreenCenter;
    onClose:= @CloseClick;
    Show;
  end;

  outline1:= TOutline.create(self);
  with outline1 do begin
    parent:= frm1;
    setbounds(20,20,300,500)
  end;  
  
  outline2:= TOutline.create(self);
  with outline2 do begin
    parent:= frm1;
    setbounds(350,20,300,500)
  end;  
  
  tabMasterDetail:= TTable.create(self);
  with tabMasterDetail do begin
    if tabMasterDetail.Active then
    exit;
  if (DatabaseName = '') then begin
    if FileExists('C:\maXbook\maxbox3\mX3999\rblexe32\mX39999\TREE_1.DB') then begin
      DatabaseName:= 'example11';
        writeln('DB NAME path: ' +DatabaseName)
     TableName:= 'TREE_1.DB';  
     try
       Open;
     except
     end  
    end;
    writeln('reccount of table '+intToStr(recordcount))
   end;
  end;
 
  DoExecQuery2((tabMasterDetail));
 
  DataSource1:= TDataSource.create(self);
  with DataSource1 do begin
   //parent:= frmDBTree;
   //if GetBdeDirectory <> ' ' then
     //DataSet:= Table1 else
       DataSet:= TDataSet(tabMasterDetail);  //ADO
       DataSet.Open;
    writeln('fieldcount of datasource '+intToStr(dataset.fieldcount))
    writeln('recordcount of datasource '+intToStr(dataset.recordcount))
  end;
  
  DBTreeView1:= TDBTreeView.create(frm1)
  try
  with DBTreeView1 do begin
    parent:= frm1;
    SetBounds(655,60,300,500)
    HideSelection:= False
    Indent:= 19
    ParentColor:= False
    borderstyle:= bsSingle;
    TabOrder:= 0
    //PopupMenu:= PopupMenu1;
    DataSource:= DataSource1;
    TableIDField:= 'Parent'
    TableParentField:= 'Child'
    TableTextField:= 'AText'
    RootID:= 'null'
    Show;
    Options:= [dtAllowDelete,dtAllowInsert,dtAutoDragMove,dtAutoExpand,dtCancelOnExit, dtConfirmDelete, dtSynchronizeDataSet]
  end;   
  SetWindowLong(DBTreeView1.Handle, GWL_EXSTYLE, GetWindowLong(DBTreeView1.Handle,
           GWL_EXSTYLE) and not WS_EX_CLIENTEDGE);
   
  except
    writeln('db tree view not called')
  end;  
 
  
 { cyColMtrx1:= TcyColorMatrix.create(infrm);
  with cyColMtrx1 do begin
     parent:= infrm;
     setbounds(14,130,815,648)
     //width:= 400;
  //     object cyColMtrx1: TcyColorMatrix
      Background.AngleDegree:= 0
      Background.FromColor:= clGray
      Background.SpeedPercent:= 100
      Background.ToColor:= clBlack
      BorderWidth:= 8
      CellHeight:= 3
      CellWidth:= 4
      ColCount:= 160
      CellFrameColor:= 16384
      CellSpacingHeight:= 0
      DefaultColor:= clGreen
      TopRowValue:= 100.000000000000000000
      RowCount:= 144
      OnCellClick:= @cyColMtrx1CellClick
      OnPaint:= @cyColMtrx1Paint
      //Bevels = <>
      Wallpaper.Transparent:= False
  end;                               }

 end;

begin

  setdboutlineFRM(self)

End.

//begin
//ref
  //http://docwiki.embarcadero.com/Libraries/XE7/en/Vcl.Outline.TOutline_Methods


  {DFM
ÿ
TFORM1
C:\maXbook\maxbox3\mX3999\rblexe32\mX39999\EX11.DFM 
$  ÿ }


(*{Author:		Craig Ward
Date:		9/11/95



Tables and the art of Drag'n'Drop
	- Using a TOutline Component with Tables





Introduction.

This article attempts to explain how to use the TOutline component inconjunction with data-tables. In the example I will demonstrate how to use two the drag'n'drop facility in TOutline components, to manipulate the data in tables that are connected in a master-detail relationship. 


Data and the TOutline Component.

Originally I was working on a project within which I wanted to create an interface where the user could drag'n'drop data, using the TOutline component.

I tried to create a data-aware TOutline component, though I soon realised that this was not possible since a user could not actually access the data in a TOutlineNode, as they can edit the data in a TDBGrid or TDBEdit. I'm not sure if this will be different in Delphi32, since that contains a Win95 TTreeView component, which if anything like the TreeView's used throughout Win95, you can actually edit the data contained in a node. 

I then tried to drag'n'drop between two TDBGrids, though this presented two problems. Firstly, trapping the mouse actions that initiated the drag, and secondly, the aesthetics of dragging between two grids is not comparable to that of two outlines, which are far more traditional with respect to drag'n'drop.

Therefore, I realised that certain compromises would have to be made. Firstly, that since the TOutline could not be made to be data-aware, I would have to programmatically deal with reading from the tables to be used in the project. This is no hardship, it just detracts from the seamless resuse of the code (ie: each project where such dragging and dropping is to be used, the code has to be modified, though with Search|Replace this is no trouble). 

Secondly, since I the component would not be truly data-aware, any changes that are made via drag'n'drop, would have to be written to the table programmatically. Again, the seamless reuse of this code is detracted from, but even though I disagree with the statement that programming can't always be straightforward, I was prepared to make compromises in this case.


Setting up.

In my example there is a master-detail relationship between the tables used. Such a relationship will usually require three tables:

[1] the master table
[2] the detail table
[3] the master\detail table (which would have a primary key which is the combination of the keys in the master, and detail, tables. If in your example it doesn't, then I'd suggest you revise your SSADM notes!).

What I want to be able to do, is represent the data in two outline components, but from opposiet angles. This way the user can see what master value detail records have been assigned to (contained in outline2), and also to see what details make up each master record (contained in outline1).

To achieve this I use:

Tables: 

TabMaster	- contains the records for the master side of the relationship (has one field: PARENT)
TabDetail	- contains the records for the detail relationship (has one field: CHILD)
TabMasterDetail - contains a combination of the master\detail keys (has two fields: PARENT, CHILD)

Outlines:

Outline1	- presents the data, with the tabMaster key as the parent nodes
Outline2	- presents the data , with the tabDetail key as the child node


Buttons:

Save		- saves data in Outline1 to table, and then closes the project down
Cancel		- closes down project


Populating the TOutlines.

This is the first step: reading the data from the table and using it to populate the outlines. 

There is a procedure for filling each of the outlines (fillOutline1, and fillOutline2). I'll now go through the code for populating the outline1 (ie: fillOutline1).

Quite simply, we intend to set up an iteration process, where we read the data in each record of the table and add it (in the form of a TOutlineNode) to the outline component.

As with all iterations, ensure that the table is at the first record before proceeding:

 tabMaster.first;

Then, the iteration can begin safely. You'll notice immediately that there is an iteration, within an iteration. The first is writing data from the master table to create the parent nodes in the outline component, the second deals with reading from the master\detail table, and adding these values as childs of the parent nodes.

In order to add these values as childs, we must first find those values in tabMasterDetail that contain a value that matches the value in tabMaster (or, from a different angle, that matches the parent nodes in outline1).


   while not tabMaster.eof do
    begin
     i := add(0,tabMasterPARENT.value);
     tabMasterDetail.first;

     {read from masterDetail table}
     while not tabMasterDetail.eof do
      begin
       if tabMasterDetailPARENT.value = tabMasterPARENT.value then
        addChild(i,tabMasterDetailCHILD.value);
       tabMasterDetail.next;
      end;

    tabMaster.next;
    end;


This will fill outline1 with parent nodes that match the values in tabMaster, and childs that match the values in tabMasterDetail. In only a small piece of code we have simulated a master-detail relationship in a TOutline component!

The procedure fillOutline2 carries out a similar process, differing only in the fact that it sets outline2 up to be the opposite of outline1 (ie: outline2 will have parent nodes which match the values in tabDetail).

Now we have the outlines filled, we must set up the dragging and dropping between the two.


Handling dragging.

In my example, the obvious procedure is to allow the user to drag from the detail outline (outline2) to the master outline (outline1).

Before we handle the amending of data in the outlines, we must set the methods for determining the drag'n'drop environment. 

First, we write the method, attached to the mouse-down event of outline2 which will set BeginDrag to true (BeginDrag method starts the dragging of a control - if true the mouse pointer changes to the value of the DragCursor property and dragging begins immediately). Note that we only start dragging if the user has selected parent node

 if button = mbLeft then
 {drag only if a parent value is selected}
 if outline2.items[outline2.getItem(x,y)].level <> 1 then
  exit
 else
  with Sender as TOutline do
   begin
     BeginDrag(False);
   end;

Second, we must allow the master outline to accept dragged items from the detail outline:

 if source is TOutline then
  accept := true;

Now we must handle the changing of data in the outlines. Basically, the user will be amending the master value of detail records, and this must be represented in both of the outlines. This is handled in the OnDragDrop event of the master outline.

Notice that the event handler will pass the following:

 procedure TForm1.Outline1DragDrop(Sender, Source: TObject; X, Y: Integer);

The values of X and Y will be of use (they are the coordinates of the mouse over the outline) and will help us determine which parent node was selected by the user.

Before anything happens, we ensure that the user is dragging and dropping over a parent node, and not a child (otherwise they could end up adding a grandchild to a child and this will disrupt our master\detail relationship).

  if outline1.items[outline1.getItem(x,y)].level <> 1 then
   exit;

We then derive basic data with regard to the item that is being dragged. Remember: the user is dragging a detail to a master. Namely we want it's index, the detail record's text, the master value to be assigned to the detail record, and lastly the current value of the master field in the detail record:

   i := outline2.selectedItem;                                 	{index}
  sText := outline2.lines.strings[i - 1];                   		{text}
  sNew := outline1.lines.strings[outline1.GetItem(x,y)-1];    {new child text}
  sOld := outline2.items[i+1].text;                           	{old child text}


There is a useful method of the TOutline component. This is the beginUpdate method, which basically turns off screen repainting while we make amendments to the data in the outline components. This will save any flickering whilst changes are made, which would arise since we are going to make several changes to the outline components.

When this method is called, there must be a call to its sister method, EndUpdate, when processing is finished. It is advisable to place this within a try..finally block.

Are next steps are to: first add the detail value to the master outline's selected parent node, then delete the old child that references this detail value in one of the master outline's parent nodes,  and then finally update the detail outline. 

We use the function GetItem, passing it the coordinates X,Y, to find the index of the parent node that is to receive the dragged item, and then add a child to this node (note that I ensure that the value of iChild can not be 0, which prevents the user from creating a new parent node):

    iChild := (outline1.GetItem(x,y));
    if iChild = 0 then
     iChild := 1;
    outline1.addChild(iChild,sText);
   end;

We then delete the old detail value that resides somewhere in the master outline. We must hunt this node down, first by finding a child node that matches the dragged item, and then by finding such a child node which has a parent node value equal to the old master value of the dragged item (note that I deduct one from the value of iD, which is due to the fact that I'm using the TOutline.items and TOutline.lines properties, where the first has an index starting from one, and the second has an index starting from zero):

   iFin := outline1.itemCount;
    for i := 1 to (iFin) do
     begin
       if outline1.items[i].text = sText then
       if outline1.items[i].parent.text = sOld then
        iD := (outline1.items[i].index)-1;                   
     end;
    outline1.lines.delete(iD);
   end;

Now we have handled the addition and deletion of a node in the master outline (which, by virtue of calling the beginUpdate procedure, will appear transparent to the user) we must update the detail outline. This is a very simple process, that simply involves updating the text  property of the child node from which we dragged:

   outline2.items[(outline2.selectedItem)+1].text := sNew; 
   outline2.update;

The drag'n'drop process is now complete! All we have left to do is to handle the writing back to the tables of data.



Writing to the Tables.

Our job here is very simple: write the values contained in one the nodes (since they both contain exactly the same data, just viewed in different ways) to the master\detail table. This is handle in the procedure WriteTabMasterDetail.

First, we empty the table. There is a procedure emptyTable which handles this job for us (notice my use of the try..except block, which handles any database exceptions smoothly):

 try
  tabMasterDetail.close;
  tabMasterDetail.exclusive := true;
  tabMasterDetail.emptyTable;
 except
  on EDatabaseError do
   begin
    messageDlg('Could not empty table. All changes will be cancelled.',mtWarning,[mbOK],0);
    exit;
   end;
 end;
  tabMasterDetail.open;

Next, we write to the table. We must use a simple for..loop iteration that reads each node of the outline, and inserts these values into the table (again notice the use of the try..except block):

 try
  begin
   iFin := outline2.itemCount;
   tabMasterDetail.first;
   for i := 1 to (iFin) do
    begin
     if outline2.items[i].level > 1 then
       begin
        tabMasterDetail.InsertRecord([outline2.items[i].text, outline2.items[i].parent.text]);
        tabMasterDetail.next;
       end;
    end;
  end;
 except
  on EDatabaseError do
   begin
   messageDlg('Could not write to table.',mtWarning,[mbOK],0);
    exit;
   end;
 end;
end;


The whole process is now complete!  We are presented with a quick, transparent process that reads data from three tables into two TOutline components, handles the dragging and dropping between the two, and then writes to the main table in a protected fashion.


Key Fields.

However, there is a slight problem with this example. For this example to make sense, the main keys fields (ie: tabMaster's PARENT and tabDetail's CHILD fields) are of alphanumeric type. 

In the vast majority of the tables that I create I use key fields that are of a numeric type (since they are smaller than string fields, allow much faster access in key searches, allow the developer to create simple routines which simulate the useful auto-increment field-type, and are generally more flexible). If I had used such tables in this example, the outlines would have been populated with data that would make little sense to the user, since the parent nodes, and their childs, would simply be meaningless numbers!


Conclusions.

However, in some cases the use of alpha fields as keys is possible, and in such circumstances this example may be of great use. It provides an interface which is extremely typical to many Windows controls, and we all know what a great piece of user-friendly software that is!


}*)