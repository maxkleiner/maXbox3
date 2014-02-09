
program primetester_14project;

{$APPTYPE CONSOLE}

uses
  SysUtils, classes;

//shows the recursive solution to the 8 queens chess problem, max@kleiner.com
//small output of solution in text mode or file list!, loc's =96
//92 board solutions are possible! you can find the solutions in a txt file



{ simple primtester between range for perfomance- and filehandling
has a function and procedure, consts, globals and locals, locs = 59
shows sequence, selection and iteration (units are implicit)
to teach programming for beginners in maXbox!}
//4294967296    2147483648

//const
  //FROM_RANGE = 90000000;
  //TO_RANGE =  100000000;

  //FROM_RANGE = 2146483400;
  //TO_RANGE = 2147483640;
  //FROM_RANGE = 1000;
  //TO_RANGE = 5000;
  //FROM_RANGE = 2147483400;
  //TO_RANGE = 2147483645;       // = 10 primes

//globals
var
  mylist: TStringList;   //is an object from class TStringList!
  time1, time2, diff: TDateTime;
  paractr: integer;

function checkPrim(acti: longint): boolean;
var //locals
  j, mysqr: longint;
  isprim: boolean;
begin
  isprim:= true;
  mysqr:= round( SQRT(acti));
  //for j:= 2 to round( SQRT(acti)) do
  for j:= 2 to mysqr do

  //for j:= 2 to acti - 1  do
     if ((acti mod j) = 0) then begin
      isprim:= false;
      break
    end;
  result:= isprim;
end;


procedure TestPrimNumbers(Vfrom_range, Vto_range: longint);
var acti, count: longint;
begin
  count:= 0; //init
  //count2:= 0;
  mylist:= TStringList.create;
  for acti:= Vfrom_range to Vto_range do begin
   //inc(acti)
   {inc(count2)
    writeln(inttostr(count2))}
    if checkPrim(acti) then begin
      inc(count);
      mylist.add(intToStr(count) +': '+intToStr(acti))
    end //if
  end //for
end;

var
myres: int64;
from_range, to_range: longint;

//9223372036854775808

//main program
begin
  //time performance
  //for paractr:=1 to ParamCount do
  writeln('this tool saves prime numbers in a file: call it for e.g. with '
       +(ParamStr(0))+ ' "1000" "5000"') ;
   from_range:= strToInt(paramStr(1));
   to_range:= strToInt(ParamStr(2));

  time1:= time;
  writeln('the range you want is: '
            + inttoStr(from_range) +' to '+inttostr(to_range));
  writeln(formatdatetime('"performance start is:" hh:mm:ss:zzz', time));
    TestPrimNumbers(FROM_RANGE, TO_RANGE);
  time2:= time;
  writeln(formatdatetime('"performance stop is:" hh:mm:ss:zzz', time));
  Diff:= time2 - time1;
  writeln(IntToStr(Trunc(Diff * 24)) +
                   FormatDateTime('" h elapsed run time is:" nn:ss:zzz',Diff));
  mylist.add(IntToStr(Trunc(Diff * 24)) +
                   FormatDateTime('" h elapsed run time is:" nn:ss:zzz',Diff));
  mylist.saveToFile(ExtractFilePath(ParamStr(0))+'primetest30_dos_delphi.txt');
  //memo2.lines.loadFromFile('primetest12.txt')
  writeln('calculated from maxbox starter '+(ParamStr(0))) ;
  writeln('prime numbers are in file primetest30_dos_delphi.txt') ;
  myres:= trunc(SQRT(922337205807));
  //trunc(myres)
  writeln('finished test value is 960383: '+inttostr((myres)));
  mylist.Free;
  //orthogonal and idempotent!
end.






{*begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  //except
    //on E:Exception do
      //Writeln(E.Classname, ': ', E.Message);
  //end;
//end.*}

{Wednesday, 24 June 2009
Delphi is fast, very fast
Jesper Hald and others recently did a benchmark of a certain algorithm to figure out, which was fastest. It evolved into a kind of competition to make the fastest algorithm to solve this problem:

Fill a data structure with 1,000,000 random, unsorted values from 0-100
Run through this data structure 200 times, counting
a) number of values = 42
b) average for all 1,000,000*200 values

The benchmark was run on a new T5800 (2GHz, 800MHz) Toshiba laptop running 32-bit Windows Vista. Nothing had been done to the Vista to make it faster or behave in a special way.

The results were interesting, and our conclusions were:

* The fastest algorithm was made in Delphi (2009 version), was reasonably easy to read, and achieved to count the 42-values amongst 200,000,000 values in 55ms. That's pretty fast: 0.275 nanoseconds per value or about 0.5 clock cycles per value.

* Some of the first attempts in C# were 30-50 times slower than the winner.

* C# and Java were generally about 1.5 times slower than Delphi. Using normal generic lists in C# would make it 13 times slower than a simple Delphi implementation with static arrays. Is this comparison fair? Well, that's how the first results were made by the various programmers.

* Using unsafe code in C# seemed obvious, but actually wasn't necessary. It was possible to make it approximately as fast in C# without going unsafe.

* Delphi was approximately same speed inside and outside the IDE, whereas C# was almost 4-5 times slower when running the code inside the IDE.

* PHP was 1000-2500 times slower than Delphi.

* We gave up BASH scripting because it took too long time to fill the array with values (!)

Please do not generalize from this example, because there are many other things in this world than counting and averaging integer values. I'm not saying that Delphi is faster than C# or Java, and always remember, that a performance ratio of less than 2 in a specific algorithm is too little to make a difference in a large application.
Posted by Lars D at 16:30 }

