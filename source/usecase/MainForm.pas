unit MainForm;

{Description to add a new Shape like a bitmap
 1. add the bitmap in the diagImageList on the form
 2. declare a enumerator e.g: jnaDrawEarth
 3. define a status hint in FNextAction
 4. define a eventhandler   nextAction:= jnadrawEarth;
 5. extend ScrollBox1MouseDown procedure in a CaseOf State
 6. define the rules between shapes in shapeClick
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, JimShape, ImgList, ExtCtrls, ScktComp;

type
  TjimNextAction = (jnaNone,jnaAddActor,jnaAddUseCase,
                    jnaStartDouble,jnaEndDouble,
                    jnaStartUsesArrow,jnaEndUsesArrow,
                    jnaStartExtendsArrow,jnaEndExtendsArrow,jnaChartMove,
                    jnaDrawEarth);

  TjimArrowType = (jatDouble,jatUses,jatExtends);


  TMainDlg = class (TForm)
    ActorBtn: TToolButton;
    BtnImageList: TImageList;
    btnMX: TToolButton;
    btnSockets: TToolButton;
    DeleteBtn: TToolButton;
    DiagImageList: TImageList;
    DoubleArrowBtn: TToolButton;
    ExtendsArrowBtn: TToolButton;
    NewBtn: TToolButton;
    OpenBtn: TToolButton;
    OpenDialog1: TOpenDialog;
    SaveBtn: TToolButton;
    SaveDialog1: TSaveDialog;
    ScrollBox1: TScrollBox;
    SelectBtn: TToolButton;
    StatusBar: TStatusBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton5: TToolButton;
    UseCaseBtn: TToolButton;
    UsesArrowBtn: TToolButton;
    procedure ActorBtnClick(Sender: TObject);
    procedure btnMXClick(Sender: TObject);
    procedure btnSocketsClick(Sender: TObject);
    procedure ClientSocket1Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Disconnect(Sender: TObject; Socket:
            TCustomWinSocket);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure DeleteBtnClick(Sender: TObject);
    procedure DoubleArrowBtnClick(Sender: TObject);
    procedure ExtendsArrowBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NewBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure ScrollBox1MouseDown(Sender: TObject; Button: TMouseButton; Shift:
            TShiftState; X, Y: Integer);
    procedure SelectBtnClick(Sender: TObject);
    procedure ServerSocket1ClientConnect(Sender: TObject; Socket:
            TCustomWinSocket);
    procedure ToolButton2Click(Sender: TObject);
    procedure UseCaseBtnClick(Sender: TObject);
    procedure UsesArrowBtnClick(Sender: TObject);
  private
    FEndShape: TmCustomShape;
    FNextAction: TjimNextAction;
    FStartShape: TmCustomShape;
    FStream: TFileStream;
    procedure ChooseButton(TheButton : TToolButton);
    procedure ConnectShapes(StartShape,EndShape : TmCustomShape; ArrowType :
            TjimArrowType);
    procedure SetNextAction(Value: TjimNextAction);
  public
    property NextAction: TjimNextAction read FNextAction write SetNextAction;
  published
    procedure CaptionDblClick(Sender : TObject);
    procedure ShapeClick(Sender : TObject);
  end;


  EDiagramError = class (Exception)
  end;


var
  MainDlg: TMainDlg;


implementation

{$R *.DFM}

uses
  CaptionEditForm;


{
*********************************** TMainDlg ***********************************
}
procedure TMainDlg.ActorBtnClick(Sender: TObject);
begin
  // Add an actor to the diagram on the next click on the scrollbox
  NextAction  := jnaAddActor;
end;

procedure TMainDlg.btnMXClick(Sender: TObject);
begin
  NextAction  := jnaChartMove;
end;


procedure TMainDlg.CaptionDblClick(Sender : TObject);
var
  TempText: string;
  TempFont: TFont;
begin
  {CaptionDblClick}
  if Sender is TmTextShape then begin
    with TmTextShape(Sender) do begin
        // Use local variables because cannot pass properties as var parameters
      TempText := Text;
      TempFont := Font;
      TCaptionEditDlg.NewCaption(TempText,TempFont);
      Text := TempText;
      Font := TempFont;
    end;
  end;
end;

procedure TMainDlg.ChooseButton(TheButton : TToolButton);
var
  i: Integer;
begin
  {ChooseButton}
  with ToolBar1 do begin
    for i := 0 to ButtonCount - 1 do begin
      Buttons[i].Down := (Buttons[i] = TheButton);
    end;
  end;

  TheButton.Click;
end;

//========================sockets test======================================

procedure TMainDlg.btnSocketsClick(Sender: TObject);
begin
  //to be continued       just a socket test
  //serverSocket1.active:= true;
  //clientSocket1.active:= true;
end;

procedure TMainDlg.ClientSocket1Connect(Sender: TObject; Socket:
        TCustomWinSocket);
begin
  // to bes
  FStream:=TFileStream.create('d:\franktech\update.txt',fmCreate);
end;

procedure TMainDlg.ClientSocket1Disconnect(Sender: TObject; Socket:
        TCustomWinSocket);
begin
  if assigned(FStream) then begin
    fStream.Free;
    fStream:= NIL;
  end;
end;

procedure TMainDlg.ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
var
  iLen: Integer;
  bfr: Pointer;
begin
  iLen:= socket.receiveLength;
  getMem(bfr, iLen);
  try
    socket.receiveBuf(bfr^, iLen);
    fStream.write(bfr^, iLen);
  finally
    freeMem(bfr);
  end;
end;

procedure TMainDlg.ServerSocket1ClientConnect(Sender: TObject; Socket:
        TCustomWinSocket);
begin
  socket.sendStream(TFileStream.create('d:\franktech\kknews.html', fmopenRead));
end;


//========================sockets test end=====================================



procedure TMainDlg.ConnectShapes(StartShape,EndShape : TmCustomShape; ArrowType
        : TjimArrowType);
var
  TempConnector: TmConnector;
  StartSide, EndSide: TjimConnectionSide;
  StartOffset, EndOffset: Integer;
begin
  {ConnectShapes}
  TempConnector := nil;
  StartSide     := csRight;
  EndSide       := csLeft;
  StartOffset   := FStartShape.Height div 2;
  EndOffset     := FEndShape.Height div 2;
  
  case ArrowType of
    jatDouble: begin
      TempConnector := TmDoubleHeadArrow.Create(Self);
    end;
    jatUses,
    jatExtends: begin
      TempConnector := TmBluntSingleHeadArrow.Create(Self);
        // Change the connection sides to top and bottom
      StartSide     := csBottom;
      EndSide       := csTop;
      StartOffset   := FStartShape.Width div 2;
      EndOffset     := FEndShape.Width div 2;
        // Create the caption
      TempConnector.Caption := TmTextShape.Create(Self);
      TempConnector.Caption.OnDblClick := CaptionDblClick;
      if ArrowType = jatUses then begin
        TempConnector.Caption.Text := '<<include>>';
      end else begin
        TempConnector.Caption.Text := '<<extend>>';
      end;
    end;
  end;
  
  with TempConnector do begin
      // Set the start connection
    StartConn.Side   := StartSide;
    StartConn.Offset := StartOffset;
    StartConn.Shape  := FStartShape;
      // Set the end connection
    EndConn.Side     := EndSide;
    EndConn.Offset   := EndOffset;
    EndConn.Shape    := FEndShape;
      // Ensure the size is correct
    SetBoundingRect;
      // Ensure the new control is visible
    Parent := ScrollBox1;
  
      // Align the caption to near the midpoint of the connector, if necessary
    if Assigned(Caption) then begin
      Caption.SetBounds(GetMidPoint.X + 20,GetMidPoint.Y,Caption.Width,Caption.Height);
    end;
  end;
end;

procedure TMainDlg.DeleteBtnClick(Sender: TObject);
begin
  TmCustomShape.DeleteSelectedShapes(ScrollBox1);
end;

procedure TMainDlg.DoubleArrowBtnClick(Sender: TObject);
begin
  // Connect an actor to a use case
  NextAction  := jnaStartDouble;
  FStartShape := nil;
  FEndShape   := nil;
end;

procedure TMainDlg.ExtendsArrowBtnClick(Sender: TObject);
begin
  // Connect 2 use cases
  NextAction  := jnaStartExtendsArrow;
  FStartShape := nil;
  FEndShape   := nil;
end;

procedure TMainDlg.FormCreate(Sender: TObject);
begin
  NextAction  := jnaNone;
  FStartShape := nil;
  FEndShape   := nil;
  mainDlg.caption:= 'maTRIx Trade Roboter';
  Height:= 500;
  Width:= 670;
  FStream:= NIL;
end;

procedure TMainDlg.NewBtnClick(Sender: TObject);
begin
  TmCustomShape.DeleteAllShapes(ScrollBox1);
end;

procedure TMainDlg.OpenBtnClick(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    TmCustomShape.LoadFromFile(OpenDialog1.FileName,ScrollBox1);
  end;
end;

procedure TMainDlg.SaveBtnClick(Sender: TObject);
begin
  if SaveDialog1.Execute then begin
    TmCustomShape.SaveToFile(SaveDialog1.FileName,ScrollBox1);
  end;
end;

procedure TMainDlg.ScrollBox1MouseDown(Sender: TObject; Button: TMouseButton;
        Shift: TShiftState; X, Y: Integer);
begin
  case FNextAction of

    jnaNone : TmCustomShape.UnselectAllShapes(ScrollBox1);
    jnaAddActor : begin
      with TmBitmapShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'New Actor';
        Caption.OnDblClick := CaptionDblClick;
        Images             := DiagImageList;
        ImageIndex         := 0;
        Top                := Y;
        Left               := X;
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        AlignCaption(taCenter);
      end;
      ChooseButton(SelectBtn);
    end;

    jnaDrawEarth: begin
      with TmBitmapShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'New Earth Player';
        Caption.OnDblClick := CaptionDblClick;
        Images             := DiagImageList;
        ImageIndex         := 1;
        Top                := Y;
        Left               := X;
        //images.Width       := 50;
        //images.Height      := 110;
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        AlignCaption(taCenter);
      end;
      ChooseButton(SelectBtn);
    end;

    jnaAddUseCase: begin
      with TmStandardShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'New Use Case';
        Caption.OnDblClick := CaptionDblClick;
        ShapeType          := stEllipse;
        Top                := Y;
        Left               := X;
        Width              := 115;
        Height             := 70;
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        AlignCaption(taCenter);
        Caption.Top := Top + (Height div 2) - (Caption.Height div 2);
      end;
        ChooseButton(SelectBtn);
    end;

    jnaChartMove: begin
      with TMoveableChart.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'Chart Generator';
        Caption.OnDblClick := CaptionDblClick;
        ShapeType          := stEllipse;
        Top                := Y;
        Left               := X;
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        AlignCaption(taCenter);
      end;
       chooseButton(selectBtn);
     end;

    jnaStartDouble,
    jnaEndDouble,
    jnaStartUsesArrow,
    jnaEndUsesArrow,
    jnaStartExtendsArrow,
    jnaEndExtendsArrow : begin
      // Shouldn't really get here when doing anything useful, so treat it as
      // clearing the setting
      ChooseButton(SelectBtn);
    end;
  end; //case
end;

procedure TMainDlg.SelectBtnClick(Sender: TObject);
begin
  // Don't add anything to the diagram on the next click on the scrollbox
  NextAction  := jnaNone;
end;


procedure TMainDlg.SetNextAction(Value: TjimNextAction);
begin
  FNextAction := Value;

  case FNextAction of
    jnaNone              : StatusBar.Panels[0].Text := 'Waiting';
    jnaAddActor          : StatusBar.Panels[0].Text := 'Place an actor on the diagram';
    jnaAddUseCase        : StatusBar.Panels[0].Text := 'Place a use case on the diagram';
    jnaStartDouble       : StatusBar.Panels[0].Text := 'Choose the actor';
    jnaEndDouble         : StatusBar.Panels[0].Text := 'Choose the use case';
    jnaStartUsesArrow    : StatusBar.Panels[0].Text := 'Choose the first use case';
    jnaEndUsesArrow      : StatusBar.Panels[0].Text := 'Choose the second use case';
    jnaStartExtendsArrow : StatusBar.Panels[0].Text := 'Choose the first use case';
    jnaEndExtendsArrow   : StatusBar.Panels[0].Text := 'Choose the second use case';
    jnaChartMove         : StatusBar.Panels[0].text:= 'let the chart moves';
    jnaDrawEarth         : statusBar.Panels[0].Text:= 'let the  earth draw';
  end;
end;

procedure TMainDlg.ShapeClick(Sender : TObject);
begin
  {ShapeClick}
  if not (Sender is TmCustomShape) then begin
    Exit;
  end;

  case FNextAction of
    jnaStartDouble: begin
        // Check that it is an allowed shape
      if not ((Sender is TmBitmapShape) or (sender is TMoveableChart)) then begin
        raise EDiagramError.Create('You must join an actor to a use case');
      end;
      FStartShape := TmCustomShape(Sender);
      NextAction  := jnaEndDouble;
    end;

    jnaEndDouble: begin
        // Check that it is an allowed shape
      if Sender = FStartShape then begin
        raise EDiagramError.Create('You cannot join an actor to itself, ' +
                                   'choose a use case instead');
      end else if not (Sender is TmStandardShape) then begin
        raise EDiagramError.Create('You must join an actor to a use case');
      end;
      FEndShape := TmCustomShape(Sender);
      ConnectShapes(FStartShape,FEndShape,jatDouble);
      ChooseButton(SelectBtn);
    end;

    jnaStartUsesArrow : begin
        // Check that it is an allowed shape
      if not (Sender is TmStandardShape) then begin
        raise EDiagramError.Create('You must join a use case to a use case');
      end;
      FStartShape := TmCustomShape(Sender);
      NextAction  := jnaEndUsesArrow;
    end;

    jnaEndUsesArrow : begin
        // Check that it is an allowed shape
      if Sender = FStartShape then begin
        raise EDiagramError.Create('You cannot join a use case to itself, ' +
                                   'choose another use case instead');
      end else if not (Sender is TmStandardShape) then begin
        raise EDiagramError.Create('You must join a use case to a use case');
      end;
      FEndShape := TmCustomShape(Sender);
      ConnectShapes(FStartShape,FEndShape,jatUses);
      ChooseButton(SelectBtn);
    end;

    jnaStartExtendsArrow : begin
        // Check that it is an allowed shape
      if not (Sender is TmStandardShape) then begin
        raise EDiagramError.Create('You must join a use case to a use case');
      end;
      FStartShape := TmCustomShape(Sender);
      NextAction  := jnaEndExtendsArrow;
    end;

    jnaEndExtendsArrow : begin
        // Check that it is an allowed shape
      if Sender = FStartShape then begin
        raise EDiagramError.Create('You cannot join a use case to itself, ' +
                                   'choose another use case instead');
      end else if not (Sender is TmStandardShape) then begin
        raise EDiagramError.Create('You must join a use case to a use case');
      end;
      FEndShape := TmCustomShape(Sender);
      ConnectShapes(FStartShape,FEndShape,jatExtends);
      ChooseButton(SelectBtn);
    end;
  end;
end;

procedure TMainDlg.ToolButton2Click(Sender: TObject);
begin
  nextAction:= jnadrawEarth; // to be continued
end;

procedure TMainDlg.UseCaseBtnClick(Sender: TObject);
begin
  // Add a use case to the diagram on the next click on the scrollbox
  NextAction  := jnaAddUseCase;
end;

procedure TMainDlg.UsesArrowBtnClick(Sender: TObject);
begin
  // Connect 2 use cases
  NextAction  := jnaStartUsesArrow;
  FStartShape := nil;
  FEndShape   := nil;
end;



end.


