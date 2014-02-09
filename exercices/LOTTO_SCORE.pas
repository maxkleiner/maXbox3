{ Wertung: 15 Punkte      Prima !           Sonnenburg }
Program Lotto;
uses crt,dos;

var tip                                : array[1..49] of integer;
    Zahlen                             : array[1..49] of integer;
    a,b,c,d,e,x,y,zieh,
    counter,merk,treffer               : integer;
    year,month,day,dayofweek           : word;

Procedure Tippen;
 Begin
      getdate(year,month,day,dayofweek);
      gotoxy(20,1);
      write(' Heute ist der ');
      write(day,'.',month,'.',year);
      counter :=1;
      x :=10; y :=5;
    repeat  gotoxy(x,y);
            write(counter,'. Tip : ');
            readln(a);
            y :=y+1;
             if (a <= 49) and (a >= 1) then
             if tip[a] <> 1 then
               begin
                    tip[a] := 1;
                    counter := counter+1;
               end
                 else
                  begin
                        writeln('Diese Zahl hatten Sie schon mal !! ');
                        y :=y+1;
                  end
                else
                 begin
                       writeln('Tip muá im Bereich 1-49 liegen !!');
                       y :=y+1;
                 end;
    until counter = 7;
 End;
Procedure Ziehen;                      {Ziehung der Lottozahlen...}
 Begin
      counter :=0;
      for a :=1 to 49 do zahlen[a] :=0;
      randomize;
      repeat
            Zieh := random(48)+1;
            if zahlen[zieh] = 0 then
              begin
                   zahlen[zieh] := 1;
                   counter :=counter+1;
              end;
       until counter > 5;
 End;


Procedure Schein;
 Begin
       textcolor(yellow);
       write('             ',chr(201)); { linke obere Ecke}
       delay(100);
      for b:=1 to 6 do
       begin
            delay(100);
            for a:=1 to 6 do write(chr(205));
                             write(chr(203));    { Ë }
       end;
      for a :=1 to 6 do write(chr(205));
                        writeln(chr(187)); { rechte obere Ecke}

       for a:=1 to 6 do
        begin
             delay(100);
             writeln('             ',chr(186),chr(186):7,chr(186):7,chr(186):7,chr(186):7,chr(186):7,chr(186):7,chr(186):7);
             writeln('             ',chr(186),chr(186):7,chr(186):7,chr(186):7,chr(186):7,chr(186):7,chr(186):7,chr(186):7);
             write('             ',chr(204));   { Ì }
             for b:=1 to 6 do
              begin
                   delay(100);
                   for c:=1 to 6 do write(chr(205));{ Í }
                   write(chr(206));  { Î }
              end;
              for d:=1 to 6 do write(chr(205));
              writeln(chr(185));  { ¹ }
         end;


        writeln('             ',chr(186),chr(186):7,chr(186):7,chr(186):7,chr(186):7,chr(186):7,chr(186):7,chr(186):7);
        writeln('             ',chr(186),chr(186):7,chr(186):7,chr(186):7,chr(186):7,chr(186):7,chr(186):7,chr(186):7);
        write('             ',chr(200)); { linke untere Ecke}
      for b:=1 to 6 do
       begin
            delay(100);
            for a:=1 to 6 do write(chr(205));
                             write(chr(202));    { Ê }
       end;
      for a :=1 to 6 do write(chr(205));
                        writeln(chr(188)); { rechte untere Ecke}

                        (*  Zahlenausgabe sowie Vergleich  *)

       x :=17;
       y :=2;
       treffer :=0;
      for a:=1 to 49 do
       begin
            if (Zahlen[a] = 1) and (Tip[a] = 1) then
              begin
                    Treffer := Treffer+1;
                    textcolor(red+blink);
              end else
            if zahlen[a] =1 then textcolor(blue) else
            if tip[a] = 1 then textcolor(green) else
               textcolor(white);
            gotoxy(x,y);
            write(a);
            x:= x+7;
            delay(100);
            if x > 59 then
             begin
                  x :=17;
                  y := y+3;
             end;
                           (* Ende der Zahlenausgabe *)

                           (* Ausgabe der Legende *)
                    gotoxy(65,9);
                    textcolor(white);
                    writeln('Legende :');
                    gotoxy(65,10);
                    writeln('ÍÍÍÍÍÍÍÍÍ');
                    gotoxy(65,11);
                    textcolor(green);
                    write('±±');
                    textcolor(white);
                    write(' = Ihr Tip ');
                    gotoxy(65,12);
                    textcolor(blue);
                    write('±±');
                    textcolor(white);
                    write(' = Lottozahlen');
                    gotoxy(65,13);
                    textcolor(red+blink);
                    write('±±');
                    textcolor(white);
                    write(' = Treffer');
                   (* Ende *)
   end;
 End;
Procedure Auswert;
 Begin
      gotoxy(10,24);
      textcolor(yellow);
      write(' Sie haben einen ',treffer,'er !!');
      readln;
 End;
BEGIN
  clrscr;
  tippen;
  clrscr;
  ziehen;
  schein;
  auswert;
END.

