{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3ListBox;

{------------------------------------------------------------------------------}
{ Author:    Primož Gabrijelèiè                                                }
{ Updated:   2012.11.09 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

//TODO: Scroll button support
//TODO: Ballistic scrolling
//TODO: Don't animate invisible items

//http://www.macresearch.org/dynamics-scrolling
//http://www.adomas.org/javascript-mouse-wheel/
//http://stackoverflow.com/questions/10313142/javascript-capture-mouse-wheel-event-and-do-not-scroll-the-page
//http://www.switchonthecode.com/tutorials/javascript-tutorial-the-scroll-wheel

interface

uses
  W3System,  W3Graphics, W3Components, W3Touch, W3Lists, W3time,
  W3Animation, w3label, w3panel, w3paintbox;

type
  TW3CustomControlClass = class of TW3CustomControl;

  TW3ListBoxStyles = class
  private
    FHighlighted: string;
    FHighlightedColor: TColor;
    FHighlightVisible: boolean;
    FItem: string;
    FItemColor: TColor;
    FMoving: string;
    FMovingColor: TColor;
    FSelected: string;
    FSelectedColor: TColor;
    FSelectionVisible: boolean;
    FText: string;
  public
    constructor Create;
    property Highlighted: string read FHighlighted write FHighlighted;          //default 'TW3Panel'
    property HighlightedColor: TColor
      read FHighlightedColor write FHighlightedColor;                           //default clNone
    property HighlightVisible: boolean
      read FHighlightVisible write FHighlightVisible;                           //default True
    property Moving: string read FMoving write FMoving;                         //default 'TW3Panel'
    property MovingColor: TColor read FMovingColor write FMovingColor;          //default clGrey
    property Item: string read FItem write FItem;                               //default 'TW3Panel'
    property ItemColor: TColor read FItemColor write FItemColor;                //default clNone
    property Selected: string read FSelected write FSelected;                   //default 'TW3Panel'
    property SelectedColor: TColor read FSelectedColor write FSelectedColor;    //default clNone;
    property SelectionVisible: boolean
      read FSelectionVisible write FSelectionVisible;                           //default True
    property Text: string read FText write FText;                               //default 'TW3Label'
  end;

  ItemStyle = (Normal, Highlighted, Selected, Moving);

  TItemSelectedEvent TItemSelectedEvent: TObjectTObject; itemIndex: integer);

  TW3ScrollBar = class(TW3PaintBox)
  private
    FGlobalAlpha: float;
    FRangeHigh: integer;
    FRangeLow: integer;
    FViewHigh: integer;
    FViewLow: integer;
  protected
    function Interpolate(viewPos: integer): integer;
    procedure Paint; override;
  public
    constructor Create(AOwner: TW3ComponentTW3Component); override;
    procedure Hide(time_ms: integer = 0);
    procedure SetRange(rangeLow, rangeHigh: integer);
    procedure SetView(viewLow, viewHigh: integer);
    procedure Show(time_ms: integer = 0);
  end;

  TW3ListBox = class(TW3Panel)
  private
    FAllowMoving: boolean;
    FClickControl: TW3CustomControl;
    FControlStart: TPoint;
    FEnableAnimation: boolean;
    FHighlightedItem: TW3CustomControl;
    FInnerSpacing: integer;
    FItems: TObjectList;
    FItemClass: TW3CustomControlClass;
    FItemHeight: integer;
    FMousePosition: TPoint;
    FMoveStart: TPoint;
    FMoving: boolean;
    FMovingIndex: integer;
    FMovingItem: TW3CustomControl;
    FOnHighlighted: TItemSelectedEvent;
    FOnMouseDown: TMouseButtonEvent
    FOnMouseEnter: TMouseEventEvent;
    FOnMouseExit: TMouseEventvent;
    FOnMouseMove: TMouseEventvent;
    FOnMouseUp: TMouseButtonEvent
    FOnMouseWheel: TMouseWheelEvent;
    FOnSelected: TItemSelectedEvent;
    FOnTouchBegin: TTouchBeginEvent;
    FOnTouchMove: TTouchMoveEvent;
    FOnTouchEnd: TTouchEndEvent;
    FScrollBar: TW3ScrollBar;
    FScrolling: boolean;
    FScrollStart: TPoint;
    FSelectedItem: TW3CustomControl;
    FStartMoving: TW3EventRepeater;
    FStyles: TW3ListBoxStyles;
  protected
    procedure CreateTextItem(itemIndex: integer; s: string);
    procedure ColorItem(item: TW3CustomControlTW3CustomControl; itemStyle: string;
      itemColor: TColor; colorVisible: boolean);
    procedure Colorize(item: TW3CustomControlTW3CustomControl; style: ItemStyle);
    procedure DoHighlighted;
    procedure DoSelected;
    function  GetCount: integer;
    function  GetHighlightedIndex: integer;
    function  GetItem(idx: integer): TW3CustomControl;
    function  GetSelectedIndex: integer;
    function  GetText(idx: integer): string;
    function  GetTextChild(idx: integer): TW3Label;
    procedure HandleMouseDown(Sender: TObjectTObject; Button: TMouseButtonTMouseButton; Shift: TShiftStateTShiftState; X, Y: Integer);
    procedure HandleMouseEnter(Sender: TObjectTObject; Shift: TShiftStateTShiftState; X, Y: Integer);
    procedure HandleMouseExit(Sender: TObjectTObject; Shift: TShiftStateTShiftState; X, Y: Integer);
    procedure HandleMouseMove(Sender: TObjectTObject; Shift: TShiftStateTShiftState; X, Y: Integer);
    procedure HandleMouseUp(Sender: TObjectTObject; Button: TMouseButtonTMouseButton; Shift: TShiftStateTShiftState; X, Y: Integer);
    procedure HandleMouseWheel(Sender: TObjectTObject; Shift: TShiftStateTShiftState;
      wheelData: integer; const mousePos : TPointTPoint; var handled : Boolean);
    procedure HandleTouchBegin(Sender: TObjectTObject; Info: TW3TouchDataTW3TouchData);
    procedure HandleTouchMove(Sender: TObjectTObject; Info: TW3TouchDataTW3TouchData);
    procedure HandleTouchEnd(Sender: TObjectTObject; Info: TW3TouchDataTW3TouchData);
    function  ItemAtPos(X, Y: integer): TW3CustomControl;
    procedure ItemMoved;
    procedure ItemMoving;
    procedure Move(itemIndex, newTop: integer);
    procedure MoveNotify(itemIndex, newTop: integer; notifyAtEnd: TAnimationNotifyTAnimationNotify);
    procedure SetMovingItem(item: TW3CustomControlTW3CustomControl);
    procedure SetScrolling(value: boolean);
    procedure SetSelectedIndex(value: integer);
    procedure Scroll(dX, dY: integer);
    procedure UpdateScrollBar;
    property Scrolling: boolean read FScrolling write SetScrolling;
  public
    constructor Create(AOwner: TW3ComponentTW3Component); override;
    function  Add: integer; overload;
    function  Add(s: string): integer; overload;
    procedure Clear;
    procedure Delete(itemIndex: integer);
    function  IndexOf(item: TW3CustomControlTW3CustomControl): integer;
    procedure Insert(itemIndex: integer); overload;
    procedure Insert(itemIndex: integer; s: string); overload;
    procedure Resize; override;
    property AllowMoving: boolean read FAllowMoving write FAllowMoving;         //default False
    property Count: integer read GetCount;
    property EnableAnimation: boolean read FEnableAnimation
      write FEnableAnimation;                                                   //default True
    property HighlightedIndex: integer read GetHighlightedIndex;
    property HighlightedItem: TW3CustomControl read FHighlightedItem;
    property Items[idx: integer]: TW3CustomControl read GetItem; default;
    property ItemClass: TW3CustomControlClass read FItemClass write FItemClass; //default TW3Panel
    property ItemHeight: integer read FItemHeight write FItemHeight;            //default 32
    property InnerSpacing: integer read FInnerSpacing write FInnerSpacing;      //default 3
    property MovingItem: TW3CustomControl read FMovingItem write SetMovingItem;
    property SelectedIndex: integer read GetSelectedIndex write SetSelectedIndex;
    property SelectedItem: TW3CustomControl read FSelectedItem;
    property Styles: TW3ListBoxStyles read FStyles;
    property Text[idx: integer]: string read GetText;
    property OnHighlighted: TItemSelectedEvent read FOnHighlighted write FOnHighlighted;
    property OnMouseDown: TMouseButtonEventead FOnMouseDown write FOnMouseDown;
    property OnMouseEnter: TMouseEventEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseExit: TMouseEventvent read FOnMouseExit write FOnMouseExit;
    property OnMouseMove: TMouseEventvent read FOnMouseMove write FOnMouseMove;
    property OnMouseUp: TMouseButtonEventd FOnMouseUp write FOnMouseUp;
    property OnMouseWheel: TMouseWheelEvent read FOnMouseWheel write FOnMouseWheel;
    property OnSelected: TItemSelectedEvent read FOnSelected write FOnSelected;
    property OnTouchBegin: TTouchBeginEvent read FOnTouchBegin write FOnTouchBegin;
    property OnTouchMove: TTouchMoveEvent read FOnTouchMove write FOnTouchMove;
    property OnTouchEnd: TTouchEndEvent read FOnTouchEnd write FOnTouchEnd;
  end;

implementation

uses
  w3c.DOM;

const
  CAnimationTime_ms = 150;
  CScrollbarAnimationTime_ms = 350;
  CDelayStartMoving_ms = 750;
  CMinDistanceToMove = 7;

{ TW3ListBoxStyles }

constructor TW3ListBoxStyles.Create;
begin
  inherited Create;
  FHighlighted := 'TW3Panel';
  FHighlightedColor := clNone;
  FHighlightVisible := true;
  FItem := 'TW3Panel';
  FItemColor := clNone;
  FMoving := 'TW3Panel';
  FMovingColor := clGrey;
  FSelected := 'TW3Panel';
  FSelectedColor := clNone;
  FSelectionVisible := true;
  FText := 'TW3Label';
end;

{ TW3ListBox }

constructor TW3ListBox.Create(AOwner: TW3ComponentTW3Component);
begin
  inherited Create$4(AOwner);
  FItems := TObjectList.Create$17;
  FStyles := TW3ListBoxStyles.Create;
  FScrollBar := TW3ScrollBar.Create(Self);
  FScrollBar.Hide;
  FEnableAnimation := true;
  FInnerSpacing := 3;
  FItemClass := TW3Panel;
  FItemHeight := 32;
  Color := clWhite;
  StyleClass := 'TW3Panel';
  inherited OnMouseDown := HandleMouseDown;
  inherited OnMouseEnter := HandleMouseEnter;
  inherited OnMouseExit := HandleMouseExit;
  inherited OnMouseMove := HandleMouseMove;
  inherited OnMouseUp := HandleMouseUp;
  inherited OnTouchBegin := HandleTouchBegin;
  inherited OnTouchMove := HandleTouchMove;
  inherited OnTouchEnd := HandleTouchEnd;
  inherited OnMouseWheel := HandleMouseWheel;
end;

function TW3ListBox.Add: integer;
begin
  var item := ItemClass.Create$4(Self);
  Colorize(item, ItemStyle.Normal);
  item.SetBounds(
    FInnerSpacing,
    FInnerSpacing + Count * (ItemHeight + 1),
    ClientWidth - 2*FInnerSpacing,
    ItemHeight);
  item.BringToFront;
  Result := FItems.Add(item);
  UpdateScrollBar;
end;

function TW3ListBox.Add(s: string): integer;
begin
  Result := Add;
  CreateTextItem(Result, s);
end;

procedure TW3ListBox.CreateTextItem(itemIndex: integer; s: string);
begin
  var lbl := TW3Label.Create$4(Items[itemIndex]);
  lbl.StyleClass := Styles.Text;
  lbl.SetBounds(InnerSpacing, InnerSpacing,
    Items[itemIndex].ClientWidth - 2*InnerSpacing,
    Items[itemIndex].ClientHeight - 2*InnerSpacing);
  lbl.Caption$2 := s;
end;

procedure TW3ListBox.ColorItem(item: TW3CustomControlTW3CustomControl; itemStyle: string;
  itemColor: TColor; colorVisible: boolean);
begin
  if colorVisible then begin
    item.StyleClass := itemStyle;
    item.Color := itemColor;
  end;
end;

procedure TW3ListBox.Colorize(item: TW3CustomControlTW3CustomControl; style: ItemStyle);
begin
  if not Assigned(item) then Exit;
  case style of
    ItemStyle.Normal:
      begin
        if item <> FSelectedItem then
          ColorItem(item, Styles.Item, Styles.ItemColor, Styles.SelectionVisible or Styles.HighlightVisible)
        else
          ColorItem(item, Styles.Selected, Styles.SelectedColor, Styles.SelectionVisible);
        if item = FHighlightedItem then begin
          FHighlightedItem := nil;
          DoHighlighted;
        end;
      end;
    ItemStyle.Highlighted:
      begin
        if Assigned(FHighlightedItem) and (FHighlightedItem <> item) then
          Colorize(FHighlightedItem, ItemStyle.Normal);
        if item <> FSelectedItem then
          ColorItem(item, Styles.Highlighted, Styles.HighlightedColor, Styles.HighlightVisible)
        else
          ColorItem(item, Styles.Selected, Styles.SelectedColor, Styles.SelectionVisible);
        FHighlightedItem := item;
        FMovingItem := nil;
        DoHighlighted;
      end;
    ItemStyle.Selected:
      begin
        if Assigned(FSelectedItem) and (FSelectedItem <> item) then
          ColorItem(FSelectedItem, Styles.Item, Styles.ItemColor, Styles.SelectionVisible);
        ColorItem(item, Styles.Selected, Styles.SelectedColor, Styles.SelectionVisible);
        FSelectedItem := item;
        DoSelected;
      end;
    ItemStyle.Moving:
      begin
        FMovingItem := item;
        ColorItem(item, Styles.Moving, Styles.MovingColor, true);
      end;
  end;
end;

procedure TW3ListBox.Clear;
begin
  FSelectedItem := nil;
  FHighlightedItem := nil;
  for var i := 0 to FItems.Count - 1 do FItems[i].Free;
  FItems.Clear;
  UpdateScrollBar;
end;

procedure TW3ListBox.Delete(itemIndex: integer);
begin
  var item := Items[itemIndex];
  var selIndex := SelectedIndex;
  if item = FSelectedItem then begin
    FSelectedItem := nil;
    DoSelected;
  end;
  if item = FHighlightedItem then begin
    FHighlightedItem := nil;
    DoHighlighted;
  end;
  FItems.Remove(itemIndex);
  item.Free;
  if itemIndex >= Count then begin
    if selIndex = itemIndex then
      SelectedIndex := selIndex - 1;
  end
  else
    //TODO: do animation only for visible items
    for var iItem := itemIndex to Count - 1 do
      if iItem = selIndex then
        MoveNotify(iItem, Items[iItem].Top$1 - ItemHeight - 1,
          procedure begin
            if selIndex >= Count then Dec(selIndex);
            SelectedIndex := selIndex;
          end)
      else
        Move(iItem, Items[iItem].Top$1 - ItemHeight - 1);
  UpdateScrollBar;
end;

procedure TW3ListBox.DoHighlighted;
begin
  if Assigned(FOnHighlighted) then
    FOnHighlighted(Self, HighlightedIndex);
end;

procedure TW3ListBox.DoSelected;
begin
  if Assigned(FOnSelected) then
    FOnSelected(Self, SelectedIndex);
end;

function TW3ListBox.GetCount: integer;
begin
  Result := FItems.Count;
end;

function TW3ListBox.GetHighlightedIndex: integer;
begin
  Result := IndexOf(FHighlightedItem);
end;

function TW3ListBox.GetItem(idx: integer): TW3CustomControl;
begin
  Result := TW3CustomControl(FItems[idx]);
end;

function TW3ListBox.GetSelectedIndex: integer;
begin
  Result := IndexOf(FSelectedItem);
end;

function TW3ListBox.GetText(idx: integer): string;
begin
  Result := '';
  var child := GetTextChild(idx);
  if Assigned(child) then
    Result := child.Caption$2;
end;

function TW3ListBox.GetTextChild(idx: integer): TW3Label;
begin
  Result := nil;
  var item := Items[idx];
  for var iChild := 0 to item.GetChildCount - 1 do begin
    var obj := item.GetChildObject(iChild);
    if Assigned(obj) and (obj is TW3Label) then
      Exit(TW3Label(obj));
  end;
end;

procedure TW3ListBox.HandleMouseDown(Sender: TObjectTObject; Button: TMouseButtonTMouseButton; Shift: TShiftStateTShiftState; X, Y: Integer);
begin
  if Enabled then begin
    FMousePosition := TPoint.Create$16(X, Y);
    FMoveStart := TPoint.Create$16(X, Y);
    FScrollStart := TPoint.Create$16(X, Y);
    FClickControl := ItemAtPos(X, Y);
    if Assigned(FClickControl) then begin
      FControlStart := TPoint.Create$16(FClickControl.Left$1, FClickControl.Top$1);
      FClickControl.BringToFront;
      FScrollBar.BringToFront;
      Colorize(FClickControl, ItemStyle.Selected);
    end;
    if AllowMoving then begin
      FStartMoving := TW3EventRepeater.Create$39(
        function (Sender: TObjectTObject): Boolean
        begin
          if (Sqr$_Integer_(FMousePosition.X$1 - FMoveStart.X$1) + Sqr$_Integer_(FMousePosition.Y$1 - FMoveStart.Y$1)) <=
              Sqr$_Integer_(CMinDistanceToMove)
          then begin
            Colorize(MovingItem, ItemStyle.Moving);
            FMoving := true;
          end;
          Result := true; //release timer
        end,
        CDelayStartMoving_ms);
      MovingItem := FClickControl;
    end;
    Scrolling := true;
  end;
  if Assigned(FOnMouseDown) then
    FOnMouseDown(Self, Button, Shift, X, Y);
end;

procedure TW3ListBox.HandleMouseEnter(Sender: TObjectTObject; Shift: TShiftStateTShiftState; X, Y: Integer);
begin
  if Enabled then begin
    FMousePosition := TPoint.Create$16(X, Y);
    if not Assigned(MovingItem) then
      Colorize(ItemAtPos(X, Y), ItemStyle.Highlighted);
  end;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self, Shift, X, Y);
end;

procedure TW3ListBox.HandleMouseExit(Sender: TObjectTObject; Shift: TShiftStateTShiftState; X, Y: Integer);
begin
  if Enabled then begin
    FMousePosition := TPoint.Create$16(X, Y);
    if not FMoving then
      Colorize(HighlightedItem, ItemStyle.Normal);
  end;
  if Assigned(FOnMouseExit) then
    FOnMouseExit(Self, Shift, X, Y);
end;

procedure TW3ListBox.HandleMouseMove(Sender: TObjectTObject; Shift: TShiftStateTShiftState; X, Y: Integer);
begin
  if Enabled then begin
    FMousePosition := TPoint.Create$16(X, Y);
    if FMoving then begin
      MovingItem.Top$1 := FControlStart.Y$1 + Y - FMoveStart.Y$1;
      ItemMoving;
    end
    else if Scrolling then begin
      Scroll(X - FScrollStart.X$1, Y - FScrollStart.Y$1);
      FScrollStart := TPoint.Create$16(X, Y);
    end;
  end;
  if Assigned(FOnMouseMove) then
    FOnMouseMove(Self, Shift, X, Y);
end;

procedure TW3ListBox.HandleMouseUp(Sender: TObjectTObject; Button: TMouseButtonTMouseButton; Shift: TShiftStateTShiftState; X, Y: Integer);
begin
  if Enabled then begin
    FMousePosition := TPoint.Create$16(X, Y);
    Colorize(ItemAtPos(X, Y), ItemStyle.Highlighted);
    if FMoving then begin
      ItemMoved;
      MovingItem := nil;
    end;
    FMoving := false;
    Scrolling := false;
    FStartMoving.Free;
  end;
  if Assigned(FOnMouseUp) then
    FOnMouseUp(Self, Button, Shift, X, Y);
end;

procedure TW3ListBox.HandleMouseWheel(Sender: TObjectTObject; Shift: TShiftStateTShiftState;
  wheelData: integer; const mousePos : TPointTPoint; var handled : Boolean);
begin
  if Enabled then
    Scroll(0, wheelData * (ItemHeight + 1) div 3);
  if Assigned(FOnMouseWheel) then
    FOnMouseWheel(Self, Shift, wheelData, mousePos, handled);
end;

procedure TW3ListBox.HandleTouchBegin(Sender: TObjectTObject; Info: TW3TouchDataTW3TouchData);
begin
  var sr := ScreenRect; 
  TShiftState.Current.Event := JKeyStateEvent(w3_event);
  HandleMouseDown(Sender, mbLeft, TShiftState.Current,
    Info.ChangedTouches[0].ScreenX - sr.Left$3, Info.ChangedTouches[0].ScreenY - sr.Top$3);
  if Assigned(FOnTouchBegin) then
    FOnTouchBegin(Self, Info);
end;

procedure TW3ListBox.HandleTouchMove(Sender: TObjectTObject; Info: TW3TouchDataTW3TouchData);
begin
  var sr := ScreenRect;
  TShiftState.Current.Event := JKeyStateEvent(w3_event);
  HandleMouseMove(Sender, TShiftState.Current,
    Info.ChangedTouches[0].ScreenX - sr.Left$3, Info.ChangedTouches[0].ScreenY - sr.Top$3);
  if Assigned(FOnTouchMove) then
    FOnTouchMove(Self, Info);
end;

procedure TW3ListBox.HandleTouchEnd(Sender: TObjectTObject; Info: TW3TouchDataTW3TouchData);
begin
  var sr := ScreenRect;
  TShiftState.Current.Event := JKeyStateEvent(w3_event);
  HandleMouseUp(Sender, mbLeft, TShiftState.Current,
    Info.ChangedTouches[0].ScreenX - sr.Left$3, Info.ChangedTouches[0].ScreenY - sr.Top$3);
  if Assigned(FOnTouchEnd) then
    FOnTouchEnd(Self, Info);
end;

function TW3ListBox.IndexOf(item: TW3CustomControlTW3CustomControl): integer;
begin
  if Assigned(item) then
    for Result := 0 to Count - 1 do
      if FItems[Result] = item then
        Exit;
  Result := -1;
end;

function TW3ListBox.ItemAtPos(X, Y: integer): TW3CustomControl;
begin
  if Count = 0 then Result := nil
  else begin
    var idx := (Y {- Top} - FInnerSpacing - Items[0].Top$1) div (ItemHeight + 1);
    if (idx < 0) or (idx >= Count) then
      Result := nil
    else
      Result := Items[idx];
  end;
end;

procedure TW3ListBox.Insert(itemIndex: integer);
begin
  var item := ItemClass.Create$4(Self);
  Colorize(item, ItemStyle.Normal);
  item.SetBounds(
    FInnerSpacing,
    FInnerSpacing + itemIndex * (ItemHeight + 1),
    ClientWidth - 2*FInnerSpacing,
    ItemHeight);
  FItems.Insert$1(itemIndex, item);
  //TODO do this only for visible items
  for var iItem := itemIndex+1 to Count - 1 do
    Move(iItem, Items[iItem].Top$1 + ItemHeight + 1);
  UpdateScrollBar;
end;

procedure TW3ListBox.Insert(itemIndex: integer; s: string);
begin
  Insert(itemIndex);
  CreateTextItem(itemIndex, s);
end;

procedure TW3ListBox.ItemMoved;
begin
  Move(FMovingIndex, FInnerSpacing + FMovingIndex * (ItemHeight + 1));
end;

procedure TW3ListBox.ItemMoving;
begin
  if (FMovingIndex < (Count - 1)) and
     ((Items[FMovingIndex].Top$1 + (ItemHeight div 2)) > Items[FMovingIndex+1].Top$1) and
     (not Animation[Items[FMovingIndex+1]].IsActive) then
  begin
    FItems.Swap$1(FMovingIndex, FMovingIndex+1);
    Inc(FMovingIndex);
    Move(FMovingIndex-1, Items[FMovingIndex-1].Top$1 - ItemHeight - 1);
  end
  else
  if (FMovingIndex > 0) and
     (Items[FMovingIndex].Top$1 < (Items[FMovingIndex-1].Top$1 + (ItemHeight div 2))) and
     (not Animation[Items[FMovingIndex-1]].IsActive) then
  begin
    FItems.Swap$1(FMovingIndex, FMovingIndex-1);
    Dec(FMovingIndex);
    Move(FMovingIndex+1, Items[FMovingIndex+1].Top$1 + ItemHeight + 1);
  end;
end;

procedure TW3ListBox.Move(itemIndex, newTop: integer);
begin
  MoveNotify(itemIndex, newTop, procedure begin end);
end;

procedure TW3ListBox.MoveNotify(itemIndex, newTop: integer; notifyAtEnd: TAnimationNotifyTAnimationNotify);
begin
  if EnableAnimation then
    Animation[Items[itemIndex]].Move$2(CAnimationTime_ms,
      Items[itemIndex].Left$1, newTop,
      Animation.Config.SetOnCompleted(notifyAtEnd))
  else begin
    Items[itemIndex].Top$1 := newTop;
    notifyAtEnd;
  end;
end;

procedure TW3ListBox.Resize;
var
  bounds: TRect;
  rightMargin: integer;
begin
  inherited;
  for var iItem := 0 to Count - 1 do begin
    var item := Items[iItem];
    var text := GetTextChild(iItem);
    if Assigned(text) then begin
      bounds := text.BoundsRect$1;
      rightMargin := item.ClientWidth - bounds.Width$3;
    end;
    item.SetBounds(
      FInnerSpacing,
      FInnerSpacing + iItem * (ItemHeight + 1),
      ClientWidth - 2*FInnerSpacing,
      ItemHeight);
    if Assigned(text) then
      text.SetBounds(bounds.Left$3, bounds.Top$3,
        item.ClientWidth - rightMargin,
        bounds.Height$3);
  end;
  FScrollBar.SetBounds(ClientWidth - 6, 2, 4, ClientHeight - 4);
  FScrollBar.SetView(0, ClientHeight);
end;

procedure TW3ListBox.Scroll(dX, dY: integer);
begin
  if (dY = 0) or (Count = 0) then Exit;
  if (dY > 0) and (Items[0].Top$1 >= 0) then Exit;
  if (dY < 0) and ((Items[Count - 1].Top$1 + ItemHeight) <= ClientHeight) then Exit;
  if (dY > 0) and ((Items[0].Top$1 + dY) > 0) then
    dY := -Items[0].Top$1;
  if (dY < 0) and ((Items[Count - 1].Top$1 + ItemHeight + dY) < ClientHeight) then
    dY := ClientHeight - (Items[Count - 1].Top$1 + ItemHeight);
  for var iItem := 0 to Count - 1 do
    Items[iItem].Top$1 := Items[iItem].Top$1 + dY;
  UpdateScrollBar;
end;

procedure TW3ListBox.SetMovingItem(item: TW3CustomControlTW3CustomControl);
begin
  FMovingItem := item;
  FMovingIndex := IndexOf(item);
end;

procedure TW3ListBox.SetScrolling(value: boolean);
begin
  FScrolling := value;
  if FScrolling then
    FScrollBar.Show(CScrollbarAnimationTime_ms)
  else
    FScrollBar.Hide(CScrollbarAnimationTime_ms);
end;

procedure TW3ListBox.SetSelectedIndex(value: integer);
begin
  if value < 0 then begin
    if Assigned(FSelectedItem) then begin
      var oldSelected := FSelectedItem;
      FSelectedItem := nil;
      Colorize(oldSelected, ItemStyle.Normal);
    end;
  end
  else
    Colorize(FItems[value]as TW3CustomControl, ItemStyle.Selected);
  DoSelected;
end;

procedure TW3ListBox.UpdateScrollBar;
begin
  if Count = 0 then
    FScrollBar.SetRange(0, 0)
  else begin
    FScrollBar.SetRange(Items[0].Top$1, Items[Count - 1].Top$1 + ItemHeight);
  end;
end;

{ TW3ScrollBar }

constructor TW3ScrollBar.Create(AOwner: TW3ComponentTW3Component);
begin
  inherited Create$4(AOwner);
  FGlobalAlpha := 0;
end;

procedure TW3ScrollBar.Hide(time_ms: integer);
begin
  if time_ms <= 0 then begin
    Visible$1 := false;
    FGlobalAlpha := 0;
    Invalidate;
  end
  else begin
    var loop := 0;
    Animation[Self].Animate(time_ms,
      procedure (progress: float)
      begin
        if loop = 1 then SendToBack;
        FGlobalAlpha := 1-progress;
        if progress = 1 then Visible$1 := false;
        Invalidate;
        Inc(loop);
      end);
  end;
end;

function TW3ScrollBar.Interpolate(viewPos: integer): integer;
begin
  Result := Round((viewPos - FRangeLow)/(FRangeHigh - FRangeLow)*ClientHeight);
end;

procedure TW3ScrollBar.Paint;
begin
  Canvas.GlobalAlpha := 1;
  Canvas.FillStyle := 'rgb(255, 255, 255)';
  Canvas.FillRectF$2(0, 0, ClientWidth, ClientHeight);
  Canvas.GlobalAlpha := FGlobalAlpha;
  Canvas.FillStyle := ColorToWebStr(clLightGrey);
  Canvas.FillRectF$2(0, 0, ClientWidth, ClientHeight);
  Canvas.FillStyle := ColorToWebStr(clDarkGrey);
  Canvas.FillRectF$2(0, Interpolate(FViewLow), ClientWidth, Interpolate(FViewHigh));
end;

procedure TW3ScrollBar.SetRange(rangeLow, rangeHigh: integer);
begin
  FRangeLow := rangeLow;
  FRangeHigh := rangeHigh;
  Invalidate;
end;

procedure TW3ScrollBar.SetView(viewLow, viewHigh: integer);
begin
  FViewLow := viewLow;
  FViewHigh := viewHigh;
  Invalidate;
end;

procedure TW3ScrollBar.Show(time_ms: integer);
begin
  Visible$1 := true;
  SendToBack;
  if time_ms <= 0 then begin
    FGlobalAlpha := 1;
    Invalidate;
  end
  else begin
    FGlobalAlpha := 0;
    Animation[Self].Animate(time_ms,
      procedure (progress: float)
      begin
        FGlobalAlpha := progress;
        if progress = 1 then BringToFront;
        Invalidate;
      end);
  end;
end;

end.
