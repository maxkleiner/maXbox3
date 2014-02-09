unit uPSI_JvDualList;
{
  list dialog
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
  TPSImport_JvDualList = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvDualListDialog(CL: TPSPascalCompiler);
procedure SIRegister_JvDualList(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvDualListDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvDualList(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Controls
  ,JvComponent
  ,JvDualList
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDualList]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDualListDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvDualListDialog') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvDualListDialog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('Ctl3D', 'Boolean', iptrw);
    RegisterProperty('Sorted', 'Boolean', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('Label1Caption', 'TCaption', iptrw);
    RegisterProperty('Label2Caption', 'TCaption', iptrw);
    RegisterProperty('OkBtnCaption', 'TCaption', iptrw);
    RegisterProperty('CancelBtnCaption', 'TCaption', iptrw);
    RegisterProperty('HelpBtnCaption', 'TCaption', iptrw);
    RegisterProperty('HelpContext', 'THelpContext', iptrw);
    RegisterProperty('List1', 'TStrings', iptrw);
    RegisterProperty('List2', 'TStrings', iptrw);
    RegisterProperty('ShowHelp', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDualList(CL: TPSPascalCompiler);
begin
  SIRegister_TJvDualListDialog(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogShowHelp_W(Self: TJvDualListDialog; const T: Boolean);
begin Self.ShowHelp := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogShowHelp_R(Self: TJvDualListDialog; var T: Boolean);
begin T := Self.ShowHelp; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogList2_W(Self: TJvDualListDialog; const T: TStrings);
begin Self.List2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogList2_R(Self: TJvDualListDialog; var T: TStrings);
begin T := Self.List2; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogList1_W(Self: TJvDualListDialog; const T: TStrings);
begin Self.List1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogList1_R(Self: TJvDualListDialog; var T: TStrings);
begin T := Self.List1; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogHelpContext_W(Self: TJvDualListDialog; const T: THelpContext);
begin Self.HelpContext := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogHelpContext_R(Self: TJvDualListDialog; var T: THelpContext);
begin T := Self.HelpContext; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogHelpBtnCaption_W(Self: TJvDualListDialog; const T: TCaption);
begin Self.HelpBtnCaption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogHelpBtnCaption_R(Self: TJvDualListDialog; var T: TCaption);
begin T := Self.HelpBtnCaption; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogCancelBtnCaption_W(Self: TJvDualListDialog; const T: TCaption);
begin Self.CancelBtnCaption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogCancelBtnCaption_R(Self: TJvDualListDialog; var T: TCaption);
begin T := Self.CancelBtnCaption; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogOkBtnCaption_W(Self: TJvDualListDialog; const T: TCaption);
begin Self.OkBtnCaption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogOkBtnCaption_R(Self: TJvDualListDialog; var T: TCaption);
begin T := Self.OkBtnCaption; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogLabel2Caption_W(Self: TJvDualListDialog; const T: TCaption);
begin Self.Label2Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogLabel2Caption_R(Self: TJvDualListDialog; var T: TCaption);
begin T := Self.Label2Caption; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogLabel1Caption_W(Self: TJvDualListDialog; const T: TCaption);
begin Self.Label1Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogLabel1Caption_R(Self: TJvDualListDialog; var T: TCaption);
begin T := Self.Label1Caption; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogTitle_W(Self: TJvDualListDialog; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogTitle_R(Self: TJvDualListDialog; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogSorted_W(Self: TJvDualListDialog; const T: Boolean);
begin Self.Sorted := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogSorted_R(Self: TJvDualListDialog; var T: Boolean);
begin T := Self.Sorted; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogCtl3D_W(Self: TJvDualListDialog; const T: Boolean);
begin Self.Ctl3D := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogCtl3D_R(Self: TJvDualListDialog; var T: Boolean);
begin T := Self.Ctl3D; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDualListDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDualListDialog) do begin
    RegisterConstructor(@TJvDualListDialog.Create, 'Create');
    RegisterMethod(@TJvDualListDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TJvDualListDialogCtl3D_R,@TJvDualListDialogCtl3D_W,'Ctl3D');
    RegisterPropertyHelper(@TJvDualListDialogSorted_R,@TJvDualListDialogSorted_W,'Sorted');
    RegisterPropertyHelper(@TJvDualListDialogTitle_R,@TJvDualListDialogTitle_W,'Title');
    RegisterPropertyHelper(@TJvDualListDialogLabel1Caption_R,@TJvDualListDialogLabel1Caption_W,'Label1Caption');
    RegisterPropertyHelper(@TJvDualListDialogLabel2Caption_R,@TJvDualListDialogLabel2Caption_W,'Label2Caption');
    RegisterPropertyHelper(@TJvDualListDialogOkBtnCaption_R,@TJvDualListDialogOkBtnCaption_W,'OkBtnCaption');
    RegisterPropertyHelper(@TJvDualListDialogCancelBtnCaption_R,@TJvDualListDialogCancelBtnCaption_W,'CancelBtnCaption');
    RegisterPropertyHelper(@TJvDualListDialogHelpBtnCaption_R,@TJvDualListDialogHelpBtnCaption_W,'HelpBtnCaption');
    RegisterPropertyHelper(@TJvDualListDialogHelpContext_R,@TJvDualListDialogHelpContext_W,'HelpContext');
    RegisterPropertyHelper(@TJvDualListDialogList1_R,@TJvDualListDialogList1_W,'List1');
    RegisterPropertyHelper(@TJvDualListDialogList2_R,@TJvDualListDialogList2_W,'List2');
    RegisterPropertyHelper(@TJvDualListDialogShowHelp_R,@TJvDualListDialogShowHelp_W,'ShowHelp');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDualList(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvDualListDialog(CL);
end;

 
 
{ TPSImport_JvDualList }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDualList.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDualList(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDualList.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDualList(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
