unit uPSI_AfViewers;
{
   a view to a fill
}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_AfViewers = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAfFileViewer(CL: TPSPascalCompiler);
procedure SIRegister_TAfCustomFileViewer(CL: TPSPascalCompiler);
procedure SIRegister_TAfTerminal(CL: TPSPascalCompiler);
procedure SIRegister_TAfCustomTerminal(CL: TPSPascalCompiler);
procedure SIRegister_TAfTerminalBuffer(CL: TPSPascalCompiler);
procedure SIRegister_TAfFileStream(CL: TPSPascalCompiler);
procedure SIRegister_TAfLineViewer(CL: TPSPascalCompiler);
procedure SIRegister_TAfCustomLineViewer(CL: TPSPascalCompiler);
procedure SIRegister_TAfFontStyleCache(CL: TPSPascalCompiler);
procedure SIRegister_AfViewers(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_AfViewers_Routines(S: TPSExec);
procedure RIRegister_TAfFileViewer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfCustomFileViewer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfTerminal(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfCustomTerminal(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfTerminalBuffer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfFileStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfLineViewer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfCustomLineViewer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfFontStyleCache(CL: TPSRuntimeClassImporter);
procedure RIRegister_AfViewers(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,Menus
  ,StdCtrls
  ,Clipbrd
  ,AfViewers
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AfViewers]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfFileViewer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAfCustomFileViewer', 'TAfFileViewer') do
  with CL.AddClassN(CL.FindClass('TAfCustomFileViewer'),'TAfFileViewer') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfCustomFileViewer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAfCustomLineViewer', 'TAfCustomFileViewer') do
  with CL.AddClassN(CL.FindClass('TAfCustomLineViewer'),'TAfCustomFileViewer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
       RegisterMethod('Procedure CloseFile');
    RegisterMethod('Function FilePtrFromLine( Line : Integer) : PChar');
    RegisterMethod('Procedure OpenFile');
    RegisterMethod('Procedure OpenData( const TextBuf : PChar; const TextSize : Integer)');
    RegisterProperty('FileSize', 'DWORD', iptr);
    RegisterProperty('ScanPosition', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfTerminal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAfCustomTerminal', 'TAfTerminal') do
  with CL.AddClassN(CL.FindClass('TAfCustomTerminal'),'TAfTerminal') do begin
   REgisterPublishedProperties;
   RegisterProperty('caption', 'string', iptrW);
  RegisterProperty('LogName', 'string', iptrw);
  RegisterProperty('OnSendChar', 'TKeyPressEvent', iptrw);
  RegisterProperty('CaretBlinkTime', 'TAfCLVCaretBlinkTime', iptrw);
  RegisterProperty('LogFileStream', 'TAfFileStream', iptrw);
  RegisterProperty('LogMemStream', 'TMemoryStream', iptrw);
  RegisterProperty('OnBeepChar', 'TNotifyEvent', iptrw);
  RegisterProperty('OnDrawBuffer', 'TNotifyEvent', iptrw);
  RegisterProperty('OnFlushLog', 'TNotifyEvent', iptrw);
   RegisterProperty('Options', 'TAfCLVOptions', iptrw);

   //RegisterProperty('Options', 'TAfComOptions', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfCustomTerminal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAfCustomLineViewer', 'TAfCustomTerminal') do
  with CL.AddClassN(CL.FindClass('TAfCustomLineViewer'),'TAfCustomTerminal') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure ClearBuffer');
    RegisterMethod('Function DefaultTermColor : TAfTRMCharAttr');
    RegisterMethod('Procedure DrawChangedBuffer');
    RegisterMethod('Procedure WriteChar( C : Char)');
    RegisterMethod('Procedure WriteColorChar( C : Char; BColor, FColor : TAfTRMCharColor)');
    RegisterMethod('Procedure WriteColorStringAndData( const S : String; BColor, FColor : TAfTRMCharColor; UserDataItem : Pointer)');
    RegisterMethod('Procedure WriteString( const S : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfTerminalBuffer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAfTerminalBuffer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAfTerminalBuffer') do begin
    RegisterProperty('FCharColorsArray', 'PAfTRMCharAttrs', iptrw);
    RegisterProperty('FColorTable', 'TAfTRMColorTable', iptrw);
    RegisterProperty('FTopestLineForUpdateColor', 'Integer', iptrw);
    RegisterProperty('EndBufPos', 'TPoint', iptrw);
    RegisterProperty('LastBufPos', 'TPoint', iptrw);
    RegisterProperty('MaxInvalidate', 'TPoint', iptrw);
    RegisterMethod('Constructor Create( ATerminal : TAfCustomTerminal)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure ClearBuffer');
    RegisterMethod('Procedure DrawChangedBuffer');
    RegisterMethod('Function GetBuffColorsForDraw( LineNumber : Integer) : PAfCLVCharColors');
    RegisterMethod('Function GetBuffLine( LineNumber : Integer) : String');
    RegisterMethod('Procedure GetLineColors( LineNumber : Integer; var Colors : TAfTRMCharAttrs)');
    RegisterMethod('Procedure ReallocBuffer( Rows : Integer; Cols : Byte; ColorMode : TAfTRMColorMode; UserDataSize : Integer)');
    RegisterMethod('Procedure SetLineColors( LineNumber : Integer; var Colors : TAfTRMCharAttrs)');
    RegisterMethod('Procedure WriteChar( C : Char)');
    RegisterMethod('Procedure WriteColorChar( C : Char; TermColor : TAfTRMCharAttr)');
    RegisterMethod('Procedure WriteStr( const S : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfFileStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THandleStream', 'TAfFileStream') do
  with CL.AddClassN(CL.FindClass('THandleStream'),'TAfFileStream') do begin
    RegisterMethod('Constructor Create( const FileName : string; Mode : Word)');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure FlushBuffers');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfLineViewer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAfCustomLineViewer', 'TAfLineViewer') do
  with CL.AddClassN(CL.FindClass('TAfCustomLineViewer'),'TAfLineViewer') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfCustomLineViewer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TAfCustomLineViewer') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TAfCustomLineViewer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
       RegisterMethod('Procedure ClearSelection');
    RegisterMethod('Procedure CopyToClipboard');
    RegisterMethod('Procedure DrawToCanvas( DrawCanvas : TCanvas; StartLine, EndLine : Integer; Rect : TRect)');
    RegisterMethod('Procedure DrawLineToCanvas( DrawCanvas : TCanvas; LineNumber : Integer; Rect : TRect; TextMetric : TTextMetric)');
    RegisterMethod('Procedure InvalidateDataRect( R : TRect; FullLine : Boolean)');
    RegisterMethod('Procedure InvalidateFocusedLine');
    RegisterMethod('Procedure InvalidateLeftSpace( StartLine, EndLine : Integer)');
    RegisterMethod('Function IsSelectionEmpty : Boolean');
    RegisterMethod('Function MouseToPoint( X, Y : Integer) : TPoint');
    RegisterMethod('Procedure ScrollIntoView');
    RegisterMethod('Procedure SelectAll');
    RegisterMethod('Procedure SelectArea( Old, New : TPoint)');
    RegisterMethod('Function TextFromRange( const ASelStart, ASelEnd : TPoint) : string');
    RegisterMethod('Procedure UnselectArea');
    RegisterProperty('CharHeight', 'Integer', iptr);
    RegisterProperty('CharWidth', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfFontStyleCache(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAfFontStyleCache') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAfFontStyleCache') do begin
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function GetFont( Style : TFontStyles) : HFont');
    RegisterMethod('Function Recreate( Font : TFont) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AfViewers(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('AfCLVMaxLineLength','LongInt').SetInt( 1024);
 CL.AddConstantN('UM_UPDATELINECOUNT','LongWord').SetUInt( WM_USER + $100);
  SIRegister_TAfFontStyleCache(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EAfCLVException');
  CL.AddTypeS('TAfCLVCaretType', '( ctVertical, ctHorizontal, ctBlock )');
  CL.AddTypeS('TAfCLVCharAttr', 'record BColor: TColor; FColor: TColor; Style: TFontStyles; end');
  //CL.AddTypeS('PAfCLVCharColors', '^TAfCLVCharColors // will not work');
  CL.AddTypeS('TAfCLVColorMode', '( cmDefault, cmLine, cmChars, cmCheckLength )');
  CL.AddTypeS('TAfCLVFocusSource', '( fsKey, fsMouse, fsHScroll, fsVScroll )');
  CL.AddTypeS('TAfCLVLineState', '( lsNormal, lsFocused, lsSelected )');
  CL.AddTypeS('TAfCLVOption', '(loCanSelect, loSelectByShift, loDrawFocusSelect, loThumbTracking, loScrollToRowCursor, loScrollToColCursor, loShowLineCursor, loShowCaretCursor, loTabs) ');
  CL.AddTypeS('TAfCLVOptions', 'set of TAfCLVOption');
  CL.AddTypeS('TAfCLVLeftSpace', 'Integer');
  CL.AddTypeS('TAfCLVMaxLineLength', 'Integer');
  CL.AddTypeS('TAfCLVCaretBlinkTime', 'Integer');
  CL.AddTypeS('TAfCLVCursorEvent', 'Procedure ( Sender : TObject; CursorPos : TPoint)');
  CL.AddTypeS('TAfCLVDrawLeftSpEvent', 'Procedure ( Sender : TObject; const Lin'
   +'e, LeftCharPos : Integer; Rect : TRect; State : TAfCLVLineState)');
  //CL.AddTypeS('TAfCLVGetTextEvent', 'Procedure ( Sender : TObject; Line : Integ'
  // +'er; var Text: String; var ColorMode: TAfCLVColorMode; var CharColors: TAfCLVCharColors)');
  SIRegister_TAfCustomLineViewer(CL);
  SIRegister_TAfLineViewer(CL);
  CL.AddTypeS('TAfTRMCharColor', 'Integer');
  CL.AddTypeS('TAfTRMCharAttr', 'record FColor: TAfTRMCharColor; BColor: TAfTRMCharColor; end');
  //CL.AddTypeS('PAfTRMCharAttrs', '^TAfTRMCharAttrs // will not work');
  CL.AddTypeS('TAfTRMColorMode', '( cmLDefault, cmL16_16, cmC16_16 )');
  CL.AddTypeS('TAfTRMLogging', '( lgOff, lgCreate, lgAppend )');
  CL.AddTypeS('TAfTRMBkSpcMode', '( bmBack, bmBackDel )');
  CL.AddTypeS('TAfTRMLogSize', 'Integer');
  CL.AddTypeS('TAfTRMLogFlushTime', 'Integer');
  //CL.AddTypeS('TAfTRMGetColorsEvent', 'Procedure ( Sender : TObject; Line : Int'
   //+'eger; var Colors : TAfTRMCharAttrs)');
  CL.AddTypeS('TAfTRMLineEvent', 'Procedure ( Sender : TObject; Line : Integer)');
  CL.AddTypeS('TAfTRMProcessCharEvent', 'Procedure (Sender: TObject; var C: Char)');
  CL.AddTypeS('TAfTRMScrBckBufChange', 'Procedure ( Sender : TObject; BufferSize: Integer)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TAfCustomTerminal');
  SIRegister_TAfFileStream(CL);
  SIRegister_TAfTerminalBuffer(CL);
  SIRegister_TAfCustomTerminal(CL);
  SIRegister_TAfTerminal(CL);
  CL.AddTypeS('TAfCVFScanStep', 'Integer');
  SIRegister_TAfCustomFileViewer(CL);
  SIRegister_TAfFileViewer(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAfCustomFileViewerScanPosition_R(Self: TAfCustomFileViewer; var T: Integer);
begin T := Self.ScanPosition; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomFileViewerFileSize_R(Self: TAfCustomFileViewer; var T: DWORD);
begin T := Self.FileSize; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferMaxInvalidate_W(Self: TAfTerminalBuffer; const T: TPoint);
Begin Self.MaxInvalidate := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferMaxInvalidate_R(Self: TAfTerminalBuffer; var T: TPoint);
Begin T := Self.MaxInvalidate; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferLastBufPos_W(Self: TAfTerminalBuffer; const T: TPoint);
Begin Self.LastBufPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferLastBufPos_R(Self: TAfTerminalBuffer; var T: TPoint);
Begin T := Self.LastBufPos; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferEndBufPos_W(Self: TAfTerminalBuffer; const T: TPoint);
Begin Self.EndBufPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferEndBufPos_R(Self: TAfTerminalBuffer; var T: TPoint);
Begin T := Self.EndBufPos; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferFTopestLineForUpdateColor_W(Self: TAfTerminalBuffer; const T: Integer);
Begin Self.FTopestLineForUpdateColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferFTopestLineForUpdateColor_R(Self: TAfTerminalBuffer; var T: Integer);
Begin T := Self.FTopestLineForUpdateColor; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferFColorTable_W(Self: TAfTerminalBuffer; const T: TAfTRMColorTable);
Begin Self.FColorTable := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferFColorTable_R(Self: TAfTerminalBuffer; var T: TAfTRMColorTable);
Begin T := Self.FColorTable; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferFCharColorsArray_W(Self: TAfTerminalBuffer; const T: PAfTRMCharAttrs);
Begin Self.FCharColorsArray := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferFCharColorsArray_R(Self: TAfTerminalBuffer; var T: PAfTRMCharAttrs);
Begin T := Self.FCharColorsArray; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerCharWidth_R(Self: TAfCustomLineViewer; var T: Integer);
begin T := Self.CharWidth; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerCharHeight_R(Self: TAfCustomLineViewer; var T: Integer);
begin T := Self.CharHeight; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AfViewers_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfFileViewer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfFileViewer) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfCustomFileViewer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfCustomFileViewer) do begin
    RegisterConstructor(@TAfCustomFileViewer.Create, 'Create');
    RegisterMethod(@TAfCustomFileViewer.Destroy, 'Free');
    RegisterMethod(@TAfCustomFileViewer.CloseFile, 'CloseFile');
    RegisterMethod(@TAfCustomFileViewer.FilePtrFromLine, 'FilePtrFromLine');
    RegisterMethod(@TAfCustomFileViewer.OpenFile, 'OpenFile');
    RegisterMethod(@TAfCustomFileViewer.OpenData, 'OpenData');
    RegisterPropertyHelper(@TAfCustomFileViewerFileSize_R,nil,'FileSize');
    RegisterPropertyHelper(@TAfCustomFileViewerScanPosition_R,nil,'ScanPosition');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfTerminal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfTerminal) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfCustomTerminal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfCustomTerminal) do begin
    RegisterConstructor(@TAfCustomTerminal.Create, 'Create');
    RegisterMethod(@TAfCustomTerminal.Destroy, 'Free');
    RegisterMethod(@TAfCustomTerminal.ClearBuffer, 'ClearBuffer');
    RegisterMethod(@TAfCustomTerminal.DefaultTermColor, 'DefaultTermColor');
    RegisterMethod(@TAfCustomTerminal.DrawChangedBuffer, 'DrawChangedBuffer');
    RegisterMethod(@TAfCustomTerminal.WriteChar, 'WriteChar');
    RegisterMethod(@TAfCustomTerminal.WriteColorChar, 'WriteColorChar');
    RegisterMethod(@TAfCustomTerminal.WriteColorStringAndData, 'WriteColorStringAndData');
    RegisterMethod(@TAfCustomTerminal.WriteString, 'WriteString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfTerminalBuffer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfTerminalBuffer) do begin
    RegisterPropertyHelper(@TAfTerminalBufferFCharColorsArray_R,@TAfTerminalBufferFCharColorsArray_W,'FCharColorsArray');
    RegisterPropertyHelper(@TAfTerminalBufferFColorTable_R,@TAfTerminalBufferFColorTable_W,'FColorTable');
    RegisterPropertyHelper(@TAfTerminalBufferFTopestLineForUpdateColor_R,@TAfTerminalBufferFTopestLineForUpdateColor_W,'FTopestLineForUpdateColor');
    RegisterPropertyHelper(@TAfTerminalBufferEndBufPos_R,@TAfTerminalBufferEndBufPos_W,'EndBufPos');
    RegisterPropertyHelper(@TAfTerminalBufferLastBufPos_R,@TAfTerminalBufferLastBufPos_W,'LastBufPos');
    RegisterPropertyHelper(@TAfTerminalBufferMaxInvalidate_R,@TAfTerminalBufferMaxInvalidate_W,'MaxInvalidate');
    RegisterConstructor(@TAfTerminalBuffer.Create, 'Create');
      RegisterMethod(@TAfTerminalBuffer.Destroy, 'Free');
    RegisterMethod(@TAfTerminalBuffer.ClearBuffer, 'ClearBuffer');
    RegisterMethod(@TAfTerminalBuffer.DrawChangedBuffer, 'DrawChangedBuffer');
    RegisterMethod(@TAfTerminalBuffer.GetBuffColorsForDraw, 'GetBuffColorsForDraw');
    RegisterMethod(@TAfTerminalBuffer.GetBuffLine, 'GetBuffLine');
    RegisterMethod(@TAfTerminalBuffer.GetLineColors, 'GetLineColors');
    RegisterMethod(@TAfTerminalBuffer.ReallocBuffer, 'ReallocBuffer');
    RegisterMethod(@TAfTerminalBuffer.SetLineColors, 'SetLineColors');
    RegisterMethod(@TAfTerminalBuffer.WriteChar, 'WriteChar');
    RegisterMethod(@TAfTerminalBuffer.WriteColorChar, 'WriteColorChar');
    RegisterMethod(@TAfTerminalBuffer.WriteStr, 'WriteStr');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfFileStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfFileStream) do
  begin
    RegisterConstructor(@TAfFileStream.Create, 'Create');
    RegisterMethod(@TAfFileStream.FlushBuffers, 'FlushBuffers');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfLineViewer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfLineViewer) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfCustomLineViewer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfCustomLineViewer) do begin
    RegisterConstructor(@TAfCustomLineViewer.Create, 'Create');
        RegisterMethod(@TAfCustomLineViewer.Destroy, 'Free');
    RegisterMethod(@TAfCustomLineViewer.ClearSelection, 'ClearSelection');
    RegisterMethod(@TAfCustomLineViewer.CopyToClipboard, 'CopyToClipboard');
    RegisterMethod(@TAfCustomLineViewer.DrawToCanvas, 'DrawToCanvas');
    RegisterMethod(@TAfCustomLineViewer.DrawLineToCanvas, 'DrawLineToCanvas');
    RegisterMethod(@TAfCustomLineViewer.InvalidateDataRect, 'InvalidateDataRect');
    RegisterMethod(@TAfCustomLineViewer.InvalidateFocusedLine, 'InvalidateFocusedLine');
    RegisterMethod(@TAfCustomLineViewer.InvalidateLeftSpace, 'InvalidateLeftSpace');
    RegisterMethod(@TAfCustomLineViewer.IsSelectionEmpty, 'IsSelectionEmpty');
    RegisterMethod(@TAfCustomLineViewer.MouseToPoint, 'MouseToPoint');
    RegisterMethod(@TAfCustomLineViewer.ScrollIntoView, 'ScrollIntoView');
    RegisterMethod(@TAfCustomLineViewer.SelectAll, 'SelectAll');
    RegisterMethod(@TAfCustomLineViewer.SelectArea, 'SelectArea');
    RegisterMethod(@TAfCustomLineViewer.TextFromRange, 'TextFromRange');
    RegisterMethod(@TAfCustomLineViewer.UnselectArea, 'UnselectArea');
    RegisterPropertyHelper(@TAfCustomLineViewerCharHeight_R,nil,'CharHeight');
    RegisterPropertyHelper(@TAfCustomLineViewerCharWidth_R,nil,'CharWidth');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfFontStyleCache(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfFontStyleCache) do begin
    RegisterMethod(@TAfFontStyleCache.Clear, 'Clear');
    RegisterMethod(@TAfFontStyleCache.GetFont, 'GetFont');
    RegisterMethod(@TAfFontStyleCache.Recreate, 'Recreate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AfViewers(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAfFontStyleCache(CL);
  with CL.Add(EAfCLVException) do
  RIRegister_TAfCustomLineViewer(CL);
  RIRegister_TAfLineViewer(CL);
  with CL.Add(TAfCustomTerminal) do
  RIRegister_TAfFileStream(CL);
  RIRegister_TAfTerminalBuffer(CL);
  RIRegister_TAfCustomTerminal(CL);
  RIRegister_TAfTerminal(CL);
  RIRegister_TAfCustomFileViewer(CL);
  RIRegister_TAfFileViewer(CL);
end;

 
 
{ TPSImport_AfViewers }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfViewers.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AfViewers(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfViewers.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AfViewers(ri);
  RIRegister_AfViewers_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
