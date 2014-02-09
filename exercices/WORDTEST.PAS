program WORDTEST;
uses crt, dos;

const      diff=32;
      maxpuffer=65530;
         {name1='test';
          name2='test1';}                                   {for debugging}

type  zeichensatz=set of 'A'..'z';                      {65..122}
      haeufigkeit=array['a'..'z'] of integer;           {real...magic logic}
       puffertype=array[0..maxpuffer] of char;

var buchstaben: zeichensatz;
    vokale, konsonanten: zeichensatz;

        filename: text;
         zeichen: char;
          anzahl: haeufigkeit;
           summe: integer;
        resultat: real;
             sum: real;
        kon, vok: integer;
         command: char;
        dateinfo: searchrec;                    {for dir}
             ask: string;
 puffer1,puffer2: ^puffertype;
     name1,name2: string;                               {deb}
          result: word;
       innerhalb: boolean;
              index,index1,index2,index3: longint;
  treffer,portion,faktor,laenge1,laenge2: longint;
                      quelltext,zieltext: file;



procedure DOPPELFENSTER(x1,y1,x2,y2:integer);
const
     m1=$c9; m2=$cd; m3=$bb; m4=$ba; m5=$bc; m6=$c8;         {ascii in hex}
var  i,j:integer;
begin
     gotoxy(x1,y1); write(chr(m1));
     gotoxy(x2,y1); write(chr(m3));
     gotoxy(x2,y2); write(chr(m5));
     gotoxy(x1,y2); write(chr(m6));
     for i:=y1+1 to y2-1 do
     begin
       gotoxy(x1,i); write(chr(m4));
       gotoxy(x2,i); write(chr(m4));
     end;
     for j:=x1+1 to x2-1 do
     begin
       gotoxy(j,y1); write(chr(m2));
       gotoxy(j,y2); write(chr(m2));
     end;
end;

procedure FEHLER(nummer:integer);
begin
  clrscr;
  case nummer of
  1: writeln('1. File ',name1,' not available !');
  2: writeln('2. File ',name2,' not available !');
  3: writeln('factor to large');
  4: writeln('files to large to compare');
  end;
 readln;
end;

procedure DIALOG;                                             {deb}
begin
  clrscr;
  gotoxy (10,5); write ('Filename Nr.1 please: ');
  readln(name1);
  gotoxy (10,6); write ('Filename Nr.2 please: ');
  readln(name2);
end;

procedure PARAMETER;
begin
  clrscr;
  gotoxy(10,5); write('old factor: ',faktor);
  gotoxy(10,6); write('new factor: ');
  readln (faktor);
end;

procedure AUSWERTUNG;
var stand,j: integer;
begin
  clrscr;
  gotoxy(17,1);
  write('K L E I N E R K O R R E L A T I O N');
  gotoxy(60,2);  write('Stand: ');
  gotoxy(60,7);  write('Files: ');
  gotoxy(60,9);  write('1. ',name1);
  gotoxy(60,10); write('2. ',name2);
  gotoxy(60,12); write('Length: ');
  gotoxy(60,16); write('Correlation: ');
  for j:= 0 to 10 do
  begin
    for index:=0 to 4 do
    begin
      gotoxy(9+10*index,23-2*j); write(10*j:3);         {10, 20, 30 etc}
    end;
  end;
  for index:=0 to 4 do
  doppelfenster(13+10*index,2,15+10*index,23);
  gotoxy(5,3); write('%');
  sum:=0;
  assign(quelltext,name1);
  {$i-}
  reset(quelltext, 1);
  if (ioresult<>0) or (name1='') then
  begin
    fehler(1); exit;
  end;
  {$i+}
  laenge1:= filesize(quelltext);
  assign(zieltext,name2);
  {$i-}
  reset(zieltext, 1);
  if (ioresult<>0) or (name2='') then
  begin
    fehler(2); exit;
  end;
  {$i+}
  laenge2:= filesize(zieltext);
  if ((laenge1<=5 * faktor) or (laenge2<=5 * faktor)) then
  begin
    fehler(3); exit;
  end;
  if (laenge1 > maxpuffer) or (laenge2 > maxpuffer) then
  begin
    fehler(4); exit;
  end;
  repeat
  blockread(quelltext,puffer1^,maxpuffer,result);
  until result=0;
  repeat
  blockread(zieltext,puffer2^,maxpuffer,result);
  until result=0;
  close(quelltext);
  close(zieltext);

  for index:= 0 to 4 do
  begin
    gotoxy(60,14); write(index+1:1, ' x ',faktor);
    portion:=faktor*(index+1);                          {factor*1,*2,*3etc.}
    treffer:=0; index1:=0;
    repeat
    for index2:= 0 to laenge2 - portion do
    begin
      if keypressed then
      if readkey=#27 then
      begin
        gotoxy(36,25); write('analyse is interrupted, go on with ENTER');
        readln; exit;
      end;
      gotoxy(60,4); write(index2:6);
      innerhalb:=true; index3:=0;
      repeat
      if innerhalb then
      if puffer1^[index1+index3]<>puffer2^[index2+index3] then
      innerhalb:=false;
      inc(index3);
      until not innerhalb or (index3=portion);
      if innerhalb and (index3=portion) then      {char und block gleich !}
      begin
        inc(treffer);
        index2:=laenge2-portion;
      end;
    end;
    index1:=index1+portion;
    gotoxy(60,5); write(index1:6);
    until (index1>laenge1-portion);
    stand:=round(20*treffer/int(laenge1/portion));
    for j:=1 to stand do
    begin
      gotoxy(14+10*index,23-j); write(chr(219));             {pegelanzeige}
    end;
    gotoxy(12+10*index,24);
    write(100*treffer/int(laenge1/portion):4:1, '%');
    sum:=sum+treffer/(int(laenge1/portion));
  end;
  gotoxy(60,18);
  write(sum/5:4:3);
  gotoxy(40,25);
  write('Analyse done - go on with ENTER...');
 readln;
end;

procedure MANUAL;
begin
clrscr;
gotoxy(4,5);
writeln('Die Kreuzkorrelation analysiert zwei Texte, Programme, Datenreihen');
writeln('etc. und "misst" ihre statistische Aehnlichkeit');
writeln('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
writeln('Der Faktor bestimmt die Laenge der miteinander zu vergleichenden');
writeln('Teilpassagen oder Bloecke.');
writeln('Fuer den Vergleich pickt sich das Programm nacheinander jedes ');
writeln('TeilstÅck von der gewaehlten Laenge aus der ersten Datei A. Bei ');
writeln('einem Faktor von 10 sind das also beim ersten Durchlauf die ');
writeln('Zeichen 1 bis 10 die mit dem jeweils um 1 erhoehten Block der ');
writeln('Datei B verglichen werden, bis diese ihr Ende erreicht hat. ');
writeln('Anschliessend erfolgt der zweite Block 11 bis 20 der wieder ');
writeln('Schritt fuer Schritt mit der Datei B verglichen wird. ');
writeln('Diese Prozedur fuehrt das Programm solange aus, bis der letzte ');
writeln('Block dh. das Ende der A-Datei erreicht ist.');
writeln('Nun erfolgt die erste Anzeige im Balkendiagramm, wobei anschliessend');
writeln('die Laenge der Vergleichsfolge von Faktor * 1 auf Faktor * 2 ');
writeln('erhoeht wird und die Geschichte wieder von vorne beginnt, dies ');
writeln('solange bis im letzten Balkendiagramm Faktor * 5 angezeigt wird. ');
writeln('Sind alle fuenf Durchlaeufe beendet, errechnet das Programm ');
writeln('schliesslich noch die arithmetisch gemittelte ');
writeln('Kleinersche Kreuz-Korrelation zwischen 0 und 1 aus. ');
readln;
end;


procedure READDATENAME(var datename: string);
begin
  gotoxy(14,23);
  write('Enter the Filename: ');
  readln(name1);
  assign(filename,name1);
  {$i-}
  reset(filename);
  if (ioresult<>0) or (name1='') then
  begin
    FEHLER(1); exit;
  end;
  {$i+}
end;

procedure SELECT;
var sign: char;
       a: integer;
begin
  a:=0;
  clrscr;
  gotoxy(10,5);
  writeln('Nun werden die drei haeufigsten Buchstaben');
  writeln('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
  writeln('                        e = 14.6%    n = 8.4%    r = 8.0%');
  writeln('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
  writeln('         gefiltert und zum Ergaenzungstest aufbereitet.');
  writeln('         go on with ENTER');
  readln;
  buchstaben:=['e','n','r','E','N','R'];
  reset(filename);
  while not eof(filename) do
  begin
    a:=a+1;
    read(filename,sign);
    if not (sign in buchstaben)           {don't forget ( ) !!!}
    then write(sign);
    if a mod 1000=0 then readln
  end;
  close(filename);
 readln;
end;

procedure COUNT;
begin
  clrscr;
  buchstaben:=['a'..'z','A'..'Z'];
  for zeichen:= 'a' to 'z' do
  anzahl[zeichen]:= 0;
  summe:= 0; sum:=0;
  resultat:=0;
  reset(filename);
  while not eof(filename) do
  begin
    read(filename,zeichen);
    if(zeichen>='A') and (zeichen<='Z') then
    zeichen:=chr(ord(zeichen) + diff);         {from A to a}
    anzahl[zeichen]:= anzahl[zeichen]+1;
    if zeichen in buchstaben then
    summe:= summe+1;
  end;
  close(filename);
  gotoxy(2,4); writeln('Hi Honey there are ',summe,' letters');
  writeln;
  gotoxy(2,6); writeln('Now the Frequency Distribution Analysis:');
  gotoxy(2,7); writeln('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
  writeln;writeln;
  for zeichen:='a' to 'z' do
  if anzahl[zeichen]> 0 then
  begin
    resultat:=((anzahl[zeichen])/(summe))*100;   {x/y*100=not(x/y)*100...}
    write(zeichen,':',resultat:5:2,'%  ');
    sum:=resultat+sum;
  end;
  writeln;writeln;
  gotoxy(50,16);
  writeln('control: ',sum:5:2,'%');
  writeln;
 readln;
end;

procedure KON_VOK(var kon, vok: integer);
begin
  kon:=0; vok:=0;
  buchstaben:=['a'..'z','A'..'Z'];
  vokale:=['a','e','i','o','u','A','E','I','O','U'];
  konsonanten:= buchstaben-vokale;
  reset(filename);
  while not eof(filename) do
  begin
    read(filename,zeichen);
    if zeichen in buchstaben then
    if zeichen in vokale then
    vok:= vok+1
    else kon:=kon+1
  end;
  close(filename);
  gotoxy(42,11); write('VerhÑltnis = ',vok,'/',kon,' = ',vok/kon:1:2);
  gotoxy(38,17); write('Tests ergaben: Code      0.55');
  gotoxy(38,18); write('               Deutsch   0.61');
  gotoxy(38,19); write('               Englisch  0.63');
  gotoxy(38,20); write('               Franz     0.80');
  gotoxy(38,21); write('               Italien   0.85');
 readln;
end;


procedure DIRECTORY;
begin
  clrscr;
  gotoxy(4,4); write('enter wildcard or joker(e.g.C:\*.*): ');
  readln(ask);
  findfirst(ask, anyfile, dateinfo);
  while doserror=0 do
  begin
    write(dateinfo.name:12,' ':4);
    findnext(dateinfo);
  end;
 repeat until keypressed;
end;

procedure SHOW;
var i,a,b: integer;
begin
  clrscr;
  for i:=1 to 10000 do
  begin
    a:=random(80);
    b:=random(26);
    gotoxy(a,b);
    write(chr(random(223)+32));
  end
end;


procedure kreuz;
begin
  new(puffer1); new(puffer2);
  clrscr; faktor:=8;
  name1:= ''; name2:='';                                 {deb}
  repeat
    clrscr;
    doppelfenster(8,4,62,6);
    doppelfenster(12,6,58,14);
    gotoxy(13,20); write('First File   = ',name1);
    gotoxy(13,21); write('Second File  = ',name2);
    gotoxy(13,22); write('Factorlenght = ',faktor);
    gotoxy(20,5); write('K R E U Z K O R R E L A T I O N');
    gotoxy(19,8); write('Files______________________1');
    gotoxy(19,9); write('Factor_____________________2');
    gotoxy(19,10);write('Analyse & Result___________3');
    gotoxy(19,11);write('Manual_____________________4');
    gotoxy(19,12);write('Back to Menu_______________5');
    repeat
      gotoxy(31,15); write('Number please: ');
      command:=readkey;
    until command in ['1','2','3','4','5'];
    case command of
     '1':DIALOG;                                              {deb}
     '2':PARAMETER;
     '3':AUSWERTUNG;
     '4':MANUAL;
     '5':begin
           dispose(puffer1); dispose(puffer2);
         end;
    end;
  until command='5';
end;



procedure MENU;
begin
clrscr;
writeln;
writeln('     MAGIC /// ');
writeln('    /// LOGIC Products  ');
writeln;
writeln('  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
writeln('   Welcome to     T/E/X/T/T/E/S/T               ');
writeln('  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
writeln;
writeln('      NEW Filename_______________0 ');
writeln('      Redundancetest_____________1 ');
writeln('      Vokal/Konsonant____________2 ');
writeln('      Buchstabenstatistik________3 ');
writeln('  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ');
writeln('      CROSSCORRELATION>>_________4 ');
writeln('      DIR________________________5 ');
writeln('      END______________________Esc ');
gotoxy(19,21);
write('NUMBER please: ');
command:=readkey;
   if command in ['0','1','2','3','4','5','6'] then
   case command of
      '0': readdatename(name1);
      '1': select;
      '2': kon_vok(kon,vok);
      '3': count;
      '4': kreuz;
      '5': directory;
           else
           begin
             gotoxy(40,6);
             writeln('dont fuck me off!');
           end;
   end;
end;



begin
  SHOW;
    repeat
     MENU;
    until command=#27;
  SHOW;
end.