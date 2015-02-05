program U_BigFloatTestBigInt;
//{ On Progress...#sign:Administrator: PC08: 04/02/2015 02:29:08 PM 
//var
  //OpBox: TOpBox;


type
  //Input conversions, {float,float}, {float,integer}, {float,none}, {none,none}
  tconvertTypes=(FF,FI,FN,NN);
{var converttype:array[0..19] of TConverttypes=(FF,FF,FF,FF,
                                               FN,FN,FI,FI,
                                               FI,FF,FF,FN,
                                               FN,FN,NN,
                                               FI,FI,FI,FI,FI);
 }
{******************* TestBtnClick ***************}
procedure TestBtnClick(Sender: TObject);
  var  a,b:TBigfloat;
       bInt:Integer;
       r:integer;
       listbox: TListbox;
       axdigits: TSpinEdit;
        ResultN: TMemo;
     ResultS: TMemo;
   
       
{perform the selected operation}
begin

  a:=TBigFloat.create;  a.Setsigdigits(maxdigits);      //maxdigits.value
  b:=TBigFloat.create;  b.SetSigdigits(maxdigits);


  (*N1SciLbl.caption:='';
  N1NormLbl.caption:='';
  if converttype[oplist.itemindex] in [FF,FI,FN] then
  begin {a= flost(x)}
      a.assign(edit1.text);
      N1SciLbl.caption:=a.converttoString(scientific);
      N1NormLbl.caption:=a.converttoString(normal);
   end;
   if converttype[oplist.itemindex] =FF then
   begin
      b.Assign(edit2.text);
      N2SciLbl.caption:=b.ConvertToString(scientific);
      N2NormLbl.caption:=b.ConvertToString(normal);
   end
   else
   if converttype[oplist.itemindex] =FI then
    begin
      bint:=strtoint(edit2.text);
      N2SciLbl.caption:='';
      N2NormLbl.caption:=edit2.text;
    end;*)

  with listbox do
  case itemindex of
    0: a.add(b);

    1: a.subtract(b);

    2: a.mult(b);

    3:begin
         screen.cursor:=crHourGlass;
         application.tag:=0;
         //stopbtn.visible:=true;
         //stopbtn.bringtofront;
         //stopbtn.update;
         a.divide(b, axdigits.Value);
         //stopbtn.visible:=false;
         screen.cursor:=crdefault;
       end;
    4: a.square(axdigits.value);
    //5: a.sqrt(axdigits.value);
    6: a.reciprocal(axdigits.value);
    7: a.IntPower(bInt, axdigits.value);
    8: a.Nroot(bInt, axdigits.value);
    9:{compare} r:=a.compare(b);
    10:{Power} a.Power(b, axdigits.value);
    11:{Log}   a.Log(axdigits.value);
    12:{Log10} a.Log10(axdigits.value);
    13:{Exp}   a.exp(axdigits.value);
    //14:{Floor} a.floor(bInt);
    //15:{Ceil} a.Ceiling(bInt);
    14:{Pi}  a.PiConst(axdigits.value);
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
  if listbox.itemindex=9 then
  begin
    case r of
      -1:ResultN.text:='-1 (X<Y)';
      0: ResultN.text:='0 (X=Y)';
      +1:ResultN.text:='+1 (X>Y)';
    end;
  end
  else
  begin
    ResultS.text:=a.ConverttoString(scientific);
    ResultN.text:=a.ConverttoString(normal);
  end;
  a.free;
  b.free;
  //movebtn.enabled:=true;
end;

(*procedure TOpBox.OpGrpClick(Sender: TObject);
begin
  if (OpList.itemindex>=4) and (OpList.itemindex<=6) then edit2.visible:=false
  else edit2.visible:=true;
end;

procedure TOpBox.StopBtnClick(Sender: TObject);
begin
  application.tag:=1;
end;

procedure TOpBox.FormCreate(Sender: TObject);
begin
  Stopbtn.top:=testbtn.top;{buttons defined with different tops for convenience}
  edit1.text:= '4'+decimalseparator+'91234567891e-5';
end;

procedure TOpBox.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TOpBox.OpListDblClick(Sender: TObject);
begin
   testbtnclick(sender);
end;

procedure TOpBox.MoveBtnClick(Sender: TObject);
begin
  edit1.text:=results.text;
  {update the labels}
  N1SciLbl.caption:=resultn.text;
  N1NormLbl.caption:=results.text
end;*)

function BigDiv2(aone, atwo: string): string;
var tbig1, tbig2: TInteger;
begin
  tbig1:= TInteger.create(10);
  tbig2:= TInteger.create(10);
  try
    tbig1.assign2(atwo)
    tbig2.assign2(aone)
    tbig2.Divide(tbig1)
  finally
    result:= tbig2.ConvertToDecimalString(false)
    tbig1.Free;
    tbig2.free;
  end;
end;  

{class} function RemoveBlanks(const s: string): string;
{deletes all blanks in s}
var
  i : integer;
begin
  Result := s;
  StringReplace(Result,' ','',[rfReplaceAll]);
  (*
  i := pos(' ', Result);
  while i > 0 do
  begin
    delete(Result, i, 1);
    i := pos(' ', Result);
  end;
  *)
end;


 var abig,bbig:TBigfloat;
  Fmt: TFormatSettings;
  S: String;
  atbig: TInteger;

begin

//Fmt := TFormatSettings.Create; // get default settings
  //
  // or:
  // Fmt := TFormatSettings.Create(SomeLocaleID); // get locale-specific settings
  //
  // or:
  // Fmt := TFormatSettings.Create(SomeLocaleName); // get locale-specific settings
  //

  // customize its fields to use whatever you want...
  Fmt.DecimalSeparator := '.';
  Fmt.ThousandSeparator := '.';

  // now format it...
  //S := FloatToStr(Value, Fmt);

  abig:=TBigFloat.create;  
  abig.Setsigdigits(40);
  abig.PiConst(280);
   writeln(abig.ConverttoString(scientific));
   writeln(abig.ConverttoString(normal));

  abig.Free;
  
  atbig:= TInteger.create(123)
  //atbig.assign2('43858699494985567')
  atbig.assign2('1024')
 
  atbig.Mult(atbig)
  writeln(atbig.ConvertToDecimalString(true))
  
  with TInteger.create(122345) do begin
    
    assign2('35757699777777777777777777777777777777777')
    Mult(atbig)
    writeln(ConvertToDecimalString(true))
    writeln(ConvertToHexString)

    Free;
    
  end;
 // atbig.Free;
 
 //ref:
 
  with TInteger.create(1) do begin
    
    assign2('2')
    //Mult(atbig)
    pow(1024)
    writeln(ConvertToDecimalString(false))
    //divide(atbig)
    //writeln(ConvertToDecimalString(false))

    //writeln(ConvertToHexString)

    Free;
    
  end;
  atbig.Free;
  
  with TInteger.create(1) do begin
    assign2('100')
    //Mult(atbig)
    //pow(1024)
    factorial;
    writeln('factorial: '+ConvertToDecimalString(false))
    //divide(atbig)
    //writeln(ConvertToDecimalString(false))
    //writeln(ConvertToHexString)
    Free;
    end;
   //9.332621544394415699238856267e+157 
   writeln(BigFactorial('100'))
  
   writeln(((powerBig(2,1024))))
 
   writeln('BigDiv: '+BigDiv('4000078669','2000123'));
  
  //1,568,286,209,185,467,743,563,551,777,777,777,777,777,743,665,455,948,344,559


end.
