unit UCMainForm;

//enhanced by max, june 2010
// dragn'drop december 2011 - 3.8.1
// all basic dias UML for extended UseCase as n-Actors
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
  Windows, SysUtils, Classes, Graphics, Forms, Messages, 
   ToolWin, JimShape, ImgList, Dialogs, ExtCtrls, ExtDlgs, ComCtrls, Controls, Menus;

type
  TjimNextAction = (jnaNone,jnaAddActor,jnaAddUseCase, jnaStartDouble,jnaEndDouble, jnaStartUsesArrow,jnaEndUsesArrow,
                    jnaStartExtendsArrow,jnaEndExtendsArrow,jnaChartMove, jnaDrawEarth, jnaAddSocket,
                    jnaAddTitle, jnaFreeDraw, jnaRaute, jnaActivity, jnaDrawEarth2,
                     jnaUC, jnaAD, jnaCD, jnaSE, jnaSEQ, jnaPAC, jnaCOM, jnaDEP, jnarect);

  //image index UC..DEP 3..10, 11 is group package

  TjimArrowType = (jatDouble,jatUses,jatExtends);


  TUCMainDlg = class (TForm)
    ActorBtn: TToolButton;
    BtnImageList: TImageList;
    btnDecision: TToolButton;
    btnDelete: TToolButton;
    btnActivity: TToolButton;
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
    btnChart: TToolButton;
    ToolButton5: TToolButton;
    UseCaseBtn: TToolButton;
    UsesArrowBtn: TToolButton;
    btnSockets: TToolButton;
    btnGroup: TToolButton;
    btnTitle: TToolButton;
    OpenPictureDialog1: TOpenPictureDialog;
    tbtnfreedraw: TToolButton;
    ToolButton7: TToolButton;
    SavePictureDialog1: TSavePictureDialog;
    tbtOpenPics: TToolButton;
    btnSavePics: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    btnUC: TToolButton;
    btnAD: TToolButton;
    btnCD: TToolButton;
    btnSE: TToolButton;
    btnSEQ: TToolButton;
    btnPAC: TToolButton;
    btnCOM: TToolButton;
    btnDEP: TToolButton;
    ToolButton2: TToolButton;
    tlbtnSaveBitmap: TToolButton;
    tbnClipboard: TToolButton;
    PopupMenu1: TPopupMenu;
    UseCase1: TMenuItem;
    Activity1: TMenuItem;
    Class1: TMenuItem;
    StateEvent1: TMenuItem;
    Sequence1: TMenuItem;
    Package1: TMenuItem;
    Component1: TMenuItem;
    Deployment1: TMenuItem;
    SaveasBitmap1: TMenuItem;
    Clipboard1: TMenuItem;
    tbtnRect: TToolButton;
    DrawaFrame1: TMenuItem;
    procedure ActorBtnClick(Sender: TObject);
    procedure btnMXchartClick(Sender: TObject);
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
    procedure tbtnGetClassClick(Sender: TObject);
    procedure UseCaseBtnClick(Sender: TObject);
    procedure UsesArrowBtnClick(Sender: TObject);
    procedure btnSocketsClick(Sender: TObject);
    procedure TbtnTitleClick(Sender: TObject);
    procedure btnFreeDrawClick(Sender: TObject);
    procedure TBtnOpenPicsClick(Sender: TObject);
    procedure TBtnSavePicsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure btnCOMClick(Sender: TObject);
    procedure btnDecisionClick(Sender: TObject);
    procedure btnActivityClick(Sender: TObject);
    procedure btnUCClick(Sender: TObject);
    procedure btnADClick(Sender: TObject);
    procedure btnCDClick(Sender: TObject);
    procedure btnSEClick(Sender: TObject);
    procedure btnSEQClick(Sender: TObject);
    procedure btnPACClick(Sender: TObject);
    procedure btnDEPClick(Sender: TObject);
    procedure StatusBarDblClick(Sender: TObject);
    procedure tlbtnSaveBitmapClick(Sender: TObject);
    procedure tbnClipboardClick(Sender: TObject);
    procedure tbtnRectClick(Sender: TObject);
  private
    FEndShape: TmCustomShape;
    FNextAction: TjimNextAction;
    FStartShape: TmCustomShape;
    FStream: TFileStream;
    FCodeFileName: string;
    myimage: TImage;
    freeimagelist: TImageList;
    STATImage: Boolean;
    procedure ChooseButton(TheButton : TToolButton);
    procedure ConnectShapes(StartShape,EndShape : TmCustomShape; ArrowType :
            TjimArrowType);
    procedure SetNextAction(Value: TjimNextAction);
    procedure InitScrollWindow;
    procedure WMDROP_THEFILES(var message: TWMDROPFILES); message WM_DROPFILES;

  public
    procedure SetCodeFileName(vName: string);
    property NextAction: TjimNextAction read FNextAction write SetNextAction;
  published
    procedure CaptionDblClick(Sender : TObject);
    procedure ShapeClick(Sender : TObject);
  private
    procedure CreateDiagramBitmap(Bmp: TBitmap);
  end;


  EDiagramError = class (Exception)
  end;


//var
  //UCMainDlg: TUCMainDlg;


implementation

{$R *.DFM}


uses
  CaptionEditForm,  ImageDLLLoader, ICOLoader, JPEGLoader, PNGLoader, HIPSLoader,
  BMPLoader, GIFLoader, PCXLoader, WMFLoader, LinarBitmap, ShellAPI, Clipbrd;

resourcestring UC1  = 'You must join use case to a use case';
               UC2  = 'You must join an actor to a use case';
               UC3  = 'You cannot join an actor to itself, ' +
                                   'choose a use case instead';

{
*********************************** TMainDlg ***********************************
}
procedure TUCMainDlg.ActorBtnClick(Sender: TObject);
begin
  // Add an actor to the diagram on the next click on the scrollbox
  NextAction:= jnaAddActor;
end;

procedure TUCMainDlg.btnMXchartClick(Sender: TObject);
begin
  NextAction:= jnaChartMove;
end;

procedure TUCMainDlg.btnPACClick(Sender: TObject);
begin
  nextAction:= jnaPAC;
  Showmessage('Check also the Units Explorer in Menu /Debug');
end;

procedure TUCMainDlg.InitScrollWindow;
begin
  with TmBitmapShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Font.Size:= 24;
        Caption.Text       := 'Welcome to maXCase, start with modeling...';
        Caption.OnDblClick := CaptionDblClick;
        Top                := 40;
        Left               := 100;
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        AlignCaption(taCenter);
      end;
    with TmBitmapShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'New Actor HEX in the BOX';
        Caption.OnDblClick := CaptionDblClick;
        Images             := DiagImageList;
        ImageIndex         := 0;
        Top                := 120;
        Left               := 160;
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        AlignCaption(taCenter);
      end;
      ChooseButton(SelectBtn);
end;


procedure TUCMainDlg.CaptionDblClick(Sender : TObject);
var
  TempText: string;
  TempFont: TFont;
begin
  {CaptionDblClick}
  if Sender is TmTextShape then begin
    with TmTextShape(Sender) do begin
        // Use local variables because cannot pass properties as var parameters
      TempText:= Text;
      TempFont:= Font;
      TCaptionEditDlg.NewCaption(TempText,TempFont);
      Text:= TempText;
      Font:= TempFont;
    end;
  end;
end;

procedure TUCMainDlg.ChooseButton(TheButton : TToolButton);
var
  i: Integer;
begin
  {ChooseButton}
  with ToolBar1 do begin
    for i:= 0 to ButtonCount - 1 do begin
      Buttons[i].Down:= (Buttons[i] = TheButton);
    end;
  end;

  TheButton.Click;
end;


procedure TUCMainDlg.ConnectShapes(StartShape,EndShape : TmCustomShape; ArrowType
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
        TempConnector.Caption.Text:= '<<include>>';
      end else begin
        TempConnector.Caption.Text:= '<<extend>>';
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
    Parent:= ScrollBox1;
  
      // Align the caption to near the midpoint of the connector, if necessary
    if Assigned(Caption) then begin
      Caption.SetBounds(GetMidPoint.X + 20,GetMidPoint.Y,Caption.Width,Caption.Height);
    end;
  end;
end;

procedure TUCMainDlg.DeleteBtnClick(Sender: TObject);
begin
  TmCustomShape.DeleteSelectedShapes(ScrollBox1);
  if Assigned(myimage) then begin
    myimage.Free;
    myimage:= NIL;
    STATImage:= false;
  end;
end;

procedure TUCMainDlg.DoubleArrowBtnClick(Sender: TObject);
begin
  // Connect an actor to a use case
  NextAction  := jnaStartDouble;
  FStartShape := nil;
  FEndShape   := nil;
end;

procedure TUCMainDlg.ExtendsArrowBtnClick(Sender: TObject);
begin
  // Connect 2 use cases
  NextAction  := jnaStartExtendsArrow;
  FStartShape := nil;
  FEndShape   := nil;
end;

procedure TUCMainDlg.FormActivate(Sender: TObject);
begin
  dragAcceptFiles(self.Handle, True);
end;

procedure TUCMainDlg.FormCreate(Sender: TObject);
begin
  NextAction  := jnaNone;
  FStartShape := nil;
  FEndShape   := nil;
  caption:= 'Use Case UML Editor maXbox';
  Height:= 800;
  Width:= 1000;
  FStream:= NIL;
  InitScrollWindow;
  //ToolButton3Click(self);
  STATImage:= false;
  //dragAcceptFiles(UCMainDlg.Handle, True);
  ImageDLLLoader.Default.FindDLLs(ExtractFilePath(application.ExeName));
end;

procedure TUCMainDlg.FormDestroy(Sender: TObject);
begin
  //if True then
  //ImageDLLLoader.Default:= NIL;
  //ImageDLLLoader.Default.Free;
  if assigned(myimage) then
    myimage.Free;
    STATImage:= false;
   DragAcceptFiles(self.Handle, false);
end;


procedure TUCMainDlg.WMDROP_THEFILES(var message: TWMDROPFILES);
const
  MAXCHARS = 254;
var
  hDroppedFile: tHandle;
  bFilename: array[0..MAXCHARS] of char;
begin
   hDroppedFile:= message.Drop;
   //Put the file on a memo and check changes
   {if STATedchanged then begin
     sysutils.beep;
     if MessageDlg(RCSTRMB+': Save Code Changes now?',
                  mtConfirmation, [mbYes,mbNo], 0) = mrYes then
       Save2Click(self)
     end else
       STATEdchanged:= false;
   last_fName:= Act_Filename;
   memo2.Lines.Add(last_fName + BEFOREFILE);    //beta
   loadLastfile1.Caption:= '&Load Last File' +': '+ extractFileName(last_fName);
   with Memo1 do begin
     Lines.clear;
     //Grab the name of a dropped file
     dragQueryFile(hDroppedFile, 0, @bFilename, sizeOf(bFilename));
     Lines.loadFromFile(StrPas(bFilename));
   end;}
     dragQueryFile(hDroppedFile, 0, @bFilename, sizeOf(bFilename));
     TmCustomShape.LoadFromFile(bFileName,ScrollBox1);
      if assigned(myimage) then begin
       myimage.Free;
       myimage:= NIL;
       STATImage:= false;
     end;
  //   Act_Filename:= bFilename;
   //memo2.Lines.Add(bFileName + FILELOAD);
   statusBar.Panels[0].text:= bFileName +' UC drag&drop';
   //release memory.
   dragFinish(hDroppedFile );
end;


procedure TUCMainDlg.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

procedure TUCMainDlg.NewBtnClick(Sender: TObject);
begin
  TmCustomShape.DeleteAllShapes(ScrollBox1);
end;

procedure TUCMainDlg.OpenBtnClick(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    TmCustomShape.LoadFromFile(OpenDialog1.FileName,ScrollBox1);
  end;
  //TMcustomshape.
  if assigned(myimage) then begin
    myimage.Free;
    myimage:= NIL;
    STATImage:= false;
  end;
end;

procedure TUCMainDlg.SaveBtnClick(Sender: TObject);
begin
  SaveDialog1.FileName:= FCodeFileName;
  if STATImage then begin
   SavePictureDialog1.Filter:= BitmapLoaders.GetSaveFilter;
    if SavePictureDialog1.Execute then
    with TLinearBitmap.Create do
      try
        //myimage.Picture.Assign(scrollbox1);
        //myimage.Parent:= scrollbox1  ;
        //myimage.Assign(scrollbox1);
        Assign(myImage.Picture.Bitmap);
        // To compress JPEG2000 files to 5% of raw bitmap size, set
        // ImageDLLLoader.Default.CompOptions:='rate=0.05';
        SaveToFile(SavePictureDialog1.FileName);
      finally
        Free;
      end;
  end;
  {if SaveDialog1.FileName <> '' then begin
    TmCustomShape.SaveToFile(SaveDialog1.FileName, ScrollBox1);
    statusBar.Panels[0].Text:= SaveDialog1.FileName+' auto stored'
   end else}
  if SaveDialog1.Execute then begin
    TmCustomShape.SaveToFile(SaveDialog1.FileName, ScrollBox1);
    statusBar.Panels[0].Text:= SaveDialog1.FileName+' stored';
  end;
end;

procedure TUCMainDlg.ScrollBox1MouseDown(Sender: TObject; Button: TMouseButton;
        Shift: TShiftState; X, Y: Integer);
begin

 //ucMainDlg.Canvas.MoveTo(X, Y);
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
        Caption.Text       := 'New Package Group';
        Caption.OnDblClick := CaptionDblClick;
        Images             := DiagImageList;
        ImageIndex         := 11;
        Top                := Y;
        Left               := X;
        //Width              := 115;
        //Height             := 70;
        //images.Width       := 50;
        //images.Height      := 110;
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        AlignCaption(taCenter);
      end;
      ChooseButton(SelectBtn);
    end;

    jnaDrawEarth2: begin
      with TmBitmapShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'World Actor';
        Caption.OnDblClick := CaptionDblClick;
        Images             := DiagImageList;
        ImageIndex         := 1;
        Top                := Y;
        Left               := X;
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        AlignCaption(taCenter);
      end;
      ChooseButton(SelectBtn);
    end;

    jnaUC: begin
      with TmBitmapShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'Use Case';
        Caption.OnDblClick := CaptionDblClick;
        Images             := DiagImageList;
        ImageIndex         := 3;
        Top                := Y;
        Left               := X;
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        AlignCaption(taCenter);
      end;
      ChooseButton(SelectBtn);
    end;

    jnaAD: begin
      with TmBitmapShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'Activity';
        Caption.OnDblClick := CaptionDblClick;
        Images             := DiagImageList;
        ImageIndex         := 4;
        Top                := Y;
        Left               := X;
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        AlignCaption(taCenter);
      end;
      ChooseButton(SelectBtn);
    end;

    jnaCD: begin
      with TmBitmapShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'Class';
        Caption.OnDblClick := CaptionDblClick;
        Images             := DiagImageList;
        ImageIndex         := 5;
        Top                := Y;
        Left               := X;
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        AlignCaption(taCenter);
      end;
      ChooseButton(SelectBtn);
    end;

    jnaSE: begin
      with TmBitmapShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'State Event';
        Caption.OnDblClick := CaptionDblClick;
        Images             := DiagImageList;
        ImageIndex         := 6;
        Top                := Y;
        Left               := X;
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        AlignCaption(taCenter);
      end;
      ChooseButton(SelectBtn);
    end;

    jnaSEQ: begin
      with TmBitmapShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'Sequence';
        Caption.OnDblClick := CaptionDblClick;
        Images             := DiagImageList;
        ImageIndex         := 7;
        Top                := Y;
        Left               := X;
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        AlignCaption(taCenter);
      end;
      ChooseButton(SelectBtn);
    end;

    jnaPAC: begin
      with TmBitmapShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'New Package';
        Caption.OnDblClick := CaptionDblClick;
        Images             := DiagImageList;
        ImageIndex         := 8;
        Top                := Y;
        Left               := X;
        //width:= 50;
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        AlignCaption(taCenter);
      end;
      ChooseButton(SelectBtn);
    end;

    jnaCOM: begin
      with TmBitmapShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'New Component';
        Caption.OnDblClick := CaptionDblClick;
        Images             := DiagImageList;
        ImageIndex         := 9;
        Top                := Y;
        Left               := X;
        //width              := 150;
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        AlignCaption(taCenter);
      end;
      ChooseButton(SelectBtn);
    end;

      jnaDEP: begin
      with TmBitmapShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'Deployment';
        Caption.OnDblClick := CaptionDblClick;
        Images             := DiagImageList;
        ImageIndex         := 10;
        Top                := Y;
        Left               := X;
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        AlignCaption(taCenter);
      end;
      ChooseButton(SelectBtn);
    end;

    jnaAddSocket: begin
      with TmBitmapShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'New Socket';
        Caption.OnDblClick := CaptionDblClick;
        Images             := DiagImageList;
        ImageIndex         := 2;
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

    jnaAddTitle: begin
      with TmBitmapShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Font.Size:= 24;
        Caption.Text       := 'Set New Title';
        Caption.OnDblClick := CaptionDblClick;
        //Images             := DiagImageList;
        //ImageIndex         := 2;
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

   jnaRaute: begin     //rhombus
      with TmStandardShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'add Decision';
        Caption.OnDblClick := CaptionDblClick;
        ShapeType          := stRoundSquare; //..stEllipse;
        Top                := Y;
        Left               := X;
        Width              := 105;
        Height             := 60;
        //canvas.polyline([Point(0, 0), Point(50, 0), Point(75, 50), Point(25, 50), Point(0, 0)]);
        //recrectangle(scrollbox1.canvas,x,y,x,y);  rhombus
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        //Anchors = [akLeft, akRight, akBottom]
        AlignCaption(taCenter);
        Caption.Top:= Top + (Height div 2) - (Caption.Height div 2);
      end;
        ChooseButton(SelectBtn);
    end;

      jnaActivity: begin
      with TmStandardShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'add Action';
        Caption.OnDblClick := CaptionDblClick;
        ShapeType          := stRoundRect;
        Top                := Y;
        Left               := X;
        Width              := 115;
        Height             := 70;
        OnClick            := ShapeClick;
        Parent             := ScrollBox1;
        AlignCaption(taCenter);
        Caption.Top:= Top + (Height div 2) - (Caption.Height div 2);
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

    jnaFreeDraw: begin
      with TFreeDraw.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'Free Draw';
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

     jnaRect: begin
      with TmStandardShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'System Boundary';
        Caption.OnDblClick := CaptionDblClick;
        ShapeType          := stRectangle;
        Top                := Y;
        Left               := X;
        Width              := 400;
        Height             := 400;
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

procedure TUCMainDlg.SelectBtnClick(Sender: TObject);
begin
  // Don't add anything to the diagram on the next click on the scrollbox
  NextAction:= jnaNone;
end;


procedure TUCMainDlg.SetNextAction(Value: TjimNextAction);
begin
  FNextAction := Value;

  case FNextAction of
    jnaNone              : StatusBar.Panels[0].Text := 'Waiting';
    jnaAddActor          : StatusBar.Panels[0].Text := 'Place an actor on the diagram';
    jnaAddUseCase        : StatusBar.Panels[0].Text := 'Place a Use Case on the diagram';
    jnaStartDouble       : StatusBar.Panels[0].Text := 'Choose the actor';
    jnaEndDouble         : StatusBar.Panels[0].Text := 'Choose the use case';
    jnaStartUsesArrow    : StatusBar.Panels[0].Text := 'Choose a must first use case';
    jnaEndUsesArrow      : StatusBar.Panels[0].Text := 'Choose include case';
    jnaStartExtendsArrow : StatusBar.Panels[0].Text := 'Choose optional extend case';
    jnaEndExtendsArrow   : StatusBar.Panels[0].Text := 'Choose the second use case';
    jnaChartMove         : StatusBar.Panels[0].text:= 'let the chart moves';
    jnaDrawEarth         : statusBar.Panels[0].Text:= 'let the earth draw';
    jnaDrawEarth2        : statusBar.Panels[0].Text:= 'set an world actor';

    jnaAD                : statusBar.Panels[0].Text:= 'connect a Action case';
    jnaSE                : statusBar.Panels[0].Text:= 'connect a State case';
    jnaCD                : statusBar.Panels[0].Text:= 'add a Class case';
    jnaSEQ               : statusBar.Panels[0].Text:= 'connect a Sequence case';
    jnaPAC               : statusBar.Panels[0].Text:= 'add a Package';
    jnaCOM               : statusBar.Panels[0].Text:= 'add a Component';
    jnaDEP               : statusBar.Panels[0].Text:= 'add a Deployment';

    jnaRaute             : statusBar.Panels[0].Text:= 'set a decison';
    jnaActivity          : statusBar.Panels[0].Text:= 'set an action';

    jnaAddSocket   : statusBar.Panels[0].Text:= 'let the socket set';
    jnaAddTitle    : statusBar.Panels[0].Text:= 'double click to size the title';
    jnaFreeDraw    : statusBar.Panels[0].Text:= 'draw some free hand style';
    jnaRect        : statusBar.Panels[0].Text:= 'draw a Frame around System';
  end;
end;

procedure TUCMainDlg.ShapeClick(Sender : TObject);
begin
  {ShapeClick}
  if not (Sender is TmCustomShape) then begin
    Exit;
  end;

  case FNextAction of
    jnaStartDouble: begin
        // Check that it is an allowed shape
      if not ((Sender is TmBitmapShape) or (sender is TMoveableChart)) then begin
        raise EDiagramError.Create(UC2);
      end;
      FStartShape := TmCustomShape(Sender);
      NextAction  := jnaEndDouble;
    end;

    jnaEndDouble: begin
        // Check that it is an allowed shape
      if Sender = FStartShape then begin
        raise EDiagramError.Create(UC3);
      end else if not (Sender is TmStandardShape) then begin
        raise EDiagramError.Create(UC2);
      end;
      FEndShape := TmCustomShape(Sender);
      ConnectShapes(FStartShape,FEndShape,jatDouble);
      ChooseButton(SelectBtn);
    end;

    jnaStartUsesArrow : begin
        // Check that it is an allowed shape
      if not (Sender is TmStandardShape) then begin
        raise EDiagramError.Create(UC1);
      end;
      FStartShape := TmCustomShape(Sender);
      NextAction  := jnaEndUsesArrow;
    end;

    jnaEndUsesArrow : begin
        // Check that it is an allowed shape
      if Sender = FStartShape then begin
        raise EDiagramError.Create(UC3);
      end else if not (Sender is TmStandardShape) then begin
        raise EDiagramError.Create(UC1);
      end;
      FEndShape := TmCustomShape(Sender);
      ConnectShapes(FStartShape,FEndShape,jatUses);
      ChooseButton(SelectBtn);
    end;

    jnaStartExtendsArrow : begin
        // Check that it is an allowed shape
      if not (Sender is TmStandardShape) then begin
        raise EDiagramError.Create(UC1);
      end;
      FStartShape := TmCustomShape(Sender);
      NextAction  := jnaEndExtendsArrow;
    end;

    jnaEndExtendsArrow : begin
        // Check that it is an allowed shape
      if Sender = FStartShape then begin
        raise EDiagramError.Create(UC3);
      end else if not (Sender is TmStandardShape) then begin
        raise EDiagramError.Create(UC1);
      end;
      FEndShape := TmCustomShape(Sender);
      ConnectShapes(FStartShape,FEndShape,jatExtends);
      ChooseButton(SelectBtn);
    end;
  end;
end;

procedure TUCMainDlg.StatusBarDblClick(Sender: TObject);
begin
  nextAction:= jnadrawEarth2;
end;

procedure TUCMainDlg.tbtnGetClassClick(Sender: TObject);
begin
  nextAction:= jnadrawEarth; // to be continued
end;

procedure TUCMainDlg.UseCaseBtnClick(Sender: TObject);
begin
  // Add a use case to the diagram on the next click on the scrollbox
  NextAction:= jnaAddUseCase;
end;

procedure TUCMainDlg.UsesArrowBtnClick(Sender: TObject);
begin
  // Connect 2 use cases
  NextAction:= jnaStartUsesArrow;
  FStartShape:= NIL;
  FEndShape:= NIL;
end;


procedure TUCMainDlg.btnSEClick(Sender: TObject);
begin
 nextAction:= jnaSE;
end;

procedure TUCMainDlg.btnSEQClick(Sender: TObject);
begin
  nextAction:= jnaSEQ;
end;

procedure TUCMainDlg.btnSocketsClick(Sender: TObject);
begin
  NextAction:= jnaAddSocket;
end;

procedure TUCMainDlg.btnUCClick(Sender: TObject);
begin
 nextAction:= jnaUC;
end;

procedure TUCMainDlg.TbtnTitleClick(Sender: TObject);
begin
  NextAction:= jnaAddTitle;
end;

function Max(Val1, Val2: integer): integer;
begin
  Result := Val1;
  if Val2 > Val1 then
    Result := Val2;
end;

procedure PaintScrollBox(sb: TScrollBox; Canvas: TCanvas);
var sbPos: TPoint;
  tmpPos: integer;
begin
  sbPos.X:= sb.HorzScrollBar.Position;
  sbPos.Y:= sb.VertScrollBar.Position;
  try
    sb.HorzScrollBar.Position:= 0;
    sb.VertScrollBar.Position:= 0;
    while true do begin
      while true do begin
        sb.PaintTo(Canvas.Handle, sb.HorzScrollBar.Position, sb.VertScrollBar.Position);
        tmpPos:= sb.VertScrollBar.Position;
        sb.VertScrollBar.Position:= sb.VertScrollBar.Position + sb.ClientHeight;
        if sb.VertScrollBar.Position = tmpPos then
          Break;
      end;
      sb.VertScrollBar.Position := 0;
      tmpPos:= sb.HorzScrollBar.Position;
      sb.HorzScrollBar.Position:= sb.HorzScrollBar.Position + sb.ClientWidth;
      if sb.HorzScrollBar.Position = tmpPos then
        Break;
    end;
  finally
    sb.HorzScrollBar.Position:= sbPos.X;
    sb.VertScrollBar.Position:= sbPos.Y;
  end;
end;



procedure TUCMainDlg.CreateDiagramBitmap(Bmp: TBitmap);
begin
  // add some extra pixels around the edges...
  bmp.Width:= Max(scrollbox1.ClientWidth, scrollbox1.HorzScrollBar.Range) + 10;
  bmp.Height:= Max(scrollbox1.ClientHeight, scrollbox1.VertScrollBar.Range) + 10;
  bmp.Canvas.Brush.Color:= scrollbox1.Color;
  bmp.Canvas.FillRect(Rect(0, 0, bmp.Width, bmp.Height));
  PaintScrollBox(scrollbox1, bmp.Canvas);
end;


procedure TUCMainDlg.tlbtnSaveBitmapClick(Sender: TObject);
var dlgSaveImage: TSaveDialog;
  // add some extra pixels around the edges...
var b: TBitmap;
begin
  dlgSaveImage:= TSaveDialog.Create(self);
  //dlgSaveImage.Filter:= 'Bitmap files (*.bmp)|*.bmp|All files|*.*';
  dlgSaveImage.Filter:= 'PNG files (*.png)|*.png|All files|*.*';
  dlgSaveImage.Options:= [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing];
  dlgSaveImage.Title:= 'Save Diagram Image as PNG';
  dlgSaveImage.DefaultExt:= 'png';
  if dlgSaveImage.Execute then begin
    b:= TBitmap.Create;
    with TLinearBitmap.Create do
    try
      CreateDiagramBitmap(b);
      //b.SaveToFile(dlgSaveImage.Filename);
      Assign(b);
      //SaveToFile(dlgSaveImage.FileName+'.png');
      SaveToFile(dlgSaveImage.FileName);
      ShellExecute(Handle, 'open', PChar(dlgSaveImage.Filename),Nil,Nil,SW_SHOWNORMAL);
      StatusBar.Panels[0].Text:= dlgSaveImage.FileName+' Stored';
    finally
      Free;
      b.Free;
      dlgSaveImage.Free;
    end;
    //ShellExecute(Handle, 'open', PChar(dlgSaveImage.Filename), nil, nil, SW_SHOWNORMAL);
  end;
end;

 procedure TUCMainDlg.tbtnRectClick(Sender: TObject);
begin
  NextAction:= jnaRect;//draw a frame
end;

procedure TUCMainDlg.tbnClipboardClick(Sender: TObject);
var
  AFormat: Word;
  b: TBitmap;
  AData: Cardinal;
  APalette: HPALETTE;
begin
  b:= TBitmap.Create;
  try
    CreateDiagramBitmap(b);
    b.SaveToClipboardFormat(AFormat, AData, APalette);
    Clipboard.SetAsHandle(AFormat, AData);
  finally
    b.Free;
  end;
end;

(*with TLinearBitmap.Create do
      try
        //myimage.Picture.Assign(scrollbox1);
        //myimage.Parent:= scrollbox1  ;
        //myimage.Assign(scrollbox1);
        Assign(myImage.Picture.Bitmap);
        // To compress JPEG2000 files to 5% of raw bitmap size, set
        // ImageDLLLoader.Default.CompOptions:='rate=0.05';
        SaveToFile(SavePictureDialog1.FileName);*)


procedure TUCMainDlg.btnCDClick(Sender: TObject);
begin
  nextAction:= jnaCD;
end;

procedure TUCMainDlg.btnCOMClick(Sender: TObject);
begin
  NextAction:= jnaCOM;
end;

procedure TUCMainDlg.TBtnOpenPicsClick(Sender: TObject);
//var myimage: TImage;
   var myrect: TRect;
   imgindx: byte;
begin
// Set up the starting directory to be the current one
  //openDialog.InitialDir := GetCurrentDir;
 // Only allow existing files to be selected
  //openDialog.Options := [ofFileMustExist];
  // all the bitmaps
  OpenPictureDialog1.Filter:='All images ('+BitmapLoaders.GetLoadFilter;
  if OpenPictureDialog1.Execute then begin
     STATImage:= true;
    myimage:= TImage.Create(self);
    //myimage.parent:= Scrollbox1;
    //myimage.BoundsRect:= myRect;
    with TLinearBitmap.Create do
      try
        myImage.Picture:= NIL;
        LoadFromFile(OpenPictureDialog1.FileName);
        AssignTo(myImage.Picture.Bitmap);
        myrect.TopLeft.X:= 10;
        myrect.TopLeft.Y:= 10;
        myrect.BottomRight.X:= myimage.Picture.Width;
        myrect.BottomRight.Y:= myimage.Picture.Height;
        myimage.BoundsRect:= myRect;

      finally
        Free;
        //myimage.Free; in open uc dialog
      end;
    StatusBar.Panels[0].Text := OpenPictureDialog1.FileName+ ' Free Image Loaded';
  // Note: Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName) will
  // also load picture in all formats, but the result will not be a TBitmap.
    freeImageList:= TImageList.Create(self);
    freeImageList.ImageType:= itImage;
    with TmBitmapShape.Create(Self) do begin
        Caption            := TmTextShape.Create(Self);
        Caption.Text       := 'Free Image';
        Caption.OnDblClick := CaptionDblClick;
        Images             := freeImageList;
        Images.Height:= myimage.Picture.Height;
        Images.Width:= myimage.Picture.Width;
        imgindx:= freeImageList.Add(myimage.Picture.Bitmap, NIL);
        ImageIndex:= imgindx;
        SetBounds(10,10, myimage.Picture.Width, myimage.Picture.Height);
        Parent             := ScrollBox1;
        OnClick            := ShapeClick;
        AlignCaption(taCenter);
        //savetofile
     end;
  end;
end;

procedure TUCMainDlg.TBtnSavePicsClick(Sender: TObject);
begin
  SavePictureDialog1.Filter:= BitmapLoaders.GetSaveFilter;
  if SavePictureDialog1.Execute then
    //SavePictureDialog1.defaultExt; //= SavePictureDialog1.Filterindex;
    with TLinearBitmap.Create do
      try
        Assign(myImage.Picture.Bitmap);
        // To compress JPEG2000 files to 5% of raw bitmap size, set
        // ImageDLLLoader.Default.CompOptions:='rate=0.05';
        //SavePictureDialog1.FileName:= SavePictureDialog1.FileName +
        //SavePictureDialog1.defaultExt;
        // FileName is Empty
        if DirectoryExists(SavePictureDialog1.FileName) then
                                          exit;
       //if FileExtension(SavePictureDialog1.DefaultExt<>'' then
        SaveToFile(SavePictureDialog1.FileName);
      finally
        Free;
      end;
    StatusBar.Panels[0].Text:= SavePictureDialog1.FileName+ ' Stored';
end;

procedure TUCMainDlg.SetCodeFileName(vName: string);
begin
  FCodeFileName:= vName;
end;

procedure TUCMainDlg.btnActivityClick(Sender: TObject);
begin
  nextAction:= jnaActivity;
end;

procedure TUCMainDlg.btnADClick(Sender: TObject);
begin
  nextAction:= jnaAD;
end;

procedure TUCMainDlg.btnDecisionClick(Sender: TObject);
begin
  nextAction:= jnaRaute;
end;

procedure TUCMainDlg.btnDEPClick(Sender: TObject);
begin
  nextAction:= jnaDEP;
end;

procedure TUCMainDlg.btnFreeDrawClick(Sender: TObject);
begin
  NextAction:= jnaFreeDraw;
end;


{with TFileSaveDialog(Sender) do
  begin
    if DirectoryExists(FileName) then // FileName is Empty
      exit;
    case FileTypeIndex of
    1: Ext := '.png';
    2: Ext := '.bmp';
    3: Ext := '.jpg';
    end;
    Dialog.GetFileName(pName);
    FName := ChangeFileExt(ExtractFileName(pName), Ext);
    Dialog.SetFileName(PChar(FName));
  end;}


end.
