unit U_BigFloatTest_mX;
 {Copyright  © 03-05, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place. #locs:580
 All other rights are reserved , crossconverter and adaption by max
 #sign:Administrator: PC08: 19/03/2015 04:57:23 PM 
 }

interface

{uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, ComCtrls, ShellAPI, UBigFloatV3;
 }
//type
  //TOpBox = class(TForm)
  var
    Edit1: TEdit;
    Edit2: TEdit;
    TestBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lResult: TLabel;
    N1NormLbl: TStaticText;
    N1SciLbl: TStaticText;
    N2NormLbl: TStaticText;
    N2SciLbl: TStaticText;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lMaxdigits: TSpinEdit;
    Memo11: TMemo;
    StopBtn: TButton;
    StaticText1: TStaticText;
    OpList: TListBox;
    Label10: TLabel;
    ResultN: TMemo;
    ResultS: TMemo;
    MoveBtn: TButton;
       procedure TestBtnClick(Sender: TObject);
       procedure OpGrpClick(Sender: TObject);
       procedure StopBtnClick(Sender: TObject);
       procedure FormCreate(Sender: TObject);
       procedure StaticText1Click(Sender: TObject);
       procedure OpListDblClick(Sender: TObject);
       procedure MoveBtnClick(Sender: TObject);
  //private
    { Private declarations }
  //public
    { Public declarations }
  //end;

var
  Opf: TForm{TOpBox};
  //var  a,b:TBigfloat;

implementation

//{$R *.dfm}

type
  //Input conversions, {float,float}, {float,integer}, {float,none}, {none,none}
 TconvertTypes=(FF,FI,FN,NN);

 var ctype: array[0..19] of TConverttypes;
                                              {=(FF,FF,FF,FF,
                                               FN,FN,FI,FI,
                                               FI,FF,FF,FN,
                                               FN,FN,NN,
                                               FI,FI,FI,FI,FI);}

{******************* TestBtnClick ***************}
procedure TestBtnClick(Sender: TObject);
  var  a,b:TBigfloat;
       bInt:Integer;
       r:integer;
{perform the selected operation}
begin

  a:=TBigFloat.create;  a.Setsigdigits(lmaxdigits.Value);
  b:=TBigFloat.create;  b.SetSigdigits(lmaxdigits.Value);

  ctype[0]:= FF; ctype[1]:= FF; ctype[2]:= FF; ctype[3]:= FF;
  ctype[4]:= FN; ctype[5]:= FN; ctype[6]:= FI; ctype[7]:= FI;
  ctype[8]:= FI; ctype[9]:= FF; ctype[10]:= FF; ctype[11]:= FN;
  ctype[12]:= FN; ctype[13]:= FN; ctype[14]:= NN; ctype[15]:= FI;
  ctype[16]:= FI; ctype[17]:= FI; ctype[18]:= FI; ctype[19]:= FI;


  N1SciLbl.caption:='';
  N1NormLbl.caption:='';
  if (ctype[oplist.itemindex] = FF) or 
      (ctype[oplist.itemindex] = FI) or
       (ctype[oplist.itemindex] = FN) then
  begin {a= flost(x)}
      a.assign8(edit1.text);
      N1SciLbl.caption:=a.converttoString(scientific);
      N1NormLbl.caption:=a.converttoString(normal);
   end;
   if ctype[oplist.itemindex] =FF then begin
      b.Assign8(edit2.text);
      N2SciLbl.caption:=b.ConvertToString(scientific);
      N2NormLbl.caption:=b.ConvertToString(normal);
   end
   else
   if ctype[oplist.itemindex] =FI then begin
      bint:=strtoint(edit2.text);
      N2SciLbl.caption:='';
      N2NormLbl.caption:=edit2.text;
    end;

  with oplist do
   case itemindex of
    0: a.add(b);
    1: a.subtract(b);
    2: a.mult(b);
    3:begin
         screen.cursor:=crHourGlass;
         application.tag:=0;
         stopbtn.visible:=true;
         stopbtn.bringtofront;
         stopbtn.update;
         a.divide(b, lmaxdigits.Value);
         stopbtn.visible:=false;
         screen.cursor:=crdefault;
       end;
    4: a.square(lmaxdigits.value);
    5: a.sqrt1(lmaxdigits.value);
    6: a.reciprocal(lmaxdigits.value);
    7: a.IntPower(bInt, lmaxdigits.value);
    8: a.Nroot(bInt, lmaxdigits.value);
    9:{compare} r:=a.compare(b);
    10:{Power} a.Power(b, lmaxdigits.value);
    11:{Log}   a.Log(lmaxdigits.value);
    12:{Log10} a.Log10(lmaxdigits.value);
    13:{Exp}   a.exp(lmaxdigits.value);
    //14:{Floor} a.floor(bInt);
    //15:{Ceil} a.Ceiling(bInt);
    14:{Pi}  a.PiConst(lmaxdigits.value);
    15: {RoundToPrec}
        a.roundtoprec(bint);
    16: {Round}
        a.round(bint);
    17: {Trunc}
        a.trunc(bint);
    18: {Floor}
        a.Floor(bint);
    19: {Ceiling}
        a.Ceiling(Bint);
  end;
  //a.round;
  if oplist.itemindex=9 then
  begin
    case r of
      -1:ResultN.text:='-1 (X<Y)';
      0: ResultN.text:='0 (X=Y)';
      +1:ResultN.text:='+1 (X>Y)';
    end;
  end
  else begin
    ResultS.text:= a.ConverttoString(scientific);
    ResultN.text:= a.ConverttoString(normal);
  end;
  a.free;
  b.free;
  movebtn.enabled:=true;
end;

procedure OpGrpClick(Sender: TObject);
begin
  if (OpList.itemindex>=4) and (OpList.itemindex<=6) then edit2.visible:=false
  else edit2.visible:=true;
end;

procedure StopBtnClick(Sender: TObject);
begin
  application.tag:=1;      //just of divide
end;

procedure FormCreate(Sender: TObject);
begin
  Stopbtn.top:=testbtn.top;{buttons defined with different tops for convenience}
  edit1.text:= '4'+decimalseparator+'91234567891e-5';
end;

procedure StaticText1Click(Sender: TObject);
begin
  {ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;}
end;

procedure OpListDblClick(Sender: TObject);
begin
   testbtnclick(sender);
end;

procedure MoveBtnClick(Sender: TObject);
begin
  edit1.text:=results.text;
  {update the labels}
  N1SciLbl.caption:=resultn.text;
  N1NormLbl.caption:=results.text
end;

procedure CloseForm(Sender: TObject; var action: TCloseAction);
var i: integer;
begin 
   {for i:= 1 to psize do              
     TLabel(labelList.objects[i-1]).Free;}
   //a.Free; b.Free;  
   action:= caFree;  
   writeln('free it form objects')     //debug
end; 


procedure loadBigFloatform;
 begin
 opf:= TForm.create(self);
  with opf do begin
  SetBounds(129,100,1415,760)
  Caption := 'mX BigFloat Demo (Version 2.0)'
  Color := clBtnFace
  Font.Charset := DEFAULT_CHARSET
  Font.Color := clBtnText
  Font.Height := -17
  Font.Name := 'MS Sans Serif'
  Font.Style := []
  OldCreateOrder := False
  Position := poScreenCenter
  OnCreate := @FormCreate
  onClose:= @CloseForm
  PixelsPerInch := 144
  //TextHeight := 20
  show;
  end;
  // FormCreate(self);
   StaticText1:= TStaticText.create(opf)
  with StaticText1 do begin
    setBounds(0,710,1193,24)
    parent:= opf;
    Cursor := crHandPoint
    Align := alBottom
    Alignment := taCenter
    Caption := 'mX4 Copyleft '#169' 2014, Gary Darby,  www.DelphiForFun.org'
    Font.Charset := DEFAULT_CHARSET
    Font.Color := clBlue
    Font.Height := -17
    Font.Name := 'Arial'
    Font.Style := [fsBold, fsUnderline]
    ParentFont := False
    TabOrder := 0
    OnClick := @StaticText1Click
  end;
    with TLabel.create(opf) do begin
      parent:= opf
        setbounds(37,74,54,20)
       Caption := 'Normal'
   end;   
    with TLabel.create(opf) do begin
      parent:= opf
        setbounds(37,98,69,20)
        Caption := 'Scientific'
   end;   
   with TLabel.create(opf) do begin
      parent:= opf
        setbounds(37,209,54,20)
        Caption := 'Normal'
   end;   
    with TLabel.create(opf) do begin
      parent:= opf
      setbounds(37,246,69,20)
      Caption := 'Scientific'
   end;   
    with TLabel.create(opf) do begin
      parent:= opf
      setbounds(25,443,54,20)
      Caption := 'Normal'
   end;   
    with TLabel.create(opf) do begin
      parent:= opf
      setbounds(12,554,69,20)
      Caption := 'Scientific'
   end;   
  lResult:= TLabel.create(opf)
    with lresult do begin
      parent:= opf
      setbounds(25,406,75,29)
    Caption := 'Result'
    Font.Charset := DEFAULT_CHARSET
    Font.Color := clWindowText
    Font.Height := -24
    Font.Name := 'MS Sans Serif'
    Font.Style := [fsBold]
    ParentFont := False
  end;
    with TLabel.create(opf) do begin
      parent:= opf
      setbounds(12,37,19,29)
      Caption := 'X'
    Font.Charset := DEFAULT_CHARSET
    Font.Color := clWindowText
    Font.Height := -24
    Font.Name := 'MS Sans Serif'
    Font.Style := [fsBold]
    ParentFont := False
   end; 
   with TLabel.create(opf) do begin
    parent:= opf
    setbounds(12,137,19,29)   //172
    Caption := 'Y'
    Font.Charset := DEFAULT_CHARSET
    Font.Color := clWindowText
    Font.Height := -24
    Font.Name := 'MS Sans Serif'
    Font.Style := [fsBold]
    ParentFont := False
   end;   
   with TLabel.create(opf) do begin
    parent:= opf
    setbounds(287,332,223,39)
    autosize:= false;
    Caption := 'Max digits to display'
    Font.Charset := DEFAULT_CHARSET
    Font.Color := clWindowText
    Font.Height := -24
    Font.Name := 'MS Sans Serif'
    Font.Style := []
    ParentFont := False
    WordWrap := True
   end;   
   with TLabel.create(opf) do begin
    parent:= opf
    setbounds(751,37,117,29)
    autosize:= false;
    Caption := 'Operation'
    Font.Charset := DEFAULT_CHARSET
    Font.Color := clWindowText
    Font.Height := -24
    Font.Name := 'MS Sans Serif'
    Font.Style := [fsbold]
    ParentFont := False
    //WordWrap := True
   end;   
   StopBtn:= TButton.create(opf);
    with StopBtn do begin  
      parent:= opf
      setbounds(25,332,137,39)
      Caption := 'Stop'
      Font.Charset := DEFAULT_CHARSET
      Font.Color := clWindowText
      Font.Height := -18
      Font.Name := 'MS Sans Serif'
      Font.Style := [fsBold]
      ParentFont := False
      TabOrder := 7
      WordWrap := True
      visible:= false //false;
      OnClick := @StopBtnClick
    end;
   Edit1:= TEdit.create(opf)
   with edit1 do begin 
      parent:= opf
      setbounds(37,37,666,28)
    TabOrder := 0
    Text := '4.91234567891e-5'
  end;
   Edit2:= TEdit.create(opf)
   with edit2 do begin 
      parent:= opf
      setbounds(37,172,666,28)
    TabOrder := 0
    Text := '41'
  end;
  TestBtn:= TButton.create(opf)
   with testbtn do begin
      parent:= opf
      setbounds(25,320,137,38)
    Caption := 'Do it Calc! '
    TabOrder := 2
    OnClick := @TestBtnClick
  end;
  N1NormLbl:= TStaticText.create(opf);
  with n1normlbl do begin
      parent:= opf
      setbounds(123,74,31,24)
    Caption := 'xxx'
    Color := clWhite
    Font.Charset := DEFAULT_CHARSET
    Font.Color := clBtnText
    Font.Height := -18
    Font.Name := 'MS Sans Serif'
    Font.Style := [fsBold]
    ParentColor := False
    ParentFont := False
    TabOrder := 3
  end;
  N1SciLbl:= TStaticText.create(opf);
  with N1SciLbl do begin
      parent:= opf
      setbounds(123,98,31,24)
   Caption := 'xxx'
    Color := clWhite
    Font.Charset := DEFAULT_CHARSET
    Font.Color := clCaptionText
    Font.Height := -18
    Font.Name := 'MS Sans Serif'
    Font.Style := [fsBold]
    ParentColor := False
    ParentFont := False
    TabOrder := 4
  end;
  N2NormLbl:= TStaticText.create(opf);
 with N2NormLbl do begin
      parent:= opf
      setbounds(135,209,31,24)
   Caption := 'xxx'
    Color := clWhite
    Font.Charset := DEFAULT_CHARSET
    Font.Color := clCaptionText
    Font.Height := -18
    Font.Name := 'MS Sans Serif'
    Font.Style := [fsBold]
    ParentColor := False
    ParentFont := False
    TabOrder := 5
  end;
  N2SciLbl:= TStaticText.create(opf);
  with N2SciLbl do begin
      parent:= opf
      setbounds(135,246,31,24)
   Caption := 'xxx'
    Color := clWhite
    Font.Charset := DEFAULT_CHARSET
    Font.Color := clCaptionText
    Font.Height := -18
    Font.Name := 'MS Sans Serif'
    Font.Style := [fsBold]
    ParentColor := False
    ParentFont := False
    TabOrder := 6
  end;
  lMaxdigits:= TSpinEdit.create(opf)
  with lMaxdigits do begin
      parent:= opf
      setbounds(517,332,88,40)
    Font.Charset := DEFAULT_CHARSET
    Font.Color := clWindowText
    Font.Height := -24
    Font.Name := 'MS Sans Serif'
    Font.Style := []
    MaxValue := 1000
    MinValue := 2
    ParentFont := False
    TabOrder := 7
    Value := 30
  end;
  Memo11:= TMemo.create(opf)
  with memo11 do begin
      parent:= opf
      setbounds(738,500,507,190)
    Color := 14548991
    Lines.add('This is an investigaton of algorithms to manipulate large '
      +'floating point numbers. '
      +'Internally,  additions and subtractions shift number to align '
      +'virtual decimal points and the use "big integer" arithmetic to '
      +'perform the  operation.'
      +CRLF+''
      +'Multiplications simply multiply the numbers as if they were big '
      +'integers and then add the exponent values.'
      +'Divide makes successive  guesses for quotient and compares '
        + 'quotient X divisor to the input dividend_. until the difference is '
      +'less than the number of significant digits to be displayed .')
      wordwrap:= true;
        ScrollBars := ssVertical
      TabOrder := 8
  end;
  OpList:= TListBox.create(opf);
  with oplist do begin
      parent:= opf
      setbounds(738,74,507,410)
    Font.Charset := DEFAULT_CHARSET
    Font.Color := clWindowText
    Font.Height := 22
    Font.Name := 'MS Sans Serif'
    Font.Style := [fsBold]
    ItemHeight := 25
    Items.add('X + Y')
    Items.add('X - Y')
    Items.add('X * Y')
    Items.add('X / Y')
    Items.add('X^2')
    Items.add('Sqrt(X)')
    Items.add('1/X {Reciprocal}')
    Items.add('Yth Power X^Y   {Y integer}')
    Items.add('Yth Root  (X^1/Y)  {Y integer}')
    Items.add('Compare X to Y')
    Items.add('X^Y {Y floating point}')
    Items.add('Log(X) {Natural log}')
    Items.add('Log10(X)')
    Items.add('Exp(X)')
    Items.add('Pi')
    Items.add('X RoundToPrec(Y) {Y= signif. digits}')
    Items.add('X Round(Y) {Y = pos relative to dec. pt.}')
    Items.add('X Trunc(Y) {Y = pos relative to dec. pt.}')
    Items.add('X Floor(Y) {Y = pos relative to dec. pt.}')
    Items.add('X Ceiling(Y){Y = pos relative to dec. pt.}')
    Items.add(' ');
    ParentFont := False
    TabOrder := 11
    OnDblClick := @OpListDblClick
  end;
  ResultN:= TMemo.create(opf)
  with resultn do begin
      parent:= opf
      setbounds(86,443,619,100)
    Lines.add(
      '')
    ScrollBars := ssVertical
    TabOrder := 12
  end;
  ResultS:= TMemo.create(opf)
  with results do begin
      parent:= opf
      setbounds(86,554,619,100)
    ScrollBars := ssVertical
    TabOrder := 13
  end;
  MoveBtn:= TButton.create(opf)
  with movebtn do begin
      parent:= opf
      setbounds(86,677,162,38)
    Caption := 'Move result to X'
    Enabled := False
    TabOrder := 14
    OnClick := @MoveBtnClick
  end;

   FormCreate(self); //onform
 end;


var abig: TBigFloat;  
    resst_ ,tmps: string;

begin  //main

 abig:=TBigFloat.create;  
  abig.Setsigdigits(40);
  abig.PiConst(330);
   //writeln(abig.ConverttoString(scientific));
   resst_:= abig.ConverttoString(normal);
   writeln(resst_);
   for it:= 3 to length(resst_) do begin
      tmps:= tmps+ chr(atoi(resst_[it])+64);
      //write(chr(atoi(resst_[it])))
      //inc(it);
    end;  
      writeln(tmps)
      writeln(itoa(it))  
   {for it:= 1 to length(resst_) do 
      beep;}
     writeln(itoa(it))  
   abig.Free;
  
   maXcalcF('4'+decimalseparator+'91234567891e-5+41')
   maXcalcF('4'+decimalseparator+'91234567891e-5-41')
   maXcalcF('4.91234567891e-5*41')
   maXcalcF('4.91234567891e-5/41')
   maXcalcF('log(4.91234567891e-5)')
   maXcalcF('ln(4.91234567891e-5)')
  
   maXcalcF('1/4'+decimalseparator+'91234567891e-5')
  
   loadBigFloatform;

end.

{//
ref:

CodeSize 18854400 = .text 18805248 + .itext
SubsystemVersion 4.0
Comments reduce to the max
LinkerVersion 2.25
ImageVersion 0.0
FileSubtype 0
FileVersionNumber 3.9.9.180
LanguageCode German (Swiss)

3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712

}