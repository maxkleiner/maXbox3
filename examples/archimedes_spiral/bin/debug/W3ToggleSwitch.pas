unit w3toggleswitch;

interface

uses
  W3System, W3Components, w3graphics, w3touch, w3label;

type

  TW3ToggleKnob = Class(TW3CustomControl)
  protected
    procedure InitializeObject; override;
  End;

  TW3ToggleOnLabel = Class(TW3Label);
  TW3ToggleOffLabel = Class(TW3Label);

  TW3ToggleSwitch = Class(TW3CustomControl)
  private
    FKnob:    TW3ToggleKnob;
    FOnText:  TW3ToggleOnLabel;
    FOffText: TW3ToggleOffLabel;
    Procedure HandleTouch(Sender: TObjectTObject; Info: TW3TouchDataTW3TouchData);
    procedure HandleMouseDown(sender:TObjectTObject;button:TMouseButtonTMouseButton;
              shiftState:TShiftStateTShiftState;x,y:Integer);
    function  getChecked:Boolean;
    procedure setChecked(Const aValue:Boolean);
  protected
    procedure InitializeObject; override;
    Procedure FinalizeObject;Override;
    procedure Resize; override;
  public
    Property  Checked:Boolean read getChecked write setChecked;
    class function supportAdjustment:Boolean;override;
    Procedure Toggle;
  End;


Implementation

  const
  CNT_TOGGLESWITCH_BARBUST = 7;


  //###########################################################################
  // TW3ToggleKnob
  //###########################################################################

  procedure TW3ToggleKnob.InitializeObject;
  begin
    inherited;
    w3_setStyle(Handle,w3_CSSPrefix('Transition'),'left .12s');
  end;

  //###########################################################################
  // TW3ToggleSwitch
  //###########################################################################


  procedure TW3ToggleSwitch.InitializeObject;
  begin
    inherited;
    (* Create the "ON" label *)
    FOnText:=TW3ToggleOnLabel.Create$4(Self);
    FOnText.Caption$2:='ON';
    FOnText.AlignText:=taCenter;
    FOnText.Font.Color$1:=clWhite;

    (* Create the "OFF" label *)
    FOffText:=TW3ToggleOffLabel.Create$4(Self);
    FOffText.Caption$2:='OFF';
    FOffText.Font.Color$1:=clBlack;
    FOffText.AlignText:=taCenter;

    (* Create our leaver knob *)
    FKnob:=TW3ToggleKnob.Create$4(Self);

    (* setup internal handlers *)
    Self.OnMouseDown:=HandleMouseDown;

    Self.OnTouchBegin:=HandleTouch;
  end;

  class function TW3ToggleSwitch.supportAdjustment:Boolean;
  Begin
    Result:=False;
  end;

  Procedure TW3ToggleSwitch.FinalizeObject;
  Begin
    FKnob.Free;
    FOffText.Free;
    FOnText.Free;
    inherited;
  end;

  function  TW3ToggleSwitch.getChecked:Boolean;
  Begin
    Result:=FKnob.Left$1>0;
  end;

  procedure TW3ToggleSwitch.setChecked(Const aValue:Boolean);
  Begin
    if aValue<>getChecked then
      Toggle;
  end;

  Procedure TW3ToggleSwitch.Toggle;
  Begin
    case getChecked of
    True:   FKnob.Left$1:=0;
    False:  FKnob.Left$1:=(ClientWidth div 2) - CNT_TOGGLESWITCH_BARBUST;
    end;
    w3_Callback(
      procedure ()
      begin
        if Assigned(OnChanged) then
           OnChanged(Self);
      end,
      300);
  end;

  Procedure TW3ToggleSwitch.HandleTouch(Sender: TObjectTObject; Info: TW3TouchDataTW3TouchData);
  Begin
    Toggle;
  end;

  procedure TW3ToggleSwitch.HandleMouseDown(sender:TObjectTObject;
            button:TMouseButtonTMouseButton;
            shiftState:TShiftStateTShiftState;
            x, y : Integer);
  Begin
    if button=mbLeft then
    Toggle;
  end;

  procedure TW3ToggleSwitch.Resize;
  var
    mTemp:  Integer;
    wd: Integer;
    hd: Integer;
    {$IFDEF CHECK_FIREFOX}
    mHSpace:  Integer;
    mVSpace:  Integer;
    {$ENDIF}
  Begin
    wd:=ClientWidth;
    hd:=ClientHeight;
    if (wd>0) and (hd>0) then
    begin

      {$IFDEF CHECK_FIREFOX}
      if w3system.w3_BrowserVendor<>bvFirefox then
      Begin
        mHSpace:=Border.getHSpace;
        mVSpace:=Border.getVSpace;
      end;
      {$ENDIF}

      mTemp:=(wd div 2);
      if (FKnob.Width$1<>mTemp)
      or (FKnob.Height$1<>hd) then
      {$IFDEF CHECK_FIREFOX}
      FKnob.SetSize((mTemp + CNT_TOGGLESWITCH_BARBUST)-mHSpace,hd-mVSpace);
      {$ELSE}
      FKnob.SetSize(mTemp + CNT_TOGGLESWITCH_BARBUST,hd);
      {$ENDIF}
      FOnText.SetBounds(0,0,mTemp,hd);
      FOffText.SetBounds(mTemp,0,mTemp,hd);
    end;
  end;


end.
