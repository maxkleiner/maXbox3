program CODEART;

{ OOP Implementation}

uses Crt, Graph, Cursor1, Zeit1;       {eigne units}

type
     WeltZeit = object(zeit)                    {heredity !!}
         CityName: String[16];
          TOffset: Integer;
            Zeile: Integer;
           Spalte: Integer;
        procedure  SetCityTime(NewCityName:String;
                               NewTOffset,NewSpalte,NewZeile:Integer);
        procedure  ShowCityTime;
     end;



procedure WeltZeit.SetCityTime(NewCityName: String;
                               NewTOffset,NewSpalte,NewZeile:Integer);
begin
  self.Now;
  CityName:= NewCityName;
  TOffset:= NewTOffSet;
  Zeile:= NewZeile;
  Spalte:= NewSpalte;
end;

procedure Weltzeit.ShowCityTime;
begin
  self.AddHour(TOffset);
  GotoXY(self.Spalte,self.Zeile);
  self.PrintLfChk;
  GotoXY(self.Spalte,(self.Zeile)+1);
  Write(CityName);
end;

procedure SHOWHEART;
var a,b: integer;
begin
    a:=random(80);
    b:=random(25);
    gotoxy(a,b);
    write(chr(3));
end;


var
  TimeArr : Array[1..12] of WeltZeit;       {Instanzenobjekte}
  C       : Cursor;
  i,z       : Integer;



procedure timelove;
begin
  C.Off;
  ClrScr;
  randomize;
  writeln;
  writeln(' MAGIC///                      _______________      ');
  writeln('///LOGIC products              T/I/M/E/L/'#3'/V/E ');
  writeln;
  writeln('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
  TimeArr[1].SetCityTime('  BERN CITY  ',  0, 4,11);
  TimeArr[2].SetCityTime('   LONDON  ',   -1,23,11);
  TimeArr[3].SetCityTime('     RIO   ',   -4,43,11);
  TimeArr[4].SetCityTime('   GANDER ',    -5,63,11);
  TimeArr[5].SetCityTime('  NEW YORK ',   -6, 4,15);
  TimeArr[6].SetCityTime(' MEXICO CITY',  -7,23,15);
  TimeArr[7].SetCityTime(' LOS ANGELES',  -9,43,15);
  TimeArr[8].SetCityTime('   HONOLULU  ',-11,63,15);
  TimeArr[9].SetCityTime('   MOSCOW ',     2,63, 7);
  TimeArr[10].SetCityTime('  HONGKONG ' ,  7,43, 7);
  TimeArr[11].SetCityTime('    TOKYO ',    8,23, 7);
  TimeArr[12].SetCityTime('   SIDNEY ',    9, 4, 7);
  gotoxy(10,20);
  writeln('__________________________________________________________');
  gotoxy(10,21);
  writeln('     Dear $ilvi, Time is Love but Timing is Money  ');
  gotoxy(10,22);
  writeln(#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3,
  #3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3);
  gotoxy(10,22);
  repeat
    for i:= 1 to 12  do
    begin
      TimeArr[i].Now;
      TimeArr[i].ShowCityTime;
    end;
    z:=z+1;
    if z mod 69 = 0 then
    SHOWHEART;
  Until KeyPressed;
 C.On;
end;

begin
timelove
end.
