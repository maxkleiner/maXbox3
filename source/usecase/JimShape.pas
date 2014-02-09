unit JimShape;

{$B-}

interface

uses
  Windows, Controls, Classes, Forms, ExtCtrls, Graphics, Messages;

type
  TmTextShape = class;


TjimSizingMode = (smTopLeft,smTop,smTopRight,smLeft,smRight,
                    smBottomLeft,smBottom,smBottomRight,smNone);  

TjimConnectionSide = (csLeft,csRight,csTop,csBottom);

  
  TmCustomShape = class (TGraphicControl)
  private
    FCanProcessMouseMsg: Boolean;
    FCaption: TmTextShape;
    FSelected: Boolean;
    FWasCovered: Boolean;
  protected
    function GetCustomShapeAtPos(X,Y : Integer): TmCustomShape;
    procedure MouseDown(Button : TMouseButton;Shift : TShiftState; X,Y : 
            Integer); override;
    procedure MouseUp(Button : TMouseButton;Shift : TShiftState; X,Y : Integer);
            override;
    procedure Notification(AComponent : TComponent;Operation : TOperation);
            override;
    procedure SetCaption(Value: TmTextShape); virtual;
    procedure SetParent(AParent : TWinControl); override;
    procedure SetSelected(Value: Boolean); virtual;
    property CanProcessMouseMsg: Boolean read FCanProcessMouseMsg write
            FCanProcessMouseMsg;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure AlignCaption(Alignment : TAlignment);
    class procedure DeleteAllShapes(ParentControl : TWinControl);
    class procedure DeleteSelectedShapes(ParentControl : TWinControl);
    class procedure LoadFromFile(const FileName : string;ParentControl : 
            TWinControl);
    class procedure SaveToFile(const FileName : string;ParentControl : 
            TWinControl);
    procedure SetBounds(ALeft,ATop,AWidth,AHeight : Integer); override;
    class procedure UnselectAllShapes(ParentControl : TWinControl);
    property Selected: Boolean read FSelected write SetSelected;
  published
    property Caption: TmTextShape read FCaption write SetCaption;
    property OnClick;
    property OnDblClick;
  end;
  

  TmMoveableShape = class (TmCustomShape)
  private
    FMoving: Boolean;
    FOrigin: TPoint;
  protected
    procedure EndMove;
    procedure MouseDown(Button : TMouseButton;Shift : TShiftState; X,Y : 
            Integer); override;
    procedure MouseMove(Shift : TShiftState;X,Y : Integer); override;
    procedure MouseUp(Button : TMouseButton;Shift : TShiftState; X,Y : Integer);
            override;
    procedure Move(DeltaX,DeltaY : Integer);
    procedure MoveShapes(DeltaX,DeltaY : Integer);
    procedure StartMove(X,Y : Integer);
    function ValidMove(DeltaX,DeltaY : Integer): Boolean;
    property Moving: Boolean read FMoving write FMoving;
  public
    constructor Create(AOwner : TComponent); override;
  end;
  


  TmSizeableShape = class (TmMoveableShape)
  private
    FActualHeight: Integer;
    FMinHeight: Integer;
    FMinWidth: Integer;
    FSizeOrigin: TPoint;
    FSizeRectHeight: Integer;
    FSizeRectWidth: Integer;
    FSizingMode: TjimSizingMode;
  protected
    procedure CheckForSizeRects(X,Y : Integer);
    procedure DrawSizingRects;
    function GetSizeRect(SizeRectType : TjimSizingMode): TRect;
    procedure MouseDown(Button : TMouseButton;Shift : TShiftState; X,Y : 
            Integer); override;
    procedure MouseMove(Shift : TShiftState;X,Y : Integer); override;
    procedure MouseUp(Button : TMouseButton;Shift : TShiftState; X,Y : Integer);
            override;
    procedure Paint; override;
    procedure ResizeControl(X,Y : Integer);
    procedure SetSelected(Value : Boolean); override;
    property MinHeight: Integer read FMinHeight write FMinHeight;
    property MinWidth: Integer read FMinWidth write FMinWidth;
    property SizeRectHeight: Integer read FSizeRectHeight write FSizeRectHeight;
    property SizeRectWidth: Integer read FSizeRectWidth write FSizeRectWidth;
    property SizingMode: TjimSizingMode read FSizingMode write FSizingMode;
  public
    constructor Create(AOwner : TComponent); override;
    procedure SetBounds(ALeft,ATop,AWidth,AHeight : Integer); override;
  end;
  

  TmTextShape = class (TmSizeableShape)
  private
    FAutosize: Boolean;
    FFont: TFont;
    FText: string;
    procedure FontChanged(Sender : TObject);
    procedure SetAutosize(Value: Boolean);
    procedure SetFont(Value: TFont);
    procedure SetText(const Value: string);
  protected
    procedure Paint; override;
    procedure RefreshText;
    procedure SetParent(AParent : TWinControl); override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft,ATop,AWidth,AHeight : Integer); override;
  published
    property Autosize: Boolean read FAutosize write SetAutosize;
    property Font: TFont read FFont write SetFont;
    property Text: string read FText write SetText;
  end;
  

  TmBitmapShape = class (TmMoveableShape)
  private
    FImageIndex: Integer;
    FImages: TImageList;
    procedure SetImageIndex(Value: Integer);
    procedure SetImages(Value: TImageList);
  protected
    procedure Notification(AComponent : TComponent;Operation : TOperation); 
            override;
    procedure Paint; override;
    procedure SetSelected(Value : Boolean); override;
  public
    constructor Create(AOwner : TComponent); override;
  published
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Images: TImageList read FImages write SetImages;
  end;
  

  TmStandardShape = class (TmSizeableShape)
  private
    FLineColour: TColor;
    FShapeType: TShapeType;
    procedure SetShapeType(Value: TShapeType);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner : TComponent); override;
  published
    property LineColour: TColor read FLineColour write FLineColour default
            clBlack;
    property ShapeType: TShapeType read FShapeType write SetShapeType;
  end;


  //  TMoveableChart = class(TjimCustomShape)
  TMoveableChart = class (TmStandardShape)
  private
    FMoving: Boolean;
    FOrigin: TPoint;
    FShapeType: TShapeType;
  protected
    procedure MouseDown(Button : TMouseButton;Shift : TShiftState; X,Y :
            Integer); override;
    procedure MouseMove(Shift : TShiftState;X,Y : Integer); override;
    procedure MouseUp(Button : TMouseButton;Shift : TShiftState; X,Y : Integer);
            override;
    procedure Paint; override;
    procedure SetShapeType(Value: TShapeType);
    property Moving: Boolean read FMoving write FMoving;
  public
    constructor Create(AOwner : TComponent); override;
    procedure StartMove(X,Y, EPoint : Integer);
    property ShapeType: TShapeType read FShapeType write SetShapeType;
  end;

  TFreeDraw = class (TmStandardShape)
  private
    FMoving: Boolean;
    FOrigin: TPoint;
    FShapeType: TShapeType;
  protected
    procedure MouseDown(Button : TMouseButton;Shift : TShiftState; X,Y :
            Integer); override;
    procedure MouseMove(Shift : TShiftState;X,Y : Integer); override;
    procedure MouseUp(Button : TMouseButton;Shift : TShiftState; X,Y : Integer);
            override;
    procedure Paint; override;
  public
    constructor Create(AOwner : TComponent); override;
    procedure StartMove(X,Y, EPoint : Integer);
    property ShapeType: TShapeType read FShapeType write SetShapeType;
  end;


  TmConnection = class (TPersistent)
  private
    FOffset: Integer;
    FShape: TmCustomShape;
    FSide: TjimConnectionSide;
  public
    constructor Create;
    procedure Assign(Source : TPersistent); override;
    function BottomMost(TerminatorRect : TRect): TPoint;
    function ConnPoint(TerminatorRect : TRect): TPoint;
    function LeftMost(TerminatorRect : TRect): TPoint;
    function RightMost(TerminatorRect : TRect): TPoint;
    function TermPoint(TerminatorRect : TRect): TPoint;
    function TopMost(TerminatorRect : TRect): TPoint;
  published
    property Offset: Integer read FOffset write FOffset;
    property Shape: TmCustomShape read FShape write FShape;
    property Side: TjimConnectionSide read FSide write FSide;
  end;


  TmConnector = class (TmCustomShape)
  private
    FEndConn: TmConnection;
    FEndTermRect: TRect;
    FLineColour: TColor;
    FLineWidth: Integer;
    FMidPoint: TPoint;
    FStartConn: TmConnection;
    FStartTermRect: TRect;
    procedure CheckSize(var AWidth,AHeight : Integer);
    function GetConn(Index: Integer): TmConnection;
    function GetTermRect(Index: Integer): TRect;
    procedure SetConn(Index: Integer; Value: TmConnection);
    procedure SetLineWidth(Value: Integer);
    procedure SetTermRect(Index: Integer; Value: TRect);
  protected
    function Convert(APoint : TPoint): TPoint;
    procedure DrawEndTerminator; virtual;
    procedure DrawStartTerminator; virtual;
    function IsConnected(ConnectedShape : TmCustomShape): Boolean;
    procedure MoveCaption;
    procedure Notification(AComponent : TComponent;Operation : TOperation); 
            override;
    procedure Paint; override;
    procedure SetCaption(Value : TmTextShape); override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function GetMidPoint: TPoint;
    procedure SetBoundingRect;
    procedure SetBounds(ALeft,ATop,AWidth,AHeight : Integer); override;
    procedure SetConnections(TheStartConn,TheEndConn : TmConnection);
    property EndTermRect: TRect index 2 read GetTermRect write SetTermRect;
    property StartTermRect: TRect index 1 read GetTermRect write SetTermRect;
  published
    property EndConn: TmConnection index 2 read GetConn write SetConn;
    property LineColour: TColor read FLineColour write FLineColour default 
            clBlack;
    property LineWidth: Integer read FLineWidth write SetLineWidth default 1;
    property StartConn: TmConnection index 1 read GetConn write SetConn;
  end;
  

  TmSingleHeadArrow = class (TmConnector)
  protected
    procedure DrawArrowHead(ConnPt,TermPt : TPoint);
    procedure DrawEndTerminator; override;
  public
    constructor Create(AOwner : TComponent); override;
  end;
  

  TmBluntSingleHeadArrow = class (TmSingleHeadArrow)
  protected
    procedure DrawStartTerminator; override;
  public
    constructor Create(AOwner : TComponent); override;
  end;
  

  TmDoubleHeadArrow = class (TmSingleHeadArrow)
  protected
    procedure DrawStartTerminator; override;
  public
    constructor Create(AOwner : TComponent); override;
  end;


implementation

uses
  SysUtils, ImgList;


type
  // This type is purely so that can acccess the protected MouseDown method
  TmMdControl = class (TControl)
  end;
  

var
  FShapeCount : Integer;
  // Used in unique naming scheme. It is global in this unit to enable a
  // 'memory' of the component names used during the lifetime of this unit.


procedure NoLessThan(var Value : Integer;Limit : Integer);
begin {NoLessThan}
  if Value < Limit then begin
    Value := Limit;
  end;
end;  {NoLessThan}


function RectHeight(ARect : TRect) : Integer;
begin {RectHeight}
  Result := ARect.Bottom - ARect.Top;
end;  {RectHeight}


function RectWidth(ARect : TRect) : Integer;
begin {RectWidth}
  Result := ARect.Right - ARect.Left;
end;  {RectWidth}


function InRect(X,Y : Integer;ARect : TRect) : Boolean;
begin {InRect}
  Result := (X >= ARect.Left) and (X <= ARect.Right) and
            (Y >= ARect.Top) and (Y <= ARect.Bottom);
end;  {InRect}


function Min(A : array of Integer) : Integer;
  var
    i : Integer;
begin {Min}
  Result := 0;  // Purely to stop compiler warnings
  for i := Low(A) to High(A) do begin
    if i = Low(A) then begin
      Result := A[i]
    end else if A[i] < Result then begin
      Result := A[i];
    end;
  end;
end;  {Min}


function Max(A : array of Integer) : Integer;
  var
    i : Integer;
begin {Max}
  Result := 0;  // Purely to stop compiler warnings
  for i := Low(A) to High(A) do begin
    if i = Low(A) then begin
      Result := A[i]
    end else if A[i] > Result then begin
      Result := A[i];
    end;
  end;
end;  {Max}


// ---------------------------- TjimCustomShape ------------------------------

{
******************************** TmCustomShape *********************************
}
constructor TmCustomShape.Create(AOwner : TComponent);
var
  AlreadyUsed: Boolean;
  i: Integer;
  TempName: string;
begin
  {Create}
  inherited Create(AOwner);
  FCanProcessMouseMsg := True;
  FCaption            := nil;
  FSelected           := False;
  FWasCovered         := False;
  
    // Give the component a name and ensure that it is unique
  repeat
      // Use a local variable to hold the name, so that don't get exceptions
      // raised on duplicate names
    TempName := 'Shape' + IntToStr(FShapeCount);
    Inc(FShapeCount);
    AlreadyUsed := False;
  
      // Loop through all the components on the form to ensure that this name
      // is not already in use
    for i := 0 to Owner.ComponentCount - 1 do begin
      if Owner.Components[i].Name = TempName then begin
          // Try the next component name as this one is used already
        AlreadyUsed := True;
        Break;
      end;
    end;
  until not AlreadyUsed;
  
  Name := TempName;
end;

destructor TmCustomShape.Destroy;
var
  i: Integer;
begin
  {Destroy}
  FCaption.Free;
  
    // First check that this control has been placed on a form
  if Assigned(Parent) then begin
      // Search parent control for TjimConnector components that connect
      // to this component
    i := 0;

    while i < Parent.ControlCount do begin
      if (Parent.Controls[i] is TmConnector) and
         (TmConnector(Parent.Controls[i]).IsConnected(Self)) then begin
        Parent.Controls[i].Free;
      end else begin
        Inc(i);
      end;
    end;
  end;
  
  inherited Destroy;
end;

procedure TmCustomShape.AlignCaption(Alignment : TAlignment);
var
  ALeft, ATop, AWidth, AHeight: Integer;
begin
  {AlignCaption}
  if not Assigned(FCaption) then begin
    Exit;
  end;
  
  ALeft   := Left;
  ATop    := Top + Height + 5;
  AWidth  := FCaption.Width;
  AHeight := FCaption.Height;
  
  case Alignment of
    taLeftJustify  : ALeft := Left;
    taRightJustify : ALeft := Left + Width - 1;
    taCenter       : ALeft := Left + ((Width - FCaption.Width) div 2);
  end;
  
  FCaption.SetBounds(ALeft,ATop,AWidth,AHeight);
end;

class procedure TmCustomShape.DeleteAllShapes(ParentControl : TWinControl);
var
  i: Integer;
begin
  {DeleteAllShapes}
    // Delete controls from ParentControl
  i := 0;
  
  while i < ParentControl.ControlCount do begin
    if ParentControl.Controls[i] is TmCustomShape then begin
      ParentControl.Controls[i].Free;
        // Note that there is no need to increment the counter, because the
        // next component (if any) will now be at the same position in Controls[]
    end else begin
      Inc(i);
    end;
  end;
end;

class procedure TmCustomShape.DeleteSelectedShapes(ParentControl : TWinControl);
var
  i: Integer;
begin
  {DeleteSelectedShapes}
    // Delete controls from ParentControl if they are flagged as selected
  i := 0;
  
  while i < ParentControl.ControlCount do begin
    if (ParentControl.Controls[i] is TmCustomShape) and
       (TmCustomShape(ParentControl.Controls[i]).Selected) then begin
      ParentControl.Controls[i].Free;
        // Note that there is no need to increment the counter, because the
        // next component (if any) will now be at the same position in Controls[]
    end else begin
      Inc(i);
    end;
  end;
end;

function TmCustomShape.GetCustomShapeAtPos(X,Y : Integer): TmCustomShape;
var
  i: Integer;
  Pt: TPoint;
begin
  {GetCustomShapeAtPos}
  Result := nil;
  
  if not Assigned(Parent) then begin
    Exit;
  end;

  Pt := Parent.ScreenToClient(ClientToScreen(Point(X,Y)));
  
  for i := 0 to Parent.ControlCount - 1 do begin
    if (Parent.Controls[i] <> Self) and
       (Parent.Controls[i] is TmCustomShape) and
       TmCustomShape(Parent.Controls[i]).CanProcessMouseMsg and
       InRect(Pt.X,Pt.Y,Parent.Controls[i].BoundsRect) then begin
      Result := TmCustomShape(Parent.Controls[i]);
      Exit;
    end;
  end;
end;

class procedure TmCustomShape.LoadFromFile(const FileName : string;
        ParentControl : TWinControl);
var
  FS: TFileStream;
  Reader: TReader;
  RealName: string;
begin
  {LoadFromFile}
  DeleteAllShapes(ParentControl);
  
  FS     := TFileStream.Create(Filename,fmOpenRead or fmShareDenyWrite);
  Reader := TReader.Create(FS,1024);
  
  try
      // Save the parent's name, in case we are reading into a different
      // control than we saved the diagram from
    RealName    := ParentControl.Name;
    Reader.Root := ParentControl.Owner;
    Reader.BeginReferences;
    Reader.ReadComponent(ParentControl);
    Reader.FixupReferences;
      // Restore the parent's name
    ParentControl.Name := RealName;
  finally
    Reader.EndReferences;
    Reader.Free;
    FS.Free;
  end;
end;

procedure TmCustomShape.MouseDown(Button : TMouseButton;Shift : TShiftState; X,
        Y : Integer);
var
  TempPt: TPoint;
  CoveredShape: TmCustomShape;
begin
  {MouseDown}
    //CoveredShape := GetCustomShapeAtPos(X,Y);
  if FCanProcessMouseMsg then begin
    BringToFront;
    MouseCapture := True;
    inherited MouseDown(Button,Shift,X,Y);
    Exit;
  end;
  //      messagebeep(0);
    // Pass message on to any covered control capable of handling it
  CoveredShape := GetCustomShapeAtPos(X,Y);
  TempPt       := Point(X,Y);
  MouseCapture := False;
  if CoveredShape <> nil then begin
    SendToBack;
      // Convert coordinates to covered shape's coordinates
    TempPt := CoveredShape.ScreenToClient(ClientToScreen(TempPt));
      // Send the mouse down message to the covered shape
    CoveredShape.MouseDown(Button,Shift,TempPt.X,TempPt.Y);
      // Flag the control as having been covered because we lose a mouse click
    CoveredShape.FWasCovered := True;
  end else if Assigned(Parent) then begin
      // Send mouse down message to Parent. The typecast is purely to gain access
      // to the Parent.MouseDown method. Need to convert coordinates to parent's
      // coordinates
    TempPt := Parent.ScreenToClient(ClientToScreen(TempPt));
    TmMdControl(Parent).MouseDown(Button,Shift,TempPt.X,TempPt.Y);
  end;
end;

procedure TmCustomShape.MouseUp(Button : TMouseButton;Shift : TShiftState; X,Y 
        : Integer);
begin
  {MouseUp}
  inherited MouseUp(Button,Shift,X,Y);
    //  messagebeep(0); test
  
  if FWasCovered then begin
      // We will lose a mouse click, so replace it
    Click;
    FWasCovered := False;
  end;
end;

procedure TmCustomShape.Notification(AComponent : TComponent;Operation : 
        TOperation);
begin
  {Notification}
  inherited Notification(AComponent,Operation);
  
  if Operation = opRemove then begin
    if AComponent = FCaption then begin
      FCaption := nil;
    end;
  end;
end;

class procedure TmCustomShape.SaveToFile(const FileName : string;ParentControl 
        : TWinControl);
var
  FS: TFileStream;
  Writer: TWriter;
  RealName: string;
begin
  {SaveToFile}
  FS     := TFileStream.Create(Filename,fmCreate or fmShareDenyWrite);
  Writer := TWriter.Create(FS,1024);
  
  try
    Writer.Root        := ParentControl.Owner;
    RealName           := ParentControl.Name;
    ParentControl.Name := '';
    Writer.WriteComponent(ParentControl);
    ParentControl.Name := RealName;
  finally
    Writer.Free;
    FS.Free;
  end;
end;

procedure TmCustomShape.SetBounds(ALeft,ATop,AWidth,AHeight : Integer);
var
  i: Integer;
begin
  {SetBounds}
  inherited SetBounds(ALeft,ATop,AWidth,AHeight);
  if not Assigned(Parent) then begin
    Exit;
  end;
  
    // Search parent control for TjimConnector components
  for i := 0 to Parent.ControlCount - 1 do begin
    if Parent.Controls[i] is TmConnector then begin
      if TmConnector(Parent.Controls[i]).IsConnected(Self) then begin
          // Resize the connector, but don't draw it yet
        TmConnector(Parent.Controls[i]).SetBoundingRect;
      end;
    end;
  end;
end;

procedure TmCustomShape.SetCaption(Value: TmTextShape);
begin
  {SetCaption}
  if (Value = nil) and Assigned(FCaption) then begin
    FCaption.Free;
    FCaption := nil;
  end else if (Value <> FCaption) then begin
    FCaption        := Value;
    FCaption.Parent := Self.Parent;
      // Ensure the caption gets aligned correctly. Ths only needs to happen if
      // the caption has not already been set in place (it will already be in the
      // right place if we are loading this from a file).
    if (FCaption.Left = 0) and (FCaption.Top = 0) then begin
      AlignCaption(taCenter);
    end;
  end;
end;

procedure TmCustomShape.SetParent(AParent : TWinControl);
begin
  {SetParent}
  inherited SetParent(AParent);
  
  if Assigned(FCaption) then begin
    FCaption.Parent := AParent;
  end;
end;

procedure TmCustomShape.SetSelected(Value: Boolean);
begin
  {SetSelected}
  FSelected := Value;
  if Assigned(FCaption) then begin
    FCaption.SetSelected(Value);
  end;
end;

class procedure TmCustomShape.UnselectAllShapes(ParentControl : TWinControl);
var
  i: Integer;
begin
  {UnselectAllShapes}
  for i := 0 to ParentControl.ControlCount - 1 do begin
    if ParentControl.Controls[i] is TmCustomShape then begin
    //if ParentControl.Controls[i] is TmMoveablechart then begin
      TmCustomShape(ParentControl.Controls[i]).Selected := False;
    end;
  end;
end;



// --------------------------- TjimMoveableShape  ----------------------------

{
******************************* TmMoveableShape ********************************
}
constructor TmMoveableShape.Create(AOwner : TComponent);
begin
  {Create}
  inherited Create(AOwner);
  Selected  := False;
  Moving    := False;
  FOrigin   := Point(0,0);
end;

procedure TmMoveableShape.EndMove;
begin
  {EndMove}
  Moving   := False;
  FOrigin  := Point(0,0);
end;

procedure TmMoveableShape.MouseDown(Button : TMouseButton;Shift : TShiftState; 
        X,Y : Integer);
begin
  {MouseDown}
  inherited MouseDown(Button,Shift,X,Y);
  
    // Only respond to left mouse button events
  if Button <> mbLeft then begin
    Exit;
  end;
  
    // If not holding down the shift key then not doing multiple selection
  if not (ssShift in Shift) then begin
    UnselectAllShapes(Parent);
  end;
  
    // Start moving the component
  StartMove(X,Y);
end;

procedure TmMoveableShape.MouseMove(Shift : TShiftState;X,Y : Integer);
begin
  {MouseMove}
  inherited MouseMove(Shift,X,Y);
  
    // Only need to move the component if the left mouse button is being held down
  if not (ssLeft in Shift) then begin
    Moving := False;
    Exit;
  end;
  
  if Moving then begin
      // Move all the selected shapes
    MoveShapes(X - FOrigin.X,Y - FOrigin.Y);
  end;
end;

procedure TmMoveableShape.MouseUp(Button : TMouseButton;Shift : TShiftState; X,
        Y : Integer);
var
  i: Integer;
  TempControl: TControl;
begin
  {MouseUp}
  inherited MouseUp(Button,Shift,X,Y);
    // Only interested in left mouse button events
  if Button <> mbLeft then begin
    Exit;
  end;
  EndMove;
    // If this shape is covering any smaller shapes then send it to the back,
    // so that we can get at the smaller ones
  if not Assigned(Parent) then begin
    Exit;
  end;
  for i := 0 to Parent.ControlCount - 1 do begin
    TempControl := Parent.Controls[i];
    if (TempControl <> Self) and (TempControl is TmCustomShape) and
       TmCustomShape(TempControl).CanProcessMouseMsg and
       InRect(TempControl.Left,TempControl.Top,BoundsRect) and
       InRect(TempControl.Left + TempControl.Width,
              TempControl.Top + TempControl.Height,BoundsRect) then begin
        // TempControl is not this one, it is a custom shape, that can process
        // mouse messages (eg not a connector), and is completely covered by
        // this control. So bring the convered control to the top of the z-order
        // so that we can access it.
      TempControl.BringToFront;
      Exit;
    end;
  end;
end;

procedure TmMoveableShape.Move(DeltaX,DeltaY : Integer);
begin
  {Move}
  SetBounds(Left + DeltaX,Top + DeltaY,Width,Height);
end;

procedure TmMoveableShape.MoveShapes(DeltaX,DeltaY : Integer);
var
  i, Pass: Integer;
  TempControl: TControl;
begin
  {MoveShapes}
  if not Assigned(Parent) then begin
    Exit;
  end;
    // Do 2 passes through controls. The first one is to check that all
    // movements are valid
  for Pass := 1 to 2 do begin
    for i := 0 to Parent.ControlCount - 1 do begin
      TempControl := Parent.Controls[i];
      if TempControl is TmMoveableShape then begin
        if (Pass = 1) and
           (not TmMoveableShape(TempControl).ValidMove(DeltaX,DeltaY)) then begin
          Exit;
        end else if (Pass = 2) and TmMoveableShape(TempControl).Selected then begin
          TmMoveableShape(TempControl).Move(DeltaX,DeltaY);
        end;
      end;
    end;
  end;
end;

procedure TmMoveableShape.StartMove(X,Y : Integer);
begin
  {StartMove}
  Selected := True;
  Moving   := True;
  FOrigin  := Point(X,Y);
end;

function TmMoveableShape.ValidMove(DeltaX,DeltaY : Integer): Boolean;
begin
  {ValidMove}
  Result := True;
  
  if not Assigned(Parent) then begin
    Exit;
  end;

  if Selected then begin
    Result := (Left + DeltaX >= 0) and
              (Top + DeltaY >= 0) and
              (Left + DeltaX + Width - 1 <
               Parent.ClientRect.Right - Parent.ClientRect.Left) and
              (Top + DeltaY + Height - 1 <
               Parent.ClientRect.Bottom - Parent.ClientRect.Top);
  end;
end;



// --------------------------- TjimSizeableShape -----------------------------

{
******************************* TmSizeableShape ********************************
}
constructor TmSizeableShape.Create(AOwner : TComponent);
begin
  {Create}
  inherited Create(AOwner);
  FSizingMode     := smNone;
  FSizeOrigin     := Point(0,0);
  FSizeRectHeight := 5;
  FSizeRectWidth  := 5;
  FMinHeight      := FSizeRectHeight;
  FMinWidth       := FSizeRectWidth;
  FActualHeight:= 0;
end;

procedure TmSizeableShape.CheckForSizeRects(X,Y : Integer);
var
  SMode: TjimSizingMode;
begin
  {CheckForSizeRects}
  FSizingMode := smNone;
  
  if not Selected then begin
    Exit;
  end;
  
  for SMode := smTopLeft to smBottomRight do begin
    if InRect(X,Y,GetSizeRect(SMode)) then begin
      FSizingMode := SMode;
      Break;
    end;
  end;
  
  case FSizingMode of
    smTopLeft     : Cursor := crSizeNWSE;
    smTop         : Cursor := crSizeNS;
    smTopRight    : Cursor := crSizeNESW;
    smLeft        : Cursor := crSizeWE;
    smRight       : Cursor := crSizeWE;
    smBottomLeft  : Cursor := crSizeNESW;
    smBottom      : Cursor := crSizeNS;
    smBottomRight : Cursor := crSizeNWSE;
    else            Cursor := crDefault;
  end;
end;

procedure TmSizeableShape.DrawSizingRects;
var
  OldBrush: TBrush;
  SMode: TjimSizingMode;
begin
  {DrawSizingRects}
  if not FSelected then begin
    Exit;
  end;
  
  with Canvas do begin
      // Draw the sizing rectangles
    OldBrush := TBrush.Create;
  
    try
      OldBrush.Assign(Brush);
      Brush.Style := bsSolid;
      Brush.Color := clBlack;
      Pen.Color   := clBlack;
  
      for SMode := smTopLeft to smBottomRight do begin
        FillRect(GetSizeRect(SMode));
      end;
    finally
      Brush.Assign(OldBrush);
      OldBrush.Free;
    end;
  end;
end;

function TmSizeableShape.GetSizeRect(SizeRectType : TjimSizingMode): TRect;
begin
  {GetSizeRect}
  case SizeRectType of
    smTopLeft     : Result := Bounds(0,0,SizeRectWidth,SizeRectHeight);
    smTop         : Result := Bounds(((ClientRect.Right - ClientRect.Left) div 2) -
                                     (SizeRectWidth div 2),
                                     0,
                                     SizeRectWidth,SizeRectHeight);
    smTopRight    : Result := Bounds(ClientRect.Right - SizeRectWidth,0,
                                     SizeRectWidth,SizeRectHeight);
    smLeft        : Result := Bounds(0,
                                     ((ClientRect.Bottom - ClientRect.Top) div 2) -
                                     (SizeRectHeight div 2),
                                     SizeRectWidth,SizeRectHeight);
    smRight       : Result := Bounds(ClientRect.Right - SizeRectWidth,
                                     ((ClientRect.Bottom - ClientRect.Top) div 2) -
                                     (SizeRectHeight div 2),
                                     SizeRectWidth,SizeRectHeight);
    smBottomLeft  : Result := Bounds(0,ClientRect.Bottom - SizeRectHeight,
                                     SizeRectWidth,SizeRectHeight);
    smBottom      : Result := Bounds(((ClientRect.Right - ClientRect.Left) div 2) -
                                     (SizeRectWidth div 2),
                                     ClientRect.Bottom - SizeRectHeight,
                                     SizeRectWidth,SizeRectHeight);
    smBottomRight : Result := Bounds(ClientRect.Right - SizeRectWidth,
                                     ClientRect.Bottom - SizeRectHeight,
                                     SizeRectWidth,SizeRectHeight);
    smNone        : Result := Bounds(0,0,0,0);
   end;
end;

procedure TmSizeableShape.MouseDown(Button : TMouseButton;Shift : TShiftState; 
        X,Y : Integer);
begin
  {MouseDown}
  if (FSizingMode = smNone) or
     (Button <> mbLeft) or
     (ssShift in Shift) then begin
      // Do moving instead of sizing
    FSizingMode := smNone;
    inherited MouseDown(Button,Shift,X,Y);
    Exit;
  end;
  
    // If sizing then make this the only selected control
  UnselectAllShapes(Parent);
  BringToFront;
  FSelected   := True;
  FSizeOrigin := Point(X,Y);
end;

procedure TmSizeableShape.MouseMove(Shift : TShiftState;X,Y : Integer);
begin
  {MouseMove}
  if Moving then begin
    inherited MouseMove(Shift,X,Y);
  end else if (FSizingMode <> smNone) and (ssLeft in Shift) then begin
    ResizeControl(X,Y);
  end else begin
      // Check if over a sizing rectangle
    CheckForSizeRects(X,Y);
  end;
end;

procedure TmSizeableShape.MouseUp(Button : TMouseButton;Shift : TShiftState; X,
        Y : Integer);
begin
  {MouseUp}
  if Button = mbLeft then begin
    FSizingMode := smNone;
  end;
  
  inherited MouseUp(Button,Shift,X,Y);
end;

procedure TmSizeableShape.Paint;
begin
  {Paint}
  inherited Paint;
  
  if not Assigned(Parent) then begin
    Exit;
  end;
  
  DrawSizingRects;
end;

procedure TmSizeableShape.ResizeControl(X,Y : Integer);
var
  L, T, W, H, DeltaX, DeltaY: Integer;
begin
  {ResizeControl}
  L := Left;
  T := Top;
  W := Width;
  H := Height;
  DeltaX := X - FSizeOrigin.X;
  DeltaY := Y - FSizeOrigin.Y;
  
    // Calculate the new boundaries on the control. Also change FSizeOrigin to
    // reflect change in boundaries if necessary.
  case FSizingMode of
    smTopLeft     : begin
        // Ensure that don't move the left edge if this would make the
        // control too narrow
      if (L + DeltaX >= 0) and (W - DeltaX > MinWidth) then begin
        L := L + DeltaX;
        W := W - DeltaX;
      end;
  
        // Ensure that don't move the top edge if this would make the
        // control too short
      if (T + DeltaY >= 0) and (H - DeltaY > MinHeight) then begin
        T := T + DeltaY;
        H := H - DeltaY;
      end;
    end;
  
    smTop         : begin
      if (T + DeltaY >= 0) and (H - DeltaY > MinHeight) then begin
        T := T + DeltaY;
        H := H - DeltaY;
      end;
    end;
  
    smTopRight    : begin
      W := W + DeltaX;
  
      if (T + DeltaY >= 0) and (H - DeltaY > MinHeight) then begin
        T := T + DeltaY;
        H := H - DeltaY;
      end;
  
      FSizeOrigin.X := X;
    end;
  
    smLeft        : begin
      if (L + DeltaX >= 0) and (W - DeltaX > MinWidth) then begin
        L := L + DeltaX;
        W := W - DeltaX;
      end;
    end;
  
    smRight       : begin
      W             := W + DeltaX;
      FSizeOrigin.X := X;
    end;
  
    smBottomLeft  : begin
      if (L + DeltaX >= 0) and (W - DeltaX > MinWidth) then begin
        L := L + DeltaX;
        W := W - DeltaX;
      end;
  
      H             := H + DeltaY;
      FSizeOrigin.Y := Y;
    end;
  
    smBottom      : begin
      H             := H + DeltaY;
      FSizeOrigin.X := X;
      FSizeOrigin.Y := Y;
    end;
  
    smBottomRight : begin
      W             := W + DeltaX;
      H             := H + DeltaY;
      FSizeOrigin.X := X;
      FSizeOrigin.Y := Y;
    end;
  
    smNone : ;
  end;
  
  SetBounds(L,T,W,H);
end;

procedure TmSizeableShape.SetBounds(ALeft,ATop,AWidth,AHeight : Integer);
begin
  {SetBounds}
    // Check that the control bounds are sensible. The control must be at least
    // as large as a sizing rectangle
  FActualHeight:= AHeight;
  NoLessThan(ALeft,0);
  NoLessThan(ATop,0);
  NoLessThan(AWidth,FMinWidth);
  NoLessThan(AHeight,FMinHeight);
  inherited SetBounds(ALeft,ATop,AWidth,AHeight);
end;

procedure TmSizeableShape.SetSelected(Value : Boolean);
begin
  {SetSelected}
  if Value <> FSelected then begin
    inherited SetSelected(Value);
      // Force redraw to show sizing rectangles
    Invalidate;
  end;
end;



// ----------------------------- TjimTextShape  ------------------------------

{
********************************* TmTextShape **********************************
}
constructor TmTextShape.Create(AOwner : TComponent);
begin
  {Create}
  inherited Create(AOwner);
  FAutosize      := True;
  FText          := '';
  FFont          := TFont.Create;
  FFont.OnChange := FontChanged;
end;

destructor TmTextShape.Destroy;
begin
  {Destroy}
  FFont.Free;
  inherited Destroy;
end;

procedure TmTextShape.FontChanged(Sender : TObject);
begin
  {FontChanged}
  RefreshText;
end;

procedure TmTextShape.Paint;
var
  TempRect: TRect;
begin
  {Paint}
  if not Assigned(Parent) then begin
    Exit;
  end;
  
  Canvas.Font := Font;
  TempRect := ClientRect;  // So can pass as a var parameter
  DrawText(Canvas.Handle,PChar(FText),Length(FText),TempRect,
           DT_CENTER or DT_NOPREFIX or DT_WORDBREAK);
  inherited Paint;
end;

procedure TmTextShape.RefreshText;
var
  i, Count: Integer;
  TempStr: string;
begin
  {RefreshText}
  FMinHeight := FSizeRectHeight;
  FMinWidth  := FSizeRectWidth;
  TempStr    := '';
  Count      := 1;
  
  if FAutosize and Assigned(Parent) then begin
    Canvas.Font := Font;
  
    for i := 1 to Length(FText) do begin
      if FText[i] = #10 then begin
          // Check the width of this line
        FMinWidth := Max([FMinWidth,Canvas.TextWidth(TempStr)]);
        TempStr   := '';
          // Count the line feeds
        Inc(Count);
      end else begin
        TempStr := TempStr + FText[i];
      end;
    end;
  
    if Count = 1 then begin
        // In case there is only one line
      FMinWidth := Max([FMinWidth,Canvas.TextWidth(FText)]);
    end;
  
      // Calculate the height of the text rectangle
    FMinHeight := Max([FMinHeight,Canvas.TextHeight(FText) * Count]);
  end;
  
  SetBounds(Left,Top,Width,Height);
end;

procedure TmTextShape.SetAutosize(Value: Boolean);
begin
  {SetAutosize}
  if FAutosize <> Value then begin
    FAutosize := Value;
    RefreshText;
  end;
end;

procedure TmTextShape.SetBounds(ALeft,ATop,AWidth,AHeight : Integer);
begin
  {SetBounds}
    // Check that the control bounds are sensible. Note that this also works
    // if try to set Left, Top etc properties, as their access methods call
    // SetBounds().
  NoLessThan(AWidth,FMinWidth);
  NoLessThan(AHeight,FMinHeight);
  inherited SetBounds(ALeft,ATop,AWidth,AHeight);
end;

procedure TmTextShape.SetFont(Value: TFont);
begin
  {SetFont}
  FFont.Assign(Value);
end;

procedure TmTextShape.SetParent(AParent : TWinControl);
begin
  {SetParent}
  inherited SetParent(AParent);
  RefreshText;
end;

procedure TmTextShape.SetText(const Value: string);
begin
  {SetText}
  if FText <> Value then begin
    FText := Value;
    RefreshText;
  end;
end;



// ---------------------------- TjimBitmapShape ------------------------------

{
******************************** TmBitmapShape *********************************
}
constructor TmBitmapShape.Create(AOwner : TComponent);
begin
  {Create}
  inherited Create(AOwner);
  FImages     := NIL;
  FImageIndex := 0;
end;

procedure TmBitmapShape.Notification(AComponent : TComponent;Operation : 
        TOperation);
begin
  {Notification}
  inherited Notification(AComponent,Operation);
  
  if Operation = opRemove then begin
    if AComponent = FImages then begin
      FImages := nil;
    end;
  end;
end;

procedure TmBitmapShape.Paint;
var
  OldPen: TPen;
begin
  {Paint}
  inherited Paint;
  
  if (not Assigned(Parent)) or
     (not Assigned(FImages)) or
     (FImageIndex < 0) or
     (FImageIndex >= FImages.Count) then begin
      // The component has not been placed on a form yet, or does not have an
      // associated image
    Exit;
  end;
  
    // Draw a focus rectangle
  OldPen             := Canvas.Pen;
  Canvas.Pen.Style   := psDot;
  Canvas.Brush.Style := bsClear;
  
  if Selected then begin
    Canvas.Pen.Mode := pmNot;
  end else begin
    Canvas.Pen.Mode := pmNop;
  end;
  
  Canvas.Polyline([Point(0,0),
                   Point(Width - 1,0),
                   Point(Width - 1,Height - 1),
                   Point(0,Height - 1),
                   Point(0,0)]);
  Canvas.Pen := OldPen;
  
    // Draw the bitmap
  FImages.DrawingStyle := dsTransparent;
  FImages.Draw(Canvas,0,0,FImageIndex);
end;

procedure TmBitmapShape.SetImageIndex(Value: Integer);
begin
  {SetImageIndex}
  if Value <> FImageIndex then begin
    FImageIndex := Value;
    Invalidate;
  end;
end;

procedure TmBitmapShape.SetImages(Value: TImageList);
begin
  {SetImages}
  if Value <> FImages then begin
    FImages := Value;
    if FImages <> nil then begin
        // Set the size of the component to the image size
      SetBounds(Left,Top,FImages.Width+10,FImages.Height);
    end;
  end;
end;

procedure TmBitmapShape.SetSelected(Value : Boolean);
begin
  {SetSelected}
  if Value <> FSelected then begin
    inherited SetSelected(Value);
      // Force redraw to show focus rectangle
    Invalidate;
  end;
end;



// ---------------------------- TtabdStandardShape ---------------------------

{
******************************* TmStandardShape ********************************
}
constructor TmStandardShape.Create(AOwner : TComponent);
var
  I: Integer;
  tempControl: TControl;
begin
  {Create}
  inherited Create(AOwner);
  {for i := 0 to Parent.ControlCount - 1 do begin
    TempControl := Parent.Controls[i];
    if TempControl is TmStandardShape then begin
      FShapeType  := stRectangle;
      Width       := 140;
      Height      := 80;
      FLineColour := clBlack;
    end else begin}
    // Set a default shape and size and colours in the box
      FShapeType  := stRectangle;
      Width       := 200;
      Height      := 130;
      FLineColour := clBlack;
end;

procedure TmStandardShape.Paint;
var
  TempRect: TRect;
  S: Integer;
begin
  {Paint}
  inherited Paint;
  
  if not Assigned(Parent) then begin
    Exit;
  end;
  
  TempRect := ClientRect;  // So can pass as a var parameter
  InflateRect(TempRect,-SizeRectWidth,-SizeRectHeight);
  
    // Draw shape outline
  Canvas.Brush.Style := bsClear;
  Canvas.Pen.Color   := FLineColour;
  S := Min([TempRect.Right - TempRect.Left + 1,TempRect.Bottom - TempRect.Top + 1]);
  
  if FShapeType in [stSquare,stRoundSquare,stCircle] then begin
    TempRect.Right  := TempRect.Left + S;
    TempRect.Bottom := TempRect.Top + S;
  end;
  
  case FShapeType of
    stRectangle,stSquare :
      Canvas.Rectangle(TempRect.Left,TempRect.Top,TempRect.Right,TempRect.Bottom);
    stRoundRect,stRoundSquare :
      Canvas.RoundRect(TempRect.Left,TempRect.Top,TempRect.Right,TempRect.Bottom,
                       S div 4,S div 4);
    stCircle,stEllipse :
      Canvas.Ellipse(TempRect.Left,TempRect.Top,TempRect.Right,TempRect.Bottom);
  end;
end;

procedure TmStandardShape.SetShapeType(Value: TShapeType);
begin
  {SetShapeType}
  if FShapeType <> Value then begin
    FShapeType := Value;
    Invalidate;
  end;
end;



// ----------------------------- TjimConnection ------------------------------

{
********************************* TmConnection *********************************
}
constructor TmConnection.Create;
begin
  {Create}
  inherited Create;
  FShape  := nil;
  FSide   := csRight;
  FOffset := 0;
end;

procedure TmConnection.Assign(Source : TPersistent);
begin
  {Assign}
  if Source is TmConnection then begin
    FShape  := TmConnection(Source).FShape;
    FSide   := TmConnection(Source).FSide;
    FOffset := TmConnection(Source).FOffset;
  end else begin
    inherited Assign(Source);
  end;
end;

function TmConnection.BottomMost(TerminatorRect : TRect): TPoint;
begin
  {BottomMost}
  Result := TermPoint(TerminatorRect);
  
  if FShape = nil then begin
    Exit;
  end;

  case FSide of
    csLeft,
    csRight  :Result.Y:= FShape.Top +FOffset +(RectHeight(TerminatorRect) div 2);
    csTop    :Result.Y:= FShape.Top - 1;
    csBottom :Result.Y:= FShape.Top + FShape.Height + RectWidth(TerminatorRect);
  end;
end;

function TmConnection.ConnPoint(TerminatorRect : TRect): TPoint;
var
  X, Y, W: Integer;
begin
  {ConnPoint}
  Result := Point(0,0);
  X      := 0;
  Y      := 0;
  W      := TerminatorRect.Right - TerminatorRect.Left;
  if FShape = nil then begin
    Exit;
  end;
  case FSide of
    csLeft   : begin
      X := FShape.Left - W;
      Y := FShape.Top + FOffset;
    end;
    csRight  : begin
      X := FShape.Left + FShape.Width - 1 + W;
      Y := FShape.Top + FOffset;
    end;
    csTop    : begin
      X := FShape.Left + FOffset;
      Y := FShape.Top - W;
    end;
    csBottom : begin
      X := FShape.Left + FOffset;
      Y := FShape.Top  + FShape.Height - 1 + W;
    end;
  end;
  
  Result := Point(X,Y);
end;

function TmConnection.LeftMost(TerminatorRect : TRect): TPoint;
begin
  {LeftMost}
  Result := TermPoint(TerminatorRect);
  
  if FShape = nil then begin
    Exit;
  end;
  
  case FSide of
    csLeft   : Result.X := FShape.Left - RectWidth(TerminatorRect);
    csRight  : Result.X := FShape.Left + FShape.Width;
    csTop,
    csBottom : Result.X := FShape.Left + FOffset - (RectHeight(TerminatorRect) div 2);
  end;
end;

function TmConnection.RightMost(TerminatorRect : TRect): TPoint;
begin
  {RightMost}
  Result := TermPoint(TerminatorRect);
  
  if FShape = nil then begin
    Exit;
  end;
  
  case FSide of
    csLeft   : Result.X := FShape.Left - 1;
    csRight  : Result.X := FShape.Left + FShape.Width - 1 + RectWidth(TerminatorRect);
    csTop,
    csBottom : Result.X := FShape.Left + FOffset + (RectHeight(TerminatorRect) div 2);
  end;
end;

function TmConnection.TermPoint(TerminatorRect : TRect): TPoint;
var
  X, Y: Integer;
begin
  {TermPoint}
  Result := Point(0,0);
  X      := 0;
  Y      := 0;
  
  if FShape = nil then begin
    Exit;
  end;
  
  case FSide of
    csLeft   : begin
      X := FShape.Left;
      Y := FShape.Top + FOffset;
    end;
  
    csRight  : begin
      X := FShape.Left + FShape.Width - 1;
      Y := FShape.Top + FOffset;
    end;
  
    csTop    : begin
      X := FShape.Left + FOffset;
      Y := FShape.Top;
    end;
  
    csBottom : begin
      X := FShape.Left + FOffset;
      Y := FShape.Top  + FShape.Height - 1;
    end;
  end;
  
  Result := Point(X,Y);
end;

function TmConnection.TopMost(TerminatorRect : TRect): TPoint;
begin
  {TopMost}
  Result := TermPoint(TerminatorRect);
  
  if FShape = nil then begin
    Exit;
  end;
  
  case FSide of
    csLeft,
    csRight  : Result.Y := FShape.Top + FOffset - (RectHeight(TerminatorRect) div 2);
    csTop    : Result.Y := FShape.Top - RectWidth(TerminatorRect) - 1;
    csBottom : Result.Y := FShape.Top + FShape.Height;
  end;
end;



// ----------------------------- TjimConnector -------------------------------

{
********************************* TmConnector **********************************
}
constructor TmConnector.Create(AOwner : TComponent);
begin
  {Create}
  inherited Create(AOwner);
  FCanProcessMouseMsg := False;
  FLineWidth          := 1;
  FLineColour         := clBlack;
  FStartTermRect      := Rect(0,0,0,0);
  FEndTermRect        := Rect(0,0,0,0);
  FStartConn          := TmConnection.Create;
  FEndConn            := TmConnection.Create;
  FMidPoint           := Point(0,0);
end;

destructor TmConnector.Destroy;
begin
  {Destroy}
  FStartConn.Free;
  FEndConn.Free;
  inherited Destroy;
end;

procedure TmConnector.CheckSize(var AWidth,AHeight : Integer);
begin
  {CheckSize}
    // Ensure the control is at least as big as the line width
  NoLessThan(AHeight,FLineWidth);
  NoLessThan(AWidth,FLineWidth);
    // Ensure the control is at least as big as the start terminator rectangle
  NoLessThan(AHeight,RectHeight(FStartTermRect));
  NoLessThan(AWidth,RectWidth(FStartTermRect));
    // Ensure the control is at least as big as the end terminator rectangle
  NoLessThan(AHeight,RectHeight(FEndTermRect));
  NoLessThan(AWidth,RectWidth(FEndTermRect));
end;

function TmConnector.Convert(APoint : TPoint): TPoint;
begin
  {Convert}
  Result := ScreenToClient(Parent.ClientToScreen(APoint));
end;

procedure TmConnector.DrawEndTerminator;
begin
  {DrawEndTerminator}
end;

procedure TmConnector.DrawStartTerminator;
begin
  {DrawStartTerminator}
end;

function TmConnector.GetConn(Index: Integer): TmConnection;
begin
  {GetConn}
  Result := nil;
  
  case Index of
    1 : Result := FStartConn;
    2 : Result := FEndConn;
  end;
end;

function TmConnector.GetMidPoint: TPoint;
var
  A, B: TPoint;
begin
  {GetMidPoint}
  A := FStartConn.ConnPoint(FStartTermRect);
  B := FEndConn.ConnPoint(FEndTermRect);
  Result := Point(Min([A.X,B.X]) + Abs(A.X - B.X) div 2,
                  Min([A.Y,B.Y]) + Abs(A.Y - B.Y) div 2);
end;

function TmConnector.GetTermRect(Index: Integer): TRect;
begin
  {GetTermRect}
  case Index of
    1 : Result := FStartTermRect;
    2 : Result := FEndTermRect;
  end;
end;

function TmConnector.IsConnected(ConnectedShape : TmCustomShape): Boolean;
begin
  {IsConnected}
  Result := (FStartConn.Shape = ConnectedShape) or
            (FEndConn.Shape = ConnectedShape);
end;

procedure TmConnector.MoveCaption;
var
  NewMidPoint: TPoint;
  ALeft, ATop, ARight, ABottom: Integer;
begin
  {MoveCaption}
  if Assigned(FCaption) then begin
    NewMidPoint := GetMidPoint;
      // Move the caption relative to the mid point of the connector
      // Not resizing anything, just moving an unconnected shape, so can use
      // faster update method than SetBounds
    FCaption.Invalidate;
    ALeft   := FCaption.Left + NewMidPoint.X - FMidPoint.X;
    ATop    := FCaption.Top + NewMidPoint.Y - FMidPoint.Y;
    ARight  := ALeft + FCaption.Width;
    ABottom := ATop + FCaption.Height;
    FCaption.UpdateBoundsRect(Rect(ALeft,ATop,ARight,ABottom));
      // Save the new mid point
    FMidPoint := NewMidPoint;
  end;
end;

procedure TmConnector.Notification(AComponent : TComponent;Operation : 
        TOperation);
begin
  {Notification}
  inherited Notification(AComponent,Operation);
  
  if Operation = opRemove then begin
    if AComponent = FStartConn.FShape then begin
      FStartConn.FShape := nil;
    end;
  
    if AComponent = FEndConn.FShape then begin
      FEndConn.FShape := nil;
    end;
  end;
end;

procedure TmConnector.Paint;
var
  EndPt: TPoint;
begin
  {Paint}
  inherited Paint;
  
  if not Assigned(Parent) then begin
    Exit;
  end;
  
  if Assigned(FStartConn.Shape) and Assigned(FEndConn.Shape) then begin
      // Draw the terminators (arrows etc)
    DrawStartTerminator;
    DrawEndTerminator;
  
    with Canvas do begin
        // Draw the connecting line
      Brush.Style := bsClear;
      Pen.Width   := FLineWidth;
      Pen.Color   := FLineColour;
        // Convert from Parent coordinates to control coordinates
      PenPos      := Convert(FStartConn.ConnPoint(FStartTermRect));
      EndPt       := Convert(FEndConn.ConnPoint(FEndTermRect));
      LineTo(EndPt.X,EndPt.Y);
    end;
  end;
end;

procedure TmConnector.SetBoundingRect;
var
  ALeft, ATop, AWidth, AHeight: Integer;
begin
  {SetBoundingRect}
  if (FStartConn.Shape = nil) or (FEndConn.Shape = nil) then begin
    Exit;
  end;
  
  ALeft   := Min([FStartConn.LeftMost(FStartTermRect).X,
                  FEndConn.LeftMost(FEndTermRect).X]);
  ATop    := Min([FStartConn.TopMost(FStartTermRect).Y,
                  FEndConn.TopMost(FEndTermRect).Y]);
  AWidth  := Max([FStartConn.RightMost(FStartTermRect).X,
                  FEndConn.RightMost(FEndTermRect).X]) -
             ALeft + 2;
  AHeight := Max([FStartConn.BottomMost(FStartTermRect).Y,
                  FEndConn.BottomMost(FEndTermRect).Y]) -
             ATop + 2;
  CheckSize(AWidth,AHeight);
  Invalidate;
  UpdateBoundsRect(Rect(ALeft,ATop,ALeft + AWidth - 1,ATop + AHeight - 1));
  MoveCaption;
end;

procedure TmConnector.SetBounds(ALeft,ATop,AWidth,AHeight : Integer);
begin
  {SetBounds}
  CheckSize(AWidth,AHeight);
    // Resize the connector
  inherited SetBounds(ALeft,ATop,AWidth,AHeight);
    // Move the caption
  MoveCaption;
end;

procedure TmConnector.SetCaption(Value : TmTextShape);
begin
  {SetCaption}
  inherited SetCaption(Value);
  MoveCaption;
end;

procedure TmConnector.SetConn(Index: Integer; Value: TmConnection);
begin
  {SetConn}
  case Index of
    1 : FStartConn.Assign(Value);
    2 : FEndConn.Assign(Value);
  end;
  
  SetBoundingRect;
end;

procedure TmConnector.SetConnections(TheStartConn,TheEndConn : TmConnection);
begin
  {SetConnections}
  StartConn := TheStartConn;
  EndConn   := TheEndConn;
end;

procedure TmConnector.SetLineWidth(Value: Integer);
begin
  {SetLineWidth}
    // Ensure that can always see the line!
  if Value >= 1 then begin
    FLineWidth := Value;
  end;
end;

procedure TmConnector.SetTermRect(Index: Integer; Value: TRect);
begin
  {SetTermRect}
  if (Value.Right - Value.Left >= 0) and (Value.Bottom - Value.Top >= 0) then begin
    case Index of
      1 : FStartTermRect := Value;
      2 : FEndTermRect   := Value;
    end;
  end;
end;



// ------------------------- TjimSingleHeadArrow ---------------------------

{
****************************** TmSingleHeadArrow *******************************
}
constructor TmSingleHeadArrow.Create(AOwner : TComponent);
begin
  {Create}
  inherited Create(AOwner);
  EndTermRect := Rect(0,0,25,10);
end;

procedure TmSingleHeadArrow.DrawArrowHead(ConnPt,TermPt : TPoint);
var
  PointPt, Corner1Pt, Corner2Pt: TPoint;
begin
  {DrawArrowHead}
  with Canvas do begin
    Brush.Style := bsSolid;
    Brush.Color := FLineColour;
    Pen.Color   := FLineColour;
  
      // Draw a line connecting the Conn and Term points
    PenPos    := ConnPt;
    LineTo(TermPt.X,TermPt.Y);
      // Set the basic points (to be modified depending on arrow head direction
    PointPt   := TermPt;
    Corner1Pt := ConnPt;
    Corner2Pt := ConnPt;
  
    if ConnPt.X < TermPt.X then begin
        // Draw a right pointing arrow head
      Inc(Corner1Pt.X,10);
      Inc(Corner2Pt.X,10);
      Dec(Corner1Pt.Y,RectHeight(EndTermRect) div 2);
      Inc(Corner2Pt.Y,RectHeight(EndTermRect) div 2);
    end else if ConnPt.X > TermPt.X then begin
        // Draw a left pointing arrow head
      Dec(Corner1Pt.X,10);
      Dec(Corner2Pt.X,10);
      Dec(Corner1Pt.Y,RectHeight(EndTermRect) div 2);
      Inc(Corner2Pt.Y,RectHeight(EndTermRect) div 2);
    end else if ConnPt.Y < TermPt.Y then begin
        // Draw a down pointing arrow head
      Inc(Corner1Pt.Y,10);
      Inc(Corner2Pt.Y,10);
      Dec(Corner1Pt.X,RectHeight(EndTermRect) div 2);
      Inc(Corner2Pt.X,RectHeight(EndTermRect) div 2);
    end else begin
        // Draw a up pointing arrow head
      Dec(Corner1Pt.Y,10);
      Dec(Corner2Pt.Y,10);
      Dec(Corner1Pt.X,RectHeight(EndTermRect) div 2);
      Inc(Corner2Pt.X,RectHeight(EndTermRect) div 2);
    end;

    Polygon([PointPt,Corner1Pt,Corner2Pt]);
  end;
end;

procedure TmSingleHeadArrow.DrawEndTerminator;
var
  ConnPt, TermPt: TPoint;
begin
  {DrawEndTerminator}
  inherited DrawEndTerminator;
  
  if Assigned(FEndConn.Shape) then begin
    ConnPt := Convert(FEndConn.ConnPoint(EndTermRect));
    TermPt := Convert(FEndConn.TermPoint(EndTermRect));;
    DrawArrowHead(ConnPt,TermPt);
  end;
end;



// ------------------------ TjimBluntSingleHeadArrow -------------------------

{
**************************** TmBluntSingleHeadArrow ****************************
}
constructor TmBluntSingleHeadArrow.Create(AOwner : TComponent);
begin
  {Create}
  inherited Create(AOwner);
  StartTermRect := Rect(0,0,10,10);
end;

procedure TmBluntSingleHeadArrow.DrawStartTerminator;
var
  ConnPt, TermPt: TPoint;
begin
  {DrawStartTerminator}
  inherited DrawStartTerminator;
  
  if not Assigned(FStartConn.Shape) then begin
    Exit;
  end;
  
  ConnPt := Convert(FStartConn.ConnPoint(StartTermRect));
  TermPt := Convert(FStartConn.TermPoint(StartTermRect));;
  
  with Canvas do begin
      // Draw a line connecting the Conn and Term points
    Pen.Color := FLineColour;
    PenPos    := ConnPt;
    LineTo(TermPt.X,TermPt.Y);
  end;
end;



// --------------------------- TjimDoubleHeadArrow ---------------------------

{
****************************** TmDoubleHeadArrow *******************************
}
constructor TmDoubleHeadArrow.Create(AOwner : TComponent);
begin
  {Create}
  inherited Create(AOwner);
  StartTermRect := EndTermRect;
end;

procedure TmDoubleHeadArrow.DrawStartTerminator;
var
  ConnPt, TermPt: TPoint;
begin
  {DrawStartTerminator}
  inherited DrawStartTerminator;
  
  if Assigned(FStartConn.Shape) then begin
    ConnPt := Convert(FStartConn.ConnPoint(StartTermRect));
    TermPt := Convert(FStartConn.TermPoint(StartTermRect));;
    DrawArrowHead(ConnPt,TermPt);
  end;
end;



{ TMoveableChart }

{
******************************** TMoveableChart ********************************
}
constructor TMoveableChart.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
   FShapeType  := stRectangle;
   Selected  := False;   //fselected ?
   Moving    := False;
   FOrigin   := Point(0,0);
end;

procedure TMoveableChart.MouseDown(Button : TMouseButton;Shift : TShiftState; X,
        Y : Integer);
begin
  inherited MouseDown(button, shift, X, Y);

   if not (ssShift in Shift) then begin
    UnselectAllShapes(Parent);
   end;
   FSelected:= True;
end;

procedure TMoveableChart.MouseMove(Shift : TShiftState;X,Y : Integer);
begin
  {MouseMove}
  //if moving then
  inherited MouseMove(Shift,X,Y);
    // Only need to move the component if left mouse button is being held down
  if not (ssLeft in Shift) then begin
    Moving := False;
    Exit;
  end;
  {if Moving then begin
      // Move all the selected shapes
    MoveShapes(X - FOrigin.X,Y - FOrigin.Y);
  end;}
end;

procedure TMoveableChart.MouseUp(Button : TMouseButton;Shift : TShiftState; X,Y
        : Integer);
var
  struc: TmCustomShape;
begin
  {MouseUp}
  inherited MouseUp(Button,Shift,X,Y);
    if FWasCovered then begin
      // We will lose a mouse click, so replace it
    Click;
    FWasCovered := False;
  end;
  EndMove;
end;

procedure TMoveableChart.Paint;
begin
  inherited Paint;
  if not Assigned(Parent) then begin
    Exit;
  end;
  StartMove(5,40, 400);
end;

procedure TMoveableChart.SetShapeType(Value: TShapeType);
begin
  {SetShapeType}
  if FShapeType <> Value then begin
    FShapeType := Value;
    Invalidate;
  end;
end;

procedure TMoveableChart.StartMove(X,Y, EPoint : Integer);
var
  i, y1, y2, maTime, maSum, hi_two: Integer;
  memos: array [1..500] of integer;
begin
  //FSelected := True;
  Moving   := True;
  FOrigin  := Point(X,Y);
  maTime := 45;
  //rectP:= getSizeRect(smtopleft);
  //getCustomshapeatPos(
  hi_two:= FActualHeight div 2;
  with Canvas do begin
    Brush.Style := bsSolid;
    Pen.Color   := CLblack;
    MoveTo(X, hi_two);
    maSum:= 0;
    y2:= hi_two;
    for i := X to EPoint do begin
      y2 := y2 + (random(9) - random(9));
      memos[i]:= y2;
      LineTo(i, FActualHeight-y2);
    // Moving Average
      if i <= (maTime + X-1) then begin
        maSum:= maSum + y2; // X as an offset relativ to array
        canvas.Pixels[i, FActualHeight-(round(maSum/(i-(X-1))))]:=clBlue;
      end else begin
        masum:= masum - (memos[(i-maTime) + X ]) + y2;
        canvas.Pixels[i, FActualHeight-(round(maSum/maTime))]:=clRed;
      end;
    end; //for
    // selected:= false;  oszzilator
   // PaintBox1.Canvas.Pixels[i, h - Round(h * v1[i])] := clRed;
  end;
end;



// ------------------ Initialisation and cleanup routines --------------------

procedure RegisterStorageClasses;
begin {RegisterStorageClasses}
  RegisterClasses([TmCustomShape,
                   TmMoveableShape,
                   TmSizeableShape,
                   TmConnection,
                   TmConnector,
                   TmSingleHeadArrow,
                   TmBluntSingleHeadArrow,
                   TmDoubleHeadArrow,
                   TmBitmapShape,
                   TmTextShape,
                   TmStandardShape,
                   TMoveableChart,
                   TFreeDraw]);
end;  {RegisterStorageClasses}




{ TFreeDraw }

constructor TFreeDraw.Create(AOwner: TComponent);
begin
  inherited Create(aOwner) ;
   Selected  := False;   //fselected ?
   Moving    := False;
   FOrigin   := Point(0,0);
   self.Canvas.Brush.Style:= bsSolid;
   self.Canvas.pen.Width:= 10;
   self.Canvas.Pen.Color:= CLBlue;
   FLineColour := clBlue;
end;

procedure TFreeDraw.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(button, shift, X, Y);
   if not (ssShift in Shift) then begin
     UnselectAllShapes(Parent);
   end;
   FSelected:= True;
   StartMove(x,y, 400);
   //self.Canvas.MoveTo(x,y);
end;

procedure TFreeDraw.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift,X,Y);
    // Only need to move the component if left mouse button is being held down
  if not (ssLeft in Shift) then begin
    Moving := true;
    Exit;
  end;
  if (ssLeft in Shift) then begin
    Moving := false;
    //Exit;
    self.Canvas.LineTo(x,y);
  end;
  StartMove(x,y, 400);
   //Exit;
  //end;
end;

procedure TFreeDraw.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
 inherited MouseUp(Button,Shift,X,Y);
    if FWasCovered then begin
      // We will lose a mouse click, so replace it
    Click;
    FWasCovered := False;
  end;
  EndMove;
end;

procedure TFreeDraw.Paint;
begin
  inherited Paint;
   if not Assigned(Parent) then begin
    Exit;
  end;
  //StartMove(5,40, 400);
end;

procedure TFreeDraw.StartMove(X, Y, EPoint: Integer);
begin
 //moving:= true;
 //FSelected:= true;
 with Canvas do begin
    Brush.Style := bsSolid;
    Pen.Color   := CLRed;
    MoveTo(X, Y);
    // selected:= false;  oszzilator
   // PaintBox1.Canvas.Pixels[i, h - Round(h * v1[i])] := clRed;
  end;
  // to be continue
end;

initialization
  RegisterStorageClasses;
  FShapeCount := 1;

end.
