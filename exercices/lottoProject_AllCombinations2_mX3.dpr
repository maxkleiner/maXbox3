program All_LottoCombinations_bit_Power;
// shows the mighty performance of all solutions 6 of 45 by max & beat straehl
// ZWEIHOCHFUENFUNDVIERZIG = 35184372088832;
// time consuming is about 45 minutes! without optimisation about 20 days!!
// number of lotto spheres are 45 with 6 crosses on it

//{$APPTYPE CONSOLE}

//uses Classes, SysUtils;

const NUMBER_OF_SPHERES = 45;
      NUMBER_OF_BITS_ARRAY_UPPER_END = 255;

var  counter, counterCopy, counterOffset, range: int64;
     bitCounter, bitCount, bitPosition: integer;
     combCounter: integer;
     byteFragmentIndexOfCounter: integer;
     positionOfLowestBitOutOfSix: integer;
     numberOfBits: array[0..NUMBER_OF_BITS_ARRAY_UPPER_END] of byte;
     before, after, beforePrint, afterPrint: TDateTime;
     combstr: string;
     lottoList: TStringList;
     E: Exception;

function powerOf2(exponent: integer): int64;
var shifter: int64;
    counter: integer;
begin
  shifter:= 1;
  for counter:= 1 to exponent do
    shifter:= shifter + shifter;
  result:= shifter;
end;

procedure presetBitCountLookupTable(highestIndex: integer);
var arrayIndex: integer;
    numberOfBitsSet: integer;
    byteValue: integer;
begin
  for arrayIndex:= 0 to highestIndex do begin //preset bit count lookup table
     byteValue:= arrayIndex;
     numberOfBitsSet:= 0;
     for bitCounter:= 1 to 8 do begin
        if ((byteValue and 1) = 1) then
          inc(numberOfBitsSet);
        byteValue:= byteValue shr 1;
     end;
    numberOfBits[arrayIndex]:= numberOfBitsSet;
  end;
end;

begin  //main
  try
  presetBitCountLookupTable(NUMBER_OF_BITS_ARRAY_UPPER_END);
  range:= powerOf2(NUMBER_OF_SPHERES);
  lottoList:= TStringlist.create;
  before:= Time;
  Writeln('Lotto report 6 of 45 start at: '+ FormatDateTime('hh:nn:ss.zzz',before));
  Writeln('You get a file  "All_lotto_combinations2.txt" of about 240 MByte!');
  counter:= 0;
  lottoList.add('All lotto combinations 6 from ' +IntToStr(NUMBER_OF_SPHERES));
  lottoList.add('**********************************************************');

  while counter < range do begin  //check cases
      bitCount:= 0;
      counterCopy:= counter;
      for byteFragmentIndexOfCounter:= 0 to 5 do begin
         bitCount:= bitCount+numberOfBits[counterCopy mod 256];
         counterCopy:= counterCopy shr 8;
      end;
      if (bitCount=6) then begin
        counterCopy:= counter;
        positionOfLowestBitOutOfSix:= -1;
        inc(combCounter);
        //write('combination #' + inttostr(combinationCounter) +': ');
        for bitCounter:=1 to NUMBER_OF_SPHERES do begin
            if ((counterCopy and 1) = 1) then begin
               //write(inttoStr(bitCounter) +' ');
               combstr:=  combstr+ ' '+inttoStr(bitCounter);
               if (positionOfLowestBitOutOfSix= -1) then
                 positionOfLowestBitOutOfSix:= bitCounter;
            end;
          counterCopy:= counterCopy shr 1;
        end;
        //writeln(' ');
        lottoList.add('# '+inttostr(combCounter)+': '+ combstr);
        combstr:= '';
        counterOffset:= 1;
        bitPosition:= 1;
        while (bitPosition<positionOfLowestBitOutOfSix) do begin
          counterOffset:= counterOffset + counterOffset;
          inc(bitPosition);
        end;
        counter:= counter + counterOffset;
      end else
        counter:= counter + 1;
  end; //while
  after:= Time;
  beforePrint:= time;
  Writeln('Save lotto file start at: ' +TimeToStr(beforePrint) + ' '+DateToStr(date));
  lottoList.SaveToFile('All_lotto_combinations2.txt');
  lottoList.Free;
  afterPrint:= time;
  Writeln('Save lotto stopped at: ' +TimeToStr(afterPrint) + ' '+DateToStr(date));
  Writeln('Save file lasted: '+FormatDateTime('hh:nn:ss.zzz',afterPrint-beforePrint));
  Writeln('Lotto report calc ended at: '+ FormatDateTime('hh:nn:ss.zzz',after));
  Writeln('Lotto report calc lasted: '+FormatDateTime('hh:nn:ss.zzz',after-before));
  Writeln('Lotto report total lasted: '+FormatDateTime('hh:nn:ss.zzz',afterPrint-before));
  Writeln('6 of ' +IntToStr(NUMBER_OF_SPHERES)+' are: ' +IntToStr(combCounter));

  except
    //E:Exception do
      Writeln('E.Classname'+ ': '+ E.Message);
  end;
end.
