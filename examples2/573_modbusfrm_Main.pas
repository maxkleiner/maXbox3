{===============================================================================

The contents of this file are subject to the Mozilla Public License Version 1.1
(the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above. If you wish to
allow use of your version of this file only under the terms of the GPL and not
to allow others to use your version of this file under the MPL, indicate your
decision by deleting the provisions above and replace them with the notice and
other provisions required by the GPL. If you do not delete the provisions
above, a recipient may use your version of this file under either the MPL or
the GPL.

$Id: frm_Main.pas,v 1.4 2010/06/25 07:43:10 plpolak Exp $

===============================================================================}

unit frm_Main;

interface

{uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdTCPServer, IdModBusServer, Grids, ExtCtrls,
  StdCtrls, Buttons, ModbusTypes;
 }
//type
  //TfrmMain = class(TForm)
  var  
    msrPLC: TIdModBusServer;
    pnlInput: TPanel;
    btnStart: TBitBtn;
    Label1: TLabel;
    edtFirstReg: TEdit;
    edtLastReg: TEdit;
    Label2: TLabel;
    pnlMain: TPanel;
    sgdRegisters: TStringGrid;
    mmoErrorLog: TMemo;
    Splitter1: TSplitter;
    Timer1: TTimer;
       procedure msrPLCReadHoldingRegisters(const Sender: TIdPeerThread; const RegNr,
         Count: Integer; var Data: TModRegisterData;
         const RequestBuffer: TModbusRequestBuffer);
       procedure msrPLCWriteRegisters(const Sender: TIdPeerThread;
         const RegNr, Count: Integer; const Data: TModRegisterData;
         const RequestBuffer: TModbusRequestBuffer);
       procedure btnStartClick(Sender: TObject);
       procedure FormCreate(Sender: TObject);
       procedure FormShow(Sender: TObject);
       procedure FormClose(Sender: TObject; var Action: TCloseAction);
       procedure sgdRegistersSetEditText(Sender: TObject; ACol, ARow: Integer;
         const Value: String);
     //private
     var
       FFirstReg: Integer;
       FLastReg: Integer;
       FRegisterValues: array of Integer;
       procedure ClearRegisters;
       procedure FillRegisters;
       procedure Convert(const Index: Integer);
       procedure SetRegisterValue(const RegNo: Integer; const Value: Word);
       function GetRegisterValue(const RegNo: Integer): Word;
     //public
       { Public declarations }
     //end;

var
  frmMain: TForm; //TfrmMain;

implementation

//{$R *.dfm}

function IntToBinary(const Value: Int64; const ALength: Integer): String;
var
  iWork: Int64;
begin
  Result := '';
  iWork := Value;
  while (iWork > 0) do
  begin
    Result := IntToStr(iWork mod 2) + Result;
    iWork := iWork div 2;
  end;
  while (Length(Result) < ALength) do
    Result := '0' + Result;
end; { IntToBinary }


procedure msrPLCReadHoldingRegisters(const Sender: TIdPeerThread;
  const RegNr, Count: Integer; var Data: TModRegisterData;
  const RequestBuffer: TModbusRequestBuffer);
var
  i: Integer;
begin
  for i := 0 to (Count - 1) do
    Data[i] := GetRegisterValue(RegNr + i);
end; { msrPLCReadRegisters }


procedure msrPLCWriteRegisters(const Sender: TIdPeerThread;
  const RegNr, Count: Integer; const Data: TModRegisterData;
  const RequestBuffer: TModbusRequestBuffer);
var
  i: Integer;
begin
  for i := 0 to (Count - 1) do
    SetRegisterValue(RegNr + i, Data[i]);
end; { msrPLCWriteRegisters }


procedure btnStartClick(Sender: TObject);
begin
  if msrPLC.Active then begin
    msrPLC.Active := False;
    edtFirstReg.Enabled := True;
    edtLastReg.Enabled := True;
    btnStart.Caption := '&Start';
    ClearRegisters;
  end
  else
  begin
    FFirstReg := StrToInt(edtFirstReg.Text);
    FLastReg := StrToInt(edtLastReg.Text);
    msrPLC.MinRegister := FFirstReg;
    msrPLC.MaxRegister := FLastReg;
    btnStart.Caption := '&Stop';
    msrPLC.Active := True;
    FillRegisters; 
  end;
end; { btnStartClick }


procedure FormCreate(Sender: TObject);
begin
  FFirstReg := 0;
  FLastReg := 0;
{ Set grid headers titles }
  sgdRegisters.Cells[0, 0] := 'RegNo';
  sgdRegisters.Cells[1, 0] := 'Decimal';
  sgdRegisters.Cells[2, 0] := 'Hex.';
  sgdRegisters.Cells[3, 0] := 'Binary';
{ Set the column width }
  sgdRegisters.ColWidths[3] := 120;
end; { FormCreate }


procedure ClearRegisters;
var
  i: Integer;
begin
  sgdRegisters.RowCount := 2;
  for i := 0 to (sgdRegisters.ColCount - 1) do
    sgdRegisters.Cells[i, 1] := '';
end; { ClearRegisters }


procedure FillRegisters;
var
  i: Integer;
begin
  ClearRegisters;
  if (FLastReg >= FFirstReg) then
  begin
    sgdRegisters.RowCount := (FLastReg - FFirstReg) + 2;
    for i := FFirstReg to FLastReg do
    begin
      sgdRegisters.Cells[0, i - FFirstReg + 1] := IntToStr(i);
      SetRegisterValue(i, Random(2000) + 3000);
    end;
  end;
end; { FillRegisters }


procedure Convert(const Index: Integer);
begin
  sgdRegisters.Cells[2, Index + 1] := IntToHex(FRegisterValues[Index], 4);
  sgdRegisters.Cells[3, Index + 1] := IntToBinary(FRegisterValues[Index], 16);
end; { Convert }


procedure SetRegisterValue(const RegNo: Integer; const Value: Word);
var
 Index: Integer;
begin
  if (RegNo >= FFirstReg) and (RegNo <= FLastReg) then
  begin
    Index := RegNo - FFirstReg;
    if (Index >= Length(FRegisterValues)) then
      SetLength(FRegisterValues, (Index + 1) * 2);
    FRegisterValues[Index] := Value;
    sgdRegisters.Cells[1, Index + 1] := IntToStr(Value);
    Convert(Index);
  end;
end; { SetRegisterValue }


 const aMAXWORD =  32767;

 function WordRange(const i: Integer):Word;
 begin
   if (i < 0) and (i >= -32767) then
     Result := Word(i)
   else if (i <= aMAXWORD) then
     Result := Word(i)
   else
     Result := aMAXWORD;
 end; { WordRange }

function GetRegisterValue(const RegNo: Integer): Word;

var
  Index: Integer;
begin
  if (RegNo >= FFirstReg) and (RegNo <= FLastReg) then
  begin
    Index := RegNo - FFirstReg;
    Assert(Index >= 0, 'must greater 0');
    Assert(Index < Length(FRegisterValues),'.');
    if (Index >= 0) and (Index < Length(FRegisterValues)) then
      Result := WordRange(FRegisterValues[Index])
    else
      Result := 0;
  end
  else
    Result := 0;
end; { GetRegisterValue }


procedure FormShow(Sender: TObject);
begin
  btnStartClick(Sender);
end; { FormShow }


procedure FormClose(Sender: TObject; var Action: TCloseAction);
begin
  msrPLC.Pause := True;
  if msrPLC.Active then
    btnStartClick(Sender);
end; { FormClose }


procedure sgdRegistersSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var
  Index: Integer;
begin
  if (ACol = 1) then
  begin
    Index := ARow - 1;
    FRegisterValues[Index] := StrToIntDef(Value, 0);
    Convert(Index);
  end;
end; { sgdRegistersSetEditText }


begin
  writeln(itoa(maxword(112,34)))
   SetMaxAsyncCallThreads(12)
   //BringParentWindowToTop
    writeln(floattostr(GetFormulaValue('2^128')));
    writeln(itoa(getProcessorCount));
   { with TEditForm.create(self) do begin
      showmodal
      free
    end;  
   }
end.


Ref: Actions add:

5: C:\maXbook\maxbox3\mX3999\maxbox3\maxbox3\source\uPSI_Clipbrd.pas

     with CL.AddClassN(CL.FindClass('TPersistent'),'TClipboard') do begin
       assign missing
       free missing
     function Clipboard: TClipboard;
begin
  if FClipboard = nil then
    FClipboard := TClipboard.Create;
  Result := FClipboard;
end;

9: C:\maXbook\maxbox3\mX3999\maxbox3\maxbox3\source\uPSI_DBXpressWeb.pas
   property Caption;
    property CaptionAlignment;
    property Columns;
    property Footer;
    property Header;
    property MaxRows;
    property Query: TSQLQuery read FQuery write SetQuery;
    property RowAttributes;
    property TableAttributes;
    property OnCreateContent;
    property OnFormatCell;
    property OnGetTableCaption;
 


17: C:\maXbook\maxbox3\mX3999\maxbox3\maxbox3\source\uPSI_IdHTTPServer.pas

 
published
    property OnCreatePostStream;
    property OnCommandGet;


18:  C:\maXbook\maxbox3\mX3999\maxbox3\maxbox3\source\uPSI_IdUDPClient.pas

	published
    property Host: string read FHost write FHost;
    property Port: Integer read FPort write FPort;
    property ReceiveTimeout;


57:  C:\maXbook\maxbox3\mX3999\maxbox3\maxbox3\source\fundamentals_lib\uPSI_SynEditExport.pas


  { Creates an instance of the exporter. }
    constructor Create(AOwner: TComponent); override;
    { Destroys an instance of the exporter. }
    destructor Destroy; override;
    { Clears the output buffer and any internal data that relates to the last
     }

83:  C:\maXbook\maxbox3\mX3999\maxbox3\maxbox3\source\REST\uPSI_devExec.pas
98:  C:\maXbook\maxbox3\mX3999\maxbox3\maxbox3\source\REST\uPSI_GR32_VectorMaps.pas

 destructor Destroy; override; missing
103:  C:\maXbook\maxbox3\mX3999\maxbox3\maxbox3\source\REST\uPSI_IdRawClient.pas

        TIdRawClient = class(TIdRawBase)
  published
    property ReceiveTimeout;
    property Host;
    property Port;
    property Protocol;
  end;
106:  C:\maXbook\maxbox3\mX3999\maxbox3\maxbox3\source\REST\uPSI_JvAddPrinter.pas

      with CL.AddClassN(CL.FindClass('TJvCommonDialogF'),'TJvAddPrinterDialog') do
  begin
    RegisterMethod('Function Execute : Boolean');
  end;

  add in help form

120:  C:\maXbook\maxbox3\mX3999\maxbox3\maxbox3\source\REST\uPSI_ovctcary.pas

     with CL.AddClassN(CL.FindClass('TOBJECT'),'TOvcCellArray') do begin
    RegisterMethod('Procedure AddCell( RowNum : TRowNum; ColNum : TColNum)');
    RegisterMethod('Procedure AddUnusedBit');
