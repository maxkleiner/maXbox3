PROGRAM RoemischeZahl;        { Dezimalzahl in roemische Zahl umwandeln }

USES Crt;

VAR
   Zahl     : INTEGER;                     { nimmt die Dezimalzahl auf }
   Roemisch : STRING;                { roemische Zahl als Zeichenkette }

BEGIN

     ClrScr;

     Write('Bitte geben Sie eine Dezimalzahl ein: ');
     ReadLn(Zahl);

     WHILE Zahl >= 1000 DO       { solange die Zahl gr”áer gleich 1000 }
     BEGIN
          Roemisch := Roemisch + 'M';               { ein 'M' anh„ngen }
          Zahl := Zahl - 1000;     { und Zahl dafr um 1000 verringern }
     END;

     IF Zahl >= 900 THEN    { 900 kann im System nur einmal erscheinen }
     BEGIN                              { deshalb nebutzen wir hier IF }
          Roemisch := Roemisch + 'CM';
          Zahl := Zahl - 900;
     END;

     IF Zahl >= 500 THEN
     BEGIN
          Roemisch := Roemisch + 'D';
          Zahl := Zahl - 500;
     END;

     IF Zahl >= 400 THEN
     BEGIN
          Roemisch := Roemisch + 'CD';
          Zahl := Zahl - 400;
     END;

     WHILE Zahl >= 100 DO
     BEGIN
          Roemisch := Roemisch + 'C';
          Zahl := Zahl - 100;
     END;

     IF Zahl >= 90 THEN
     BEGIN
          Roemisch := Roemisch + 'XC';
          Zahl := Zahl - 90;
     END;

     IF Zahl >= 50 THEN
     BEGIN
          Roemisch := Roemisch + 'L';
          Zahl := Zahl - 50;
     END;

     IF Zahl >= 40 THEN
     BEGIN
          Roemisch := Roemisch + 'XL';
          Zahl := Zahl - 40;
     END;

     WHILE Zahl >= 10 DO
     BEGIN
          Roemisch := Roemisch + 'X';
          Zahl := Zahl - 10;
     END;

     IF Zahl >= 9 THEN
     BEGIN
          Roemisch := Roemisch + 'IX';
          Zahl := Zahl - 9;
     END;

     IF Zahl >= 5 THEN
     BEGIN
          Roemisch := Roemisch + 'V';
          Zahl := Zahl - 5;
     END;

     IF Zahl >= 4 THEN
     BEGIN
          Roemisch := Roemisch + 'IV';
          Zahl := Zahl - 4;
     END;

     WHILE Zahl >= 1 DO
     BEGIN
          Roemisch := Roemisch + 'I';
          Zahl := Zahl - 1;
     END;

     WriteLn('Die r”mische Zahl lautet: ', Roemisch);
     ReadKey;

END.

