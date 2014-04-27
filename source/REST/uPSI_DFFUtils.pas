unit uPSI_DFFUtils;

{
  after passing the syn test
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
  TPSImport_DFFUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_DFFUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DFFUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Stdctrls
  ,Grids
  ,DFFUtils
  ,UGetParens
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DFFUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_DFFUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure reformatMemo( const m : TCustomMemo)');
 CL.AddDelphiFunction('Procedure SetMemoMargins( m : TCustomMemo; const L, T, R, B : integer)');
 CL.AddDelphiFunction('Procedure MoveToTop( memo : TMemo)');
 CL.AddDelphiFunction('Procedure ScrollToTop( memo : TMemo)');
 CL.AddDelphiFunction('Function LineNumberClicked( memo : TMemo) : integer');
 CL.AddDelphiFunction('Function MemoClickedLine( memo : TMemo) : integer');
 CL.AddDelphiFunction('Function ClickedMemoLine( memo : TMemo) : integer');
 CL.AddDelphiFunction('Function MemoLineClicked( memo : TMemo) : integer');
 CL.AddDelphiFunction('Function LinePositionClicked( Memo : TMemo) : integer');
 CL.AddDelphiFunction('Function ClickedMemoPosition( memo : TMemo) : integer');
 CL.AddDelphiFunction('Function MemoPositionClicked( memo : TMemo) : integer');
 CL.AddDelphiFunction('Procedure AdjustGridSize( grid : TDrawGrid)');
 CL.AddDelphiFunction('Procedure DeleteGridRow( Grid : TStringGrid; const ARow : integer)');
 CL.AddDelphiFunction('Procedure InsertgridRow( Grid : TStringGrid; const ARow : integer)');
 CL.AddDelphiFunction('Procedure Sortgrid( Grid : TStringGrid; const SortCol : integer);');
 CL.AddDelphiFunction('Procedure Sortgrid1( Grid : TStringGrid; const SortCol : integer; sortascending : boolean);');
 CL.AddDelphiFunction('Procedure sortstrDown( var s : string)');
 CL.AddDelphiFunction('Procedure sortstrUp( var s : string)');
 CL.AddDelphiFunction('Procedure rotatestrleft( var s : string)');
 CL.AddDelphiFunction('Function dffstrtofloatdef( s : string; default : extended) : extended');
 CL.AddDelphiFunction('Function deblank( s : string) : string');
 CL.AddDelphiFunction('Function IntToBinaryString( const n : integer; MinLength : integer) : string');
 CL.AddDelphiFunction('Procedure FreeAndClearListBox( C : TListBox);');
 CL.AddDelphiFunction('Procedure FreeAndClearMemo( C : TMemo);');
 CL.AddDelphiFunction('Procedure FreeAndClearStringList( C : TStringList);');
 CL.AddDelphiFunction('Function dffgetfilesize( f : TSearchrec) : int64');
 CL.AddDelphiFunction('Procedure GetParens( Variables : string; OpChar : char; var list : TStringlist)');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure FreeAndClear2_P( C : TStringList);
Begin DFFUtils.FreeAndClear(C); END;

(*----------------------------------------------------------------------------*)
Procedure FreeAndClear1_P( C : TMemo);
Begin DFFUtils.FreeAndClear(C); END;

(*----------------------------------------------------------------------------*)
Procedure FreeAndClear_P( C : TListBox);
Begin DFFUtils.FreeAndClear(C); END;

(*----------------------------------------------------------------------------*)
Procedure Sortgrid1_P( Grid : TStringGrid; const SortCol : integer; sortascending : boolean);
Begin DFFUtils.Sortgrid(Grid, SortCol, sortascending); END;

(*----------------------------------------------------------------------------*)
Procedure Sortgrid_P( Grid : TStringGrid; const SortCol : integer);
Begin DFFUtils.Sortgrid(Grid, SortCol); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DFFUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@reformatMemo, 'reformatMemo', cdRegister);
 S.RegisterDelphiFunction(@SetMemoMargins, 'SetMemoMargins', cdRegister);
 S.RegisterDelphiFunction(@MoveToTop, 'MoveToTop', cdRegister);
 S.RegisterDelphiFunction(@ScrollToTop, 'ScrollToTop', cdRegister);
 S.RegisterDelphiFunction(@LineNumberClicked, 'LineNumberClicked', cdRegister);
 S.RegisterDelphiFunction(@MemoClickedLine, 'MemoClickedLine', cdRegister);
 S.RegisterDelphiFunction(@ClickedMemoLine, 'ClickedMemoLine', cdRegister);
 S.RegisterDelphiFunction(@MemoLineClicked, 'MemoLineClicked', cdRegister);
 S.RegisterDelphiFunction(@LinePositionClicked, 'LinePositionClicked', cdRegister);
 S.RegisterDelphiFunction(@ClickedMemoPosition, 'ClickedMemoPosition', cdRegister);
 S.RegisterDelphiFunction(@MemoPositionClicked, 'MemoPositionClicked', cdRegister);
 S.RegisterDelphiFunction(@AdjustGridSize, 'AdjustGridSize', cdRegister);
 S.RegisterDelphiFunction(@DeleteGridRow, 'DeleteGridRow', cdRegister);
 S.RegisterDelphiFunction(@InsertgridRow, 'InsertgridRow', cdRegister);
 S.RegisterDelphiFunction(@Sortgrid, 'Sortgrid', cdRegister);
 S.RegisterDelphiFunction(@Sortgrid1_P, 'Sortgrid1', cdRegister);
 S.RegisterDelphiFunction(@sortstrDown, 'sortstrDown', cdRegister);
 S.RegisterDelphiFunction(@sortstrUp, 'sortstrUp', cdRegister);
 S.RegisterDelphiFunction(@rotatestrleft, 'rotatestrleft', cdRegister);
 S.RegisterDelphiFunction(@strtofloatdef, 'dffstrtofloatdef', cdRegister);
 S.RegisterDelphiFunction(@deblank, 'deblank', cdRegister);
 S.RegisterDelphiFunction(@IntToBinaryString, 'IntToBinaryString', cdRegister);
 S.RegisterDelphiFunction(@FreeAndClear, 'FreeAndClearListbox', cdRegister);
 S.RegisterDelphiFunction(@FreeAndClear1_P, 'FreeAndClearMemo', cdRegister);
 S.RegisterDelphiFunction(@FreeAndClear2_P, 'FreeAndClearStringlist', cdRegister);
 S.RegisterDelphiFunction(@getfilesize, 'dffgetfilesize', cdRegister);
 S.RegisterDelphiFunction(@GetParens, 'GetParens', cdRegister);
end;

 
 
{ TPSImport_DFFUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DFFUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DFFUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DFFUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_DFFUtils(ri);
  RIRegister_DFFUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
