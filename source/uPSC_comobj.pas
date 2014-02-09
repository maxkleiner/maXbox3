{ compiletime ComObj support }
unit uPSC_comobj;

{$I PascalScript.inc}
interface
uses
  uPSCompiler, uPSUtils;

{
 
Will register:
 
function CreateOleObject(const ClassName: String): IDispatch;
function GetActiveOleObject(const ClassName: String): IDispatch;
   add the ole 

}

procedure SIRegister_ComObj(cl: TPSPascalCompiler);

implementation

procedure SIRegister_ComObj(cl: TPSPascalCompiler);
begin
  cl.AddDelphiFunction('function CreateOleObject(const ClassName: String): IDispatch;');
  cl.AddDelphiFunction('function GetActiveOleObject(const ClassName: String): IDispatch;');
  cl.AddDelphiFunction('function ProgIDToClassID(const ProgID: string): TGUID;');
  cl.AddDelphiFunction('function ClassIDToProgID(const ClassID: TGUID): string;');
  cl.AddDelphiFunction('function CreateClassID: string;');
  cl.AddDelphiFunction('function CreateGUIDString: string;');
  cl.AddDelphiFunction('function CreateGUIDID: string;');
  cl.AddDelphiFunction('procedure OleError(ErrorCode: longint)');
  cl.AddDelphiFunction('procedure OleCheck(Result: HResult);');

  end;
end.
