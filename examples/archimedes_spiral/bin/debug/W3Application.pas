{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3Application;

{------------------------------------------------------------------------------}
{ Author:    Jon Lennart Aasenden                                              }
{ Updated:   2012.04.24 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

{$I 'vjl.inc'}

{$DEFINE USE_AUTO_ADJUST}

interface

uses
  W3System, W3Lists, W3Forms, W3Components, W3Graphics, W3Effects, W3Time, 
  W3Dialogs;

type
  EW3Screen      = class(EW3Exception);
  EW3Application = class(EW3Exception);

  TFormEntryEffect = (feNone, feFromRight, feToLeft);

  TDisplayOrientation = (soPortrait, soLandscapeLeft, soLandscapeRight, soFlipped);

  TDisplayOrientationChangedEvent TDisplayOrientationChangedEventTObjectTObject; Orientation: TDisplayOrientationTDisplayOrientation; Angle: Integer);

  TW3DisplayViewArangeType = (dvaSizeToView, dvaVStack, dvaHStack);

  TW3BlockBox = class(TW3CustomControl)
  end;

  TW3DisplayView = class(TW3CustomControl)
  private
    FArrange: Boolean;
    FArrangeKind: TW3DisplayViewArangeType;
    procedure setArrange(aValue: Boolean);
    procedure setArrangeType(aValue: TW3DisplayViewArangeTypeTW3DisplayViewArangeType);
  protected
    procedure ArrangeChildren(aKind: TW3DisplayViewArangeTypeTW3DisplayViewArangeType);
    procedure Resize; override;
    procedure InitializeObject; override;
  public
    property AutoArrange: Boolean read FArrange write setArrange;
    property ArrangeType: TW3DisplayViewArangeType read FArrangeKind write setArrangeType;
    procedure ApplyArrangement(aKind: TW3DisplayViewArangeTypeTW3DisplayViewArangeType);
  end;

  TW3Display = class(TW3CustomControl)
  private
    FHeader: TObject;
    FView: TW3DisplayView;
    FFooter: TObject;
    FOnOrient: TDisplayOrientationChangedEvent;
    function getHeightOfChildren: Integer;
    function getOrientation: TDisplayOrientation;
  protected
    procedure Resize; override;
    procedure InitializeObject; override;
    procedure FinalizeObject; override;
  public
    property Orientation: TDisplayOrientation read getOrientation;
    property View: TW3DisplayView read FView;
    procedure PositionFormInView(aForm$1: TW3CustomFormTW3CustomForm);

    property OnOrientationChanged: TDisplayOrientationChangedEvent read FOnOrient write FOnOrient;
  end;

  TApplicationUnloadEvent       TApplicationUnloadEventTObjectTObject);
  TApplicationBeforeUnloadEvent TApplicationBeforeUnloadEventTObjectTObject);

  TModalResult = (mrCancel, mrOK);
  TModalDialogProc TModalDialogProclog: TW3CustomFormTW3CustomForm);

  TW3CustomApplication = partial class(TObject)
  private
    FBody: TDocumentBody;
    FDisplay: TW3Display;
    FForms: array of TW3CustomForm;
    FTerminated: Boolean;
    FDialog: TW3AlertDialog;
    FBlockBox: TW3BlockBox;
    FDialogEvent: TW3AlertSelectEvent;
    FMainForm: TW3CustomForm;
    FCurrentForm: TW3CustomForm;
    FEnterAnim: TW3NamedAnimation;
    FLeaveAnim: TW3NamedAnimation;
    (* Forms currently in transition *)
    FFormChangeActive: Boolean; // Transition active flag
    FTransSrc: TW3CustomForm; // Form app is leaving
    FTransDst: TW3CustomForm; // Form app is entering
    FEntryEffect: TFormEntryEffect;

    FOnUnload:  TApplicationUnloadEvent;
    FOnBeforeUnload:  TApplicationBeforeUnloadEvent;

    procedure HandleLeaveAnimEnds(Sender$1: TObjectTObject);
    procedure HandleEnterAnimEnds(Sender: TObjectTObject);
    function getForm(index: Integer): TW3CustomForm;
    function getFormCount: Integer;
    procedure HandleDialogFeedBack(Sender: TObjectTObject; aResult: TW3AlertResultTW3AlertResult);
    procedure HandleDialogBlockerReSize(Sender: TObjectTObject);
    function GetDialogActive: Boolean;
    function GetAppName: String;
  protected
    (* Native event interception *)
    procedure CBOnUnLoad; virtual;
    procedure CBOnBeforeUnload; virtual;
    procedure CBOnReSize; virtual;
    procedure CBOnOrientationChange; virtual;
    procedure AdjustScreen;
    procedure HookWindowEvents; virtual;
    procedure ApplicationStarting; virtual;
    procedure ApplicationStarted; virtual;
    procedure ApplicationClosing; virtual;
  public
    function FormByName(formName: string): TW3CustomForm;
    class var Instance: TW3CustomApplication;
    property Terminated: Boolean read FTerminated;
    property Document: TDocumentBody read FBody;
    property Display: TW3Display read FDisplay;
    property OnDialogSelect: TW3AlertSelectEvent read FDialogEvent write FDialogEvent;
    property Forms[index: Integer]: TW3CustomForm read getForm;
    property FormCount: Integer read getFormCount;
    property FormChangeActive: Boolean read FFormChangeActive;
    property CurrentForm: TW3CustomForm read FCurrentForm;
    property MainForm: TW3CustomForm read FMainForm;
    property DialogActive: Boolean read GetDialogActive;
    property Name: String read GetAppName;
    procedure CreateForm(aForm: TW3CustomFormClass; isMainForm: Boolean = False);
    procedure RegisterFormInstance(aForm: TW3CustomFormTW3CustomForm; isMainForm: Boolean = False);
    procedure UnRegisterFormInstance(aForm: TW3CustomFormTW3CustomForm);
    procedure ShowDialog(aCaption: String; aText: String; aOptions: TW3AlertOptionsTW3AlertOptions);
    procedure CloseDialog;
    procedure ShowModal(form: TW3CustomFormTW3CustomForm; panel, focusControl: TW3CustomControlTW3CustomControlTW3CustomControl;
      onInit, onOK, onCancel: TModalDialogProcTModalDialogProcTModalDialogProcTModalDialogProc = nil); overload;
    procedure ShowModal(formName, panelName, focusControlName: string;
      onInit, onOK, onCancel: TModalDialogProcTModalDialogProcTModalDialogProcTModalDialogProc = nil); overload;
    procedure HideModal(modalResult: TModalResultTModalResult);
    class function CreateOpaqueMask(backgroundColor: string = 'black'; opacity: string = '0.6'): Variant; static;
    procedure GotoFormByRef(aForm: TW3CustomFormTW3CustomForm; Effect: TFormEntryEffectTFormEntryEffect = feNone);
    procedure GotoForm(aName: String; Effect: TFormEntryEffectTFormEntryEffect = feNone);
    procedure RunApp;
    procedure Terminate;
    constructor Create$43; virtual;
    destructor Destroy; override;

    property  OnBeforeUnload:TApplicationBeforeUnloadEvent
              read FOnBeforeUnload write FOnBeforeUnload;
    property  OnUnload:TApplicationUnloadEvent
              read FOnUnload write FOnUnload;
  end;

function Application$1: TW3CustomApplication;

implementation

const
   FORM_CHANGE_DELAY = 0.3;
   CNT_ERR_FORM_PARAM_WAS_NIL = 'Form parameter was NIL error';

type
  TModalInfo = class
    OnOK: TModalDialogProc;
    OnCancel: TModalDialogProc;
    ModalForm: TW3CustomForm;
    ModalPanel: TW3CustomControl;
    OwnerForm: TW3CustomForm;
    OpaqueMask: TW3BlockBox;
  end;

  TW3CustomApplication = partial class(TObject)
  private
    FModalInfoList: array of TModalInfo;
  end;

function Application$1: TW3CustomApplication;
begin
  Result := TW3CustomApplication.Instance;
end;

{ **************************************************************************** }
{ TW3DisplayView                                                               }
{ **************************************************************************** }

procedure TW3DisplayView.InitializeObject;
begin
  inherited;
  FArrange := true;
  FArrangeKind := dvaSizeToView;
end;

procedure TW3DisplayView.setArrange(aValue:Boolean);
begin
  if aValue<>FArrange then
  begin
    FArrange := aValue;
    if FArrange then
    ApplyArrangement(FArrangeKind);
  end;
end;

procedure TW3DisplayView.setArrangeType(aValue: TW3DisplayViewArangeType);
begin
  (* Any difference? *)
  if aValue<>FArrangeKind then
  begin
    (* object ready or being constructed? *)
    if ObjectReady then
    begin

      (* Auto arrangement active? *)
      if FArrange then
      begin
        (* ok, issue an update *)
        BeginUpdate;
        try
          FArrangeKind := aValue;
          SetWasSized;
        finally
          EndUpdate;
        end;
      end else
      FArrangeKind := aValue;
    end else
    FArrangeKind := aValue;
  end;
end;

(* NOTE: This procedure is called internally by the ReSize() method in
   order to do some layout work. As such, it does not check if the
   control is ready (i.e not being constructed) and it does NOT issue an
   update. The reason is that it would create an infinite recursive loop. *)
procedure TW3DisplayView.ArrangeChildren(aKind: TW3DisplayViewArangeTypeTW3DisplayViewArangeType);
var
  x$20:      Integer;
  dx$2,dy$2:  Integer;
  mObj$18:   TObject;
  mCount$2: Integer;
  mRect:  TRect;
  wd$2,hd$2:  Integer;
begin
  (* Any child objects at all? *)
  mCount$2 := GetChildCount;
  if mCount$2>0 then
  begin
    mRect := BoundsRect$1;
    case aKind of
    dvaSizeToView:
      begin
        wd$2 := mRect.Width$3;
        hd$2 := mRect.Height$3;
        //wd := (mRect.right-mRect.left) + 1;
        //hd := (mRect.bottom-mRect.top)+1;
        (* Size each child object to view size.
           Note: We dont mess with the x/y pos size it might be
                 positioned "off screen" *)
        for x$20 := 0 to mCount$2-1 do
        begin
          mObj$18 := GetChildObject(x$20);
          if (mObj$18 is TW3CustomControl)
          and not (mObj$18 is TW3BlockBox) then
          TW3CustomControl(mObj$18).SetSize(wd$2,hd$2);
        end;
      end;
    dvaVStack:
      begin
        (* Stack the children top-to-bottom *)
        dy$2 := mRect.Top$3;
        wd$2 := mRect.Width$3;
        //wd := (mRect.right-mRect.left) + 1;
        for x$20 := 0 to mCount$2-1 do
        begin
          mObj$18 := GetChildObject(x$20);
          if (mObj$18 is TW3CustomControl)
          and not (mObj$18 is TW3BlockBox) then
          begin
            hd$2 := TW3CustomControl(mObj$18).Height$1;
            TW3CustomControl(mObj$18).SetBounds(mRect.Left$3, dy$2, wd$2, hd$2);
            Inc(dy$2, hd$2);
          end;
        end;
      end;
    dvaHStack:
      begin
        (* Stack the children left-to-right *)
        dx$2 := mRect.Left$3;
        hd$2 := mRect.Height$3;
        //hd := (mRect.bottom-mRect.top)+1;
        for x$20 := 0 to mCount$2-1 do
        begin
          mObj$18 := GetChildObject(x$20);
          if (mObj$18 is TW3CustomControl)
          and not (mObj$18 is TW3BlockBox) then
          begin
            wd$2 := TW3CustomControl(mObj$18).Width$1;
            TW3CustomControl(mObj$18).SetBounds(dx$2, mRect.Top$3, wd$2, hd$2);
            Inc(dx$2, wd$2);
          end;
        end;
      end;
    end;
  end;
end;

(* NOTE: This is the "public" version of the above method. As you can see
   this method does check if the object is ready and also issues an
   update to ensure that changes are handled properly *)
procedure TW3DisplayView.ApplyArrangement(aKind: TW3DisplayViewArangeType);
begin
  if ObjectReady then
  begin
    BeginUpdate;
    ArrangeChildren(aKind);
    EndUpdate;
  end;
end;

procedure TW3DisplayView.Resize;
begin
  inherited;
  if FArrange then
  ArrangeChildren(FArrangeKind)
end;



{ **************************************************************************** }
{ TW3Display                                                                   }
{ **************************************************************************** }

procedure TW3Display.InitializeObject;
begin
  inherited;
  FView := TW3DisplayView.Create$4(Self);
  FView.Top$1 := 5;
end;

procedure TW3Display.FinalizeObject;
begin
  FView.Free;
  if Assigned(FHeader) then
    FHeader.Free;
  if Assigned(FFooter) then
    FFooter.Free;
  inherited;
end;

function TW3Display.getOrientation:TDisplayOrientation;
var
  mTemp:  Integer;
begin
  mTemp := 0;
  asm
    @mTemp = window.orientation;
  end;
  case mTemp of
  090:  Result := soLandscapeLeft;
  -90:  Result := soLandscapeRight;
  180:  Result := soFlipped;
  else  Result := soPortrait;
  end;
end;

function TW3Display.getHeightOfChildren: Integer;
var
  x$21:  Integer;
  mCount$3: Integer;
  mObj$19: TObject;
begin
  Result := 0;
  mCount$3 := GetChildCount;
  for x$21 := 0 to mCount$3-1 do
  begin
    mObj$19 := GetChildObject(x$21);
    if  (mObj$19 is TW3CustomControl)
    and not (mObj$19 is TW3BlockBox)
    and (mObj$19<>FView) then
    Inc(Result,TW3CustomControl(mObj$19).Height$1);
  end;
end;

procedure TW3Display.Resize;
var
  mTotal: Integer;
  mList: TW3ComponentArray;
  x$22:  Integer;
  dy$4: Integer;
  mObj$20: TW3CustomControl;
begin
  inherited;
  (* The screen can have multiple children.
     Calculate height of the screen-view in that case *)
  mTotal := getHeightOfChildren;
  FView.Height$1 := (Height$1-mTotal);

  (* now position objects based on their Y pos *)
  mList := GetChildrenSortedByYPos;

  dy$4 := 0;
  for x$22 := 0 to mList.Count-1 do
  begin
    mObj$20 := TW3CustomControl(mList[x$22]);
    if not (mObj$20 is TW3BlockBox) then
    begin
      mObj$20.SetBounds(0,dy$4,Width$1,mObj$20.Height$1);
      Inc(dy$4,mObj$20.Height$1);
      if x$22=0 then
        Inc(dy$4,2);
    end else
    mObj$20.SetBounds(0,0,Width$1,Height$1);
  end;

end;

procedure TW3Display.PositionFormInView(aForm$1: TW3CustomFormTW3CustomForm);
var
  mApp: TW3CustomApplication;
  dx$3: Integer;
  dy$3: Integer;
begin
  if Assigned(aForm$1) then
  begin
    mApp := Application$1;
    if  Assigned(mApp)
    and not mApp.Terminated then
    begin
      dx$3 := View.ScrollInfo.OffsetX;
      dy$3 := View.ScrollInfo.OffsetY;
      aForm$1.SetBounds(dx$3, dy$3, View.Width$1, View.Height$1);
    end;
  end else
  raise EW3Screen.CreateFmt(CNT_ERR_METHOD,['PositionFormInView',ClassName,CNT_ERR_FORM_PARAM_WAS_NIL]);
end;



{ **************************************************************************** }
{ TW3CustomApplication                                                         }
{ **************************************************************************** }

constructor TW3CustomApplication.Create$43;
begin
  inherited Create;
  FBody := TDocumentBody.Create$4(nil);
  FDisplay := TW3Display.Create$4(FBody);

  (* set class instance variable *)
  if not Assigned(Instance) then
    Instance := Self;
end;

destructor TW3CustomApplication.Destroy;
begin
  if not Terminated then
  Terminate;

  FDisplay.Free;
  FBody.Free;

  Instance := nil;

  inherited;
end;

function TW3CustomApplication.FormByName(formName: string): TW3CustomForm;
begin
  Result := nil;
  var lcName := Trim$_String_(LowerCase(formName));
  for var i := 0 to FormCount - 1 do
    if LowerCase(Forms[i].Name$3) = lcName then
      exit(Forms[i]);
end;

procedure TW3CustomApplication.HookWindowEvents;
begin
  w3_bind2(BrowserAPI.GetBody, 'onunload', CBOnUnLoad);
  w3_bind2(BrowserAPI.GetBody, 'onbeforeunload', CBOnBeforeUnload);
  w3_bind2(BrowserAPI.GetWindow, 'onresize', CBOnReSize);
  w3_bind2(BrowserAPI.GetWindow, 'onorientationchange', CBOnOrientationChange);
end;

function TW3CustomApplication.GetAppName: String;
begin
  Result := {$I 'app:name'};
end;

procedure TW3CustomApplication.ShowDialog(aCaption: String;aText: String;
          aOptions: TW3AlertOptionsTW3AlertOptions);
var
  dx, dy: Integer;
begin
  if not GetDialogActive then
  begin
    FBlockBox := TW3BlockBox.Create$4(Display);
    FBlockBox.SetBounds(0,0,Display.Width$1,Display.Height$1);

    (* We want to center our dialog should the blockbox be
       resized. So we hook into the resize mechanism *)
    FBlockBox.OnResize := HandleDialogBlockerReSize;

    FDialog := TW3AlertDialog.Create$4(FBlockBox);
    FDialog.OnSelect := HandleDialogFeedBack;
    FDialog.Width$1 := 280;
    FDialog.Height$1 := 200;

    dx := (FBlockBox.Width$1 - FDialog.Width$1) div 2;
    dy := (FBlockBox.Height$1 - FDialog.Height$1) div 2;

    FDialog.SetBounds(dx,dy,FDialog.Width$1,FDialog.Height$1);
    (FDialog as IW3AlertDialog).SetupDialog(aCaption,aText,aOptions);
  end else
  raise EW3Application.Create('A dialog is already active error');
end;

procedure TW3CustomApplication.HandleDialogBlockerReSize(Sender: TObjectTObject);
var
  dx, dy: Integer;
  modalInfo: TModalInfo;
begin
  if Assigned(FDialog) and Assigned(FBlockBox) then
  begin
    dx := (FBlockBox.Width$1 - FDialog.Width$1) div 2;
    dy := (FBlockBox.Height$1 - FDialog.Height$1) div 2;
    FDialog.MoveTo(dx,dy);
  end;
  for modalInfo in FModalInfoList do begin
    dx := (modalInfo.OpaqueMask.Width$1 - modalInfo.ModalPanel.Width$1) div 2;
    dy := (modalInfo.OpaqueMask.Height$1 - modalInfo.ModalPanel.Height$1) div 2;
    modalInfo.ModalPanel.MoveTo(dx,dy);
  end;
end;

procedure TW3CustomApplication.ShowModal(form: TW3CustomFormTW3CustomForm; panel,
  focusControl: TW3CustomControlTW3CustomControlTW3CustomControl; onInit, onOK, onCancel: TModalDialogProc);
var
  zIndex: integer;
begin
  if FModalInfoList.Count = 0 then
    zIndex := CurrentForm.GetMaxZIndex
  else begin
    zIndex := FModalInfoList.Peek.ModalForm.GetMaxZIndex;
    // modal form over a modal form - make owner's opaque mask invisible
    FModalInfoList.Peek.OpaqueMask.Visible$1 := false;
  end;

  var opaqueMask := TW3BlockBox.Create$4(Display);
  opaqueMask.SetBounds(0,0,Display.Width$1,Display.Height$1);
    (* We want to center our dialog should the blockbox be
       resized. So we hook into the resize mechanism *)
  opaqueMask.OnResize := HandleDialogBlockerReSize;

  if Assigned(onInit) then
    onInit(form);

  var modalInfo := TModalInfo.Create;
  FModalInfoList.Push(modalInfo);

  modalInfo.OpaqueMask := opaqueMask;
  modalInfo.OpaqueMask.Handle.style.zIndex := IntToStr(zIndex + 1);
  modalInfo.ModalForm := form;
  modalInfo.ModalPanel := panel;
  modalInfo.OnOK := onOK;
  modalInfo.OnCancel := onCancel;
  modalInfo.ModalPanel.InsertInto(CurrentForm.Handle);
  modalInfo.ModalPanel.Visible$1 := true;
  modalInfo.ModalPanel.Handle.style.zIndex := IntToStr(zIndex + 2);
  panel.MoveTo((CurrentForm.ClientWidth - panel.Width$1) div 2,
               (CurrentForm.ClientHeight - panel.Height$1) div 2);

  modalInfo.ModalForm.FormActivated;
  if Assigned(focusControl) then
    (focusControl as TW3CustomControl).SetFocus;
end;

procedure TW3CustomApplication.ShowModal(formName, panelName, focusControlName: string;
  onInit, onOK, onCancel: TModalDialogProc);
var
  focusControl: TW3Component;
begin
  var modalForm := Application.FormByName(formName);
  if not Assigned(modalForm) then
    raise EW3Application.CreateFmt(CNT_ERR_METHOD,[{$I %FUNCTION%},ClassName,Format('Form [%s] not found',[formName])]);
  var modalPanel := modalForm.ChildByName(panelName);
  if not Assigned(modalPanel) then
    raise EW3Application.CreateFmt(CNT_ERR_METHOD,[{$I %FUNCTION%},ClassName,Format('Component [%s] not found',[panelName])]);
  if not (modalPanel is TW3CustomControl) then
    raise EW3Application.CreateFmt(CNT_ERR_METHOD,[{$I %FUNCTION%},ClassName,Format('Component [%s] is not a TW3CustomControl',[panelName])]);
  if focusControlName = '' then focusControl := nil
  else begin
    focusControl := TW3CustomControl(modalPanel).ChildByName(focusControlName);
    if not Assigned(focusControl) then
      raise EW3Application.CreateFmt(CNT_ERR_METHOD,[{$I %FUNCTION%},ClassName,Format('Component [%s] not found',[focusControlName])]);
    if not (focusControl is TW3CustomControl) then
      raise EW3Application.CreateFmt(CNT_ERR_METHOD,[{$I %FUNCTION%},ClassName,Format('Component [%s] is not a TW3CustomControl',[focusControlName])]);
  end;
  ShowModal(modalForm, TW3CustomControl(modalPanel), TW3CustomControl(focusControl), onInit, onOK, onCancel);
end;

procedure TW3CustomApplication.HideModal(modalResult: TModalResult);
begin
  var modalInfo := FModalInfoList.Pop;

  modalInfo.OpaqueMask.Free;

  if FModalInfoList.Count > 0 then // modal form over a modal form - restore owner's opaque mask
    FModalInfoList.Peek.OpaqueMask.Visible$1 := true;

  modalInfo.ModalPanel.Visible$1 := false;
  modalInfo.ModalForm.FormDeActivated;
  case modalResult of
    mrOK:   
      if assigned(modalInfo.OnOK) then 
        modalInfo.OnOK(modalInfo.ModalForm);
    mrCancel: 
      if assigned(modalInfo.OnCancel) then 
        modalInfo.OnCancel(modalInfo.ModalForm);
  end;
end;

procedure TW3CustomApplication.CloseDialog;
begin
  if GetDialogActive then
  begin
    FDialog.Free;
    FDialog := nil;

    if FBlockBox<>nil then
    begin
      FBlockBox.Free;
      FBlockBox := nil;
    end;

  end;
end;

class function TW3CustomApplication.CreateOpaqueMask(backgroundColor, opacity: string): Variant;
var
  doc: Variant;
begin
  asm @doc = document; end;
  Result := doc.createElement('div');
  Result.setAttribute('style', 'position:absolute;width:100%;height:100%;text-align:center');
  Result.style.backgroundColor := backgroundColor;
  Result.style.opacity := opacity;
  Result.style.backgroundPosition := 'center center';
  if Assigned(Instance) and Assigned(Instance.CurrentForm) then
     Result.style.zIndex := IntToStr(Instance.CurrentForm.GetMaxZIndex + 1);
  doc.body.appendChild(Result);
end;

procedure TW3CustomApplication.HandleDialogFeedBack(Sender: TObjectTObject; aResult: TW3AlertResultTW3AlertResult);
begin
  try
    if Assigned(FDialogEvent) then
      FDialogEvent(Self, aResult);
  finally
    CloseDialog;
  end;
end;

function TW3CustomApplication.GetDialogActive: Boolean;
begin
  Result := Assigned(FDialog);
end;

procedure TW3CustomApplication.CBOnBeforeUnload;
begin
  if Assigned(FOnBeforeUnload) then
    FOnBeforeUnload(Self);
end;

procedure TW3CustomApplication.CBOnUnLoad;
begin
  try
    if Assigned(FOnUnload) then
      FOnUnload(Self);
  finally
    if not Terminated then
      Terminate;
  end;
end;

procedure TW3CustomApplication.CBOnReSize;
begin
  AdjustScreen;
end;

procedure TW3CustomApplication.CBOnOrientationChange;
var
  mOrientation: TDisplayOrientation;
  mTemp$11:  Integer;
  mEntry: TDisplayOrientationChangedEvent;
begin
  mTemp$11 := 0;
  asm
    @mTemp$11 = window.orientation;
  end;
  case mTemp$11 of
  000:  mOrientation := soPortrait;
  090:  mOrientation := soLandscapeLeft;
  -90:  mOrientation := soLandscapeRight;
  180:  mOrientation := soFlipped;
  end;

  try
    if Assigned(FDisplay) then
    begin
      mEntry := FDisplay.OnOrientationChanged;
      if Assigned(mEntry) then
      mEntry(FDisplay,mOrientation,mTemp$11);
    end;
  finally
    AdjustScreen;
  end;
end;

procedure TW3CustomApplication.AdjustScreen;
begin
  FDisplay.ScrollInfo.ScrollTo(0,0);
  FDisplay.SetBounds(0,0,FBody.Width$8,FBody.Height$6);
end;

procedure TW3CustomApplication.Terminate;
begin
  if FTerminated then exit;

  FTerminated := True;
  ApplicationClosing;

  try
    for var x$2 := 0 to FForms.High do
    begin
      FForms[x$2].Free;
      FForms[x$2] := nil;
    end;
    FForms.Clear;
  finally
    Self.Free;
  end;
end;

procedure TW3CustomApplication.ApplicationStarted;
begin
//
end;

procedure TW3CustomApplication.ApplicationStarting;
begin
  AdjustScreen;
end;

procedure TW3CustomApplication.ApplicationClosing;
begin
//
end;

procedure TW3CustomApplication.RunApp;
var
  FTemp:  TW3CustomForm;
begin
  HookWindowEvents;
  ApplicationStarting;
  if Assigned(FMainForm) then
  begin
    FTemp := FMainForm;
    FMainForm := nil;
    GotoFormByRef(FTemp,feNone);
  end;
  ApplicationStarted;
end;

function TW3CustomApplication.getFormCount: Integer;
begin
  Result := FForms.Count;
end;

function TW3CustomApplication.getForm(index: Integer): TW3CustomForm;
begin
  Result := FForms[index];
end;

procedure TW3CustomApplication.CreateForm(aForm: TW3CustomFormClass; isMainForm: Boolean = False);
begin
  RegisterFormInstance(aForm.Create$4(Display.View), isMainForm);
end;

procedure TW3CustomApplication.RegisterFormInstance(aForm: TW3CustomFormTW3CustomForm; isMainForm:Boolean=False);
begin
  if not Terminated then
  begin
    if Assigned(aForm) then
    begin
      if FForms.IndexOf(aForm)<0 then
      begin

        (* add form to our internal list *)
        try
          FForms.Add(aForm);
        except
          on e: Exception do
          raise EW3Exception.CreateFmt(CNT_ERR_METHOD,
          [{$I %FUNCTION%},ClassName,e.Message]);
        end;

        // apply control adjustment
        {$IFDEF USE_AUTO_ADJUST}
        w3_RequestAnimationFrame
          (
          procedure
          begin
            aForm.AdjustToParentBox;
          end
          );
        {$ENDIF}

        (* Was this the mainform? Keep a reference *)
        if isMainForm then
          FMainForm := aForm
        else aForm.Visible$1 := False;

      end else
      raise EW3Application.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'Form already registered']);
    end else
    raise EW3Application.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'Form parameter is NIL error']);
  end;
end;

procedure TW3CustomApplication.UnRegisterFormInstance(aForm: TW3CustomFormTW3CustomForm);
var
  mIndex: Integer;
begin
  if not Terminated then
  begin
    if Assigned(aForm) then
    begin
      mIndex := FForms.IndexOf(aForm);
      if mIndex>=0 then
      begin
        if FMainForm<>aForm then
        begin
          (* form in view now? Ok, fall back to mainform *)
          if FCurrentForm=aForm then
          GotoFormByRef(FMainForm);

          (* delete reference from our list *)
          FForms.Delete(mIndex);

          (* now release the instance *)
          try
            aForm.Free;
          except
            on e: Exception do
            begin
              raise EW3Application.CreateFmt(CNT_ERR_METHOD,
              [{$I %FUNCTION%},ClassName,e.Message]);
            end;
          end;

        end else
        raise EW3Application.CreateFmt(CNT_ERR_METHOD,
        [{$I %FUNCTION%},ClassName,
        'Main form cannot be removed error']);
      end else
      raise EW3Application.CreateFmt(CNT_ERR_METHOD,
      [{$I %FUNCTION%},ClassName,'Form is not registered']);
    end else
    raise EW3Application.CreateFmt(CNT_ERR_METHOD,
    [{$I %FUNCTION%},ClassName,'Form parameter is NIL error']);
  end;
end;

procedure TW3CustomApplication.HandleLeaveAnimEnds(Sender$1: TObjectTObject);
var
  mAnim$1: TW3NamedAnimation;
begin
  mAnim$1 := TW3NamedAnimation(Sender$1);
  FTransSrc.Visible$1 := False;
  mAnim$1.Free;
end;

procedure TW3CustomApplication.HandleEnterAnimEnds(Sender: TObjectTObject);
var
  mAnim: TW3NamedAnimation;
begin
  mAnim := TW3NamedAnimation(Sender);
  case FEntryEffect of
  feFromRight:
    begin
      (* pin the sliding form to 0,0 *)
      FTransDst.MoveTo(0,0);

      (* make the sliding for the active one *)
      FCurrentForm := FTransDst;
      FCurrentForm.FormActivated;

      (* Unlock for further processing *)
      FFormChangeActive := False;
    end;
  feToLeft:
    begin
      FTransDst.MoveTo(0,0);

      (* make the sliding form the active one *)
      FCurrentForm := FTransDst;
      FCurrentForm.FormActivated;

      FTransSrc.Visible$1 := False;
      FDisplay.PositionFormInView(FTransSrc);

      (* Unlock for further processing *)
      FFormChangeActive := False;
    end;
  end;

  (* dispose of animation object *)
  mAnim.Free;
  mAnim := nil;
end;


procedure TW3CustomApplication.GotoFormByRef(aForm: TW3CustomFormTW3CustomForm; Effect:TFormEntryEffectTFormEntryEffect=feNone);
var
  mIndex: Integer;
begin
  if not Terminated then
  begin
    if not FFormChangeActive then
    begin
      if aForm<>nil then
      begin
        mIndex := FForms.IndexOf(aForm);
        if mIndex>=0 then
        begin

          if aForm<>FCurrentForm then
          begin

            (* first form to show? Just show it *)
            if FCurrentForm=nil then
            begin
              FCurrentForm := aForm;
              FDisplay.PositionFormInView(aForm);
              aForm.Visible$1 := True;
              aForm.FormActivated;
              exit;
            end else
            begin
              FFormChangeActive := True;
              FEntryEffect := Effect;

              aForm.BringToFront;

              case Effect of
              feNone:
                begin
                  FCurrentForm.Visible$1 := False;
                  FCurrentForm.FormDeActivated;

                  aForm.Visible$1 := True;
                  FDisplay.PositionFormInView(aForm);
                  aForm.FormActivated;
                  FCurrentForm := aForm;
                  FFormChangeActive := false;
                end;
              feFromRight:
                begin
                  FCurrentForm.FormDeActivated;

                  FTransSrc := FCurrentForm;
                  FTransDst := aForm;

                  aForm.Visible$1 := True;
                  FDisplay.PositionFormInView(aForm);

                  FEnterAnim := TW3NamedAnimation.Create$40;
                  FEnterAnim.AnimName := 'MOVE-LEFT';
                  FEnterAnim.Duration := FORM_CHANGE_DELAY;

                  FLeaveAnim := TW3NamedAnimation.Create$40;
                  FLeaveAnim.AnimName := 'MOVE-OUT-LEFT';
                  FLeaveAnim.Duration := FORM_CHANGE_DELAY;

                  FEnterAnim.ExecuteEx(aForm,nil,HandleEnterAnimEnds);
                  FLeaveAnim.ExecuteEx(FCurrentForm,nil,HandleLeaveAnimEnds);
                end;
              feToLeft:
                begin
                  FCurrentForm.FormDeActivated;
                  FTransSrc := FCurrentForm;
                  FTransDst := aForm;

                  aForm.Visible$1 := True;
                  FDisplay.PositionFormInView(aForm);

                  FEnterAnim := TW3NamedAnimation.Create$40;
                  FEnterAnim.AnimName := 'MOVE-RIGHT';
                  FEnterAnim.Duration := FORM_CHANGE_DELAY;

                  FLeaveAnim := TW3NamedAnimation.Create$40;
                  FLeaveAnim.AnimName := 'MOVE-OUT-RIGHT';
                  FLeaveAnim.Duration := FORM_CHANGE_DELAY;

                  FEnterAnim.ExecuteEx(aForm,nil,HandleEnterAnimEnds);
                  FLeaveAnim.ExecuteEx(FCurrentForm,nil,HandleLeaveAnimEnds);
                end;
              end;

            end;

          end;

        end else
        raise EW3Application.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'Form not registered error']);
      end else
      raise EW3Application.CreateFmt(CNT_ERR_METHOD,[{$I %FUNCTION%},ClassName,'Form parameter is NIL error']);
    end else
    raise EW3Application.CreateFmt(CNT_ERR_METHOD,[{$I %FUNCTION%},ClassName,'A form transition is already active error']);
  end;
end;

procedure TW3CustomApplication.GotoForm(aName: String; Effect: TFormEntryEffect = feNone);
begin
  if aName='' then
    raise EW3Application.CreateFmt(CNT_ERR_METHOD,[{$I %FUNCTION%},ClassName,'Invalid form name error']);

  for var f in FForms do
  begin
    if SameText(aName, f.Name$3) then begin
      GotoFormByRef(f, Effect);
      exit;
    end;
  end;

  raise EW3Application.CreateFmt(CNT_ERR_METHOD,[{$I %FUNCTION%},ClassName,Format('Form [%s] not found error',[aName])]);
end;

end.

