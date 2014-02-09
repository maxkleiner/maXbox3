unit uPSI_mORMotReport;
{
   report of synopse framework
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
  TPSImport_mORMotReport = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRenderPages(CL: TPSPascalCompiler);
procedure SIRegister_TRenderBox(CL: TPSPascalCompiler);
procedure SIRegister_TGDIPages(CL: TPSPascalCompiler);
procedure SIRegister_TGDIPageContent(CL: TPSPascalCompiler);
procedure SIRegister_TGDIPagereference(CL: TPSPascalCompiler);
procedure SIRegister_TPagePaintBox(CL: TPSPascalCompiler);
procedure SIRegister_THeaderFooter(CL: TPSPascalCompiler);
procedure SIRegister_mORMotReport(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_mORMotReport_Routines(S: TPSExec);
procedure RIRegister_TRenderPages(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRenderBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGDIPages(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGDIPageContent(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGDIPagereference(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPagePaintBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_THeaderFooter(CL: TPSRuntimeClassImporter);
procedure RIRegister_mORMotReport(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   SynCommons
  ,SynLz
  ,SynPdf
  ,Windows
  ,Messages
  ,Contnrs
  ,SynGdiPlus
  ,Graphics
  ,Controls
  ,Dialogs
  ,Forms
  ,StdCtrls
  ,ExtCtrls
  ,WinSpool
  ,Printers
  ,Menus
  ,ShellAPI
  ,RichEdit
  ,mORMotReport
  ;
 
 
procedure Register;
begin
  //RegisterComponents('Pascal Script', [TPSImport_mORMotReport]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRenderPages(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGDIPages', 'TRenderPages') do
  with CL.AddClassN(CL.FindClass('TGDIPages'),'TRenderPages') do begin
    RegisterMethod('Procedure RdrSetCurrentStateAsDefault');
    RegisterMethod('Procedure RdrParagraph');
    RegisterMethod('Function RdrTableBegin( const PercentWidth : array of integer) : Boolean');
    RegisterMethod('Function RdrTableColumn( aColumnIndex : Integer) : TRenderBox');
    RegisterMethod('Function RdrTableEnd : Boolean');
    RegisterProperty('Rdr', 'TRenderBox', iptr);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure SaveLayout');
    RegisterMethod('Procedure RestoreSavedLayout');
    RegisterProperty('ParagraphBefore', 'Integer', iptrw);
    RegisterProperty('ParagraphAfter', 'Integer', iptrw);
    RegisterProperty('ParagraphFirstLineIndent', 'Integer', iptrw);
    RegisterProperty('ParagraphLeftIndent', 'Integer', iptrw);
    RegisterProperty('ParagraphRightIndent', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRenderBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TRenderBox') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TRenderBox') do
  begin
    RegisterMethod('Constructor Create( Owner : TRenderPages)');
    RegisterMethod('Procedure AddText( const s : string);');
    RegisterMethod('Procedure AddText1( PW : PWideChar; PWLen : integer);');
    RegisterMethod('Procedure Flush( Left, Top : Integer; CurrentPageOnly : boolean; ForcedHeightBottomCentered : Integer; ForcedAtBottom : boolean)');
    RegisterMethod('Procedure NewLine');
    RegisterMethod('Procedure LinkBegin( const aBookmarkName : string)');
    RegisterMethod('Function LinkEnd : boolean');
    RegisterMethod('Procedure Plain');
    RegisterMethod('Procedure Pard');
    RegisterMethod('Procedure PardPlain');
    RegisterProperty('Owner', 'TRenderPages', iptr);
    RegisterProperty('Font', 'TFont', iptr);
    RegisterProperty('BiDiMode', 'TBiDiMode', iptrw);
    RegisterProperty('Width', 'integer', iptrw);
    RegisterProperty('Height', 'integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGDIPages(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TScrollBox', 'TGDIPages') do
  with CL.AddClassN(CL.FindClass('TScrollBox'),'TGDIPages') do
  begin
    RegisterProperty('OnPopupMenuPopup', 'TNotifyEvent', iptrw);
    RegisterProperty('OnPopupMenuClick', 'TNotifyEvent', iptrw);
    RegisterProperty('PopupMenuClass', 'TPopupMenuClass', iptrw);
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('ForcePrintAsBitmap', 'boolean', iptrw);
    RegisterProperty('ForceNoAntiAliased', 'boolean', iptrw);
    RegisterProperty('ForceInternalAntiAliased', 'boolean', iptrw);
    RegisterProperty('ForceInternalAntiAliasedFontFallBack', 'boolean', iptrw);
    RegisterProperty('ForcePrintColorMode', '( printColorDefault, printBW, printColor ) ', iptrw);
    RegisterProperty('ForcePrintDuplexMode', '( printDuplexDefault, printSimplex, printDuplex ) ', iptrw);
    RegisterProperty('ForceCopyTextAsWholeContent', 'boolean', iptrw);
    RegisterProperty('OnStringToUnicode', 'TOnStringToUnicodeEvent', iptrw);
    RegisterProperty('GroupsMustBeOnSamePage', 'boolean', iptrw);
    RegisterProperty('PreviewSurfaceBitmap', 'TBitmap', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Invalidate');
    RegisterMethod('Procedure BeginDoc');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure DrawText( const s : string)');
    RegisterMethod('Procedure DrawTextU( const s : RawUTF8)');
    RegisterMethod('Procedure DrawTextW( const s : SynUnicode)');
    RegisterMethod('Procedure DrawTextFmt( const s : string; const Args : array of const)');
    RegisterMethod('Function TitleFlags : integer');
    RegisterMethod('Procedure DrawTitle( const s : SynUnicode; DrawBottomLine : boolean; OutlineLevel : Integer; const aBookmark : string; const aLink : string)');
    RegisterMethod('Procedure DrawTextAt( s : SynUnicode; XPos : integer; const aLink : string; CheckPageNumber : boolean)');
    RegisterMethod('Procedure DrawAngledTextAt( const s : SynUnicode; XPos, Angle : integer)');
    RegisterMethod('Procedure DrawBox( left, top, right, bottom : integer)');
    RegisterMethod('Procedure DrawBoxFilled( left, top, right, bottom : integer; Color : TColor)');
    RegisterMethod('Procedure DrawBMP( rec : TRect; bmp : TBitmap);');
    RegisterMethod('Procedure DrawBMP1( bmp : TBitmap; bLeft, bWidth : integer; const Legend : string);');
    RegisterMethod('Procedure DrawMeta( rec : TRect; meta : TMetafile)');
    RegisterMethod('Procedure DrawGraphic( graph : TGraphic; bLeft, bWidth : integer; const Legend : SynUnicode)');
    RegisterMethod('Procedure DrawArrow( Point1, Point2 : TPoint; HeadSize : integer; SolidHead : boolean)');
    RegisterMethod('Procedure DrawLine( doubleline : boolean)');
    RegisterMethod('Procedure DrawDashedLine');
    RegisterMethod('Procedure AppendRichEdit( RichEditHandle : HWnd)');
    RegisterMethod('Procedure NewLine');
    RegisterMethod('Procedure NewHalfLine');
    RegisterMethod('Procedure NewLines( count : integer)');
    RegisterMethod('Procedure SaveLayout');
    RegisterMethod('Procedure RestoreSavedLayout');
    RegisterMethod('Procedure NewPage( ForceEndGroup : boolean)');
    RegisterMethod('Procedure NewPageIfAnyContent');
    RegisterMethod('Procedure NewPageLayout( sizeWidthMM, sizeHeightMM : integer; nonPrintableWidthMM : integer; nonPrintableHeightMM : integer);');
    RegisterMethod('Procedure NewPageLayout1( paperSize : TGdiPagePaperSize; orientation : TPrinterOrientation; nonPrintableWidthMM : integer; nonPrintableHeightMM : integer);');
    RegisterMethod('Procedure BeginGroup');
    RegisterMethod('Procedure EndGroup');
    RegisterMethod('Procedure EndDoc');
    RegisterMethod('Function PrintPages( PrintFrom, PrintTo : integer) : boolean');
    RegisterMethod('Function ExportPDF( aPdfFileName : TFileName; ShowErrorOnScreen : boolean; LaunchAfter : boolean) : boolean');
    RegisterMethod('Function ExportPDFStream( aDest : TStream) : boolean');
    RegisterMethod('Procedure ShowPreviewForm');
    RegisterMethod('Procedure SetTabStops( const tabs : array of integer)');
    RegisterMethod('Function HasSpaceForLines( Count : integer) : boolean');
    RegisterMethod('Function HasSpaceFor( mm : integer) : boolean');
    RegisterMethod('Procedure ClearHeaders');
    RegisterMethod('Procedure AddLineToHeader( doubleline : boolean)');
    RegisterMethod('Procedure AddTextToHeader( const s : SynUnicode)');
    RegisterMethod('Procedure AddTextToHeaderAt( const s : SynUnicode; XPos : integer)');
    RegisterMethod('Procedure ClearFooters');
    RegisterMethod('Procedure AddLineToFooter( doubleline : boolean)');
    RegisterMethod('Procedure AddTextToFooter( const s : SynUnicode)');
    RegisterMethod('Procedure AddTextToFooterAt( const s : SynUnicode; XPos : integer)');
    RegisterMethod('Procedure AddPagesToFooterAt( const PageText : string; XPos : integer)');
    RegisterMethod('Procedure AddColumn( left, right : integer; align : TColAlign; bold : boolean)');
    RegisterMethod('Procedure AddColumns( const PercentWidth : array of integer; align : TColAlign)');
    RegisterMethod('Procedure AddColumnHeaders( const headers : array of SynUnicode; WithBottomGrayLine : boolean; BoldFont : boolean; RowLineHeight : integer; flags : integer)');
    RegisterMethod('Procedure AddColumnHeadersFromCSV( var CSV : PWideChar; WithBottomGrayLine : boolean; BoldFont : boolean; RowLineHeight : integer)');
    RegisterMethod('Procedure DrawTextAcrossCols( const StringArray : array of SynUnicode; BackgroundColor : TColor)');
    RegisterMethod('Procedure DrawTextAcrossColsFromCSV( var CSV : PWideChar; BackgroundColor : TColor)');
    RegisterMethod('Procedure DrawLinesInCurrencyCols( doublelines : boolean)');
    RegisterProperty('ColumnCount', 'integer', iptr);
    RegisterMethod('Function GetColumnInfo( index : integer) : TColRec');
    RegisterMethod('Procedure SetColumnAlign( index : integer; align : TColAlign)');
    RegisterMethod('Procedure SetColumnBold( index : integer)');
    RegisterMethod('Procedure ClearColumns');
    RegisterMethod('Procedure ClearColumnHeaders');
    RegisterMethod('Procedure ColumnHeadersNeeded');
    RegisterMethod('Function AddBookMark( const aBookmarkName : string; aYPosition : integer) : Boolean');
    RegisterMethod('Function GotoBookmark( const aBookmarkName : string) : Boolean');
    RegisterMethod('Procedure AddOutline( const aTitle : string; aLevel : Integer; aYPosition : integer; aPageNumber : integer)');
    RegisterMethod('Procedure AddLink( const aBookmarkName : string; aRect : TRect; aPageNumber : integer)');
    RegisterMethod('Function MmToPrinter( const R : TRect) : TRect');
    RegisterMethod('Function PrinterToMM( const R : TRect) : TRect');
    RegisterMethod('Function MmToPrinterPxX( mm : integer) : integer');
    RegisterMethod('Function MmToPrinterPxY( mm : integer) : integer');
    RegisterMethod('Function PrinterPxToMmX( px : integer) : integer');
    RegisterMethod('Function PrinterPxToMmY( px : integer) : integer');
    RegisterMethod('Function TextWidth( const Text : SynUnicode) : integer');
    RegisterProperty('TextAlign', 'TTextAlign', iptrw);
    RegisterProperty('BiDiMode', 'TBiDiMode', iptrw);
    RegisterMethod('Function CreatePictureMetaFile( Width, Height : integer; out MetaCanvas : TCanvas) : TMetaFile');
    RegisterMethod('Function CurrentGroupPosStart : integer');
    RegisterMethod('Procedure GotoPosition( aPage : integer; aYPos : integer)');
    RegisterProperty('Pages', 'TGDIPageContentDynArray', iptr);
    RegisterMethod('Function NewPopupMenuItem( const aCaption : string; Tag : integer; SubMenu : TMenuItem; OnClick : TNotifyEvent; ImageIndex : integer) : TMenuItem');
    RegisterMethod('Procedure PopupMenuItemClick( Sender : TObject)');
    RegisterProperty('Canvas', 'TMetaFileCanvas', iptr);
    RegisterProperty('CurrentYPos', 'integer', iptrw);
    RegisterProperty('LineHeight', 'integer', iptr);
    RegisterProperty('PrinterName', 'string', iptr);
    RegisterProperty('Page', 'integer', iptrw);
    RegisterProperty('PageCount', 'integer', iptr);
    RegisterProperty('PageMargins', 'TRect', iptrw);
    RegisterProperty('LeftMargin', 'integer', iptrw);
    RegisterProperty('RightMarginPos', 'integer', iptr);
    RegisterProperty('PaperSize', 'TSize', iptr);
    RegisterProperty('PrinterPxPerInch', 'TPoint', iptr);
    RegisterProperty('HasPDFPrinterInstalled', 'boolean', iptr);
    RegisterProperty('ExportPDFForceJPEGCompression', 'integer', iptrw);
    RegisterProperty('ExportPDFApplication', 'string', iptrw);
    RegisterProperty('ExportPDFAuthor', 'string', iptrw);
    RegisterProperty('ExportPDFSubject', 'string', iptrw);
    RegisterProperty('ExportPDFKeywords', 'string', iptrw);
    RegisterProperty('ExportPDFEmbeddedTTF', 'boolean', iptrw);
    RegisterProperty('ExportPDFA1', 'Boolean', iptrw);
    RegisterProperty('ExportPDFBackground', 'TGraphic', iptrw);
    RegisterProperty('ExportPDFUseUniscribe', 'boolean', iptrw);
    RegisterProperty('ExportPDFUseFontFallBack', 'boolean', iptrw);
    RegisterProperty('ExportPDFFontFallBackName', 'string', iptrw);
    RegisterProperty('VirtualPageNum', 'integer', iptrw);
    RegisterProperty('HeaderDone', 'boolean', iptr);
    RegisterProperty('NegsToParenthesesInCurrCols', 'boolean', iptrw);
    RegisterProperty('WordWrapLeftCols', 'boolean', iptrw);
    RegisterProperty('UseOutlines', 'boolean', iptrw);
    RegisterProperty('HangIndent', 'integer', iptrw);
    RegisterProperty('LineSpacing', 'TLineSpacing', iptrw);
    RegisterProperty('Orientation', 'TPrinterOrientation', iptrw);
    RegisterProperty('Zoom', 'integer', iptrw);
    RegisterProperty('ZoomStatus', 'TZoomStatus', iptrw);
    RegisterProperty('ForceScreenResolution', 'boolean', iptrw);
    RegisterProperty('OnNewPage', 'TNewPageEvent', iptrw);
    RegisterProperty('OnStartPageHeader', 'TNotifyEvent', iptrw);
    RegisterProperty('OnEndPageHeader', 'TNotifyEvent', iptrw);
    RegisterProperty('OnStartPageFooter', 'TNotifyEvent', iptrw);
    RegisterProperty('OnEndPageFooter', 'TNotifyEvent', iptrw);
    RegisterProperty('OnStartColumnHeader', 'TNotifyEvent', iptrw);
    RegisterProperty('OnEndColumnHeader', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDocumentProduced', 'TNotifyEvent', iptrw);
    RegisterProperty('OnPreviewPageChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('OnZoomChanged', 'TZoomChangedEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGDIPageContent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TGDIPageContent') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TGDIPageContent') do
  begin
    RegisterProperty('MetaFileCompressed', 'RawByteString', iptrw);
    RegisterProperty('Text', 'string', iptrw);
    RegisterProperty('SizePx', 'TPoint', iptrw);
    RegisterProperty('MarginPx', 'TRect', iptrw);
    RegisterProperty('OffsetPx', 'TPoint', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGDIPagereference(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TGDIPagereference') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TGDIPagereference') do
  begin
    RegisterProperty('Page', 'Integer', iptrw);
    RegisterProperty('Rect', 'TRect', iptrw);
    RegisterProperty('Preview', 'TRect', iptrw);
    RegisterMethod('Constructor Create( PageNumber : integer; Left, Top, Right, Bottom : integer)');
    RegisterMethod('Procedure ToPreview( Pages : TGDIPages)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPagePaintBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPaintBox', 'TPagePaintBox') do
  with CL.AddClassN(CL.FindClass('TPaintBox'),'TPagePaintBox') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THeaderFooter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THeaderFooter') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THeaderFooter') do begin
    RegisterProperty('Text', 'SynUnicode', iptrw);
    RegisterProperty('State', 'TSavedState', iptrw);
    RegisterMethod('Constructor Create( Report : TGDIPages; doubleline : boolean; const aText : SynUnicode; IsText : boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_mORMotReport(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MAXCOLS','LongInt').SetInt( 20);
 CL.AddConstantN('MAXTABS','LongInt').SetInt( 20);
 CL.AddConstantN('PAGENUMBER','String').SetString( '<<pagenumber>>');
  CL.AddTypeS('TTextAlign', '( taLeft, taRight, taCenter, taJustified )');
  CL.AddTypeS('TColAlign', '( caLeft, caRight, caCenter, caCurrency )');
  CL.AddTypeS('TLineSpacing', '( lsSingle, lsOneAndHalf, lsDouble )');
  CL.AddTypeS('TZoomStatus', '( zsPercent, zsPageFit, zsPageWidth )');
  CL.AddTypeS('TNewPageEvent', 'Procedure ( Sender : TObject; PageNumber : integer)');
  CL.AddTypeS('TZoomChangedEvent', 'Procedure ( Sender : TObject; Zoom : intege'
   +'r; ZoomStatus : TZoomStatus)');
  //CL.AddTypeS('TOnStringToUnicodeEvent', 'Function(const Text : SynUnicode):SynUnicode');
  CL.AddTypeS('TGdiPagePaperSize', '( psA4, psA5, psA3, psLetter, psLegal )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TGDIPages');
  CL.AddTypeS('TSavedState', 'record FontName : string; FontColor : integer; Fl'
   +'ags : integer; LeftMargin : integer; RightMargin : integer; BiDiMode : TBi'
   +'DiMode; end');
  SIRegister_THeaderFooter(CL);
  CL.AddTypeS('TColRec', 'record ColAlign : TColAlign; ColBold : boolean; end');
  //CL.AddTypeS('TPopupMenuClass', 'class of TPopupMenu');
  SIRegister_TPagePaintBox(CL);
  SIRegister_TGDIPagereference(CL);
  SIRegister_TGDIPageContent(CL);
  CL.AddTypeS('TGDIPageContentDynArray', 'array of TGDIPageContent');
  SIRegister_TGDIPages(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TRenderPages');
  CL.AddTypeS('TSavedStateRender', 'record FirstLineIndent : Integer; Before : '
   +'Integer; After : Integer; RightIndent : Integer; LeftIndent : Integer; end');
  //CL.AddTypeS('PRenderBoxWord', '^TRenderBoxWord // will not work');
  CL.AddTypeS('TRenderBoxWord', 'record TextOffset : integer; TextLength : inte'
   +'ger; Size : TSize; FontIndex : integer; FontSpaceWidth : integer; SpaceAft'
   +'erCount : integer; LinkNumber : integer; end');
  //CL.AddTypeS('PRenderBoxLayout', '^TRenderBoxLayout // will not work');
  //CL.AddTypeS('TRenderBoxLayout', 'record Text : PWideChar; Length : integer; L'
  // +'eft : integer; Top : integer; Width : integer; Height : integer; LineIndex'
  // +' : integer; LastBox : TRenderBoxWord; BreakExtra : integer; BreakCount : integer; end');
  SIRegister_TRenderBox(CL);
  SIRegister_TRenderPages(CL);
  CL.AddTypeS('TReportPopupMenu', '( rNone, rNextPage, rPreviousPage, rGotoPage'
   +', rZoom, rBookmarks, rPageAsText, rPrint, rExportPDF, rClose )');
 CL.AddConstantN('GRAY_MARGIN','LongInt').SetInt( 10);
 CL.AddConstantN('PAGE_WIDTH','LongInt').SetInt( - 1);
 CL.AddConstantN('PAGE_FIT','LongInt').SetInt( - 2);
 CL.AddConstantN('FORMAT_DEFAULT','LongWord').SetUInt( $0);
 CL.AddConstantN('FORMAT_SIZE_MASK','LongWord').SetUInt( $FF);
 CL.AddConstantN('FORMAT_ALIGN_MASK','LongWord').SetUInt( $300);
 CL.AddConstantN('FORMAT_LEFT','LongWord').SetUInt( $0);
 CL.AddConstantN('FORMAT_RIGHT','LongWord').SetUInt( $100);
 CL.AddConstantN('FORMAT_CENTER','LongWord').SetUInt( $200);
 CL.AddConstantN('FORMAT_JUSTIFIED','LongWord').SetUInt( $300);
 CL.AddConstantN('FORMAT_BOLD','LongWord').SetUInt( $400);
 CL.AddConstantN('FORMAT_UNDERLINE','LongWord').SetUInt( $800);
 CL.AddConstantN('FORMAT_ITALIC','LongWord').SetUInt( $1000);
 CL.AddConstantN('FORMAT_UNDEFINED','LongWord').SetUInt( $2000);
 CL.AddConstantN('FORMAT_SINGLELINE','LongWord').SetUInt( $8000);
 CL.AddConstantN('FORMAT_DOUBLELINE','LongWord').SetUInt( $4000);
 CL.AddConstantN('FORMAT_LINES','LongWord').SetUInt( $C000);
 CL.AddConstantN('FORMAT_XPOS_MASK','LongWord').SetUInt( $FFFF0000);
 CL.AddConstantN('PAPERSIZE_A4_WIDTH','LongInt').SetInt( 210);
 CL.AddConstantN('PAPERSIZE_A4_HEIGHT','LongInt').SetInt( 297);
 CL.AddDelphiFunction('Procedure SetCurrentPrinterAsDefault');
 CL.AddDelphiFunction('Function CurrentPrinterName : string');
 CL.AddDelphiFunction('Function mCurrentPrinterPaperSize : string');
 CL.AddDelphiFunction('Procedure UseDefaultPrinter');
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TRenderPagesParagraphRightIndent_W(Self: TRenderPages; const T: Integer);
begin Self.ParagraphRightIndent := T; end;

(*----------------------------------------------------------------------------*)
procedure TRenderPagesParagraphRightIndent_R(Self: TRenderPages; var T: Integer);
begin T := Self.ParagraphRightIndent; end;

(*----------------------------------------------------------------------------*)
procedure TRenderPagesParagraphLeftIndent_W(Self: TRenderPages; const T: Integer);
begin Self.ParagraphLeftIndent := T; end;

(*----------------------------------------------------------------------------*)
procedure TRenderPagesParagraphLeftIndent_R(Self: TRenderPages; var T: Integer);
begin T := Self.ParagraphLeftIndent; end;

(*----------------------------------------------------------------------------*)
procedure TRenderPagesParagraphFirstLineIndent_W(Self: TRenderPages; const T: Integer);
begin Self.ParagraphFirstLineIndent := T; end;

(*----------------------------------------------------------------------------*)
procedure TRenderPagesParagraphFirstLineIndent_R(Self: TRenderPages; var T: Integer);
begin T := Self.ParagraphFirstLineIndent; end;

(*----------------------------------------------------------------------------*)
procedure TRenderPagesParagraphAfter_W(Self: TRenderPages; const T: Integer);
begin Self.ParagraphAfter := T; end;

(*----------------------------------------------------------------------------*)
procedure TRenderPagesParagraphAfter_R(Self: TRenderPages; var T: Integer);
begin T := Self.ParagraphAfter; end;

(*----------------------------------------------------------------------------*)
procedure TRenderPagesParagraphBefore_W(Self: TRenderPages; const T: Integer);
begin Self.ParagraphBefore := T; end;

(*----------------------------------------------------------------------------*)
procedure TRenderPagesParagraphBefore_R(Self: TRenderPages; var T: Integer);
begin T := Self.ParagraphBefore; end;

(*----------------------------------------------------------------------------*)
procedure TRenderPagesRdr_R(Self: TRenderPages; var T: TRenderBox);
begin T := Self.Rdr; end;

(*----------------------------------------------------------------------------*)
procedure TRenderBoxHeight_R(Self: TRenderBox; var T: integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TRenderBoxWidth_W(Self: TRenderBox; const T: integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TRenderBoxWidth_R(Self: TRenderBox; var T: integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TRenderBoxBiDiMode_W(Self: TRenderBox; const T: TBiDiMode);
begin Self.BiDiMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TRenderBoxBiDiMode_R(Self: TRenderBox; var T: TBiDiMode);
begin T := Self.BiDiMode; end;

(*----------------------------------------------------------------------------*)
procedure TRenderBoxFont_R(Self: TRenderBox; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TRenderBoxOwner_R(Self: TRenderBox; var T: TRenderPages);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
Procedure TRenderBoxAddText1_P(Self: TRenderBox;  PW : PWideChar; PWLen : integer);
Begin Self.AddText(PW, PWLen); END;

(*----------------------------------------------------------------------------*)
Procedure TRenderBoxAddText_P(Self: TRenderBox;  const s : string);
Begin Self.AddText(s); END;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnZoomChanged_W(Self: TGDIPages; const T: TZoomChangedEvent);
begin Self.OnZoomChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnZoomChanged_R(Self: TGDIPages; var T: TZoomChangedEvent);
begin T := Self.OnZoomChanged; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnPreviewPageChanged_W(Self: TGDIPages; const T: TNotifyEvent);
begin Self.OnPreviewPageChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnPreviewPageChanged_R(Self: TGDIPages; var T: TNotifyEvent);
begin T := Self.OnPreviewPageChanged; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnDocumentProduced_W(Self: TGDIPages; const T: TNotifyEvent);
begin Self.OnDocumentProduced := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnDocumentProduced_R(Self: TGDIPages; var T: TNotifyEvent);
begin T := Self.OnDocumentProduced; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnEndColumnHeader_W(Self: TGDIPages; const T: TNotifyEvent);
begin Self.OnEndColumnHeader := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnEndColumnHeader_R(Self: TGDIPages; var T: TNotifyEvent);
begin T := Self.OnEndColumnHeader; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnStartColumnHeader_W(Self: TGDIPages; const T: TNotifyEvent);
begin Self.OnStartColumnHeader := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnStartColumnHeader_R(Self: TGDIPages; var T: TNotifyEvent);
begin T := Self.OnStartColumnHeader; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnEndPageFooter_W(Self: TGDIPages; const T: TNotifyEvent);
begin Self.OnEndPageFooter := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnEndPageFooter_R(Self: TGDIPages; var T: TNotifyEvent);
begin T := Self.OnEndPageFooter; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnStartPageFooter_W(Self: TGDIPages; const T: TNotifyEvent);
begin Self.OnStartPageFooter := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnStartPageFooter_R(Self: TGDIPages; var T: TNotifyEvent);
begin T := Self.OnStartPageFooter; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnEndPageHeader_W(Self: TGDIPages; const T: TNotifyEvent);
begin Self.OnEndPageHeader := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnEndPageHeader_R(Self: TGDIPages; var T: TNotifyEvent);
begin T := Self.OnEndPageHeader; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnStartPageHeader_W(Self: TGDIPages; const T: TNotifyEvent);
begin Self.OnStartPageHeader := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnStartPageHeader_R(Self: TGDIPages; var T: TNotifyEvent);
begin T := Self.OnStartPageHeader; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnNewPage_W(Self: TGDIPages; const T: TNewPageEvent);
begin Self.OnNewPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnNewPage_R(Self: TGDIPages; var T: TNewPageEvent);
begin T := Self.OnNewPage; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesForceScreenResolution_W(Self: TGDIPages; const T: boolean);
begin Self.ForceScreenResolution := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesForceScreenResolution_R(Self: TGDIPages; var T: boolean);
begin T := Self.ForceScreenResolution; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesZoomStatus_W(Self: TGDIPages; const T: TZoomStatus);
begin Self.ZoomStatus := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesZoomStatus_R(Self: TGDIPages; var T: TZoomStatus);
begin T := Self.ZoomStatus; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesZoom_W(Self: TGDIPages; const T: integer);
begin Self.Zoom := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesZoom_R(Self: TGDIPages; var T: integer);
begin T := Self.Zoom; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOrientation_W(Self: TGDIPages; const T: TPrinterOrientation);
begin Self.Orientation := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOrientation_R(Self: TGDIPages; var T: TPrinterOrientation);
begin T := Self.Orientation; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesLineSpacing_W(Self: TGDIPages; const T: TLineSpacing);
begin Self.LineSpacing := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesLineSpacing_R(Self: TGDIPages; var T: TLineSpacing);
begin T := Self.LineSpacing; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesHangIndent_W(Self: TGDIPages; const T: integer);
begin Self.HangIndent := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesHangIndent_R(Self: TGDIPages; var T: integer);
begin T := Self.HangIndent; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesUseOutlines_W(Self: TGDIPages; const T: boolean);
begin Self.UseOutlines := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesUseOutlines_R(Self: TGDIPages; var T: boolean);
begin T := Self.UseOutlines; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesWordWrapLeftCols_W(Self: TGDIPages; const T: boolean);
begin Self.WordWrapLeftCols := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesWordWrapLeftCols_R(Self: TGDIPages; var T: boolean);
begin T := Self.WordWrapLeftCols; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesNegsToParenthesesInCurrCols_W(Self: TGDIPages; const T: boolean);
begin Self.NegsToParenthesesInCurrCols := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesNegsToParenthesesInCurrCols_R(Self: TGDIPages; var T: boolean);
begin T := Self.NegsToParenthesesInCurrCols; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesHeaderDone_R(Self: TGDIPages; var T: boolean);
begin T := Self.HeaderDone; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesVirtualPageNum_W(Self: TGDIPages; const T: integer);
begin Self.VirtualPageNum := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesVirtualPageNum_R(Self: TGDIPages; var T: integer);
begin T := Self.VirtualPageNum; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFFontFallBackName_W(Self: TGDIPages; const T: string);
begin Self.ExportPDFFontFallBackName := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFFontFallBackName_R(Self: TGDIPages; var T: string);
begin T := Self.ExportPDFFontFallBackName; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFUseFontFallBack_W(Self: TGDIPages; const T: boolean);
begin Self.ExportPDFUseFontFallBack := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFUseFontFallBack_R(Self: TGDIPages; var T: boolean);
begin T := Self.ExportPDFUseFontFallBack; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFUseUniscribe_W(Self: TGDIPages; const T: boolean);
begin Self.ExportPDFUseUniscribe := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFUseUniscribe_R(Self: TGDIPages; var T: boolean);
begin T := Self.ExportPDFUseUniscribe; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFBackground_W(Self: TGDIPages; const T: TGraphic);
begin Self.ExportPDFBackground := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFBackground_R(Self: TGDIPages; var T: TGraphic);
begin T := Self.ExportPDFBackground; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFA1_W(Self: TGDIPages; const T: Boolean);
begin Self.ExportPDFA1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFA1_R(Self: TGDIPages; var T: Boolean);
begin T := Self.ExportPDFA1; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFEmbeddedTTF_W(Self: TGDIPages; const T: boolean);
begin Self.ExportPDFEmbeddedTTF := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFEmbeddedTTF_R(Self: TGDIPages; var T: boolean);
begin T := Self.ExportPDFEmbeddedTTF; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFKeywords_W(Self: TGDIPages; const T: string);
begin Self.ExportPDFKeywords := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFKeywords_R(Self: TGDIPages; var T: string);
begin T := Self.ExportPDFKeywords; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFSubject_W(Self: TGDIPages; const T: string);
begin Self.ExportPDFSubject := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFSubject_R(Self: TGDIPages; var T: string);
begin T := Self.ExportPDFSubject; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFAuthor_W(Self: TGDIPages; const T: string);
begin Self.ExportPDFAuthor := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFAuthor_R(Self: TGDIPages; var T: string);
begin T := Self.ExportPDFAuthor; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFApplication_W(Self: TGDIPages; const T: string);
begin Self.ExportPDFApplication := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFApplication_R(Self: TGDIPages; var T: string);
begin T := Self.ExportPDFApplication; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFForceJPEGCompression_W(Self: TGDIPages; const T: integer);
begin Self.ExportPDFForceJPEGCompression := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesExportPDFForceJPEGCompression_R(Self: TGDIPages; var T: integer);
begin T := Self.ExportPDFForceJPEGCompression; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesHasPDFPrinterInstalled_R(Self: TGDIPages; var T: boolean);
begin //T := Self.HasPDFPrinterInstalled;
 end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesPrinterPxPerInch_R(Self: TGDIPages; var T: TPoint);
begin T := Self.PrinterPxPerInch; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesPaperSize_R(Self: TGDIPages; var T: TSize);
begin T := Self.PaperSize; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesRightMarginPos_R(Self: TGDIPages; var T: integer);
begin T := Self.RightMarginPos; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesLeftMargin_W(Self: TGDIPages; const T: integer);
begin Self.LeftMargin := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesLeftMargin_R(Self: TGDIPages; var T: integer);
begin T := Self.LeftMargin; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesPageMargins_W(Self: TGDIPages; const T: TRect);
begin Self.PageMargins := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesPageMargins_R(Self: TGDIPages; var T: TRect);
begin T := Self.PageMargins; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesPageCount_R(Self: TGDIPages; var T: integer);
begin T := Self.PageCount; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesPage_W(Self: TGDIPages; const T: integer);
begin Self.Page := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesPage_R(Self: TGDIPages; var T: integer);
begin T := Self.Page; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesPrinterName_R(Self: TGDIPages; var T: string);
begin T := Self.PrinterName; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesLineHeight_R(Self: TGDIPages; var T: integer);
begin T := Self.LineHeight; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesCurrentYPos_W(Self: TGDIPages; const T: integer);
begin Self.CurrentYPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesCurrentYPos_R(Self: TGDIPages; var T: integer);
begin T := Self.CurrentYPos; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesCanvas_R(Self: TGDIPages; var T: TMetaFileCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesPages_R(Self: TGDIPages; var T: TGDIPageContentDynArray);
begin T := Self.Pages; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesBiDiMode_W(Self: TGDIPages; const T: TBiDiMode);
begin Self.BiDiMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesBiDiMode_R(Self: TGDIPages; var T: TBiDiMode);
begin T := Self.BiDiMode; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesTextAlign_W(Self: TGDIPages; const T: TTextAlign);
begin Self.TextAlign := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesTextAlign_R(Self: TGDIPages; var T: TTextAlign);
begin T := Self.TextAlign; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesColumnCount_R(Self: TGDIPages; var T: integer);
begin T := Self.ColumnCount; end;

(*----------------------------------------------------------------------------*)
Procedure TGDIPagesNewPageLayout1_P(Self: TGDIPages;  paperSize : TGdiPagePaperSize; orientation : TPrinterOrientation; nonPrintableWidthMM : integer; nonPrintableHeightMM : integer);
Begin Self.NewPageLayout(paperSize, orientation, nonPrintableWidthMM, nonPrintableHeightMM); END;

(*----------------------------------------------------------------------------*)
Procedure TGDIPagesNewPageLayout_P(Self: TGDIPages;  sizeWidthMM, sizeHeightMM : integer; nonPrintableWidthMM : integer; nonPrintableHeightMM : integer);
Begin Self.NewPageLayout(sizeWidthMM, sizeHeightMM, nonPrintableWidthMM, nonPrintableHeightMM); END;

(*----------------------------------------------------------------------------*)
Procedure TGDIPagesDrawBMP1_P(Self: TGDIPages;  bmp : TBitmap; bLeft, bWidth : integer; const Legend : string);
Begin Self.DrawBMP(bmp, bLeft, bWidth, Legend); END;

(*----------------------------------------------------------------------------*)
Procedure TGDIPagesDrawBMP_P(Self: TGDIPages;  rec : TRect; bmp : TBitmap);
Begin Self.DrawBMP(rec, bmp); END;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesPreviewSurfaceBitmap_W(Self: TGDIPages; const T: TBitmap);
Begin Self.PreviewSurfaceBitmap := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesPreviewSurfaceBitmap_R(Self: TGDIPages; var T: TBitmap);
Begin T := Self.PreviewSurfaceBitmap; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesGroupsMustBeOnSamePage_W(Self: TGDIPages; const T: boolean);
Begin Self.GroupsMustBeOnSamePage := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesGroupsMustBeOnSamePage_R(Self: TGDIPages; var T: boolean);
Begin T := Self.GroupsMustBeOnSamePage; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnStringToUnicode_W(Self: TGDIPages; const T: TOnStringToUnicodeEvent);
Begin Self.OnStringToUnicode := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnStringToUnicode_R(Self: TGDIPages; var T: TOnStringToUnicodeEvent);
Begin T := Self.OnStringToUnicode; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesForceCopyTextAsWholeContent_W(Self: TGDIPages; const T: boolean);
Begin Self.ForceCopyTextAsWholeContent := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesForceCopyTextAsWholeContent_R(Self: TGDIPages; var T: boolean);
Begin T := Self.ForceCopyTextAsWholeContent; end;

{//(*----------------------------------------------------------------------------*)
procedure TGDIPagesForcePrintDuplexMode_W(Self: TGDIPages; const T: (printDuplexDefault, printSimplex, printDuplex ) );
Begin Self.ForcePrintDuplexMode := T; end;

//(*----------------------------------------------------------------------------*)
procedure TGDIPagesForcePrintDuplexMode_R(Self: TGDIPages; var T: ( printDuplexDefault, printSimplex, printDuplex ) );
Begin T := Self.ForcePrintDuplexMode; end;

//(*----------------------------------------------------------------------------*)
procedure TGDIPagesForcePrintColorMode_W(Self: TGDIPages; const T: ( printColorDefault, printBW, printColor ) );
Begin Self.ForcePrintColorMode := T; end;

//(*----------------------------------------------------------------------------*)
procedure TGDIPagesForcePrintColorMode_R(Self: TGDIPages; var T: ( printColorDefault, printBW, printColor ) );
Begin T := Self.ForcePrintColorMode; end; }

(*----------------------------------------------------------------------------*)
procedure TGDIPagesForceInternalAntiAliasedFontFallBack_W(Self: TGDIPages; const T: boolean);
Begin Self.ForceInternalAntiAliasedFontFallBack := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesForceInternalAntiAliasedFontFallBack_R(Self: TGDIPages; var T: boolean);
Begin T := Self.ForceInternalAntiAliasedFontFallBack; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesForceInternalAntiAliased_W(Self: TGDIPages; const T: boolean);
Begin Self.ForceInternalAntiAliased := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesForceInternalAntiAliased_R(Self: TGDIPages; var T: boolean);
Begin T := Self.ForceInternalAntiAliased; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesForceNoAntiAliased_W(Self: TGDIPages; const T: boolean);
Begin Self.ForceNoAntiAliased := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesForceNoAntiAliased_R(Self: TGDIPages; var T: boolean);
Begin T := Self.ForceNoAntiAliased; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesForcePrintAsBitmap_W(Self: TGDIPages; const T: boolean);
Begin Self.ForcePrintAsBitmap := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesForcePrintAsBitmap_R(Self: TGDIPages; var T: boolean);
Begin T := Self.ForcePrintAsBitmap; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesCaption_W(Self: TGDIPages; const T: string);
Begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesCaption_R(Self: TGDIPages; var T: string);
Begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesPopupMenuClass_W(Self: TGDIPages; const T: TPopupMenuClass);
Begin Self.PopupMenuClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesPopupMenuClass_R(Self: TGDIPages; var T: TPopupMenuClass);
Begin T := Self.PopupMenuClass; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnPopupMenuClick_W(Self: TGDIPages; const T: TNotifyEvent);
Begin Self.OnPopupMenuClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnPopupMenuClick_R(Self: TGDIPages; var T: TNotifyEvent);
Begin T := Self.OnPopupMenuClick; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnPopupMenuPopup_W(Self: TGDIPages; const T: TNotifyEvent);
Begin Self.OnPopupMenuPopup := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagesOnPopupMenuPopup_R(Self: TGDIPages; var T: TNotifyEvent);
Begin T := Self.OnPopupMenuPopup; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPageContentOffsetPx_W(Self: TGDIPageContent; const T: TPoint);
Begin Self.OffsetPx := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPageContentOffsetPx_R(Self: TGDIPageContent; var T: TPoint);
Begin T := Self.OffsetPx; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPageContentMarginPx_W(Self: TGDIPageContent; const T: TRect);
Begin Self.MarginPx := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPageContentMarginPx_R(Self: TGDIPageContent; var T: TRect);
Begin T := Self.MarginPx; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPageContentSizePx_W(Self: TGDIPageContent; const T: TPoint);
Begin Self.SizePx := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPageContentSizePx_R(Self: TGDIPageContent; var T: TPoint);
Begin T := Self.SizePx; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPageContentText_W(Self: TGDIPageContent; const T: string);
Begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPageContentText_R(Self: TGDIPageContent; var T: string);
Begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPageContentMetaFileCompressed_W(Self: TGDIPageContent; const T: RawByteString);
Begin Self.MetaFileCompressed := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPageContentMetaFileCompressed_R(Self: TGDIPageContent; var T: RawByteString);
Begin T := Self.MetaFileCompressed; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagereferencePreview_W(Self: TGDIPagereference; const T: TRect);
Begin Self.Preview := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagereferencePreview_R(Self: TGDIPagereference; var T: TRect);
Begin T := Self.Preview; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagereferenceRect_W(Self: TGDIPagereference; const T: TRect);
Begin Self.Rect := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagereferenceRect_R(Self: TGDIPagereference; var T: TRect);
Begin T := Self.Rect; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagereferencePage_W(Self: TGDIPagereference; const T: Integer);
Begin Self.Page := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIPagereferencePage_R(Self: TGDIPagereference; var T: Integer);
Begin T := Self.Page; end;

(*----------------------------------------------------------------------------*)
procedure THeaderFooterState_W(Self: THeaderFooter; const T: TSavedState);
Begin Self.State := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderFooterState_R(Self: THeaderFooter; var T: TSavedState);
Begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure THeaderFooterText_W(Self: THeaderFooter; const T: SynUnicode);
Begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderFooterText_R(Self: THeaderFooter; var T: SynUnicode);
Begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_mORMotReport_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SetCurrentPrinterAsDefault, 'SetCurrentPrinterAsDefault', cdRegister);
 S.RegisterDelphiFunction(@CurrentPrinterName, 'CurrentPrinterName', cdRegister);
 S.RegisterDelphiFunction(@mCurrentPrinterPaperSize, 'mCurrentPrinterPaperSize', cdRegister);
 S.RegisterDelphiFunction(@UseDefaultPrinter, 'UseDefaultPrinter', cdRegister);
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRenderPages(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRenderPages) do begin
    RegisterMethod(@TRenderPages.RdrSetCurrentStateAsDefault, 'RdrSetCurrentStateAsDefault');
    RegisterMethod(@TRenderPages.RdrParagraph, 'RdrParagraph');
    RegisterMethod(@TRenderPages.RdrTableBegin, 'RdrTableBegin');
    RegisterMethod(@TRenderPages.RdrTableColumn, 'RdrTableColumn');
    RegisterMethod(@TRenderPages.RdrTableEnd, 'RdrTableEnd');
    RegisterPropertyHelper(@TRenderPagesRdr_R,nil,'Rdr');
    RegisterConstructor(@TRenderPages.Create, 'Create');
    RegisterMethod(@TRenderPages.Clear, 'Clear');
    RegisterMethod(@TRenderPages.SaveLayout, 'SaveLayout');
    RegisterMethod(@TRenderPages.RestoreSavedLayout, 'RestoreSavedLayout');
    RegisterPropertyHelper(@TRenderPagesParagraphBefore_R,@TRenderPagesParagraphBefore_W,'ParagraphBefore');
    RegisterPropertyHelper(@TRenderPagesParagraphAfter_R,@TRenderPagesParagraphAfter_W,'ParagraphAfter');
    RegisterPropertyHelper(@TRenderPagesParagraphFirstLineIndent_R,@TRenderPagesParagraphFirstLineIndent_W,'ParagraphFirstLineIndent');
    RegisterPropertyHelper(@TRenderPagesParagraphLeftIndent_R,@TRenderPagesParagraphLeftIndent_W,'ParagraphLeftIndent');
    RegisterPropertyHelper(@TRenderPagesParagraphRightIndent_R,@TRenderPagesParagraphRightIndent_W,'ParagraphRightIndent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRenderBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRenderBox) do begin
    RegisterConstructor(@TRenderBox.Create, 'Create');
    RegisterMethod(@TRenderBoxAddText_P, 'AddText');
    RegisterMethod(@TRenderBoxAddText1_P, 'AddText1');
    RegisterMethod(@TRenderBox.Flush, 'Flush');
    RegisterMethod(@TRenderBox.NewLine, 'NewLine');
    RegisterMethod(@TRenderBox.LinkBegin, 'LinkBegin');
    RegisterMethod(@TRenderBox.LinkEnd, 'LinkEnd');
    RegisterMethod(@TRenderBox.Plain, 'Plain');
    RegisterMethod(@TRenderBox.Pard, 'Pard');
    RegisterMethod(@TRenderBox.PardPlain, 'PardPlain');
    RegisterPropertyHelper(@TRenderBoxOwner_R,nil,'Owner');
    RegisterPropertyHelper(@TRenderBoxFont_R,nil,'Font');
    RegisterPropertyHelper(@TRenderBoxBiDiMode_R,@TRenderBoxBiDiMode_W,'BiDiMode');
    RegisterPropertyHelper(@TRenderBoxWidth_R,@TRenderBoxWidth_W,'Width');
    RegisterPropertyHelper(@TRenderBoxHeight_R,nil,'Height');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGDIPages(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGDIPages) do begin
    RegisterPropertyHelper(@TGDIPagesOnPopupMenuPopup_R,@TGDIPagesOnPopupMenuPopup_W,'OnPopupMenuPopup');
    RegisterPropertyHelper(@TGDIPagesOnPopupMenuClick_R,@TGDIPagesOnPopupMenuClick_W,'OnPopupMenuClick');
    RegisterPropertyHelper(@TGDIPagesPopupMenuClass_R,@TGDIPagesPopupMenuClass_W,'PopupMenuClass');
    RegisterPropertyHelper(@TGDIPagesCaption_R,@TGDIPagesCaption_W,'Caption');
    RegisterPropertyHelper(@TGDIPagesForcePrintAsBitmap_R,@TGDIPagesForcePrintAsBitmap_W,'ForcePrintAsBitmap');
    RegisterPropertyHelper(@TGDIPagesForceNoAntiAliased_R,@TGDIPagesForceNoAntiAliased_W,'ForceNoAntiAliased');
    RegisterPropertyHelper(@TGDIPagesForceInternalAntiAliased_R,@TGDIPagesForceInternalAntiAliased_W,'ForceInternalAntiAliased');
    RegisterPropertyHelper(@TGDIPagesForceInternalAntiAliasedFontFallBack_R,@TGDIPagesForceInternalAntiAliasedFontFallBack_W,'ForceInternalAntiAliasedFontFallBack');
    //RegisterPropertyHelper(@TGDIPagesForcePrintColorMode_R,@TGDIPagesForcePrintColorMode_W,'ForcePrintColorMode');
    //RegisterPropertyHelper(@TGDIPagesForcePrintDuplexMode_R,@TGDIPagesForcePrintDuplexMode_W,'ForcePrintDuplexMode');
    RegisterPropertyHelper(@TGDIPagesForceCopyTextAsWholeContent_R,@TGDIPagesForceCopyTextAsWholeContent_W,'ForceCopyTextAsWholeContent');
    RegisterPropertyHelper(@TGDIPagesOnStringToUnicode_R,@TGDIPagesOnStringToUnicode_W,'OnStringToUnicode');
    RegisterPropertyHelper(@TGDIPagesGroupsMustBeOnSamePage_R,@TGDIPagesGroupsMustBeOnSamePage_W,'GroupsMustBeOnSamePage');
    RegisterPropertyHelper(@TGDIPagesPreviewSurfaceBitmap_R,@TGDIPagesPreviewSurfaceBitmap_W,'PreviewSurfaceBitmap');
    RegisterConstructor(@TGDIPages.Create, 'Create');
    RegisterMethod(@TGDIPages.Invalidate, 'Invalidate');
    RegisterMethod(@TGDIPages.BeginDoc, 'BeginDoc');
    RegisterVirtualMethod(@TGDIPages.Clear, 'Clear');
    RegisterMethod(@TGDIPages.DrawText, 'DrawText');
    RegisterMethod(@TGDIPages.DrawTextU, 'DrawTextU');
    RegisterMethod(@TGDIPages.DrawTextW, 'DrawTextW');
    RegisterMethod(@TGDIPages.DrawTextFmt, 'DrawTextFmt');
    RegisterMethod(@TGDIPages.TitleFlags, 'TitleFlags');
    RegisterMethod(@TGDIPages.DrawTitle, 'DrawTitle');
    RegisterMethod(@TGDIPages.DrawTextAt, 'DrawTextAt');
    RegisterMethod(@TGDIPages.DrawAngledTextAt, 'DrawAngledTextAt');
    RegisterMethod(@TGDIPages.DrawBox, 'DrawBox');
    RegisterMethod(@TGDIPages.DrawBoxFilled, 'DrawBoxFilled');
    RegisterMethod(@TGDIPagesDrawBMP_P, 'DrawBMP');
    RegisterMethod(@TGDIPagesDrawBMP1_P, 'DrawBMP1');
    RegisterMethod(@TGDIPages.DrawMeta, 'DrawMeta');
    RegisterMethod(@TGDIPages.DrawGraphic, 'DrawGraphic');
    RegisterMethod(@TGDIPages.DrawArrow, 'DrawArrow');
    RegisterMethod(@TGDIPages.DrawLine, 'DrawLine');
    RegisterMethod(@TGDIPages.DrawDashedLine, 'DrawDashedLine');
    RegisterMethod(@TGDIPages.AppendRichEdit, 'AppendRichEdit');
    RegisterMethod(@TGDIPages.NewLine, 'NewLine');
    RegisterMethod(@TGDIPages.NewHalfLine, 'NewHalfLine');
    RegisterMethod(@TGDIPages.NewLines, 'NewLines');
    RegisterVirtualMethod(@TGDIPages.SaveLayout, 'SaveLayout');
    RegisterVirtualMethod(@TGDIPages.RestoreSavedLayout, 'RestoreSavedLayout');
    RegisterMethod(@TGDIPages.NewPage, 'NewPage');
    RegisterMethod(@TGDIPages.NewPageIfAnyContent, 'NewPageIfAnyContent');
    RegisterMethod(@TGDIPagesNewPageLayout_P, 'NewPageLayout');
    RegisterMethod(@TGDIPagesNewPageLayout1_P, 'NewPageLayout1');
    RegisterMethod(@TGDIPages.BeginGroup, 'BeginGroup');
    RegisterMethod(@TGDIPages.EndGroup, 'EndGroup');
    RegisterMethod(@TGDIPages.EndDoc, 'EndDoc');
    RegisterMethod(@TGDIPages.PrintPages, 'PrintPages');
    RegisterMethod(@TGDIPages.ExportPDF, 'ExportPDF');
    RegisterMethod(@TGDIPages.ExportPDFStream, 'ExportPDFStream');
    RegisterMethod(@TGDIPages.ShowPreviewForm, 'ShowPreviewForm');
    RegisterMethod(@TGDIPages.SetTabStops, 'SetTabStops');
    RegisterMethod(@TGDIPages.HasSpaceForLines, 'HasSpaceForLines');
    RegisterMethod(@TGDIPages.HasSpaceFor, 'HasSpaceFor');
    RegisterMethod(@TGDIPages.ClearHeaders, 'ClearHeaders');
    RegisterMethod(@TGDIPages.AddLineToHeader, 'AddLineToHeader');
    RegisterMethod(@TGDIPages.AddTextToHeader, 'AddTextToHeader');
    RegisterMethod(@TGDIPages.AddTextToHeaderAt, 'AddTextToHeaderAt');
    RegisterMethod(@TGDIPages.ClearFooters, 'ClearFooters');
    RegisterMethod(@TGDIPages.AddLineToFooter, 'AddLineToFooter');
    RegisterMethod(@TGDIPages.AddTextToFooter, 'AddTextToFooter');
    RegisterMethod(@TGDIPages.AddTextToFooterAt, 'AddTextToFooterAt');
    RegisterMethod(@TGDIPages.AddPagesToFooterAt, 'AddPagesToFooterAt');
    RegisterMethod(@TGDIPages.AddColumn, 'AddColumn');
    RegisterMethod(@TGDIPages.AddColumns, 'AddColumns');
    RegisterMethod(@TGDIPages.AddColumnHeaders, 'AddColumnHeaders');
    RegisterMethod(@TGDIPages.AddColumnHeadersFromCSV, 'AddColumnHeadersFromCSV');
    RegisterMethod(@TGDIPages.DrawTextAcrossCols, 'DrawTextAcrossCols');
    RegisterMethod(@TGDIPages.DrawTextAcrossColsFromCSV, 'DrawTextAcrossColsFromCSV');
    RegisterMethod(@TGDIPages.DrawLinesInCurrencyCols, 'DrawLinesInCurrencyCols');
    RegisterPropertyHelper(@TGDIPagesColumnCount_R,nil,'ColumnCount');
    RegisterMethod(@TGDIPages.GetColumnInfo, 'GetColumnInfo');
    RegisterMethod(@TGDIPages.SetColumnAlign, 'SetColumnAlign');
    RegisterMethod(@TGDIPages.SetColumnBold, 'SetColumnBold');
    RegisterMethod(@TGDIPages.ClearColumns, 'ClearColumns');
    RegisterMethod(@TGDIPages.ClearColumnHeaders, 'ClearColumnHeaders');
    RegisterMethod(@TGDIPages.ColumnHeadersNeeded, 'ColumnHeadersNeeded');
    RegisterVirtualMethod(@TGDIPages.AddBookMark, 'AddBookMark');
    RegisterVirtualMethod(@TGDIPages.GotoBookmark, 'GotoBookmark');
    RegisterVirtualMethod(@TGDIPages.AddOutline, 'AddOutline');
    RegisterVirtualMethod(@TGDIPages.AddLink, 'AddLink');
    RegisterMethod(@TGDIPages.MmToPrinter, 'MmToPrinter');
    RegisterMethod(@TGDIPages.PrinterToMM, 'PrinterToMM');
    RegisterMethod(@TGDIPages.MmToPrinterPxX, 'MmToPrinterPxX');
    RegisterMethod(@TGDIPages.MmToPrinterPxY, 'MmToPrinterPxY');
    RegisterMethod(@TGDIPages.PrinterPxToMmX, 'PrinterPxToMmX');
    RegisterMethod(@TGDIPages.PrinterPxToMmY, 'PrinterPxToMmY');
    RegisterMethod(@TGDIPages.TextWidth, 'TextWidth');
    RegisterPropertyHelper(@TGDIPagesTextAlign_R,@TGDIPagesTextAlign_W,'TextAlign');
    RegisterPropertyHelper(@TGDIPagesBiDiMode_R,@TGDIPagesBiDiMode_W,'BiDiMode');
    RegisterMethod(@TGDIPages.CreatePictureMetaFile, 'CreatePictureMetaFile');
    RegisterMethod(@TGDIPages.CurrentGroupPosStart, 'CurrentGroupPosStart');
    RegisterMethod(@TGDIPages.GotoPosition, 'GotoPosition');
    RegisterPropertyHelper(@TGDIPagesPages_R,nil,'Pages');
    RegisterMethod(@TGDIPages.NewPopupMenuItem, 'NewPopupMenuItem');
    RegisterMethod(@TGDIPages.PopupMenuItemClick, 'PopupMenuItemClick');
    RegisterPropertyHelper(@TGDIPagesCanvas_R,nil,'Canvas');
    RegisterPropertyHelper(@TGDIPagesCurrentYPos_R,@TGDIPagesCurrentYPos_W,'CurrentYPos');
    RegisterPropertyHelper(@TGDIPagesLineHeight_R,nil,'LineHeight');
    RegisterPropertyHelper(@TGDIPagesPrinterName_R,nil,'PrinterName');
    RegisterPropertyHelper(@TGDIPagesPage_R,@TGDIPagesPage_W,'Page');
    RegisterPropertyHelper(@TGDIPagesPageCount_R,nil,'PageCount');
    RegisterPropertyHelper(@TGDIPagesPageMargins_R,@TGDIPagesPageMargins_W,'PageMargins');
    RegisterPropertyHelper(@TGDIPagesLeftMargin_R,@TGDIPagesLeftMargin_W,'LeftMargin');
    RegisterPropertyHelper(@TGDIPagesRightMarginPos_R,nil,'RightMarginPos');
    RegisterPropertyHelper(@TGDIPagesPaperSize_R,nil,'PaperSize');
    RegisterPropertyHelper(@TGDIPagesPrinterPxPerInch_R,nil,'PrinterPxPerInch');
    RegisterPropertyHelper(@TGDIPagesHasPDFPrinterInstalled_R,nil,'HasPDFPrinterInstalled');
    RegisterPropertyHelper(@TGDIPagesExportPDFForceJPEGCompression_R,@TGDIPagesExportPDFForceJPEGCompression_W,'ExportPDFForceJPEGCompression');
    RegisterPropertyHelper(@TGDIPagesExportPDFApplication_R,@TGDIPagesExportPDFApplication_W,'ExportPDFApplication');
    RegisterPropertyHelper(@TGDIPagesExportPDFAuthor_R,@TGDIPagesExportPDFAuthor_W,'ExportPDFAuthor');
    RegisterPropertyHelper(@TGDIPagesExportPDFSubject_R,@TGDIPagesExportPDFSubject_W,'ExportPDFSubject');
    RegisterPropertyHelper(@TGDIPagesExportPDFKeywords_R,@TGDIPagesExportPDFKeywords_W,'ExportPDFKeywords');
    RegisterPropertyHelper(@TGDIPagesExportPDFEmbeddedTTF_R,@TGDIPagesExportPDFEmbeddedTTF_W,'ExportPDFEmbeddedTTF');
    RegisterPropertyHelper(@TGDIPagesExportPDFA1_R,@TGDIPagesExportPDFA1_W,'ExportPDFA1');
    RegisterPropertyHelper(@TGDIPagesExportPDFBackground_R,@TGDIPagesExportPDFBackground_W,'ExportPDFBackground');
    RegisterPropertyHelper(@TGDIPagesExportPDFUseUniscribe_R,@TGDIPagesExportPDFUseUniscribe_W,'ExportPDFUseUniscribe');
    RegisterPropertyHelper(@TGDIPagesExportPDFUseFontFallBack_R,@TGDIPagesExportPDFUseFontFallBack_W,'ExportPDFUseFontFallBack');
    RegisterPropertyHelper(@TGDIPagesExportPDFFontFallBackName_R,@TGDIPagesExportPDFFontFallBackName_W,'ExportPDFFontFallBackName');
    RegisterPropertyHelper(@TGDIPagesVirtualPageNum_R,@TGDIPagesVirtualPageNum_W,'VirtualPageNum');
    RegisterPropertyHelper(@TGDIPagesHeaderDone_R,nil,'HeaderDone');
    RegisterPropertyHelper(@TGDIPagesNegsToParenthesesInCurrCols_R,@TGDIPagesNegsToParenthesesInCurrCols_W,'NegsToParenthesesInCurrCols');
    RegisterPropertyHelper(@TGDIPagesWordWrapLeftCols_R,@TGDIPagesWordWrapLeftCols_W,'WordWrapLeftCols');
    RegisterPropertyHelper(@TGDIPagesUseOutlines_R,@TGDIPagesUseOutlines_W,'UseOutlines');
    RegisterPropertyHelper(@TGDIPagesHangIndent_R,@TGDIPagesHangIndent_W,'HangIndent');
    RegisterPropertyHelper(@TGDIPagesLineSpacing_R,@TGDIPagesLineSpacing_W,'LineSpacing');
    RegisterPropertyHelper(@TGDIPagesOrientation_R,@TGDIPagesOrientation_W,'Orientation');
    RegisterPropertyHelper(@TGDIPagesZoom_R,@TGDIPagesZoom_W,'Zoom');
    RegisterPropertyHelper(@TGDIPagesZoomStatus_R,@TGDIPagesZoomStatus_W,'ZoomStatus');
    RegisterPropertyHelper(@TGDIPagesForceScreenResolution_R,@TGDIPagesForceScreenResolution_W,'ForceScreenResolution');
    RegisterPropertyHelper(@TGDIPagesOnNewPage_R,@TGDIPagesOnNewPage_W,'OnNewPage');
    RegisterPropertyHelper(@TGDIPagesOnStartPageHeader_R,@TGDIPagesOnStartPageHeader_W,'OnStartPageHeader');
    RegisterPropertyHelper(@TGDIPagesOnEndPageHeader_R,@TGDIPagesOnEndPageHeader_W,'OnEndPageHeader');
    RegisterPropertyHelper(@TGDIPagesOnStartPageFooter_R,@TGDIPagesOnStartPageFooter_W,'OnStartPageFooter');
    RegisterPropertyHelper(@TGDIPagesOnEndPageFooter_R,@TGDIPagesOnEndPageFooter_W,'OnEndPageFooter');
    RegisterPropertyHelper(@TGDIPagesOnStartColumnHeader_R,@TGDIPagesOnStartColumnHeader_W,'OnStartColumnHeader');
    RegisterPropertyHelper(@TGDIPagesOnEndColumnHeader_R,@TGDIPagesOnEndColumnHeader_W,'OnEndColumnHeader');
    RegisterPropertyHelper(@TGDIPagesOnDocumentProduced_R,@TGDIPagesOnDocumentProduced_W,'OnDocumentProduced');
    RegisterPropertyHelper(@TGDIPagesOnPreviewPageChanged_R,@TGDIPagesOnPreviewPageChanged_W,'OnPreviewPageChanged');
    RegisterPropertyHelper(@TGDIPagesOnZoomChanged_R,@TGDIPagesOnZoomChanged_W,'OnZoomChanged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGDIPageContent(CL: TPSRuntimeClassImporter);
begin
 { with CL.Add(TGDIPageContent) do begin
    RegisterPropertyHelper(@TGDIPageContentMetaFileCompressed_R,@TGDIPageContentMetaFileCompressed_W,'MetaFileCompressed');
    RegisterPropertyHelper(@TGDIPageContentText_R,@TGDIPageContentText_W,'Text');
    RegisterPropertyHelper(@TGDIPageContentSizePx_R,@TGDIPageContentSizePx_W,'SizePx');
    RegisterPropertyHelper(@TGDIPageContentMarginPx_R,@TGDIPageContentMarginPx_W,'MarginPx');
    RegisterPropertyHelper(@TGDIPageContentOffsetPx_R,@TGDIPageContentOffsetPx_W,'OffsetPx');
  end;}
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGDIPagereference(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGDIPagereference) do begin
    RegisterPropertyHelper(@TGDIPagereferencePage_R,@TGDIPagereferencePage_W,'Page');
    RegisterPropertyHelper(@TGDIPagereferenceRect_R,@TGDIPagereferenceRect_W,'Rect');
    RegisterPropertyHelper(@TGDIPagereferencePreview_R,@TGDIPagereferencePreview_W,'Preview');
    RegisterConstructor(@TGDIPagereference.Create, 'Create');
    RegisterMethod(@TGDIPagereference.ToPreview, 'ToPreview');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPagePaintBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPagePaintBox) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THeaderFooter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THeaderFooter) do
  begin
    RegisterPropertyHelper(@THeaderFooterText_R,@THeaderFooterText_W,'Text');
    RegisterPropertyHelper(@THeaderFooterState_R,@THeaderFooterState_W,'State');
    RegisterConstructor(@THeaderFooter.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_mORMotReport(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGDIPages) do
  RIRegister_THeaderFooter(CL);
  RIRegister_TPagePaintBox(CL);
  RIRegister_TGDIPagereference(CL);
  RIRegister_TGDIPageContent(CL);
  RIRegister_TGDIPages(CL);
  with CL.Add(TRenderPages) do
  RIRegister_TRenderBox(CL);
  RIRegister_TRenderPages(CL);
end;

 
 
{ TPSImport_mORMotReport }
(*----------------------------------------------------------------------------*)
procedure TPSImport_mORMotReport.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_mORMotReport(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_mORMotReport.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_mORMotReport(ri);
  RIRegister_mORMotReport_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
