unit w3scrollbar;

interface

uses
  W3System, W3Components, W3MouseCapture;

  const
  CNT_SCROLLBAR_THUMB_SIZE  = 28;


type

  TW3ScrollbarLowerBtn  = Class(TW3CustomControl);
  TW3ScrollbarHigherBtn = class(TW3CustomControl);
  TW3ScrollbarHandle    = class(TW3CustomControl);

  TW3CustomScrollBar = Class(TW3CustomControl)
  private
    FUpBtn:     TW3ScrollbarLowerBtn;
    FDownBtn:   TW3ScrollbarHigherBtn;
    FHandle:    TW3ScrollbarHandle;
    FTotal:     Integer;
    FPageSize:  Integer;
    FPosition:  Integer;
  protected
    Procedure   HandleMinClick(Sender:TObjectTObject);virtual;
    procedure   HandleMaxClick(Sender:TObjectTObject);virtual;
    Procedure   setTotal(aValue:Integer);virtual;
    procedure   setPageSize(aValue:Integer);virtual;
    Procedure   setPosition(aValue:Integer);virtual;
    Procedure   setPositionNoCalc(aValue:Integer);virtual;
    function    calcSizeOfHandle:Integer;
    function    PositionToPixelOffset(aPosition:Integer):Integer;
    function    PixelOffsetToPosition(aPxPos:Integer):Integer;
    Procedure   Recalculate;virtual;abstract;
    function    getArea:Integer;virtual;abstract;
    procedure   InitializeObject; override;
    procedure   FinalizeObject; override;
  public
    class function supportAdjustment:Boolean;override;
    Property    MinButton:TW3ScrollbarLowerBtn read FUpBtn;
    property    MaxButton:TW3ScrollbarHigherBtn read FDownBtn;
    Property    DragHandle:TW3ScrollbarHandle read FHandle;
  published
    Property    Total:Integer read FTotal write setTotal;
    Property    PageSize:Integer read FPageSize write setPageSize;
    Property    Position:Integer read FPosition write setPosition;
  End;

  TW3VerticalScrollbar = Class(TW3CustomScrollBar)
  private
    FDragSize:  Integer;
    FDragPos:   Integer;
    FMoving:    Boolean;
    FEntry:     Integer;
    //Procedure   HandleMouseLeave(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    Procedure   HandleDragBarMouseDown(sender:TObjectTObject;button:TMouseButtonTMouseButton;
                shiftState:TShiftStateTShiftState;x,y:Integer);
    procedure   HandleDragBarMouseUp(sender:TObjectTObject;button:TMouseButtonTMouseButton;
                shiftState:TShiftStateTShiftState;x,y:Integer);
    procedure   HandleDragBarMouseMove(sender:TObjectTObject;
                shiftState:TShiftStateTShiftState;x,y:Integer);
  protected
    procedure InitializeObject; override;
    procedure Resize;Override;
    function  getArea:Integer;override;
    Procedure Recalculate;override;
  End;

  TW3HorizontalScrollbar = Class(TW3CustomScrollBar)
  private
    FDragSize:  Integer;
    FDragPos:   Integer;
    FMoving:    Boolean;
    FEntry:     Integer;
    //Procedure   HandleMouseLeave(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    Procedure   HandleDragBarMouseDown(sender:TObjectTObject;button:TMouseButtonTMouseButton;
                shiftState:TShiftStateTShiftState;x,y:Integer);
    procedure   HandleDragBarMouseUp(sender:TObjectTObject;button:TMouseButtonTMouseButton;
                shiftState:TShiftStateTShiftState;x,y:Integer);
    procedure   HandleDragBarMouseMove(sender:TObjectTObject;
                shiftState:TShiftStateTShiftState;x,y:Integer);
  protected
    procedure InitializeObject; override;
    procedure Resize;Override;
    function  getArea:Integer;override;
    Procedure Recalculate;override;
  End;


Implementation


  //###########################################################################
  // TW3CustomScrollBar
  //###########################################################################

  procedure TW3CustomScrollBar.InitializeObject;
  Begin
    inherited;
    FUpBtn:=TW3ScrollbarLowerBtn.Create$4(Self);
    FUpBtn.OnClick:=HandleMinClick;

    FDownBtn:=TW3ScrollbarHigherBtn.Create$4(Self);
    FDownBtn.OnClick:=HandleMaxClick;

    FHandle:=TW3ScrollbarHandle.Create$4(Self);
  end;

  procedure TW3CustomScrollBar.FinalizeObject;
  Begin
    FUpBtn.Free;
    FDownBtn.Free;
    FHandle.Free;
    inherited;
  end;

  Procedure TW3CustomScrollBar.HandleMinClick(Sender:TObjectTObject);
  Begin
    if FTotal>0 then
    setPosition(FPosition-FPageSize);
  end;

  procedure TW3CustomScrollBar.HandleMaxClick(Sender:TObjectTObject);
  Begin
    if FTotal>0 then
    setPosition(FPosition+FPageSize);
  end;

  class function TW3CustomScrollBar.supportAdjustment:Boolean;
  Begin
    Result:=false;
  end;

  Procedure TW3CustomScrollBar.setTotal(aValue:Integer);
  Begin
    aValue:=TInteger.EnsureRange(aValue,0,MAX_INT);
    if aValue<>FTotal then
    Begin
      FTotal:=aValue;

      if FPageSize>FTotal then
      FPageSize:=FTotal;

      if FPosition>FTotal-FPageSize then
      Begin
        if (FTotal-FPageSize)<1 then
        FPosition:=0 else
        FPosition:=FTotal-FPageSize;
      end;
      Recalculate;
      LayoutChildren;

      if Assigned(OnChanged) then
        OnChanged(Self);
    end;
  end;

  procedure TW3CustomScrollBar.setPageSize(aValue:Integer);
  Begin
    aValue:=TInteger.EnsureRange(aValue,0,FTotal);
    if aValue<>FPageSize then
    Begin
      FPageSize:=aValue;
      if FTotal>0 then
      Begin
        Recalculate;
        LayoutChildren;
      end;
      if Assigned(OnChanged) then
        OnChanged(Self);
    end;
  end;

  Procedure TW3CustomScrollBar.setPosition(aValue:Integer);
  Begin
    aValue:=TInteger.EnsureRange(aValue,0,FTotal-FPageSize);
    if aValue<>FPosition then
    Begin
      FPosition:=aValue;
      if FTotal>0 then
      Begin
        Recalculate;
        LayoutChildren;
      end;
      if Assigned(OnChanged) then
        OnChanged(Self);
    end;
  end;

  Procedure TW3CustomScrollBar.setPositionNoCalc(aValue:Integer);
  Begin
    aValue:=TInteger.EnsureRange(aValue,0,FTotal-FPageSize);
    if aValue<>FPosition then
    Begin
      FPosition:=aValue;
      if Assigned(OnChanged) then
        OnChanged(Self);
    end;
  end;

  function TW3CustomScrollBar.calcSizeOfHandle:Integer;
  var
    mTemp:  Integer;
  Begin
    mTemp:=TInteger.PercentOfValue(PageSize,Total);
    Result:=Trunc( mTemp * getArea / 100);
  end;

  function TW3CustomScrollBar.PositionToPixelOffset(aPosition:Integer):Integer;
  var
    mTemp:  Integer;
  Begin
    mTemp:=TInteger.PercentOfValue(aPosition,Total);
    Result:=Trunc( mTemp * getArea / 100);
  end;

  function TW3CustomScrollBar.PixelOffsetToPosition(aPxPos:Integer):Integer;
  var
    mTemp: Integer;
  Begin
    mTemp:=TInteger.PercentOfValue(aPxPos,getArea);
    Result:=Trunc( (mTemp * Total) / 100 );
  end;

  //###########################################################################
  // TW3HorizontalScrollbar
  //###########################################################################

  procedure TW3HorizontalScrollbar.InitializeObject;
  Begin
    inherited;
    FMoving:=False;

    (* Set correct styles for -/+ and leaver *)
    MinButton.StyleClass:='TW3ScrollbarLeftBtn';
    MaxButton.StyleClass:='TW3ScrollbarRightBtn';
    DragHandle.StyleClass:='TW3ScrollbarHandle';

    //self.OnMouseExit:=HandleMouseLeave;

    (* hook into our own events *)
    Self.OnMouseDown:=HandleDragBarMouseDown;
    Self.OnMouseMove:=HandleDragBarMouseMove;
    Self.OnMouseUp:=HandleDragBarMouseUp;
  end;

  function TW3HorizontalScrollbar.getArea:Integer;
  Begin
    Result:=(MaxButton.Left$1-1) - (MinButton.BoundsRect$1.Right$1 + 1);
  end;

  Procedure TW3HorizontalScrollbar.HandleDragBarMouseDown(sender:TObjectTObject;
            button:TMouseButtonTMouseButton;shiftState:TShiftStateTShiftState;x,y:Integer);
  Begin
    if button=mbLeft then
    Begin
      if DragHandle.BoundsRect$1.ContainsPos$1(x,y) then
      Begin
        SetCapture;
        FEntry:=x - DragHandle.Left$1;
        FMoving:=True;
      end else
      Begin
        if  (x<DragHandle.Left$1)
        and not MinButton.BoundsRect$1.ContainsPos$1(x,y) then
        setPosition(Position - PageSize) else

        if (x>DragHandle.BoundsRect$1.Right$1)
        and not MaxButton.BoundsRect$1.ContainsPos$1(x,y) then
        setPosition(Position + PageSize);
      end;
    end;

  end;

  procedure TW3HorizontalScrollbar.HandleDragBarMouseMove(sender:TObjectTObject;
            shiftState:TShiftStateTShiftState;x,y:Integer);
  var
    mNewPos:  Integer;
    dx: Integer;
  Begin
    if FMoving then
    Begin
      (* take offset on draghandle into account *)
      dx:=x - FEntry;

      (* position draghandle *)
      DragHandle.Left$1:=TInteger.EnsureRange(dx,
        MinButton.BoundsRect$1.Right$1,
        MaxButton.Left$1 - FDragSize);

      (* Update position based on draghandle *)
      mNewPos:=PixelOffsetToPosition(DragHandle.Left$1-(MinButton.BoundsRect$1.Right$1+1));
      setPositionNoCalc(mNewPos);
    end;
  end;

  procedure TW3HorizontalScrollbar.HandleDragBarMouseUp(sender:TObjectTObject;
            button:TMouseButtonTMouseButton;
            shiftState:TShiftStateTShiftState;x,y:Integer);
  Begin
    if FMoving then
    Begin
      FMoving:=False;
      setPosition(PixelOffsetToPosition
      (DragHandle.Left$1 - (MinButton.BoundsRect$1.Right$1+1) ));
      ReleaseCapture;
    end;
  end;

  procedure TW3HorizontalScrollbar.Resize;
  var
    mLeft: Integer;
  Begin
    inherited;

    MinButton.SetBounds(0,0,CNT_SCROLLBAR_THUMB_SIZE,ClientHeight);
    MaxButton.SetBounds((ClientWidth-CNT_SCROLLBAR_THUMB_SIZE),0,
    CNT_SCROLLBAR_THUMB_SIZE,ClientHeight);

    Recalculate;

    if (Total<1)
    or (FDragPos<0) then
    DragHandle.Visible$1:=False else
    DragHandle.Visible$1:=True;

    mLeft:=MinButton.Left$1 + MinButton.Width$1 +  1 + FDragPos;
    DragHandle.SetBounds(mLeft,2,FDragSize,ClientHeight-4);
  end;

  Procedure TW3HorizontalScrollbar.Recalculate;
  Begin
    FDragSize:=calcSizeOfHandle;
    FDragPos:=PositionToPixelOffset(Position);
  end;


  //###########################################################################
  // TW3VerticalScrollbar
  //###########################################################################

  procedure TW3VerticalScrollbar.InitializeObject;
  Begin
    inherited;
    FMoving:=False;

    (* Set correct styles for -/+ and leaver *)
    MinButton.StyleClass:='TW3ScrollbarDownBtn';
    MaxButton.StyleClass:='TW3ScrollbarUpBtn';
    DragHandle.StyleClass:='TW3ScrollbarHandle';

    (* hook into our own events *)
    Self.OnMouseDown:=HandleDragBarMouseDown;
    Self.OnMouseMove:=HandleDragBarMouseMove;
    Self.OnMouseUp:=HandleDragBarMouseUp;
  end;

  function TW3VerticalScrollbar.getArea:Integer;
  Begin
    Result:=(MaxButton.Top$1-1) - (MinButton.BoundsRect$1.Bottom$1 + 1);
  end;

  Procedure TW3VerticalScrollbar.HandleDragBarMouseDown(sender:TObjectTObject;
            button:TMouseButtonTMouseButton;shiftState:TShiftStateTShiftState;x,y:Integer);
  Begin
    if button=mbLeft then
    Begin
      if DragHandle.BoundsRect$1.ContainsPos$1(x,y) then
      Begin
        SetCapture;
        FEntry:=y - DragHandle.Top$1;
        FMoving:=True;
      end else
      Begin
        if  (y<DragHandle.Top$1)
        and not MinButton.BoundsRect$1.ContainsPos$1(x,y) then
        setPosition(Position - PageSize) else

        if (y>DragHandle.BoundsRect$1.Bottom$1)
        and not MaxButton.BoundsRect$1.ContainsPos$1(x,y) then
        setPosition(Position + PageSize);
      end;
    end;

  end;

  procedure TW3VerticalScrollbar.HandleDragBarMouseMove(sender:TObjectTObject;
            shiftState:TShiftStateTShiftState;x,y:Integer);
  var
    mNewPos:  Integer;
    dy: Integer;
  Begin
    if FMoving then
    Begin
      (* take offset on draghandle into account *)
      dy:=y - FEntry;

      (* position draghandle *)
      DragHandle.Top$1:=TInteger.EnsureRange(dy,
        MinButton.BoundsRect$1.Bottom$1,
        MaxButton.Top$1 - FDragSize);

      (* Update position based on draghandle *)
      mNewPos:=PixelOffsetToPosition(DragHandle.Top$1-(MinButton.BoundsRect$1.Bottom$1+1));
      setPositionNoCalc(mNewPos);
    end;
  end;

  procedure TW3VerticalScrollbar.HandleDragBarMouseUp(sender:TObjectTObject;
            button:TMouseButtonTMouseButton;
            shiftState:TShiftStateTShiftState;x,y:Integer);
  Begin
    if FMoving then
    Begin
      FMoving:=False;
      setPosition(PixelOffsetToPosition
      (DragHandle.Top$1 - (MinButton.BoundsRect$1.Bottom$1+1) ));
      ReleaseCapture;
    end;
  end;

  procedure TW3VerticalScrollbar.Resize;
  var
    mTop: Integer;
  Begin
    inherited;

    MinButton.SetBounds(0,0,ClientWidth,CNT_SCROLLBAR_THUMB_SIZE);
    MaxButton.SetBounds(0,(ClientHeight-CNT_SCROLLBAR_THUMB_SIZE),
                        ClientWidth,CNT_SCROLLBAR_THUMB_SIZE);

    Recalculate;

    if (Total<1)
    or (FDragPos<0) then
    DragHandle.Visible$1:=False else
    DragHandle.Visible$1:=True;

    mTop:=MinButton.Top$1 + MinButton.Height$1 +  1 + FDragPos;
    DragHandle.SetBounds(2,mTop,ClientWidth-4,FDragSize);
  end;

  Procedure TW3VerticalScrollbar.Recalculate;
  Begin
    FDragSize:=calcSizeOfHandle;
    FDragPos:=PositionToPixelOffset(Position);
  end;



end.
