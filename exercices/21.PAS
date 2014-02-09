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


