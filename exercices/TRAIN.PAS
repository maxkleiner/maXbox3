program train;
uses crt;
type feldtyp=array[1..100] of real;
var dateivar: file of feldtyp;
    feld: feldtyp;
    i: integer;
begin
randomize;
clrscr;
          for i:=1 to 12 do begin
         feld[i]:=random;
     {    readln(feld[i]);}
         end;
     assign(dateivar,'c:\field.dat');
     rewrite(dateivar);
     write(dateivar,feld);
     close(dateivar);
     writeln;
     assign(dateivar,'c:\field.dat');
     reset(dateivar);
     while not eof(dateivar) do
     read(dateivar,feld);
     for i:=1 to 12 do
     writeln(feld[i]);
     close(dateivar);
     end.

