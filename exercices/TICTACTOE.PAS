(*$B-*)
PROGRAM TicTacToe;
(* Auf Eingabe einer Spielsituation von Kringel-und-Kreuze     *)
(* (Tic Tac Toe) wird fuer die freien Felder brechnet,         *)
(* ob sie zu einem Gewinn, Unentschieden oder Verlust fuehren. *)

CONST schwarz    = -1;
      weiss    =  1;
      frei    =  0;
TYPE Status    = -1..1;
     Spielbrett    = ARRAY[1..9] OF Status;
     Wert    = -1..1;

VAR B  : Spielbrett;
    w  : Wert;
    i  : INTEGER;

FUNCTION Muehle(B: Spielbrett): BOOLEAN;
(* Ist genau dann TRUE, wenn das Spielbrett eine Muehle enthaelt. *)
   VAR i: INTEGER;
   BEGIN
      Muehle := FALSE;
      FOR i := 1 TO 3 DO
      BEGIN
          IF abs(B[i] + B[i+3] + B[i+6]) = 3 THEN Muehle := TRUE;
         IF abs(B[3*i-2] + B[3*i-1] + B[3*i]) = 3 THEN Muehle := TRUE;
      END;
       IF abs(B[1] + B[5] + B[9]) = 3 THEN Muehle := TRUE;
      IF abs(B[3] + B[5] + B[7]) = 3 THEN Muehle := TRUE;
   END; (* Muehle *)

FUNCTION Voll(B: Spielbrett): BOOLEAN;
(* Liefert genau dann TRUE, wenn alle Felder belegt sind. *)
   VAR i : INTEGER;
   BEGIN
      Voll := TRUE;
      FOR i := 1 TO 9 DO
     IF B[i] = frei THEN Voll := FALSE
   END; (* Voll *)

FUNCTION Auswertung(B: Spielbrett; s: Status): Wert;
(* Ist Spieler s am Zug, so wird fuer jedes freie Feld von B berechnet ob, *)
(*  wenn s es ankreuzt, schwarz gewinnt (-1), weiss gewinnt (1)            *)
(*  oder es ein Unentschieden gibt (0).                                    *)

   VAR w, max: Wert;
       i     : INTEGER;
   BEGIN
      IF Muehle(B) OR Voll(B) THEN
     IF Muehle(B) THEN Auswertung := -s
     ELSE Auswertung := 0
      ELSE
      BEGIN
     max := -1;
     FOR i := 1 TO 9 DO                  (* Schaue alle Felder von B an. *)
     BEGIN
        IF B[i] = frei THEN              (* Falls Feld noch frei,        *)
        BEGIN
           B[i] := s;                    (* kreuze Feld an.              *)
           w := Auswertung(B,-s);        (* Berechne, wer dann gewinnt.  *)
           B[i] := frei;                 (* Gebe Feld wieder frei.       *)
           IF max < s*w THEN max := s*w  (* Bilde Maximum (falls s=1),   *)
        END; (* IF *)                    (* bzw. Minimum (falls s=-1)    *)
        Auswertung := s*max              (* ueber die Werte aller Felder.*)
     END (* FOR *)
      END (* IF *)
   END; (* Auswertung *)

PROCEDURE Ausgabe(i: INTEGER; w: Wert);
   BEGIN
      Write(i,': ');
      CASE w OF
        -1: WriteLn('Verlustzug');
         0: WriteLn('Unentschieden');
         1: WriteLn('Gewinnzug')
      END
   END; (* Ausgabe *)

BEGIN (* Hauptprogramm *)
   Write('Gebe zeilenweise die Belegung des Spielbretts ein, ');
   WriteLn('so dass Weiss am Zug ist.');
   WriteLn('Dabei ist 0 = Leer, 1 = Weiss, -1 = Schwarz: ');
   For i := 1 TO 3 DO
   BEGIN
      Write('Felder ',3*i-2,', ',3*i-1,' und ',3*i,':  ');
      ReadLn(B[3*i-2],B[3*i-1],B[3*i]);
      WriteLn
   END;

   IF Muehle(B) OR Voll(B) THEN WriteLn('Spiel bereits zu Ende')
   ELSE
   BEGIN
      FOR i := 1 TO 9 DO                 (* Schaue alle Felder an.     *)
      BEGIN
     IF B[i] = frei THEN             (* Falls Feld noch frei,      *)
     BEGIN
        B[i] := weiss;               (* wird es von Weiss markiert.*)
        w := Auswertung(B,schwarz);  (* Berechne wer dann gewinnt. *)
        B[i] := frei;                (* Gebe Feld wieder frei.     *)
        Ausgabe(i,w)
     END (* IF *)
      END (* FOR *)
   END (* IF *)
END.




{**********************************************************************}
{*                           EINUNDZWANZIG                            *}
{*--------------------------------------------------------------------*}
{* Ziel dieses Spiels ist es, durch geschickte Addition der beiden    *}
{* Werte 1 und 2 das Eregbnis 21 zu erreichen. Dabei wird gegen den   *}
{* Computer gespielt. Wer als erster den Wert 21 erreicht hat, ist    *}
{* Sieger.                                                            *}
{*--------------------------------------------------------------------*}
{* Dateiname:  21.PAS                                                 *}
{**********************************************************************}

PROGRAM Einundzwanzig;

USES Crt;

VAR
   xz,  boMyTurn : BOOLEAN;         {* True => Computer ist an der Reihe *}
     iWert : INTEGER;                           { aktueller Spielstand }

PROCEDURE Stand;
BEGIN
     WriteLn(^j,' Spielstand: ', iWert);
END;

PROCEDURE Spieler;
VAR
     cEingabe : CHAR;
BEGIN

     boMyTurn := FALSE;                       {* Computer darf NICHT! *}

     Write('Ihr Zug bitte: ');
     cEingabe := ReadKey;                  {* auf eine Eingabe warten *}

     CASE cEingabe OF                        {* und Eingabe auswerten *}
        '1':                       {* er mîchte also um 1 erhîhen ... *}
            BEGIN
            WriteLn('Genehmigt!');
            Inc(iWert);                               {* Wert erhîhen *}
            END;
        '2':
           BEGIN                                      {* um 2 erhîhen *}
           WriteLn('Sie gehen aber ran!');
           Inc(iWert, 2);
           END;
        ELSE                              {* Falscheingabe! SO Nicht! *}
           WriteLn('Das kann wohl nicht ganz sein.... NOCHMAL!');
           Spieler;                {* Spieler mu· Eingabe wiederholen *}
     END;
END;

PROCEDURE Computer;
BEGIN
     boMyTurn := TRUE;                 {* jetzt bin ich endlich dran! *}
                             {* je nach dem augenblicklichen Stand um *}
     CASE iWert OF                          {* um 1 oder um 2 erhîhen *}
        1,                {* unsere Kandidaten fÅr eine Erhîhung um 2 *}
        4,
        7,
        10,
        13,
        16,
        19:
        BEGIN
           WriteLn('Ich erhîhe um 2!');
           Inc(iWert, 2);                 {* auch tatsÑchlich erhîhen *}
        END
        ELSE                  {* in allen Åbrigen FÑllen: erhîhe um 1 *}
           WriteLn('Ich erhîhe um 1!');
           Inc(iWert);
       END;
END;


BEGIN

bomyturn:=true;
     ClrScr;                                     {* Bildschirm lîschen *}
                                               {* und neu aufbauen... *}
     WriteLn('****************************************************');
     WriteLn('*                   EINUNDZWANZIG                  *');
     WriteLn('*--------------------------------------------------*');
     WriteLn('* Das Ziel des Spiels ist es, durch Addition der   *');
     WriteLn('* beiden Zahlen 1 oder 2 den Wert 21 zu erreichen. *');
     WriteLn('* Derjenige, der diesen als erster erreicht, ist   *');
     WriteLn('* Sieger.                                          *');
     WriteLn('****************************************************');
     WriteLn(^j);

     REPEAT
     xz:=true;
        iWert := 0;                         {* wir beginnen mit NULL! *}
        Write('Mîchten Sie anfangen?: ');           {* immer hîflich... *}
        IF UpCase(ReadKey) = 'J' THEN               {* der Schurke... *}
           boMyTurn := FALSE;                 {* Gegner darf anfangen *}
        WriteLn;
        IF boMyTurn = FALSE THEN            {* Gegner mîchte beginnen *}
        BEGIN
           Stand;                  {* augenblicklichen Stand ausgeben *}
           Spieler;                   {* mein Gegner darf beginnen... *}
        END;

        WHILE(iWert < 21) DO        {* solange 21 noch nicht erreicht *}
        BEGIN
           Stand;                  {* augenblicklichen Stand ausgeben *}
           Computer;                       {* jetzt darf der Computer *}
           if iwert=21 then begin
             WriteLn('Ich habe gewonnen!');
             xz:=false;
            end;
          if xz=true then
          begin
           Stand;                  {* augenblicklichen Stand ausgeben *}
           Spieler;
           if iwert=21 then
           WriteLn('Gratuliere, Sie haben gewonnen!');

           end                   {* mein Gegner ist an der Reihe *}
        END;


        WriteLn('Mîchten Sie noch einmal?');
        boMyTurn := (UpCase(ReadKey) = 'J');

     UNTIL boMyTurn = FALSE;

     WriteLn('Es hat viel Spass gemacht - bis zum nÑchsten Mal!');

END.


