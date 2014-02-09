program Lotto_Simulation;

uses crt;

const cross=10;
      peop =10;

type lottozahlen= set of 1..cross;
         spieler= record
                    name: string;
                     tip: array[1..cross] of byte;
                  end;
          gruppe= array[1..peop] of spieler;
     lottozettel= array[1..peop] of lottozahlen;

var    team: gruppe;
       tips: lottozettel;
    gezogen: lottozahlen;
  x,zaehler: longint;
          z: integer;
       ende: boolean;
    numbers: byte;
    crosses: byte;
     people: byte;
    antwort: string;

procedure AUSFUELLEN(var team:gruppe; var tips:lottozettel; x:integer);
var n: integer;
begin
  tips[x]:= [ ];
  with team[x] do
    begin
      gotoxy(5+z,15); write('Name please: '); readln(name);
      for n:=1 to crosses do
        begin
          gotoxy(9+z,16+n); write(n:2,'.zahl: ');
          readln(tip[n]);
          tips[x]:= tips[x]+[tip[n]];
        end;
    end;
end;

procedure ZIEHUNG(var gezogen: lottozahlen);
var zufall, step: integer;
begin
  gezogen:= [ ];
  step:=0;
   repeat
     randomize;
     zufall:=random(numbers)+1;
     if not (zufall in gezogen)
     then
       begin
         step:= step+1;
         gezogen:= gezogen+[zufall];
       end;
   until step= crosses;
end;

procedure AUSWERTUNG(gezogen:lottozahlen; tips:lottozettel;
                        team:gruppe; var fertig: boolean);
var n: integer;
begin
  n:=0;
   repeat
     n:=n+1;
     if gezogen=tips[n]
     then
       begin
         writeln;
         writeln('         Nun ', crosses,' richtige hat ',team[n].name);
         ende:=true
       end;
    until n= people;
end;

procedure MASK;
begin
clrscr;
  gotoxy(4,3);
  writeln;
  writeln('     MAGIC /// ');
  writeln('    /// LOGIC products  ');
  writeln;
  writeln('  ******************************************************************');
  writeln('   Statistical Lotto Simulator for several Persons    ');
  writeln('  ******************************************************************');
  writeln;
  write('    Range please  (1...?)     : '); readln(numbers);
  write('    How many tips (crosses)   : '); readln(crosses);
  write('    How many player           : '); readln(people);
end;

begin
repeat
  MASK;
  z:=0;
  for x:= 1 to people do
    begin
      AUSFUELLEN(team,tips,x);
      z:=z+20;                                  {spalten auf schirm}
    end;
  zaehler:=0;
  repeat
    ende:=false;
    zaehler:=zaehler+1;
    ZIEHUNG(gezogen);
    AUSWERTUNG(gezogen,tips,team,ende);
    writeln(zaehler);
  until ende or(zaehler=maxint) or keypressed;
  if ende
  then writeln(' bonne chance after ',zaehler,' trials')
  else writeln(zaehler,'-mal versucht and no lucky punch');
  writeln(' once again ? (j/n)');
  readln(antwort);
until (antwort='n') or (antwort='N')
end.

