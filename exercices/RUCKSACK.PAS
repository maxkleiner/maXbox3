program rucksack;

uses Crt;

const
range=5;
code:array[1..range] of integer = (16,8,4,2,1);
maxzahl=20;

type allfeld = array[1..range]of integer;

var
  zahlen,binaer,dummy:allfeld;
  taste: char;
  i,x,old: integer;
  maxmeng,anzahl,menge,gesamt: integer;
  inRound: double;

function zweihochn(n:integer):integer;
begin
  if n=0 then zweihochn:=1
  else zweihochn:=2*zweihochn(n-1);
end;

function biRound(wert: double): longint;
const rFac:integer = 10000;
var zsum: longint;
ztest: double;
z: longint;
begin
 { biRound:= round(wert / 10000)*10000;}
 zsum:= trunc(wert/(rFac))*(rFac);
 if  (frac(wert/rFac) >= 0.3) and
                          (frac(wert/rFac) <= 0.7) then
   biRound:= Zsum + round(rFac/2)  else
   biRound:= round(wert/rFac)*rFac;

 {biRound:=round(wert)}
end;


procedure deztobin(wert:integer);
var z:integer;
begin
  for z:=1 to menge do
  if wert and code[z]=code[z] then
  binaer[z]:=1;
end;

procedure clrbinaer;
var z:integer;
begin
  for z:=1 to menge do binaer[z]:=0;
end;

begin
repeat
  clrscr;
  gotoxy(4,5);
  writeln('gib Zahl zum Runden');
  readln(inRound);
  gotoxy(4,7);
  writeln(biround(inround));

 { writeln('gib die anzahl objekte ein, die du ');
  gotoxy(4,7);
  writeln('optimal verteilen willst: '); gotoxy(30,7);readln(menge);
  gotoxy(4,9);writeln('welches ist die maximalmenge ?');readln(maxmeng);
  gotoxy(4,11);writeln('nun gib die objektdaten ein: ');
  for anzahl:=1 to menge do readln(zahlen[anzahl]);
  i:=0; old:=0;
  for i:=1 to ((zweihochn(anzahl))-1) do
  begin
    gesamt:=0;
    deztobin(i);
    for x:=1 to anzahl do
    dummy[x]:=0;
    for x:=1 to anzahl do
    begin
      if binaer[range+1-x]=1 then
      begin
        inc(gesamt,zahlen[x]);
        dummy[x]:=zahlen[x];
      end;
    end;
    if gesamt=maxmeng then
    begin
    for x:=1 to anzahl do write(dummy[x]:3);
    writeln(i:5,'. Matching ');
    end;
{    if gesamt<=maxzahl then
    begin
      write(' matching!');
      if old<gesamt then old:=gesamt;
    end else
    write(' to big');
    writeln('  aktuelle wahl: ',old:4);
    taste:=readkey;
    if taste=#27 then exit;
    clrbinaer;
  end;      }
  taste:=readkey;
  if taste=#27 then exit;
 until taste=#27;
end.



