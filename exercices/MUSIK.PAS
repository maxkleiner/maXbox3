{ Weiterausbau von Programm Musik1.pas aus Pascal 3.0 }
{$R-}    {Range checking off}
{$B+}    {Boolean complete evaluation on}
{$S+}    {Stack checking on}
{$I+}    {I/O checking on}
{$N-}    {No numeric coprocessor}
{$M 65500,16384,655360} {Turbo 3 default stack and heap}

program Happy_Birthday (input, output);


Uses
  DOS, Crt, Graph, Math; {Unit found in TURBO.TPL}

CONST Faktor         = 3;
      Zwischenton    = 10;

TYPE
  Verbindung = ^Melodie;
  Ton = RECORD
          Oktave    : integer;
          Tonhoehe  : integer;
          Tonlaenge : integer;
        END;

  Melodie = RECORD
              Einzelton : Ton;
              Naechste  : Verbindung;
              Vorher    : Verbindung;
            END;

  Filetyp = FILE OF Ton;

VAR
  Antwort     : char;
  Start, Ende : Verbindung;
  Start2      : Verbindung;
  eingabe     : Filetyp;
  Richtung    : boolean;
  Stop        : boolean;  (* FÅr das Ende einer Eingabe ab Tastatur *)



PROCEDURE Play(Octave,Note,Duration: integer);
{ Play Note in Octave Duration milliseconds
  Frequency computed by first computing C in
  Octave then increasing frequency by Note-1
  times the twelfth root of 2. (1.059463994)

  If Duration is zero  Note will be played
  until you activate procedure NoSound       }


CONST Faktor         = 3;
      Zwischenton    = 10;
      Grundfrequenz  = 1; {32.625}
      Oktavfaktor    = 7 ; {2}
      Tonanzahl      = 49; {12}

var
  Endfrequenz : real;
  I         : integer;
  Loesch    : real;

begin
  IF Note < 13 THEN BEGIN
    Endfrequenz := Grundfrequenz *
      B_hoch_C(Oktavfaktor, (Octave-1) + (Note-1)/Tonanzahl);
    if Duration > 0 THEN BEGIN
      Sound(Round(Endfrequenz));
      Delay(Duration);
      NoSound;
    end
    else REPEAT Sound(Round(Endfrequenz)) UNTIL Keypressed; END
  ELSE BEGIN  (* Fortsetzung IF Duration *)
    NoSound;
    Delay(Duration);
  END;
end;


PROCEDURE Ton_anhaengen (Note : Ton; VAR Hilf : Verbindung);

  VAR Last : Verbindung;

  BEGIN
    NEW (Last);
    Hilf^.Einzelton := Note;
    Hilf^.Naechste := Last;
    Last^.Vorher := Hilf;
    Hilf := Last;
  END;

PROCEDURE Melodie_abspielen (Beginn : Verbindung; Richtung : boolean);
  VAR Hilf : Verbindung;
  BEGIN
    Hilf := Beginn;
    WHILE Hilf <> NIL DO
      BEGIN
        WITH Hilf^, Hilf^.Einzelton DO
          BEGIN
            Play (Oktave, Tonhoehe, ROUND (Tonlaenge/Faktor));
            NoSound;
            Delay (Zwischenton);
            If Richtung
              THEN Hilf := Hilf^.Naechste
              ELSE Hilf := Hilf^.Vorher;
          END;
      END;
  END;


PROCEDURE Aus_Speicher_laden (VAR Anfang, Schluss : Verbindung;
                              VAR Datei: Filetyp; Dateiname : String);
  VAR Hilf       : Verbindung;
      Note       : Ton;

  BEGIN
    ASSIGN (Datei, Dateiname);
    RESET (Datei);
    NEW (Anfang);
    Anfang^.Vorher := NIL;
    Hilf := Anfang;
    WHILE NOT eof(Datei) DO
      BEGIN
        read (Datei, Note);
        Ton_anhaengen (Note, Hilf);
      END;
      Schluss := Hilf^.Vorher;
      DISPOSE (Hilf);
      Schluss^.Naechste := NIL;
    CLOSE (Datei);
  END;


BEGIN  (* Hauptprogramm *);

  Aus_Speicher_laden (Start, Ende, eingabe, 'b:\datlist\hapbirth.mel');
  Melodie_abspielen (Start, ODD(1));
(*    Aus_Speicher_laden (Start, Ende, eingabe, 'b:\datlist\pauken1.mel');
    Aus_Speicher_laden (Start2, Ende, eingabe, 'b:\datlist\pauken2.mel');
    Melodie_abspielen (Start, ODD(1));
    Melodie_abspielen (Start2, ODD(1)); *)

END.
