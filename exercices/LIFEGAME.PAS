(*$B-*)
PROGRAM LIFEGAME (Input, Output);

(* GAME OF LIFE   *)
(* K.Laeufer 1982, weiterbearbeitet von S. Rothen 1993 *)
(* lÑuft! *)
(* von allgemeinem Interesse: Tastatursteuerung des Cursors *)
(* Ausbau: Cursorsteurerung mit Maus *)

USES CRT;
{CRT wegen Keypressed, Textcolor}

CONST
      lebewesen          = 1;
      kein_lebewesen     = 0;
      size1              = 16;
      size2              = 17;
      max_felder         = 256;
      max_generationen   = 50;
      hintergrund        = 2;

TYPE
      index1             = 1..size1;
      index2             = 0..size2;
      wesen_typ          = kein_lebewesen..lebewesen;
      pop_typ            = ARRAY [index2,index2] OF wesen_typ;
      zaehl_feld_typ     = 0..max_felder;

VAR
      Farbe            : 0..15;
      Oben, Unten      : 0..24;
      Links, Rechts    : 0..79;
      Eingabe          : char;
      geboren,lebendig,
      gestorben        : zaehl_feld_typ;
      population       : pop_typ;
      generation       : 1..max_generationen;

{$I keypruef.tp6}

PROCEDURE Textfenster
  (Farbe, Links, Oben, Rechts, Unten : integer);
  BEGIN
    WINDOW (Links, Oben, Rechts, Unten);
    Textbackground(Farbe);
    CLRSCR;
    GOTOXY (1,1);
  END;

PROCEDURE population_init (VAR population : pop_typ);
  VAR zeile, spalte : index2;
  BEGIN
    FOR zeile := 0 TO size2 DO
      FOR spalte := 0 TO size2 DO
        population [zeile, spalte] := kein_lebewesen;
  END;

PROCEDURE Kopf_des_Spiels;
  BEGIN
    textfenster (hintergrund + 5, 1, 1, 42, 9);
    writeln; writeln;
    TEXTCOLOR (hintergrund + 2);
    writeln ('        * * *  GAME OF LIFE  * * * ');
    writeln;
    writeln ('       Ausmasse des Feldes: ',size1,' x ',size1);
    writeln;
    writeln ('    Kennzeichnen Sie ein Lebewesen mit ');
    write   (' einem beliebigen Buchstaben oder Zeichen');
  END;

PROCEDURE beigemuese (gestorben, geboren, lebendig : zaehl_feld_typ);
  BEGIN
    textfenster (hintergrund + 5, 1, 10, 42, 18);
    writeln; writeln; writeln;
    writeln ('       Generation ',generation);
    writeln;
    writeln ('          gestorben  : ',gestorben);
    writeln ('          geboren    : ',geboren);
    write   ('          lebendig   : ',lebendig);
  END;

PROCEDURE Matrize_einlesen
(Randoben, Randlinks, W_Hoehe, W_Breite, Farbe : integer;
VAR Eingabefeld : pop_typ);
  TYPE Cursorposition  = RECORD
                           Zeile  : integer;
                           Spalte : integer;
                         END;
  VAR Cursor      : Cursorposition;
      Eingabe     : char;
      x, y        : integer;

  PROCEDURE Richtung
  (Eingabe : char; W_Hoehe, W_Breite : integer;
  VAR x, y : integer);
    BEGIN
      CASE UPCASE (Eingabe) OF
        'H': IF x > 1 THEN x := x-1;                { Pfeil nach oben   }
        'P': IF x < W_Hoehe  THEN x  := x+1;        { Pfeil nach unten  }
        'M': IF y < W_Breite THEN Y := y+1;         { Pfeil nach rechts }
        'K': IF y > 1 THEN y := y-1;                { Pfeil nach links  }
        ';': x := 1;                                { F1 = Erste Zeile  }
        '<': x := W_Hoehe;                          { F2 = Letzte Zeile }
        '=': y := 1;                                { F3 = Zeilenanfang }
        '>': y := W_Breite;                         { F4 = Zeilenende   }
        'G': BEGIN                                  { home = linksoben  }
               IF x > 1            THEN x := x-1;
             IF y > 1            THEN y := y-1;
             END;
        'O': BEGIN                                  { end = linksunten  }
               IF x < W_Hoehe    THEN x := x+1;
               IF y > 1            THEN y := y-1;
             END;
        'I': BEGIN                                  { PgUp = rechtsoben }
              IF x > 1            THEN x := x-1;
               IF y < W_Breite   THEN y := y+1;
             END;
        'Q': BEGIN                                  { PgDn = rechtsunten}
               IF x < W_Hoehe    THEN x := x+1;
               IF y < W_Breite   THEN y := y+1;
             END;
      END; (* CASE *)
    END;  (* Unterprozedur Richtung *)

  PROCEDURE Cursor_bewegen_und_einlesen
  (W_Hoehe, W_Breite : integer;
  VAR x, y : integer; VAR Taste : char; VAR Eingabefeld : pop_typ);
  (* W_Hoehe/W_Breite geben Bildschirmhoehe/-breite an  Default 25/80 *)
  (* x und y sind Koordinaten der zu veraendernden Cursorposition *)
    VAR Eingabe       : char;
        Funktionstaste : boolean;    (* TRUE, falls Funktionstaste gedrÅckt *)
    BEGIN (* Prozedur Cursor_bewegen *)
      Eingabe := keypruef (Funktionstaste);
      Taste := Eingabe;
      IF Funktionstaste
        THEN BEGIN
          Richtung (Eingabe, W_Hoehe, W_Breite, (* Var *) x, y);
          GOTOXY (y, x);
        END
        ELSE BEGIN
          IF Taste = ' ' THEN Eingabefeld[x,y] := 0
            ELSE IF Taste <> #13 THEN Eingabefeld[x,y] := 1;
          write (Taste);
          GOTOXY (y,x);
        END;
    END (* Unterprozedur Cursor_bewegen *);

  BEGIN (* Prozedur Matrize_einlesen *)
    Textfenster
      (Farbe, Randlinks, Randoben, W_Breite+Randlinks-1, W_Hoehe+Randoben-1);
    WITH Cursor DO BEGIN
      Zeile  := W_Hoehe DIV 2;
      Spalte := W_Breite DIV 2;
      GOTOXY (Spalte,Zeile);
    END;

    FOR x := 1 TO W_Hoehe DO
      FOR y := 1 TO W_Breite DO
        Eingabefeld[x,y] := 0;

    REPEAT
      Cursor_bewegen_und_einlesen
      (W_Hoehe, W_Breite,Cursor.Zeile, Cursor.Spalte, Eingabe, Eingabefeld);
    UNTIL UpCase(Eingabe) IN [#13, #27, ^C];
          { Ausgang Åber <Return>, Abbruch mit <Ctrl C> }
  END; (* Prozedur Matrize_einlesen *)


PROCEDURE gib_aus (population : pop_typ);
  VAR
        zeile, spalte : index2;
  BEGIN
    lebendig := 0;
    Textfenster ( hintergrund+1, 60, 1, 77, 18);
    GOTOXY (1,1);
    FOR zeile := 0 TO size2 DO
      BEGIN
        FOR spalte :=0 TO size2 DO
          IF (spalte = 17) AND (zeile = 17)
            THEN GOTOXY (17, 17)
            ELSE IF population [zeile, spalte] = lebewesen
                    THEN BEGIN
                      lebendig := lebendig + 1;
                      write (chr(11));
                    END
                    ELSE write (' ');;
      END;
  END;


PROCEDURE naechste_generation (VAR population : pop_typ);
  VAR
      zeile, spalte : index1;
      alte_population : pop_typ;

  PROCEDURE umfeld_untersuchen (z, s : index1);
    VAR
        anzahl_nachbarn : 0..8;
    BEGIN
      anzahl_nachbarn := alte_population [z-1,s-1]
                       + alte_population [z-1,s  ]
                       + alte_population [z-1,s+1]
                       + alte_population [z  ,s-1]
                       + alte_population [z  ,s+1]
                       + alte_population [z+1,s-1]
                       + alte_population [z+1,s  ]
                       + alte_population [z+1,s+1];
      IF alte_population [z,s] = lebewesen
        THEN IF (anzahl_nachbarn <= 1) OR (anzahl_nachbarn >= 4)
               THEN
                 BEGIN
                   population [z,s] := kein_lebewesen;
                   gestorben := gestorben + 1;
                 END
               ELSE
                 BEGIN
                   population [z,s] := lebewesen;
                   lebendig := lebendig + 1;
                 END
        ELSE IF anzahl_nachbarn = 3
               THEN
                 BEGIN
                   population [z,s] := lebewesen;
                   geboren := geboren + 1;
                   lebendig := lebendig + 1;
                 END;
    END (* umfeld_untersuchen *);

  BEGIN (* naechste generation *)
    alte_population := population;
    gestorben       := 0;
    geboren         := 0;
    lebendig        := 0;

    FOR zeile := 1 TO size1 DO
      FOR spalte := 1 TO size1 DO
        umfeld_untersuchen (zeile, spalte);
    generation := generation + 1;
  END;

FUNCTION noch_ne_generation : boolean;
  VAR antwort : char;
  BEGIN
    noch_ne_generation := false;
    textfenster (hintergrund + 2, 1, 20, 79, 24);
    writeln;
    IF (gestorben = 0) AND (geboren = 0)
      THEN writeln (' Statische Population')
      ELSE IF lebendig = 0
             THEN writeln (' Keine öberlebenden mehr')
             ELSE IF generation = max_generationen
                    THEN writeln (' Maximale Anzahl Generationen erreicht')
                    ELSE BEGIN
                           write (' Noch ne Generation (J/N) : ');
                           readln (antwort);
                           noch_ne_generation := (antwort IN ['J','j',' ']);
                         END (* ELSE *);
  END (* noch_ne_generation *);


PROCEDURE Programmende;
  BEGIN
    readln;
    textfenster (hintergrund + 2, 1, 20, 79, 24);
    Textbackground (hintergrund + 5);
    GOTOXY (21,2);
    write   ('       * * * Programmende * * *        ');
    GOTOXY (21,4);
    write   ('   FÅr Wiederholung drÅcke "lifegame"  ');
  END;


BEGIN
  Textmode(CO80);
  CLRSCR;
  population_init (population);
  generation := 1;
  gestorben  := 0;
  geboren    := 0;
  Kopf_des_Spiels;
  Textfenster (hintergrund + 1, 60, 1, 77, 18);
  TEXTCOLOR (Black);
  Matrize_einlesen (2, 61, 16, 16, hintergrund + 2, Population);
  gib_aus (population);
  geboren := lebendig;
  beigemuese (gestorben, geboren, lebendig);
  WHILE noch_ne_generation DO
    BEGIN
      naechste_generation (population);
      gib_aus (population);
      beigemuese (gestorben, geboren, lebendig);
    END (* While *);

  Programmende;
END.