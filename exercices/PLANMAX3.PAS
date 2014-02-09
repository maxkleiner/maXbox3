Program P_L_A_N_M_A_X;

USES  Crt, Dos, Printer, Graph,
      IO, Utility,                                     (* eigene UNITS *)

      Bgidriv, Bgifont;
      (* Zeichensaetze und Grafiktreiber werden in Objektcode genommen *)




CONST xBreite = 15;     (* xBreite Punkte pro Tag => 40 Tage berechnet *)
      yBreite = 200;
      yNull   = 170;
      xLimite = 600;
      Tick    = 5;
      koerper_zyklus        = 23;
      emotional_zyklus      = 28;
      intelligenz_zyklus    = 33;

      maxnr=18;
       cola: array[0..maxnr] of string = ('integrated','total',
      'systemized','parallel','responsive','synchronized','optional',
      'compatible','balanced','regulated','tabulated','coordinated',
      'segmented','multiplex','operative','limited','participant',
      'ascendant','priority');

       colb: array[0..maxnr] of string = ('management','organizational',
      'monitored','reciprocal','logistical','incremental','transitional',
      'third-generation','policy','categorial','conversion','alterational',
      'aggregational','operational','convexity','cognition','mode','platform',
      'supplemental');

       colc: array[0..maxnr] of string = ('options','flexibility',
      'capability','mobility','concept','projection','time-phase','hardware',
      'contingency','analysis','rectification','construct','variation','matrix',
      'expectation','examination','stratification','catalyzation',
      'progression');

       days: array [0..6] of String[9] =
     ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');

      cc=   1;                                     {sound}
      dd=   3;
      ee=   5;
      ff=   6;
      gg=   8;
      aa=  10;
      bb=  11;
      hh=  12;
   start=  25;                                     {vision}
    ende= 475;
 abstand=   6;
 timemin=   8;
 timemax=  20;
    gtag=  20; gmonat= 06; gjahr= 59;              {birth initialize}


TYPE  natzahl               = 0..maxint;
      zyklus_typ            = koerper_zyklus..intelligenz_zyklus;

      string25= string[25];
      teilnehmersatz= record
                       name: string25;
                       tel: string25;
                       system: string25;
                      end;

      zeiger=^startliste;
      startliste= record
                   starter: teilnehmersatz;
                   naechster: zeiger;
                  end;

          day= 1..7;
       planer= Array[timemin..timemax,day] of String[5];           {matrix}
     dateityp= File of planer;
      nametyp= String[40];
{    searchrec=record}                                               {for dir}
              {  name:string[12];}

Var            time: 8..20;
      jour,from,fin: day;
               plan: planer;
           datename: nametyp;
               work: String;
               gone: Char;
            command: Char;
                  n: Integer;
         flag,flag2: boolean;
              a,b,c: String;                   {for random speechgame}
          y,m,d,dow: Word;                     {for get date}
       h,mi,s,hund : Word;                     {for time}
          basistage: integer;                  {biorhythm}
         lebenstage: integer;
      anfangszeiger: zeiger;                   {for weekbase}
             weiter: char;
            auswahl: integer;
            friends: teilnehmersatz;
          frienddat: file of teilnehmersatz;
             wochen: real;
        x1,y1,x2,y2: integer;                      {for vision}
        GraphDriver: integer;
          GraphMode: integer;
            ErrCode: integer;
                Pi2: real;
              xr,yr: real;
            x,yt,i : integer;
           Pal     : integer;
         Amplitude : real;
      Verschiebung : integer;
      Datum        : string;

      anfangs_datum: datum_typ;                    {unit datestructur}
      geburts_datum: datum_typ;
              dauer: natzahl;
             zyklus: zyklus_typ;
           resttage: integer;
           dateinfo: searchrec;                    {for dir}
                ask: string;


function ANZTAGE(tag,monat,jahr: integer): integer;
var totage: integer;
begin
  totage:=(jahr-45)*365 +(jahr-45) div 4;
       if monat>1  then totage:= totage+31;
        if monat>2  then totage:= totage+28;
         if monat>3  then totage:= totage+31;
          if monat>4  then totage:= totage+30;
           if monat>5  then totage:= totage+31;
            if monat>6  then totage:= totage+30;
           if monat>7  then totage:= totage+31;
          if monat>8  then totage:= totage+31;
         if monat>9  then totage:= totage+30;
        if monat>10 then totage:= totage+31;
       if monat>11 then totage:= totage+30;
  if (monat>2)and(jahr mod 4= 0) then
  totage:= totage +1;
  totage:= totage+tag;
  anztage:= totage;
end;


function WEEK(tag,monat: integer): real;
var totage: integer;
begin
totage:=0;
       if monat>1  then totage:= totage+31;
        if monat>2  then totage:= totage+28;
         if monat>3  then totage:= totage+31;
          if monat>4  then totage:= totage+30;
           if monat>5  then totage:= totage+31;
            if monat>6  then totage:= totage+30;
           if monat>7  then totage:= totage+31;
          if monat>8  then totage:= totage+31;
         if monat>9  then totage:= totage+30;
        if monat>10 then totage:= totage+31;
       if monat>11 then totage:= totage+30;
  totage:= totage+tag;
  week:= (totage/7);
end;


procedure TON(Octave,Note: integer);
var Frequency : real;
    I         : integer;
begin
  Frequency := 32.625;
  for I := 1 to Octave do                { Compute C in Octave             }
  Frequency := Frequency * 2;
  for I := 1 to Note - 1 do              { Increase frequency Note-1 times }
  Frequency := Frequency * 1.059463094;
  Sound(Round(Frequency));
end;

procedure DIRECTORY;
begin
  clrscr;
  gotoxy(4,4); write('please enter wildcard or joker(e.g. \*.*): ');
  readln(ask);
  findfirst(ask, anyfile, dateinfo);
  while doserror=0 do
  begin
    write(dateinfo.name:12,' ':4);
    findnext(dateinfo);
  end;
 repeat until keypressed;
end;

procedure BIOOUT(lebtage: integer);
begin
flag2:=false;
   if (lebtage mod 23=0) or (lebtage mod 23=11) then
   begin
      flag2:=true;
      gotoxy(3,22);writeln('physical is crucial!') ;
   end;
   if (lebtage mod 28=0) or (lebtage mod 28=14) then
   begin
      flag2:=true;
      gotoxy(3,23);writeln('emotional is crucial!');
   end;
   if (lebtage mod 33=0) or (lebtage mod 33=16) then
   begin
      flag2:=true;
      gotoxy(3,24);writeln('intellectual is crucial!');
   end;
 if flag2=false then
 begin
   gotoxy(49,24);writeln('///BIOrhythm just fine.........')
 end
end;


procedure MASK(var datename: nametyp); forward;
procedure OPEN(var datename: nametyp);
begin
   gotoxy(38,13); write('  ///FILENAME/// please: ');
   readln(datename);
   MASK(datename);
end;

procedure OPEN_2(var datename: nametyp);
begin
   gotoxy(38,13); write('   ///FILENAME///: ');
   readln(datename);
end;


procedure WRITEFILE(datename: nametyp; pla: planer );
var arrayfile : dateityp;
begin
   assign(arrayfile,datename);
       rewrite(arrayfile);
       write(arrayfile,pla);
   close(arrayfile);
end;


procedure SHOWTABLE; forward;
procedure MASK_2(var datename: nametyp); forward;

procedure READFILE(var datename: Nametyp; var pla: planer; var flag: boolean);
var arrayfile: dateityp;
begin
OPEN_2(datename);
    assign(arrayfile,datename);
{SI-}
    reset(arrayfile);
    if IOResult <> 0 then
    begin
      WriteLn; write('sorry buddy but File not found...');
      delay(3000);halt;
    end;
{SI+}
   clrscr;
     while not eof(arrayfile) do
      begin
        read(arrayfile,pla);
        for time:= timemin to timemax do
        for jour:= 1 to 7 do
          begin
             gotoxy(jour*6,time+4);
             write(plan[time,jour]:5);
          end;
      end;
   if flag= true then MASK_2(datename)
   else
   begin
     gotoxy(5,10);
     write('   Mon ','  Tue ','  Wed ','  Thu ','  Fri ','  Sat ','  Sun ');
     gotoxy(1,12);
     for time:= timemin to timemax do writeln(time:4);
     gotoxy(50,24); writeln('hit any key to return');
     gotoxy(50,24); readln;
   end;
  close(arrayfile);
end;


procedure SHOWTABLE;
begin
   for time:= timemin to timemax do
   for jour:= 1 to 7 do
   begin
      gotoxy(jour*6,time+3);            {absolute, start_koordinate  6/12}
      write(plan[time,jour]:5);         {relative, 1(mon)/8..7(son)/19}
   end;
end;


procedure INGOING;
begin

   gotoxy(17,2); readln(jour);
   gotoxy(17,3); clreol; readln(from);
   gotoxy(17,4); readln(fin);
   gotoxy(17,5); clreol; readln(work);
     for time:= from to fin-1 do
     plan[time,jour]:=work;
end;


procedure SHAKE(var ya,yb,yc: string);
begin;
     ya:=(cola[random(maxnr)]);
     yb:=(colb[random(maxnr)]);
     yc:=(colc[random(maxnr)]);
end;


procedure PRINT;
begin
write(lst,'         Mon   ','Tue   ','Wed   ','Thu   ',
'Fri   ','Sat   ','Sun   ','  Week ',round(wochen));
writeln(lst);
writeln(lst);
 for time:= timemin to timemax do
 begin
   write(lst,time:6);
       for jour:= 1 to 7 do
       write(lst,plan[time,jour]:6);     {relative, 1(mon)/8..7(son)/19}
   writeln(lst);
 end;
end;


procedure OPEN_3;
begin
   gotoxy(44,9); write('   ///FILENAME///: ');
   readln(datename);
end;


procedure ANFUEGEN(var a_kopf: zeiger);
var laufzeiger, hilfszeiger: zeiger;
begin
  new(hilfszeiger);
  hilfszeiger^.starter:= friends;
  hilfszeiger^.naechster:= nil;
  if a_kopf= nil
    then begin
      a_kopf:= hilfszeiger;
    end
    else
    begin
      laufzeiger:= a_kopf;
      while laufzeiger^.naechster<>nil do
      laufzeiger:= laufzeiger^.naechster;
      laufzeiger^.naechster:= hilfszeiger;         {eigentliches anfuegen}
    end
end;


procedure EINGABE(var e_kopf: zeiger);
begin
  repeat
    clrscr; gotoxy(1,10);
    with friends do
    begin
      write('  Name:    '); readln(name);
      write('  Tel:     '); readln(tel);
      write('  System:  '); readln(system);
    end;
    writeln;
    ANFUEGEN(e_kopf);
    write('  eingabe weiter (j/n) '); readln(weiter);
  until weiter in ['n','N'];
end;


procedure LISTEINDATEISCHREIBEN(laufzeiger: zeiger);
var loeschzeiger: zeiger;
begin
assign(frienddat,datename);
rewrite(frienddat);
while laufzeiger <> nil do
  begin
    write(frienddat,laufzeiger^.starter);
    loeschzeiger:= laufzeiger;
    laufzeiger:= laufzeiger^.naechster;
    dispose(loeschzeiger);
  end;
  close(frienddat);
end;


procedure DATEILESEN_LISTENAUFBAU(var d_kopf: zeiger);
begin
clrscr;
  assign(frienddat,datename);
  reset(frienddat);
  while not eof(frienddat) do
  begin
    read(frienddat,friends);
    ANFUEGEN(d_kopf);
  end;
    while d_kopf<>nil do
      begin
        with d_kopf^.starter do
        writeln(name:4,'  ',tel:4,'  ',system);
        d_kopf:= d_kopf^.naechster;
      end;
      readln;
  close(frienddat);
end;


procedure MASKE;
begin
  clrscr;
  anfangszeiger:= nil;
  gotoxy(5,5); writeln('      WEEKBASE>>>>>Date');
  gotoxy(2,6); writeln('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
  gotoxy(2,7); writeln('             <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
  gotoxy(5,9) ; writeln(' Name & Create & Save............1');
  gotoxy(5,11); writeln(' Load & See......................2');
  gotoxy(5,13); writeln(' End.............................3');
end;


procedure AUSWAHLMASKE;
begin
repeat
MASKE;
gotoxy(38,15); clreol; readln(auswahl);
case auswahl of
     1 :begin
          OPEN_3;
          EINGABE(anfangszeiger);
          LISTEINDATEISCHREIBEN(anfangszeiger);
        end;
     2 :begin
          anfangszeiger:=nil;
          OPEN_3;
          DATEILESEN_LISTENAUFBAU(anfangszeiger);
        end;
        else begin
               gotoxy(35,20);write('bye bye honey.....');
               delay(700);
             end;
     end;
until auswahl=3;
end;


procedure MASK(var datename: nametyp);
begin
clrscr;
gotoxy(50,21); write('Name of File:  ',datename);
gotoxy(3,2); write('Day_Nr     :   ');
gotoxy(3,3); write('from time  :   ');
gotoxy(3,4); write('to   time  :   ');
gotoxy(3,5); write('which Work :   ');
gotoxy(25,2);write('again...j/n:   ');
gotoxy(1,7); write(' Today you work on ',a,' ',b,' ',c,'' );
gotoxy(1,8); write('*****************************************************************');
gotoxy(5,9);
write(' Mon_1 ','Tue_2 ','Wed_3 ','Thu_4 ','Fri_5 ','Sat_6 ','Sun_7 ');
gotoxy(1,11);
for time:= timemin to timemax do writeln(time:4);
writeln;
for jour:= 1 to 7 do
for time:= timemin to timemax do plan[time,jour]:='/';
SHOWTABLE;
repeat
randomize;
  SHAKE(a,b,c);
  INGOING;
  SHOWTABLE;
  gotoxy(39,2); readln(gone);
until gone= 'n';
end;


procedure MASK_2(var datename: nametyp);
begin
clrscr;
gotoxy(50,21); write('Name of File:  ',datename);
gotoxy(3,2); write('Day_Nr     :   ');
gotoxy(3,3); write('from time  :   ');
gotoxy(3,4); write('to   time  :   ');
gotoxy(3,5); write('which Work :   ');
gotoxy(25,2);write('again...j/n:   ');
gotoxy(1,7); write(' Today you work on ',a,' ',b,' ',c,'' );
gotoxy(1,8); write('*****************************************************************');
gotoxy(5,9);
write(' Mon_1 ','Tue_2 ','Wed_3 ','Thu_4 ','Fri_5 ','Sat_6 ','Sun_7 ');
gotoxy(1,11);
for time:= timemin to timemax do writeln(time:4);
SHOWTABLE;
repeat
randomize;
  SHAKE(a,b,c);
  INGOING;
  SHOWTABLE;
  gotoxy(39,2); readln(gone);
until gone= 'n';
end;


PROCEDURE Grafiktreiber;
  VAR GraphDriver, GraphMode : integer;
      ErrCode : integer;
  BEGIN
    GraphDriver := Detect;
    InitGraph(GraphDriver,GraphMode,' ');
    ErrCode := GraphResult;            {GraphResult aus Graph}
    IF ErrCode <> grOk
      THEN BEGIN
        writeln('Dieses Programm l„uft leider nicht auf Ihrem Bildschirm');
        HALT; {Programmabbruch!}
      END;
  END;

(* REGISTRIEREN
   Funktion       : Grafik- und Fonttreiber registrieren
   Eingaben       : Keine
   Ausgaben       : indirekt: Grafikmodus
   Uses           : GRAPH                                     *)

PROCEDURE Registrieren;

  PROCEDURE Abort(message : string); {Unterprozedur}
    BEGIN
      writeln ('Treiber ', message, ' falsch geladen!');
    END;

  BEGIN {PROCEDURE Registrieren}
    { "Registrierung" aller Zeichens„tze (aus FONTS.TPU) }
    IF RegisterBGIfont(@GothicFontProc) < 0
      THEN Abort('Gothic');
    IF RegisterBGIfont(@SansSerifFontProc) < 0
      THEN Abort('SansSerif');
    IF RegisterBGIfont(@SmallFontProc) < 0
      THEN Abort('Small');
    IF RegisterBGIfont(@TriplexFontProc) < 0
      THEN Abort('Triplex');

    { "Registrierung" aller Grafik-Treiber (aus DRIVERS.TPU)}
    IF RegisterBGIdriver(@CGADriverProc) < 0
      THEN Abort('CGA');
    IF RegisterBGIdriver(@EGAVGADriverProc) < 0
      THEN Abort('EGA/VGA');
    IF RegisterBGIdriver(@ATTDriverProc) < 0
      THEN Abort('AT&T');
    IF RegisterBGIdriver(@PC3270DriverProc) < 0
      THEN Abort('PC 3270');
    IF RegisterBGIDriver(@HercDriverProc) < 0
      THEN Abort('Herkules');
      END; {PROCEDURE Registrieren}


PROCEDURE Datum_in_String (Tag, Monat, Jahr : integer; VAR Ausgabe : string);
  VAR DatumT                        : string;
      DatumM                        : string;
      DatumJ                        : string;
  BEGIN
    STR (Tag, DatumT);
    STR (Monat, DatumM);
    STR (Jahr, DatumJ);
    Ausgabe := DatumT + '.' + DatumM + '.' + DatumJ;
  END;


PROCEDURE daten_eingeben (VAR geburts_datum, anfangs_datum :datum_typ;
                          VAR dauer    : natzahl);

  PROCEDURE lies_datum (VAR datum : datum_typ);
    VAR  Datum_OK : boolean;
    BEGIN (* lies_datum *)
      REPEAT
        WITH datum DO
          BEGIN  {Prozeduren aus Unit Io}
            LiesIntegerGrenz ('Tag   : ', 1, 31, tag);
            LiesIntegerGrenz ('Monat : ', 1, 12, monat);
            LiesInteger ('Jahr  : ', jahr);
            IF Jahr < 100 THEN jahr := jahr + 1900;
          END (* WITH *);
          Datum_OK := Datum_pruefen (datum); {Unit Utility}
          IF NOT Datum_OK
             THEN BEGIN
               GOTOXY (1, 25);
               write ('Unmoegliches Datum, noch einmal eingeben!');
               GOTOXY (1, 1);
               END
             ELSE BEGIN
               WITH datum DO BEGIN
                 Write('Ist das Datum "', tag, '. ', monat, '. ', jahr);
                 IF Chartrue('" richtig (J/N): ',['N','n'])
                   THEN Datum_OK := False;
               END; {WITH}
             END; {IF...ELSE}
      UNTIL Datum_OK
    END (* lies_datum *);

  BEGIN (* daten_eingeben *)
  writeln; writeln;
    writeln ('Gib dein Geburtsdatum ein '); writeln;
    lies_datum (geburts_datum);
    IF Chartrue('Biorythmus fr heutiges Datum (J/N): ', ['J', 'j', 'Y', 'y'])
      THEN BEGIN
        GETDATE(y, m, d,dow); {Unit Dos}
        WITH Anfangs_datum DO BEGIN
          jahr := y;
          monat := m;
          tag := d;
        END;
      END {THEN}
      ELSE BEGIN
        writeln ('Gib das Datum fr Biorythmus-Berechnung ein ');
        lies_datum (anfangs_datum);
      END; {IF Chartrue}
  END (* daten_eingeben *);


FUNCTION wieviel_tage (datum : datum_typ) : integer;
  VAR gleich : integer;
  BEGIN (* wieviel_tage *)
    WITH datum DO
      BEGIN
        gleich := 365 * jahr + tag + 31 * (monat - 1);
        IF monat <= 2
          THEN wieviel_tage := gleich + (jahr - 1) DIV 4 -
                 TRUNC (0.75 * TRUNC(((jahr-1)/100)+1))
          ELSE wieviel_tage := gleich + jahr DIV 4 - TRUNC(0.4 * monat + 2.3)
                 - TRUNC (0.75 * (jahr DIV 100 + 1));
       END (* With *);
   END (* wieviel_tage *);

PROCEDURE Zeitachse;
  BEGIN
    Line(0, yNull, xLimite, yNull);
    FOR i := 0 TO xLimite DO
      BEGIN
        x := i;
        IF i = xLimite/4
           THEN BEGIN
             Line (x, yNull - yBreite DIV 2, x, yNull + yBreite DIV 2 + 15);
             WITH anfangs_datum DO
               Datum_in_String (tag,monat,jahr, Datum);
             SetTextJustify (CenterText, TopText);
             MOVETO (x, yNull + yBreite DIV 2 + 18);
             OutText (Datum);
           END
           ELSE
             IF x MOD xbreite = 0
               THEN
                 IF x MOD (xBreite * 10) = 0
                   THEN BEGIN
                     Line (x, yNull + yBreite DIV 2, x, yNull - yBreite DIV 2);
                     IF x = 0
                       THEN BEGIN SetTextStyle (DefaultFont, HorizDir, 1);
                         SetTextJustify (LeftText, BottomText);
                         OUTTEXTXY(0, yNull - yBreite DIV 2 - 3, 'high');
                         SetTextJustify (LeftText, TopText);
                         OUTTEXTXY(0, yNull + yBreite DIV 2 + 3, 'low');
                       END;
                   END
                   ELSE Line (x, yNull + Tick, x, yNull - Tick);
      END;
  END;



PROCEDURE Zeitachse2;
var dat: string;
  BEGIN
    Line(0, yNull, xLimite, yNull);
    FOR i := 0 TO xLimite DO
      BEGIN
        x := i;
        IF i = xLimite/4
           THEN BEGIN
             Line (x, yNull - yBreite DIV 2, x, yNull + yBreite DIV 2 + 15);
             SetTextJustify (CenterText, TopText);
             MOVETO (x, yNull + yBreite DIV 2 + 18);
             dat:=('today');
             OutText (dat);
           END
           ELSE
             IF x MOD xbreite = 0
               THEN
                 IF x MOD (xBreite * 10) = 0
                   THEN BEGIN
                     Line (x, yNull + yBreite DIV 2, x, yNull - yBreite DIV 2);
                     IF x = 0
                       THEN BEGIN SetTextStyle (DefaultFont, HorizDir, 1);
                         SetTextJustify (LeftText, BottomText);
                         OUTTEXTXY(0, yNull - yBreite DIV 2 - 3, 'high');
                         SetTextJustify (LeftText, TopText);
                         OUTTEXTXY(0, yNull + yBreite DIV 2 + 3, 'low');
                       END;
                   END
                   ELSE Line (x, yNull + Tick, x, yNull - Tick);
      END;
  END;


PROCEDURE Kurve_zeichnen (zyklus : zyklus_typ; resttage : integer);
  CONST Amplitude = 0.5;
  BEGIN
    FOR i := 0 TO xLimite DO
    BEGIN
      x := i;
      xr := (x + resttage * xBreite) /(xBreite * zyklus);
      yr := SIN (Pi2 * xr);
      yt := - ROUND ((yr * yBreite * Amplitude) - yNull);
      IF i > 0 THEN Lineto (x, yt)
               ELSE MOVETO (x, yt);
    END;
    GOTOXY (30, ROUND(y DIV 8));
   CASE zyklus of
     koerper_zyklus : OutText (' phy ');
     emotional_zyklus : OutText (' emo');
     intelligenz_zyklus : OutText (' int');
   END (* Case *);
 END (* Kurve zeichnen *);

PROCEDURE Programm_beenden;
  VAR i : integer;
  BEGIN
    SetTextStyle(SansSerifFont, HorizDir, 8);
    MOVETO (GetMaxX Div 2, GetMaxY Div 2);
    SetTextJustify(CenterText, CenterText);
    OUTTEXT (' bye bye honey...');
    SetTextStyle(TriplexFont, HorizDir, 1);
    MOVETO (GetMaxX DIV 2, GetMaxY - 20);
    OutText ('the cash and crash company ');
    delay(6000);
    SetTextJustify(LeftText, TopText);
    Textmode(LastMode);
  END;

PROCEDURE Logo;
  BEGIN
    SetTextStyle(GothicFont, HorizDir, 8);
    MOVETO (GetMaxX Div 2, GetMaxY Div 2);
    SetTextJustify(CenterText, CenterText);
    OUTTEXT ('B I O M A X');
    SetTextStyle(TriplexFont, HorizDir, 1);
    MOVETO (GetMaxX DIV 2, GetMaxY - 20);
    OutText ('Coder :  Kleiner/Rothen  (1993) ');
    DELAY(6000);
    SetTextJustify(LeftText, TopText);
    Textmode(LastMode);
  END;

procedure BIO;
begin;
  Registrieren;
  Grafiktreiber;
  Logo;
  closegraph;
  clrscr;
  daten_eingeben (geburts_datum, anfangs_datum, dauer);
  dauer := wieviel_tage (anfangs_datum) - wieviel_tage (geburts_datum)
             - ROUND(xLimite/(4*xBreite));                {-10}
  writeln; gotoxy(15,21);
  writeln('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
  gotoxy(15,22);
  writeln('What the hell you are   ',dauer+10, '   days old');
  gotoxy(15,22);readln;
  Grafiktreiber;
  SetTextStyle (DefaultFont, HorizDir, 2);
  WITH anfangs_datum DO
   Datum_in_String (tag,monat,jahr,Datum);
  Datum := 'Biorhythmus vom ' + Datum;
  OUTTEXTXY (1, 1, Datum);
  Pi2 := 8 * ARCTAN(1.0);
  Zeitachse;
  SetTextStyle (DefaultFont, HorizDir, 1);
  SetTextJustify (LeftText, CenterText);
  SetLineStyle (solidln, 0, Thickwidth);
  Kurve_zeichnen (koerper_zyklus, dauer MOD 23);
  SetLineStyle (dottedln, 0, Normwidth);
  Kurve_zeichnen (emotional_zyklus, dauer MOD 28);
  SetLineStyle (solidln, 0, normwidth);
  Kurve_zeichnen (intelligenz_zyklus, dauer MOD 33);
    SetTextStyle (DefaultFont, HorizDir, 2);
  SetTextJustify (LeftText, BottomText);
  WITH geburts_datum DO
    Datum_in_String (tag,monat,jahr,Datum);
  Datum := 'Born on: ' + Datum;
  OUTTEXTXY (1, 347, Datum);
  Taste;
  Programm_beenden;
  Textmode(LastMode);
closegraph;
end;

procedure BIO2;
var dat: string;
begin
Pi2 := 8 * ARCTAN(1.0);
REGISTRIEREN;
GRAFIKTREIBER;
  Zeitachse2;
  SetTextStyle (DefaultFont, HorizDir, 1);
  SetTextJustify (LeftText, CenterText);
  SetLineStyle (solidln, 0, Thickwidth);
  Kurve_zeichnen (koerper_zyklus, (lebenstage-10) MOD 23);
  SetLineStyle (dottedln, 0, Normwidth);
  Kurve_zeichnen (emotional_zyklus, (lebenstage-10) MOD 28);
  SetLineStyle (solidln, 0, normwidth);
  Kurve_zeichnen (intelligenz_zyklus, (lebenstage-10) MOD 33);
  SetTextStyle (DefaultFont, HorizDir, 2);
  SetTextJustify (LeftText, BottomText);
  Dat := 'wisdom is where knowledge ends...';
  OUTTEXTXY (1, 347, Dat);
  Taste;
  Programm_beenden;
  Textmode(LastMode);
closegraph;
end;




procedure MENU;
begin
clrscr;
  basistage:= ANZTAGE(d,m,y-1900);
  lebenstage:= basistage - ANZTAGE(gtag,gmonat,gjahr);
  gotoxy(45,21);writeln('livedate:',lebenstage);
  BIOOUT(lebenstage);
  wochen:=WEEK(d,m);
gotoxy(4,3);
writeln;
writeln('     MAGIC /// ');
writeln('    /// LOGIC Products  ');
writeln;
writeln('  ******************************************************************');
writeln('   Welcome to     P/L/A/N/M/A/X               ');
writeln('  ******************************************************************');
writeln('  >>> Week ',round(wochen));
writeln;
writeln('      NAME & CREATE a new week___1 ');
writeln('      Save_1>____________________2 ');
writeln('      Load & See_________________3 ');
writeln('      Open & Modify______________4 ');
writeln('      PRINT______________________5 ');
writeln('      DATES>>>___________________6 ');
writeln('      BIORHYTHM>>>public_________7___privat___8 ');
writeln('      END________________________9___DIR______0 ');

gotoxy(49,22);
writeln('',days[dow],',',
               d:0, '/', m:0, '/', y:0);
gotoxy(19,21);
write('NUMBER please: ');
command:=readkey;
 if command in ['0','1','2','3','4','5','6','7','8'] then
   case command of
     '0': DIRECTORY;
     '1': OPEN(datename);
     '2': WRITEFILE(datename,plan);
     '3': begin
          flag:= false;
          READFILE(datename,plan,flag);
          end;
     '4': begin
          flag:= true;
          READFILE(datename,plan,flag);
          WRITEFILE(datename,plan);
          end;
     '5': PRINT;
     '6': AUSWAHLMASKE;
     '7': BIO;
     '8': BIO2;
        else begin gotoxy(40,8);
        writeln('dont fuck me off!');
      end;
   end;


end;



Begin
GetTime(h,mi,s,hund);
GetDate(y,m,d,dow);
randomize;
  SHAKE(a,b,c);
  TON(2,ee); delay(500); nosound;
  TON(2,aa); delay(400); nosound;
  TON(3,dd); delay(300); nosound;
  TON(3,gg); delay(200); nosound;
  TON(3,hh); delay(100); nosound;
  TON(4,ee); delay(100); nosound;
  repeat
    MENU;
  until command= '9';
  registrieren;
  grafiktreiber;
  y1:= start; x1:= start; y2:= ende;
  while x1<=187 do
    begin
      TON(x1-(25+x1),gg); delay(100); nosound;
        x2:= (start+ende)-x1;
        line(x1,y1,x2,y2);
        x1:=x1+abstand;
    end;
    delay(4000);
    closegraph;
    gotoxy(15,23); writeln('<<<>>>>><<<<<>>>>><<<<<>>>>><<<<<>>>>><<<<<>>>');
    gotoxy(15,24); writeln('press any key to continue or any other to quit!');
    gotoxy(15,24); readln;
end.

