unit uPSI_JvAirBrush;
{
   for scratch education
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
  TPSImport_JvAirBrush = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvAirBrush(CL: TPSPascalCompiler);
procedure SIRegister_JvAirBrush(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvAirBrush(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvAirBrush(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,Graphics
  ,JvComponentBase
  ,JvAirBrush
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvAirBrush]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvAirBrush(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvAirBrush') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvAirBrush') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Draw( ACanvas : TCanvas; X, Y : Integer)');
    RegisterProperty('Air', 'Boolean', iptr);
    RegisterProperty('Size', 'Integer', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('Intensity', 'Integer', iptrw);
    RegisterProperty('Shape', 'TJvAirBrushShape', iptrw);
    RegisterProperty('Interval', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvAirBrush(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvAirBrushShape', '( absRound, absSquare, absLeftSlash, absRigh'
   +'tSlash, absHorizontal, absVertical, absSpray )');
  SIRegister_TJvAirBrush(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvAirBrushInterval_W(Self: TJvAirBrush; const T: Integer);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAirBrushInterval_R(Self: TJvAirBrush; var T: Integer);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure TJvAirBrushShape_W(Self: TJvAirBrush; const T: TJvAirBrushShape);
begin Self.Shape := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAirBrushShape_R(Self: TJvAirBrush; var T: TJvAirBrushShape);
begin T := Self.Shape; end;

(*----------------------------------------------------------------------------*)
procedure TJvAirBrushIntensity_W(Self: TJvAirBrush; const T: Integer);
begin Self.Intensity := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAirBrushIntensity_R(Self: TJvAirBrush; var T: Integer);
begin T := Self.Intensity; end;

(*----------------------------------------------------------------------------*)
procedure TJvAirBrushColor_W(Self: TJvAirBrush; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAirBrushColor_R(Self: TJvAirBrush; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TJvAirBrushSize_W(Self: TJvAirBrush; const T: Integer);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAirBrushSize_R(Self: TJvAirBrush; var T: Integer);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TJvAirBrushAir_R(Self: TJvAirBrush; var T: Boolean);
begin T := Self.Air; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvAirBrush(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvAirBrush) do begin
    RegisterConstructor(@TJvAirBrush.Create, 'Create');
    RegisterMethod(@TJvAirBrush.Destroy, 'Free');
    RegisterMethod(@TJvAirBrush.Draw, 'Draw');
    RegisterPropertyHelper(@TJvAirBrushAir_R,nil,'Air');
    RegisterPropertyHelper(@TJvAirBrushSize_R,@TJvAirBrushSize_W,'Size');
    RegisterPropertyHelper(@TJvAirBrushColor_R,@TJvAirBrushColor_W,'Color');
    RegisterPropertyHelper(@TJvAirBrushIntensity_R,@TJvAirBrushIntensity_W,'Intensity');
    RegisterPropertyHelper(@TJvAirBrushShape_R,@TJvAirBrushShape_W,'Shape');
    RegisterPropertyHelper(@TJvAirBrushInterval_R,@TJvAirBrushInterval_W,'Interval');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvAirBrush(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvAirBrush(CL);
end;

 
 
{ TPSImport_JvAirBrush }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAirBrush.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvAirBrush(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAirBrush.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvAirBrush(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
