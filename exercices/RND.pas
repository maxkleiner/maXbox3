{-Modulename and path: RND
//
//D:\franktech\UMLbook\UMLbook2\designPattern\dpatterns\patterns7.mpb
//Category    Controller
//
//Developer kleiner kommunikation
//Last Modification on 10.06.03 23:39:19:
//simulator Engine of financal engineering
  6.6.03 redesign of Hurst exponent
  9.6.03 performance now zoom based
  patterns: visitor
  ex.: Visitor.VisitElementChartData(Self);
//==========================================================================}
UNIT RND;
(*********************************************************)
(*   Finanzzahlengenerator                               *)
(*   1999 max kleiner                                    *)
(*   Borland Delphi 3                                    *)
(*********************************************************)
{
Die Funktion RandomA liefert pseudozufällige Zahlen im
Bereich 0<=r<=1, die den Spektral-Test (Knuth, V2, §3.4)
besteht. Da die Parameter dem Lehrsatz A (op.cit. S.15)
genügen, werden unabhängig vom Startwert eine Million
unterschiedlicher Zufallszahlen erzeugt.
Dieser Zufallszahlengenerator wurde von Don Malm für ein
Programm für die HP-65 Anwenderbibliothek entwickelt.
HP-34C Standard Programmsammlung
September 1979 Seite 58
chartgenerator first fix in DAT}

interface

uses classes, sysutils, forms;

const
//Startwert für Generator
  StartValue: Extended = 0.5;
//Anzahl zu berechnender Werte     
  DAT = 1600;          

type
 TMemor= array[1..DAT] of double;
 TMAverage = array[1..DAT] of double;
 TPerfMem = array[1..DAT] of integer;
 THurst = array[1..DAT] of double;
 
 TChartVisitor = class;

  EOptMovingAverage = class (Exception)
  end;
  

  TChartGen = class (TObject)
  protected
    procedure letPrimeStatistics(const chartData: TMemor; var mn, std: 
            extended);
  public
    function ChartGenerator(HBase, count: integer; var vdata: TMemor): Boolean;
    function genStatistics(const cData: TMemor; const maData: TMAverage): 
            string;
    function getFramePerfCount(const perfMem: TPerfMem; frameWidth: integer): 
            Integer;
    function getHurst(const memos: TMemor; var hu: THurst; datlen: integer): 
            Boolean;
    procedure MAPerformance(const memos: TMemor; ma: TMAverage; framePerf: 
            integer; var perfMem: TPerfMem; var perfAmount: integer);
    function MovingAverage(const memos: TMemor; var MA: TMAverage; datlen: 
            integer; time: byte): Boolean;
    function optMovingAverage(from, till: byte; const chartData: TMemor; 
            chartcount: word; var optMA: byte; perfList: TStringList): 
            TStringList;
    function RandomA(RefValue : Extended): Extended;
    procedure setMACycle(mycycle: integer);
    procedure zoomfact(var cData: TMemor; vfact: single);
  end;
  
  TChartMember = class (TObject)
  public
    procedure acceptMemberVisitor(visitor: TChartVisitor); virtual; abstract;
  end;
  
  TElementChartData = class (TChartMember)
  public
    procedure acceptMemberVisitor(visitor: TChartVisitor); override;
    procedure getMeanStat(const data: TMemor; var mean, stddev: extended);
  end;
  
  TElementChartMA = class (TChartMember)
  public
    procedure acceptMemberVisitor(visitor: TChartVisitor); override;
    procedure getmomentSkew(const data: TMAverage; var m1, m2, m3, m4, skew, 
            kurtosis: extended);
  end;
  
  TChartVisitor = class (TObject)
  private
    FcData: TMemor;
    FmaData: TMAverage;
    FTotalStatistic: string;
  protected
    procedure SetTotalStatistic(Value: string);
  public
    constructor create(const cData: TMemor; const maData: TMAverage); virtual;
    procedure visitElementChartData(inst: TElementChartData); virtual;
    procedure visitElementChartMA(inst: TElementChartMA); virtual;
    property TotalStatistic: string read FTotalStatistic write 
            SetTotalStatistic;
  end;
  

implementation

 uses  ulooktrans, math;

{
********************************** TChartGen ***********************************
}
function TChartGen.ChartGenerator(HBase, count: integer; var vdata: TMemor): 
        Boolean;
var
  i, y2: Integer;
  mn, std: Extended;
begin
  randomize;
  y2:= HBase;
  try
    result:= false;
    for i:= 1 to count do begin
      y2:= y2 + (random(RANDHIGH) - random(RANDLOW));
      if y2 > 0 then
      vdata[i]:= abs(round(y2))
      else vdata[i]:= 1;
    end;
   letPrimeStatistics(vdata,mn,std);
   result:= true;
  finally
   //randomize;
  end;
end;

function TChartGen.genStatistics(const cData: TMemor; const maData: TMAverage): 
        string;
var
  visitor: TChartVisitor;
  objCData: TElementChartData;
  objCMA: TElementChartMA;
begin
  visitor:= TchartVisitor.create(cData, madata);
  objcData:= TElementChartData.create;
  objcMA:= TElementChartMA.create;
  try
    objCData.AcceptMemberVisitor(Visitor);
    objcMA.AcceptMemberVisitor(Visitor);
    result:= visitor.totalStatistic;
  finally
    visitor.free;
    objCData.free;
    objcMA.free;
  end;
end;

function TChartGen.getFramePerfCount(const perfMem: TPerfMem; frameWidth: 
        integer): Integer;
var
  z, i: Integer;
  buysell: Byte;
begin
   z:= 0;
   buysell:= 0;
   for i:= 1 to frameWidth -1 do begin
     inc(z);
     if perfMem[z]= SELLSYM then begin
       inc(buysell);
       inc(z);
     end
   end;
  result:= buysell;
end;

function TChartGen.getHurst(const memos: TMemor; var hu: THurst; datlen: 
        integer): Boolean;
var
  hurst, deltaR: Double;
  i: Integer;
  std: Extended;
  dynarray: array of Double;
begin
  //std:= stdDev(memos);
   for i:= 1 to datlen -1 do HU[i]:=0;
   SetLength(dynarray, high(memos));
   for i:= 1 to datlen -1 do begin
    dynarray[i-1]:= memos[i];
     //dynarray:= copy(memos);
     setlength(dynarray, i+1);
     deltaR:= maxValue(dynarray) - minValue(dynarray);
     std:= stdDev(dynarray);
     hurst:= ln(deltaR/std)/ln(i+1);
     hu[i]:= hurst;
    end;
  result:= true;
  
  {function TotalVariance(const Data: array of Double): Extended;
  var
    Sum, SumSquares: Extended;
  begin
    SumsAndSquares(Data, Sum, SumSquares);
    Result:= SumSquares - Sqr(Sum)/(High(Data) - Low(Data) + 1);
  end;}
end;

procedure TChartGen.letPrimeStatistics(const chartData: TMemor; var mn, std: 
        extended);
begin
  MeanAndStdDev(chartData, mn, std);
end;

procedure TChartGen.MAPerformance(const memos: TMemor; ma: TMAverage; 
        framePerf: integer; var perfMem: TPerfMem; var perfAmount: integer);
var
  z, i, delta1, delta2, deltaBuySell: Integer;
  firstBuy, firstSell, nextSell, nextBuy: Byte;
begin
   //symbol 1 is buy, symbol 2 is sell
   firstbuy:= 1;
   firstsell:= 0;
   perfAmount:= 0;
   delta1:= 0;
   delta2:= 0;
   z:=5;
   nextSell:= 1;
   nextBuy:= 1;
   for i:= 1 to framePerf do perfMem[i]:=0; //check
   while z < framePerf-9 do  begin
    inc(z);
    if ((memos[z]) > (ma[z])) and (firstBuy=1) then begin
      delta1:= round((memos[z] + memos[z+1])/2);
      firstBuy:= 0;
      firstSell:= 1;
      nextSell:= 1;
      perfMem[z]:= BUYSYM;
    end else
    if (((memos[z])<= ma[z])) and (firstSell=1) then begin //sell
      delta2:= round((memos[z] + memos[z+1])/2);
      firstSell:= 0;
      firstBuy:= 1;
      nextBuy:= 1;
      perfMem[z]:= SELLSYM;
      deltaBuySell:=delta2 - delta1;
      perfMem[z+1]:= deltaBuySell;
      perfAmount:= perfAmount + deltaBuySell;
    end;
    //approximator to next sell and to next buy
    if nextBuy = 1 then begin
      nextBuy:= 0;
      if ((z+DISTMIN)<(framePerf-DISTMIN)) then
       z:= z + DISTMIN else exit;
      if ((memos[z]) > ma[z]) and (z < framePerf) then repeat
        inc(z)
      until (memos[z]) < ma[z];
    end;
    if nextSell = 1 then begin
      nextSell:= 0;
      if ((z+DAYMIN)<(framePerf-DAYMIN)) then
       z:= z + DAYMIN else exit;
      if ((memos[z]) < ma[z]) and (z < framePerf-9) then repeat
        inc(z)
      until (memos[z]) >= ma[z];
    end;
   end;
end;

function TChartGen.MovingAverage(const memos: TMemor; var MA: TMAverage; 
        datlen: integer; time: byte): Boolean;
var
  masum, y: Double;
  i: Integer;
begin
   masum:= 0;
   for i:= 1 to datlen -1 do MA[i]:=0;
   for i:= 1 to datlen -1 do begin
     y:= memos[i];
     if i <= time then begin
       masum:= masum + y;
       MA[i]:= round(masum/i);
     end;
     if i > time then begin
      //moving the timewindow
       masum:= masum - ((memos[i - time])) + y;
       MA[i]:= round(masum/time);
     end;
   end;
  result:= true;
end;

function TChartGen.optMovingAverage(from, till: byte; const chartData: TMemor; 
        chartcount: word; var optMA: byte; perfList: TStringList): TStringList;
var
  i, perfAmount, framepcount, maxperf: Integer;
  period: string;
  perfMem: TPerfMem;
  maData: TMAverage;
  perfcount, cycle: Byte;
begin
   perfcount:= till - from;
   perfAmount:= 0;
   cycle:= from;
   maxperf:= -1000;
   optMA:= 0;
  try
    for i:= 1 to perfcount do begin
     //period:=' ';  external exception!!!
     inc(cycle);
     movingAverage(chartData, maData, chartcount, cycle);
     MAPerformance(chartData, maData, chartcount,
                              perfMem, perfAmount);
     if perfamount > maxperf then begin
       maxperf:= perfamount;
       optMA:= from + i;
     end;
     framePcount:=getFramePerfCount(perfMem, chartcount);
     period:= format('%d %d   %d  %d',[cycle, perfamount, +
                                        framePCount, optMA]);
     perfList.add(period);
    end;
    result:= perflist;
  except
    raise EOptMovingAverage.Create(trans.strlit[35])
  end;
end;

function TChartGen.RandomA(RefValue : Extended): Extended;
begin
  Result:= Frac(9821.0 * RefValue + 0.211327)
end;

procedure TChartGen.setMACycle(mycycle: integer);
begin
  MA_CYCLE:= mycycle;
end;

procedure TChartGen.zoomfact(var cData: TMemor; vfact: single);
var
  i: Integer;
begin
  //intfact:= round(hi div mx);
  for i:= 1 to chdat -1 do
    cdata[i]:= cdata[i] * vfact
end;

{
****************************** TElementChartData *******************************
}
procedure TElementChartData.acceptMemberVisitor(visitor: TChartVisitor);
begin
  Visitor.VisitElementChartData(Self);
end;

procedure TElementChartData.getMeanStat(const data: TMemor; var mean, stddev: 
        extended);
begin
  MeanAndStdDev(Data, mean, stddev);
end;

{
******************************* TElementChartMA ********************************
}
procedure TElementChartMA.acceptMemberVisitor(visitor: TChartVisitor);
begin
  Visitor.VisitElementChartMA(Self);
end;

procedure TElementChartMA.getmomentSkew(const data: TMAverage; var m1, m2, m3, 
        m4, skew, kurtosis: extended);
begin
  momentSkewKurtosis(data, m1, m2, m3, m4, skew, kurtosis)
end;

{
******************************** TChartVisitor *********************************
}
constructor TChartVisitor.create(const cData: TMemor; const maData: TMAverage);
begin
  FcData:= cData;
  FmaData:= maData;
end;

procedure TChartVisitor.SetTotalStatistic(Value: string);
begin
  if FTotalStatistic <> Value then
  begin
    FTotalStatistic := Value;
  end;
end;

procedure TChartVisitor.visitElementChartData(inst: TElementChartData);
var
  mean, stddev: Extended;
begin
  inst.getMeanStat(fcData, mean, stddev);
  FTotalStatistic:=
       Format('mean: %4.3f stddev: %4.3f ',[mean, stddev]);
end;

procedure TChartVisitor.visitElementChartMA(inst: TElementChartMA);
var
  m1, m2, m3, m4, skew, kurtosis: Extended;
begin
  inst.getMomentSkew(fmaData, m1, m2, m3, m4, skew, kurtosis);
  fTotalStatistic:=
      fTotalStatistic +Format(' m1: %4.3f m2: %4.3f',[m1, m2]);
end;


end.

