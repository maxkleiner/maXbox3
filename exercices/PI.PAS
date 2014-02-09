PROGRAM PiZufall;
Uses Crt;
{
 **************************************************************************
 Name / Vorname    : ABW
 Ausgabe/Version   : 1.0/10.06.88
 Filename          : I2P12BSP.PAS
 Beschreibung      : Es werden paarweise reelle Zufallszahlen zwischen 0
                     und 1 erzeugt. Darauf wird untersucht, ob die durch
                     die zwei Zahlen bestimmte Koordinate in einem Viertel-
                     kreis mit Radius 1 liegt. Diese "Treffer" werden ge-
                     zaehlt und der Quotient "Treffer" / "Versuche" sollte
                     den Wert Pi/4 ergeben. Somit kann mit dieser Methode
                     einerseits Pi angenaehert werden, andrerseits laesst
                     sich eine Aussage ueber die Qualitaet des Zufalls-
                     generators machen.
 **************************************************************************
}
CONST
  Reihe = 50;
VAR
 Zufall1,Zufall2: real;
  Treffer, Versuche,i : integer;
  Antwort           : char;
 Innerhalb,Versuchsnummer: integer;

{Unterprogramme}

PROCEDURE Versuchsreihe(VAR Innerhalb, Versuchsnummer : integer);
 { VAR
    Zufall1, Zufall2  : real;}


  PROCEDURE Generiere(VAR zuza1, zuza2 : real);
    BEGIN
      zuza1 := random;
      zuza2 := random
    END;

  FUNCTION InKreis(zuza1, zuza2 : real) : boolean;
    BEGIN
      InKreis := (sqr(zuza1) + sqr(zuza2)) <= 1
    END;

  BEGIN
    FOR i := 1 TO Reihe DO
      BEGIN

        Generiere(Zufall1,Zufall2);
        IF InKreis(Zufall1,Zufall2) THEN Innerhalb := Innerhalb + 1;
        writeln(Innerhalb);
        Versuchsnummer := Versuchsnummer + 1;
        writeln(Versuchsnummer)
      END
  END;


BEGIN
  Treffer := 0; Versuche := 0;
  REPEAT
    clrscr;
    Versuchsreihe(Treffer,Versuche);
    gotoXY(10,10);
    write('Naeherungswert fuer Pi = ', 4*Treffer/Versuche:15:12);
    gotoXY(10,13);
    write('Weitere  ',Reihe,' Versuche ? (j/n) '); read(Antwort)
  UNTIL (Antwort = 'n') OR (Antwort = 'N')
END.
