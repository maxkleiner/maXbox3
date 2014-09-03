// ******************************************************************************
//
//  Copyright (C) 2006 W. Soltendick und TOOLBOX-Verlag, alle Rechte vorbehalten
//
//  V0.17, 30.03.2006
//  V0.42, 21.05.2005
//    V0.90  22.08.2014 adapt/adopt to maXbox
//    V0.95  31.08.2014 with serial interface and monitor
//
// ******************************************************************************

unit gpsdata_testkit;

interface

{uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Serial, StdCtrls, Menus, ComCtrls, ExtCtrls, TeEngine, Series, TeeProcs,
  Chart;}

type
  TGPS = record//class(TForm)
    Seriell: TSerial;
    NumSatTxt: TLabel;
    LaengeTxt: TLabel;
    HoeheTxt: TLabel;
    BreiteTxt: TLabel;
    NumSat: TLabel;
    Laenge: TLabel;
    Breite: TLabel;
    Hoehe: TLabel;
    Text: TLabel;
    Start: TButton;
    Stop: TButton;
    Einst: TButton;
    Status: TLabel;
    Empfang: TLabel;
    GPRMC: TLabel;
    GPGGA: TLabel;
    Edit1: TEdit;
    Einstellungen: TEdit;
    DebugBox: TCheckBox;
    ZeitTxt: TLabel;
    GenauTxt: TLabel;
    Zeit: TLabel;
    Genau: TLabel;
    DatumTxt: TLabel;
    Datum: TLabel;
    BreiteNS: TLabel;
    LaengeOW: TLabel;
    HoeheM: TLabel;
    GPGSA: TLabel;
    GPGSV: TLabel;
    Schreiben: TCheckBox;
    Satelliten: TButton;
    ECount: TLabel;
    ExceptionText: TLabel;
    GeschwindigkeitTxt: TLabel;
    Geschwindigkeit: TLabel;
    Gechwindigkeit_kmh: TLabel;
    KursTxt: TLabel;
    Kurs: TLabel;
    KursGrad: TLabel;
    Timer1: TTimer;
    Version: TLabel;
    commanager: TCOMManager;
    end;
       procedure EinstClick(Sender: TObject);
       procedure StartClick(Sender: TObject);
       procedure StopClick(Sender: TObject);
       procedure SeriellEventChar(Sender: TObject);
       procedure DebugBoxClick(Sender: TObject);
       procedure SeriellRxChar(Sender: TObject);
       procedure SatellitenClick(Sender: TObject);
       procedure Timer1Timer(Sender: TObject);
       procedure DiagramClick(Sender: TObject);
  //private
    { Private-Deklarationen }
  //public
    { Public-Deklarationen }
  //end;
  
  type
  TSatellit = record //class(TForm)
    Sat2Bar: TProgressBar;
    Sat3Bar: TProgressBar;
    Sat4Bar: TProgressBar;
    Sat5Bar: TProgressBar;
    Sat6Bar: TProgressBar;
    Sat7Bar: TProgressBar;
    Sat8Bar: TProgressBar;
    SatAnzahlText: TLabel;
    SatAnzahl: TLabel;
    AnzahlGSV: TLabel;
    Sat1ID: TLabel;
    Sat2ID: TLabel;
    Sat3ID: TLabel;
    Sat4ID: TLabel;
    Sat5ID: TLabel;
    Sat6ID: TLabel;
    Sat7ID: TLabel;
    Sat8ID: TLabel;
   end;
   
   type
  TSatDaten = record //class(TForm)
    Sat1ID: TLabel;
    Sat2ID: TLabel;
    Sat3ID: TLabel;
    Sat4ID: TLabel;
    Sat5ID: TLabel;
    Sat6ID: TLabel;
    Sat7ID: TLabel;
    Sat8ID: TLabel;
    SatAnzahlText: TLabel;
    SatAnzahl: TLabel;
    GSVAnzahl: TLabel;
    AnzahlTextGSV: TLabel;
    Sat2Bar: TProgressBar;
    Sat3Bar: TProgressBar;
    Sat4Bar: TProgressBar;
    Sat5Bar: TProgressBar;
    Sat6Bar: TProgressBar;
    Sat7Bar: TProgressBar;
    Sat8Bar: TProgressBar;
    Sat1Bar: TProgressBar;
    Sat9Bar: TProgressBar;
    Sat10Bar: TProgressBar;
    Sat11Bar: TProgressBar;
    Sat12Bar: TProgressBar;
    Sat9ID: TLabel;
    Sat10ID: TLabel;
    Sat11ID: TLabel;
    Sat12ID: TLabel;
  end;



var
  GPS: TGPS;
  Satellit: TSatellit;
  SatDaten: TSatDaten; //must a form

  Zeichenkette, rueckgabe: String; // gesamte empfangene Zeichen (nur fuer Debug-Zwecke)
  Anzahl: integer;      // Anzahl empfangener Datensaetze
  DebugFlag: Boolean;   // Debug-Informationen anzeigen
  TeilString: String;   // bestimmter Teildatensatz
  TempString: String;   // Daten zwischen zwei Kommata
  Komma2: integer;      // Position des zweiten Kommas
  Warnung: Boolean;     // GPS-Warnung
  SchreibFlag: Boolean; // GPS-Daten in Datei schreiben
  Zeichen: String;      // empfangene Zeichen
  RohDatei: TFileStream;      // Datei-Stream
  ExceptionCounter: Integer;  // Zaehler fuer Exceptions
  TxtDatei: TFileStream;      // Daten in Klartext
  SchreibTextFlag: Boolean;   // Text-Daten schreiben
  SchreibRohFlag: Boolean;    // Rohdaten schreiben

implementation

//uses Einstell, Sat, SatUnit, dia;

//{$R *.DFM}

// Einstellungen Dialog anzeigen
procedure EinstClick(Sender: TObject);
var
  Temp: Integer;
  ErrPos: Integer;
begin
  //gps.Einstellungen.Show;

  // Timer-Wert checken
  Val ('Einstellungen.Edit3.Text', Temp, ErrPos);
  if (ErrPos <> 0) then begin
    // Default Werte setzen
    gps.Timer1.Interval := 3000;
    //Einstellungen.Edit3.Text := '3000';
  end else begin
    gps.Timer1.Interval := Temp;
  end;
end;

// Start Button
procedure StartClick(Sender: TObject);
var
  Rueckgabe: boolean;  // Rueckgabewert
  i: integer;
  Temp: Integer;
  ErrPos: Integer;
  AusgabeTxt: String;
begin
  // Button Einstellungen deaktivieren
  gps.Einst.Enabled := False;

  // Schnittstelle checken
  if (gps.COMManager.PortExists (gps.Seriell.COMPort) = false) then begin
    // erste verfuegbare suchen
    for i := 1 to 8 do begin
      if (gps.COMManager.PortExists (i) = True) then begin
        gps.Seriell.COMPort := i;
        break;
      end;
    end;
  end;

  // Schnittstelle mit default Werten oeffnen
  Rueckgabe := gps.Seriell.OpenComm;
  if (Rueckgabe = True) then begin
    gps.Text.Caption := 'COM ' + IntToStr (gps.Seriell.ComPort) + ' geoeffnet';

    // Felder loeschen
    gps.GPGGA.Caption := '';
    gps.GPRMC.Caption := '';
    gps.GPGSA.Caption := '';
    gps.GPGSV.Caption := '';
    gps.NumSat.Caption := '0';
    gps.Zeit.Caption := '000000';
    gps.Datum.Caption := '000000';
    gps.Genau.Caption := '0.0';
    gps.Laenge.Caption := '0.0';
    gps.LaengeOW.Caption := 'W';
    gps.Breite.Caption := '0.0';
    gps.BreiteNS.Caption := 'S';
    gps.Hoehe.Caption := '0';
    gps.HoeheM.Caption := 'M';
    Warnung := false;

    // Zeichenkette loeschen
    Zeichen :='';
    gps.Empfang.Caption := '';
    Zeichenkette := '';
    Anzahl := 0;
    DebugFlag := false;

    // Debug-Flag checken
    if (gps.DebugBox.Checked = true) then begin
      DebugFlag := true;
      gps.Edit1.Visible := true;
    end;

    // Exception Zaehler initialisieren
    ExceptionCounter := 0;

    // Datei schreiben ?
    SchreibFlag := False;
    if (gps.Schreiben.Checked = true) then begin
      SchreibFlag := True;

      // welche Daten ?
      SchreibRohFlag := false;
      SchreibTextFlag := false;
      {if (Einstellungen.SchreibenRoh.Checked = true) then
        SchreibRohFlag := true;
      if (Einstellungen.SchreibenText.Checked = true) then
        SchreibTextFlag := true;}
    end;

    // Box aus
    gps.Schreiben.Enabled := False;

    // Button Satelliten an
    gps.Satelliten.Enabled := True;

    // Timer setzen
//    Timer1.Interval := strtoint (Einstellungen.Edit3.Text);
    Val ('gps.Einstellungen.Edit3.Text', Temp, ErrPos);
    if (ErrPos <> 0) then begin
      gps.Timer1.Interval := 3000;
      //Einstellungen.Edit3.Text := '3000';
    end else begin
      gps.Timer1.Interval := Temp;
    end;

    // Datei oeffnen
    if (SchreibFlag = True) then begin
      if (SchreibRohFlag = true) then begin
        RohDatei:= TFileStream.Create (('Einstellungen.Edit1.Text'), fmCreate or fmOpenWrite);
        gps.Text.Caption := gps.Text.Caption + ' - ' + 'Einstellungen.Edit1.Text';
      end;
      if (SchreibTextFlag = true) then begin
        TxtDatei := TFileStream.Create (('Einstellungen.Edit2.Text'), fmCreate or fmOpenWrite);
        AusgabeTxt := 'Zeit,Datum,Breite,Breitengrad,Laenge,Laengengrad,Hoehe,M,Geschwindigkeit,Kurs' + #13 + #10;
        TxtDatei.Write (PChar (AusgabeTxt), Length (AusgabeTxt));
      end;
    end;

    // Satellitendaten loeschen
    {SatDaten.Sat1Bar.Position := 0;
    SatDaten.Sat1ID.Caption := '-';
    SatDaten.Sat2Bar.Position := 0;
    SatDaten.Sat2ID.Caption := '-';
    SatDaten.Sat3Bar.Position := 0;
    SatDaten.Sat3ID.Caption := '-';
    SatDaten.Sat4Bar.Position := 0;
    SatDaten.Sat4ID.Caption := '-';
    SatDaten.Sat5Bar.Position := 0;
    SatDaten.Sat5ID.Caption := '-';
    SatDaten.Sat6Bar.Position := 0;
    SatDaten.Sat6ID.Caption := '-';
    SatDaten.Sat7Bar.Position := 0;
    SatDaten.Sat7ID.Caption := '-';
    SatDaten.Sat8Bar.Position := 0;
    SatDaten.Sat8ID.Caption := '-';
    SatDaten.Sat9Bar.Position := 0;
    SatDaten.Sat9ID.Caption := '-';
    SatDaten.Sat10Bar.Position := 0;
    SatDaten.Sat10ID.Caption := '-';
    SatDaten.Sat11Bar.Position := 0;
    SatDaten.Sat11ID.Caption := '-';
    SatDaten.Sat12Bar.Position := 0;
    SatDaten.Sat12ID.Caption := '-'; }

  end else begin
    gps.Text.Caption:= 'Fehler beim Oeffnen von COM '+ IntToStr (gps.Seriell.ComPort);
  end;
end;

procedure {TGPS.}StopClick(Sender: TObject);
begin
  // Schnittstelle schliessen
  gps.Seriell.CloseComm;

  // Ausgabe
  gps.Text.Caption := '';
  if (DebugFlag = true) then
    gps.Text.Caption := IntToStr (Anzahl) + ' - ' ;
  gps.Text.Caption := gps.Text.Caption+ 'COM '+ IntToStr (gps.Seriell.ComPort) + ' geschlossen';
  gps.Edit1.Text := Zeichenkette;

  // Button Einstellungen aktivieren
  gps.Einst.Enabled := true;

  // Schreibdatei schliessen ...
  if (SchreibFlag = True) then begin
    if (SchreibRohFlag = true) then
      RohDatei.Free;
    if (SchreibTextFlag = true) then
      TxtDatei.Free;
    SchreibFlag := False;
  end;

  // ... und Checkbox wieder aktivieren
  gps.Schreiben.Enabled := True;

  // Button Satelliten aus
  gps.Satelliten.Enabled := False;

end;

// naechste Daten in GPS-Daten
function NaechstesDatum (Start: integer) : integer;
var
  i: integer;
  Komma: integer;   // Position des Kommas
begin
  Result := 1;
  if (Start = 0) then begin
    Komma := Pos(',', TeilString);
  end else begin
    if (Start = 1) then begin
      Komma := Komma2;
    end else begin
      Komma := Start;
    end;
  end;
  if (Komma <> 0) then begin
    TeilString[Komma] := '-';
    Komma2 := Pos(',', TeilString);

    // auf letztes Zeichen checken
    if (Komma2 = 0) then begin
      Komma2 := Pos ('*', TeilString);
    end;

    if (Komma2 <> 0) then begin
      // Info kopieren
      TempString := '';
      TeilString[Komma2] := '-';

      // nur kopieren, wenn tatsaechlich Zeichen vorhanden
      if (Komma2 - 1 >= Komma + 1) then begin
        for i := Komma + 1 to Komma2 - 1 do begin
          TempString := TempString + ' ';
          TempString[i-Komma] := TeilString [i];
        end;
      end;
    end else begin
      Result := 0;
    end;
  end else begin
    Result := 0;
  end;
end;

 Type TRText2 = Function: string;
 
     function gettext: string;
     var zeichen2: TRText;

     begin
       //result:= TRText(gps.Seriell.ReceiveText);
       zeichen2:= gps.Seriell.ReceiveText;
       result:= zeichen2();
       result:= gps.Seriell.ReceiveText();
    
     end;
 

// serielles Ereiegnis aufgetreten
procedure {TGPS.}SeriellEventChar(Sender: TObject);
var
  Zeichen: String;     // Zeichenkette
  zeichen2: TRText;
  zeichen3: TRText2;
  
  Komma: integer;      // Position des Kommas
  i: integer;
  Rueckgabe: integer;  // Rueckgabewert
  Fehler: boolean;     // Fehler-Flag

  AnzahlGSV: Integer;  // Anzahl der GPGSV-Zeilen
  GSVAktuell: Integer; // Index der aktuellen GSV-Zeile
  AnzahlSat: Integer;  // Anzahl der sichtbaren Satelliten
  Wert: Integer;       // temporaerer Zwischenwert
begin
  // Zeichen auslesen, default ohne Timeout !
  Zeichen:= gps.Seriell.ReceiveText();
  zeichen3:= @gettext;
  zeichen:= gettext;
  Anzahl := Anzahl + 1;  // Anzahl der Funktionsaufrufe
  Fehler := false;       // Fehler-Flag zuruecksetzen

  // ... und ausgeben (DEBUG)
  if (DebugFlag = true) then begin
    gps.Empfang.Caption := Zeichen;
  end else begin
    gps.Empfang.Caption := '   ... Empfange Zeichen ...';
  end;

  // nur Debugging
  Zeichenkette := (* Zeichenkette + *) Zeichen;

  // nach Daten verzweigen ...
  // $GPGGA - GPS feste Daten
  if (strpos (PChar (Zeichen), 'GGA') <> nil) then begin
    TeilString := string (strpos (PChar (Zeichen), 'GGA'));
    if (DebugFlag = true) then
      gps.GPGGA.Caption := 'GPGGA';

    // Zeit
    Rueckgabe := NaechstesDatum (0);
    if (Rueckgabe = 0) then begin
      Fehler := true;
    end else begin
      gps.Zeit.Caption := TempString;
    end;

    // Breitengrad
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        gps.Breite.Caption := TempString;
      end;
    end;

    // Breite
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        gps.BreiteNS.Caption := TempString;
      end;
    end;

    // Laengengrad
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        gps.Laenge.Caption := TempString;
      end;
    end;

    // Laenge
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        gps.LaengeOW.Caption := TempString;
      end;
    end;

    // Gueltigkeit
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        if (TempString = '1') then
          gps.Text.Caption := ' Daten gueltig ...';
        if (TempString = '0') then
          gps.Text.Caption := ' Daten ungueltig !!!';
      end;
    end;

    // Anzahl
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        gps.NumSat.Caption := TempString;
      end;
    end;

    // Genauigkeit
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        gps.Genau.Caption := TempString;
      end;
    end;

    // Hoehe
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        gps.Hoehe.Caption := TempString;
      end;
    end;

    // Hoehe M
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        gps.HoeheM.Caption := TempString;
      end;
    end;
  end;

  // $GPRMC - Minimum Navi Informationen
  if (strpos (PChar (Zeichen), 'RMC') <> nil) then begin
    TeilString := string (strpos (PChar (Zeichen), 'RMC'));
    if (DebugFlag = true) then
      gps.GPRMC.Caption := 'GPRMC';

    // naechstes Datum
    Fehler := true;
    Rueckgabe := NaechstesDatum (0);
    if (Rueckgabe <> 0) then begin
      gps.Zeit.Caption := TempString;
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe <> 0) then begin
        Fehler := false;
        if (TempString = 'V') then begin
          if (Warnung = false) then begin
            gps.Text.Caption := gps.Text.Caption + ' - GPS-Warnung !!!';
            Warnung := true;
          end;
        end;
      end;
    end;

    // Infos ueberspringen
    if (Fehler = false) then begin
      for i := 1 to 3 do begin
        Komma := Pos(',', TeilString);
        if (Komma <> 0) then begin
          TeilString[Komma] := '-';
        end else begin
          Fehler := true;
          break;
        end;
      end;
    end;

      // Geschwindigkeit
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (0);
        if (Rueckgabe <> 0) then begin
          gps.Geschwindigkeit.Caption := TempString;
        end else begin
          Fehler := true;
        end;
      end;

      // Kurs
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe <> 0) then begin
          gps.Kurs.Caption := TempString;
        end else begin
          Fehler := true;
        end;
      end;

    // Datum
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe <> 0) then begin
        gps.Datum.Caption := TempString;
      end;
    end;
  end;

  // $GPGSA - Satelliten Informationen
  if (strpos (PChar (Zeichen), 'GSA') <> nil) then begin
    TeilString := string (strpos (PChar (Zeichen), 'GSA'));
    if (DebugFlag = true) then
      gps.GPGSA.Caption := 'GPGSA';
  end;

  // $GPGSV - sichtbare Satelliten
  if (strpos (PChar (Zeichen), 'GSV') <> nil) then begin
    TeilString := string (strpos (PChar (Zeichen), 'GSV'));
    if (DebugFlag = true) then
      gps.GPGSV.Caption := 'GPGSV';

    // weitere Sat-Daten...
    // Anzahl GPGSV-Zeilen
    Rueckgabe := NaechstesDatum (0);
    if (Rueckgabe = 0) then begin
      Fehler := true;
    end else begin
      Wert := 0;
      if (strlen (PChar (TempString)) > 0) then begin
        try
          Wert := strtoint (TempString);
        except //on E: EConvertError do
          Fehler := true;  // Fehler aufgetreten
        end;
        if (Fehler = true) then begin
          Wert := 0;  // zuruecksetzen
          ExceptionCounter := ExceptionCounter + 1;
        end;
      end;  // strlen
      // Variable setzen und ausgeben
      AnzahlGSV := Wert;
      SatDaten.GSVAnzahl.Caption := TempString;
    end;

    // Index aktuelle GSV-Zeile
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        Wert := 0;
        if (strlen (PChar(TempString)) > 0) then begin
          try
            Wert := strtoint (TempString);
          except //on E: EConvertError do
            Fehler := true;  // Fehler aufgetreten
          end;
          if (Fehler = true) then begin
            Wert := 0;  // zuruecksetzen
            ExceptionCounter := ExceptionCounter + 1;
          end;
        end;
        GSVAktuell := Wert;
      end;
    end;

    // Sat-Anzahl
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        SatDaten.SatAnzahl.Caption := TempString;
        Wert := 0;
        if (strlen (PChar(TempString)) > 0) then begin
          try
            Wert := strtoint (TempString);
          except //on E: EConvertError do
            Fehler := true;  // Fehler aufgetreten
          end;
          if (Fehler = true) then begin
            Wert := 0;  // zuruecksetzen
            ExceptionCounter := ExceptionCounter + 1;
          end;
        end;
        AnzahlSat := Wert;

        // Daten loeschen
        if (AnzahlSat < 12) then begin
          SatDaten.Sat12ID.Caption := '-';
          SatDaten.Sat12Bar.Position := 0;
        end;
        if (AnzahlSat < 11) then begin
          SatDaten.Sat11ID.Caption := '-';
          SatDaten.Sat11Bar.Position := 0;
        end;
        if (AnzahlSat < 10) then begin
          SatDaten.Sat10ID.Caption := '-';
          SatDaten.Sat10Bar.Position := 0;
        end;
        if (AnzahlSat < 9) then begin
          SatDaten.Sat9ID.Caption := '-';
          SatDaten.Sat9Bar.Position := 0;
        end;
        if (AnzahlSat < 8) then begin
          SatDaten.Sat8ID.Caption := '-';
          SatDaten.Sat8Bar.Position := 0;
        end;
        if (AnzahlSat < 7) then begin
          SatDaten.Sat7ID.Caption := '-';
          SatDaten.Sat7Bar.Position := 0;
        end;
        if (AnzahlSat < 6) then begin
          SatDaten.Sat6ID.Caption := '-';
          SatDaten.Sat6Bar.Position := 0;
        end;
      end;
    end;


    // Sat ID
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        if (GSVAktuell = 1) then begin
          SatDaten.Sat1ID.Caption := TempString;
          SatDaten.Sat1Bar.Position := 0;  // zuruecksetzen
        end;
        if (GSVAktuell = 2) then begin
          SatDaten.Sat5ID.Caption := TempString;
          SatDaten.Sat5Bar.Position := 0;
        end;
        if (GSVAktuell = 3) then begin
          SatDaten.Sat9ID.Caption := TempString;
          SatDaten.Sat9Bar.Position := 0;
        end;
      end;
    end;

    //  Elevation & Azimuth ueberspringen, SNR lesen
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then
        Fehler := true;
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then
          Fehler := true;
      end;
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);  // SNR
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          if (strlen (PChar(TempString)) > 0) then begin
            try
              Wert := strtoint (TempString);
            except //on E: EConvertError do
              Fehler := true;  // Fehler aufgetreten
            end;
            if (Fehler = true) then begin
              Wert := 0;  // zuruecksetzen
              ExceptionCounter := ExceptionCounter + 1;
              if (DebugFlag = true) then begin
                 // Debug Ausgabe in Datei
                 Zeichen := Zeichen + '-1<';
              end;
            end;
          end else begin
            Wert := 0;
          end;
          // Signalstaerke ausgeben
          if (GSVAktuell = 1) then begin
            SatDaten.Sat1Bar.Position := Wert;
          end;
          if (GSVAktuell = 2) then begin
            SatDaten.Sat5Bar.Position := Wert;
          end;
          if (GSVAktuell = 3) then begin
            SatDaten.Sat9Bar.Position := Wert;
          end;
        end;
      end;
    end;

    // Sat ID
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        if (GSVAktuell = 1) then begin
          SatDaten.Sat2ID.Caption := TempString;
          SatDaten.Sat2Bar.Position := 0;
        end;
        if (GSVAktuell = 2) then begin
          SatDaten.Sat6ID.Caption := TempString;
          SatDaten.Sat6Bar.Position := 0;
        end;
        if (GSVAktuell = 3) then begin
          SatDaten.Sat10ID.Caption := TempString;
          SatDaten.Sat10Bar.Position := 0;
        end;
      end;
    end;

    //  Elevation & Azimuth ueberspringen, SNR lesen
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then
        Fehler := true;
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then
          Fehler := true;
      end;
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);  // SNR
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          if (strlen (PChar(TempString))> 0) then begin
            try
              Wert := strtoint (TempString);
            except //on E: EConvertError do
              Fehler := true;  // Fehler aufgetreten
            end;
            if (Fehler = true) then begin
              Wert := 0;  // zuruecksetzen
              ExceptionCounter := ExceptionCounter + 1;
              if (DebugFlag = true) then begin
                 // Debug Ausgabe in Datei
                 Zeichen := Zeichen + '-2<';
              end;
            end;
          end else begin
            Wert := 0;
          end;
          if (GSVAktuell = 1) then begin
            SatDaten.Sat2Bar.Position := Wert;
          end;
          if (GSVAktuell = 2) then begin
            SatDaten.Sat6Bar.Position := Wert;
          end;
          if (GSVAktuell = 3) then begin
            SatDaten.Sat10Bar.Position := Wert;
          end;
        end;
      end;
    end;

    // Sat ID
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        if (GSVAktuell = 1) then begin
          SatDaten.Sat3ID.Caption := TempString;
          SatDaten.Sat3Bar.Position := 0;
        end;
        if (GSVAktuell = 2) then begin
          SatDaten.Sat7ID.Caption := TempString;
          SatDaten.Sat7Bar.Position := 0;
        end;
        if (GSVAktuell = 3) then begin
          SatDaten.Sat11ID.Caption := TempString;
          SatDaten.Sat11Bar.Position := 0;
        end;
      end;
    end;

    //  Elevation & Azimuth ueberspringen, SNR lesen
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then
        Fehler := true;
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then
          Fehler := true;
      end;
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);  // SNR
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          if (strlen (PChar(TempString)) > 0) then begin
            try
              Wert := strtoint (TempString);
            except //on E: EConvertError do
              Fehler := true;  // Fehler aufgetreten
            end;
            if (Fehler = true) then begin
              Wert := 0;  // zuruecksetzen
              ExceptionCounter := ExceptionCounter + 1;
              if (DebugFlag = true) then begin
                 // Debug Ausgabe in Datei
                 Zeichen := Zeichen + '-3<';
              end;
            end;
          end else begin
            Wert := 0;
          end;
          if (GSVAktuell = 1) then begin
            SatDaten.Sat3Bar.Position := Wert;
          end;
          if (GSVAktuell = 2) then begin
            SatDaten.Sat7Bar.Position := Wert;
          end;
          if (GSVAktuell = 3) then begin
            SatDaten.Sat11Bar.Position := Wert;
          end;
        end;
      end;
    end;

    // Sat ID
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        if (GSVAktuell = 1) then begin
          SatDaten.Sat4ID.Caption := TempString;
          SatDaten.Sat4Bar.Position := 0;
        end;
        if (GSVAktuell = 2) then begin
          SatDaten.Sat8ID.Caption := TempString;
          SatDaten.Sat8Bar.Position := 0;
        end;
        if (GSVAktuell = 3) then begin
          SatDaten.Sat12ID.Caption := TempString;
          SatDaten.Sat12Bar.Position := 0;
        end;
      end;
    end;

    //  Elevation & Azimuth ueberspringen, SNR lesen
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then
        Fehler := true;
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then
          Fehler := true;
      end;
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);  // SNR
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          if (strlen (PChar(TempString)) > 0) then begin
            try
              Wert := strtoint (TempString);
            except //on E: EConvertError do
              Fehler := true;  // Fehler aufgetreten
            end;
            if (Fehler = true) then begin
              Wert := 0;  // zuruecksetzen
              ExceptionCounter := ExceptionCounter + 1;
              if (DebugFlag = true) then begin
                 // Debug Ausgabe in Datei
                 Zeichen := Zeichen + '-4<';
              end;
            end;
          end else begin
            Wert := 0;
          end;
          if (GSVAktuell = 1) then begin
              SatDaten.Sat4Bar.Position := Wert;
          end;
          if (GSVAktuell = 2) then begin
            SatDaten.Sat8Bar.Position := Wert;
          end;
          if (GSVAktuell = 3) then begin
            SatDaten.Sat12Bar.Position := Wert;
          end;
        end;
      end;
    end;

  end; // GPGSV

  // Original schreiben
  if (SchreibFlag = true) then begin
    if (DebugFlag = true) then begin
      // Debug Ausgabe in Datei
      Zeichen := Zeichen + '-';
    end;
    if (SchreibRohFlag = true) then
      RohDatei.Write (PChar (Zeichen), Length (Zeichen));
  end;

  // Exception Zaehler anzeigen
  gps.ECount.Caption := inttostr (ExceptionCounter);
end;

// Debug Box angeklickt
procedure {TGPS.}DebugBoxClick(Sender: TObject);
begin
  DebugFlag := false;
  gps.Edit1.Visible := false;
  if (gps.DebugBox.Checked = true) then begin
    DebugFlag := true;
    gps.Edit1.Visible := true;
  end;
end;

// zweite Empfangsroutine
procedure {TGPS.}SeriellRxChar(Sender: TObject);
var
  Fehler: boolean;       // Fehler-Flag
  Rueckgabe: integer;    // Rueckgabewert
  i: integer;
  Komma: integer;        // Index des Kommas
  AnzahlGSV: Integer;    // Anzahl der GSV-Zeilen
  GSVAktuell: Integer;   // Index aktuelle GSV-Zeile
  AnzahlSat: Integer;    // Anzahl der sichtbaren Satelliten
  Wert: Integer;         // temporärer Wert
begin
  // empfangene Zeichen anfügen
  Zeichen := Zeichen + gps.Seriell.ReceiveText();  //proc type!
  GSVAktuell := 0;

  // Zeichenkette ausgeben
  if (DebugFlag = true) then
  begin
    gps.Empfang.Caption := Zeichen;
  end else begin
    gps.Empfang.Caption := '   ... Empfange Zeichen ...';
  end;

  // *-Zeichen empfangen
  if (strscan (PChar (Zeichen), Char ('*')) <> nil) then
  begin
    // Datei schreiben
    if (SchreibFlag = true) then begin
      if (SchreibRohFlag=true) then
        //RohDatei.Write (PChar (Zeichen)^, Length (Zeichen));
        RohDatei.Write (PChar (Zeichen), Length (Zeichen));

    end;

    // Aufruf Anzahl erhoehen
    Anzahl := Anzahl + 1;

    // Fehler-Flag zurücksetzen
    Fehler := false;

    // nur Debugging
    Zeichenkette := (* Zeichenkette + *) Zeichen;

    // nach Daten verzweigen ...
    // $GPGGA - GPS feste Daten
    if (strpos (PChar (Zeichen), 'GGA') <> nil) then begin
      TeilString := string (strpos (PChar (Zeichen), 'GGA'));
      if (DebugFlag = true) then
        gps.GPGGA.Caption := 'GPGGA';

      // Zeit
      Rueckgabe := NaechstesDatum (0);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        gps.Zeit.Caption := TempString;
      end;

      // Breitengrad
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          gps.Breite.Caption := TempString;
        end;
      end;

      // Breite
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          gps.BreiteNS.Caption := TempString;
        end;
      end;

      // Laengengrad
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          gps.Laenge.Caption := TempString;
        end;
      end;

      // Laenge
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          gps.LaengeOW.Caption := TempString;
        end;
      end;

      // Gueltigkeit
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          if (TempString = '1') then
            gps.Text.Caption := ' Daten gueltig ...';
          if (TempString = '0') then
            gps.Text.Caption := ' Daten ungueltig !!!';
        end;
      end;

      // Anzahl
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          gps.NumSat.Caption := TempString;
        end;
      end;

      // Genauigkeit
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          gps.Genau.Caption := TempString;
        end;
      end;

      // Hoehe
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          gps.Hoehe.Caption := TempString;
        end;
      end;

      // Hoehe M
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          gps.HoeheM.Caption := TempString;
        end;
      end;
    end;

    // $GPRMC - Minimum Navi Informationen
    if (strpos (PChar (Zeichen), 'RMC') <> nil) then begin
      TeilString := string (strpos (PChar (Zeichen), 'RMC'));
      if (DebugFlag = true) then
        gps.GPRMC.Caption := 'GPRMC';

      // naechstes Datum
      Fehler := true;
      Rueckgabe := NaechstesDatum (0);
      if (Rueckgabe <> 0) then begin
        gps.Zeit.Caption := TempString;
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe <> 0) then begin
          Fehler := false;
          if (TempString = 'V') then begin
            if (Warnung = false) then begin
              gps.Text.Caption := gps.Text.Caption + ' - GPS-Warnung !!!';
              Warnung := true;
            end;
          end;
        end;
      end;

      // Infos ueberspringen
      if (Fehler = false) then begin
        for i := 1 to 3 do begin
          Komma := Pos(',', TeilString);
          if (Komma <> 0) then begin
            TeilString[Komma] := '-';
          end else begin
            Fehler := true;
            break;
          end;
        end;
      end;

      // Geschwindigkeit
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (0);
        if (Rueckgabe <> 0) then begin
          gps.Geschwindigkeit.Caption := TempString;
        end else begin
          Fehler := true;
        end;
      end;

      // Kurs
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe <> 0) then begin
          gps.Kurs.Caption := TempString;
        end else begin
          Fehler := true;
        end;
      end;

      // Datum
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe <> 0) then begin
          gps.Datum.Caption := TempString;
        end;
      end;
    end;

    // $GPGSA - Satelliten Informationen
    if (strpos (PChar (Zeichen), 'GSA') <> nil) then begin
      TeilString := string (strpos (PChar (Zeichen), 'GSA'));
      if (DebugFlag = true) then
        gps.GPGSA.Caption := 'GPGSA';
    end;

    // $GPGSV - sichtbare Satelliten
    if (strpos (PChar (Zeichen), 'GSV') <> nil) then begin
      TeilString := string (strpos (PChar (Zeichen), 'GSV'));
      if (DebugFlag = true) then
        gps.GPGSV.Caption := 'GPGSV';

      // weitere Sat-Daten...
      // Anzahl GPGSV-Zeilen
      Rueckgabe := NaechstesDatum (0);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        Wert := 0;
        if (strlen (PChar (TempString)) > 0) then begin
          try
            Wert := strtoint (TempString);
          except //on E: EConvertError do
            Fehler := true;  // Fehler aufgetreten
          end;
          if (Fehler = true) then begin
            Wert := 0;  // zuruecksetzen
            ExceptionCounter := ExceptionCounter + 1;
          end;
        end;  // strlen
        // anzeigen
        AnzahlGSV := Wert;
        SatDaten.GSVAnzahl.Caption := TempString;
      end;

      // aktuelle GSV-Zeile
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          Wert := 0;
          if (strlen (PChar(TempString)) > 0) then begin
            try
              Wert := strtoint (TempString);
            except //on E: EConvertError do
              Fehler := true;  // Fehler aufgetreten
            end;
            if (Fehler = true) then begin
              Wert := 0;  // zuruecksetzen
              ExceptionCounter := ExceptionCounter + 1;
            end;
          end;
          GSVAktuell := Wert;
        end;
      end;

      // Sat-Anzahl
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          SatDaten.SatAnzahl.Caption := TempString;
          Wert := 0;
          if (strlen (PChar(TempString)) > 0) then begin
            try
              Wert := strtoint (TempString);
            except //on E: EConvertError do
              Fehler := true;  // Fehler aufgetreten
            end;
            if (Fehler = true) then begin
              Wert := 0;  // zuruecksetzen
              ExceptionCounter := ExceptionCounter + 1;
            end;
          end;
          AnzahlSat := Wert;

          // Daten loeschen
          if (AnzahlSat < 12) then begin
            SatDaten.Sat12ID.Caption := '-';
            SatDaten.Sat12Bar.Position := 0;
          end;
          if (AnzahlSat < 11) then begin
            SatDaten.Sat11ID.Caption := '-';
            SatDaten.Sat11Bar.Position := 0;
          end;
          if (AnzahlSat < 10) then begin
            SatDaten.Sat10ID.Caption := '-';
            SatDaten.Sat10Bar.Position := 0;
          end;
          if (AnzahlSat < 9) then begin
            SatDaten.Sat9ID.Caption := '-';
            SatDaten.Sat9Bar.Position := 0;
          end;
          if (AnzahlSat < 8) then begin
            SatDaten.Sat8ID.Caption := '-';
            SatDaten.Sat8Bar.Position := 0;
          end;
          if (AnzahlSat < 7) then begin
            SatDaten.Sat7ID.Caption := '-';
            SatDaten.Sat7Bar.Position := 0;
          end;
          if (AnzahlSat < 6) then begin
            SatDaten.Sat6ID.Caption := '-';
            SatDaten.Sat6Bar.Position := 0;
          end;

        end;
      end;

      // Sat ID
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          if (GSVAktuell = 1) then begin
            SatDaten.Sat1ID.Caption := TempString;
            SatDaten.Sat1Bar.Position := 0;  // zuruecksetzen
          end;
          if (GSVAktuell = 2) then begin
            SatDaten.Sat5ID.Caption := TempString;
            SatDaten.Sat5Bar.Position := 0;
          end;
          if (GSVAktuell = 3) then begin
            SatDaten.Sat9ID.Caption := TempString;
            SatDaten.Sat9Bar.Position := 0;
          end;
        end;
      end;

      //  Elevation & Azimuth ueberspringen, SNR lesen
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then
          Fehler := true;
        if (Fehler = false) then begin
          Rueckgabe := NaechstesDatum (1);
          if (Rueckgabe = 0) then
            Fehler := true;
        end;
        if (Fehler = false) then begin
          Rueckgabe := NaechstesDatum (1);  // SNR
          if (Rueckgabe = 0) then begin
            Fehler := true;
          end else begin
            if (strlen (PChar(TempString)) > 0) then begin
              try
                Wert := strtoint (TempString);
              except //on E: EConvertError do
                Fehler := true;  // Fehler aufgetreten
              end;
              if (Fehler = true) then begin
                Wert := 0;  // zuruecksetzen
                ExceptionCounter := ExceptionCounter + 1;
              end;
            end else begin
              Wert := 0;
            end;
            if (GSVAktuell = 1) then begin
              SatDaten.Sat1Bar.Position := Wert;
            end;
            if (GSVAktuell = 2) then begin
              SatDaten.Sat5Bar.Position := Wert;
            end;
            if (GSVAktuell = 3) then begin
              SatDaten.Sat9Bar.Position := Wert;
            end;
          end;
        end;
      end;

      // Sat ID
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          if (GSVAktuell = 1) then begin
            SatDaten.Sat2ID.Caption := TempString;
            SatDaten.Sat2Bar.Position := 0;
          end;
          if (GSVAktuell = 2) then begin
            SatDaten.Sat6ID.Caption := TempString;
            SatDaten.Sat6Bar.Position := 0;
          end;
          if (GSVAktuell = 3) then begin
            SatDaten.Sat10ID.Caption := TempString;
            SatDaten.Sat10Bar.Position := 0;
          end;
        end;
      end;

      //  Elevation & Azimuth ueberspringen, SNR lesen
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then
          Fehler := true;
        if (Fehler = false) then begin
          Rueckgabe := NaechstesDatum (1);
          if (Rueckgabe = 0) then
            Fehler := true;
        end;
        if (Fehler = false) then begin
          Rueckgabe := NaechstesDatum (1);  // SNR
          if (Rueckgabe = 0) then begin
            Fehler := true;
          end else begin
            if (strlen (PChar(TempString))> 0) then begin
              try
                Wert := strtoint (TempString);
              except //on E: EConvertError do
                Fehler := true;  // Fehler aufgetreten
              end;
              if (Fehler = true) then begin
                Wert := 0;  // zuruecksetzen
                ExceptionCounter := ExceptionCounter + 1;
              end;
            end else begin
              Wert := 0;
            end;
            if (GSVAktuell = 1) then begin
              SatDaten.Sat2Bar.Position := Wert;
            end;
            if (GSVAktuell = 2) then begin
              SatDaten.Sat6Bar.Position := Wert;
            end;
            if (GSVAktuell = 3) then begin
              SatDaten.Sat10Bar.Position := Wert;
            end;
          end;
        end;
      end;

      // Sat ID
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          if (GSVAktuell = 1) then begin
            SatDaten.Sat3ID.Caption := TempString;
            SatDaten.Sat3Bar.Position := 0;
          end;
          if (GSVAktuell = 2) then begin
            SatDaten.Sat7ID.Caption := TempString;
            SatDaten.Sat7Bar.Position := 0;
          end;
          if (GSVAktuell = 3) then begin
            SatDaten.Sat11ID.Caption := TempString;
            SatDaten.Sat11Bar.Position := 0;
          end;
        end;
      end;

      //  Elevation & Azimuth ueberspringen, SNR lesen
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then
          Fehler := true;
        if (Fehler = false) then begin
          Rueckgabe := NaechstesDatum (1);
          if (Rueckgabe = 0) then
            Fehler := true;
        end;
        if (Fehler = false) then begin
          Rueckgabe := NaechstesDatum (1);  // SNR
          if (Rueckgabe = 0) then begin
            Fehler := true;
          end else begin
            if (strlen (PChar(TempString)) > 0) then begin
              try
                Wert := strtoint (TempString);
              except //on E: EConvertError do
                Fehler := true;  // Fehler aufgetreten
              end;
              if (Fehler = true) then begin
                Wert := 0;  // zuruecksetzen
                ExceptionCounter := ExceptionCounter + 1;
              end;
            end else begin
              Wert := 0;
            end;
            if (GSVAktuell = 1) then begin
              SatDaten.Sat3Bar.Position := Wert;
            end;
            if (GSVAktuell = 2) then begin
              SatDaten.Sat7Bar.Position := Wert;
            end;
            if (GSVAktuell = 3) then begin
              SatDaten.Sat11Bar.Position := Wert;
            end;
          end;
        end;
      end;

      // Sat ID
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then begin
          Fehler := true;
        end else begin
          if (GSVAktuell = 1) then begin
            SatDaten.Sat4ID.Caption := TempString;
            SatDaten.Sat4Bar.Position := 0;
          end;
          if (GSVAktuell = 2) then begin
            SatDaten.Sat8ID.Caption := TempString;
            SatDaten.Sat8Bar.Position := 0;
          end;
          if (GSVAktuell = 3) then begin
            SatDaten.Sat12ID.Caption := TempString;
            SatDaten.Sat12Bar.Position := 0;
          end;
        end;
      end;

      //  Elevation & Azimuth ueberspringen, SNR lesen
      if (Fehler = false) then begin
        Rueckgabe := NaechstesDatum (1);
        if (Rueckgabe = 0) then
          Fehler := true;
        if (Fehler = false) then begin
          Rueckgabe := NaechstesDatum (1);
          if (Rueckgabe = 0) then
            Fehler := true;
        end;
        if (Fehler = false) then begin
          Rueckgabe := NaechstesDatum (1);  // SNR
          if (Rueckgabe = 0) then begin
            Fehler := true;
          end else begin
            if (strlen (PChar(TempString)) > 0) then begin
              try
                Wert := strtoint (TempString);
              except //on E: EConvertError do
                Fehler := true;  // Fehler aufgetreten
              end;
              if (Fehler = true) then begin
                Wert := 0;  // zuruecksetzen
                ExceptionCounter := ExceptionCounter + 1;
              end;
            end else begin
              Wert := 0;
            end;
            if (GSVAktuell = 1) then begin
              SatDaten.Sat4Bar.Position := Wert;
            end;
            if (GSVAktuell = 2) then begin
              SatDaten.Sat8Bar.Position := Wert;
            end;
            if (GSVAktuell = 3) then begin
              SatDaten.Sat12Bar.Position := Wert;
            end;
          end;
        end;
      end;
    end; // GPGSV

    // String zurücksetzen
    Zeichen := '';
    if (DebugFlag = true) then
      Zeichen := '-';  // Debugging
  end;  // strscan

  // Exception Zaehler anzeigen
  gps.ECount.Caption := inttostr (ExceptionCounter);
end;

//******************SAT MAT*******************************
procedure SatStart_TForm1Create(Sender: TObject);
VAR sv, sb , s: String;
  os: TOSVERSIONINFO; //Tversioninfo
 today          :  TSystemTime;
   si              : TStartUpInfo;
   pi              : TProcessInformation;
   dwExitCode      : DWORD;
   osVers           : DWORD;
   Startflag        : Boolean;
   TDTVon           : TDateTime;
   iniFile          : TIniFile;
   ininame          : String;

BEGIN
   os.dwOSVersionInfoSize := SizeOf(os);
   GetVersionEx(os);
   osvers := os.dwPlatformId;
   GetSystemTime(today);

   //ZeroMemory(@si,SizeOf(si));
   //ZeroMemory(@pi, SizeOf(pi));
   si.cb := SizeOf(si{TStartUpInfo});
   si.dwFlags := STARTF_USESHOWWINDOW;
   si.wShowWindow := SW_SHOWNORMAL; 

//  CreateProcessAsUser( NIL,'Satreceiver.exe',NIL, NIL, FALSE,0,NIL,NIL, si, pi);

   WaitForInputIdle(GetCurrentProcessId, INFINITE);

   IF pi.hProcess <> 0 THEN BEGIN
      dwExitCode := STILL_ACTIVE;
      WHILE dwExitCode = STILL_ACTIVE DO BEGIN
          WaitForSingleObject(pi.hProcess,10);
         GetExitCodeProcess(pi.hProcess,dwExitCode);

         Startflag := dwExitCode = 123;
         GetDir(0,s);
         s:= getcurrentdir;
         iniName := s + '\SatReceiver.ini';
         IF Startflag then  begin
            iniFile := TIniFile.Create(iniName);
            sv := iniFile.ReadString('Capture','RECORDStart', '');
            sb := iniFile.ReadString('Capture','RECORDStop', '');
            TDTVon := StrToDateTime(sv);
            iniFile.Free;
            //Timer1.Enabled := TRUE;

         end else begin
           // Timer1.Enabled := False;
           // Application.Terminate;
         end; 
      END;
   END;  
 end;



procedure TForm1_Timer1Timer(Sender: TObject);
VAR SysTime: TSystemTime;
    TDT : TdateTime;
    s : String;
   erreicht         : BOOLEAN;
   TDTVon           : TDateTime;
   arelval: TValueRelationship;
  //TValueRelationship','array [-1..1] of byte)'
BEGIN
//7 Result := false;
 Erreicht := False;
 arelval[0]:= 1;
 GetSystemTime (SysTime);
// korrektur
   With SySTime DO begin
    wHour := wHour + 2;
    IF wHour > 24 then begin
       wHour := whour - 24;
       wday := wDay + 1;
       wdayOfWeek := wdayOfWeek + 1;
       IF wdayOfWeek > 7 then
          wdayOfWeek := wdayOfWeek - 7 ;
     end;
       wSecond := 0 ;
   end;
 TDT := SystemTimeToDateTime( SysTime);
 s := dateTimeToStr(TDT);

 arelval:= CompareTime(TDT,TDTVon)
 IF (arelval[0] > 0) then Begin

    //CreateProcessRedir( NIL, 'SatReceiver.exe Aufnahme', NIL, NIL, FALSE,
                   //0,NIL,NIL, si, pi);

  MessageBeep(0);
  Erreicht := TRUE;
  Application.Terminate;   
 end;

end;


// SatDaten anzeigen
procedure SatellitenClick(Sender: TObject);
begin
  //SatDaten.ShowModal;
end;

// Timer Event
procedure Timer1Timer(Sender: TObject);
var
  AusgabeTxt: String;
begin
  // Datei schreiben
  if (SchreibFlag = True) then begin
    AusgabeTxt := gps.Zeit.Caption + ',' + gps.Datum.Caption + ',' + gps.Breite.Caption + ',' + gps.BreiteNS.Caption+ ',' + gps.Laenge.Caption + ',' + gps.LaengeOW.Caption + ',' + gps.Hoehe.Caption + ',' + gps.HoeheM.Caption + ',' + gps.Geschwindigkeit.Caption + ',' + gps.Kurs.Caption + #13 + #10;
    if (SchreibTextFlag = true) then
      TxtDatei.Write (PChar (AusgabeTxt), Length (AusgabeTxt));
  end;
end;

procedure {TGPS.}DiagramClick(Sender: TObject);
begin
  //Diagramm.Show();
end;


  procedure MorseGenerator(atext: string);
  var key,i: byte;
   achar, aget: char;
   asign: string;
  begin
   with TAfComPort.create(NIL) do begin
     //core:= core1; 
     comnumber:= 4;
     BaudRate:= br9600; //br9600;
     Open;
     //autoopen:= true;
     //active:= true;
     ExecuteCOMDialog;
    //aget:= atext[1];
     for it:= 1 to length(atext) do begin
       asign:= getmorsesign(atext[it]);
       if atext[it]=' ' then begin
          sleep(1000)
          continue
       end;  
       writeln(getmorsesign(atext[it]));
       for i:= 1 to length(asign) do begin
          writeChar('1');
          if (asign[i]='-') then begin
            sleep(300)   //500
            MakeSound(500, 250, 60,'')
          end else begin
            sleep(100);
            MakeSound(500, 100, 60,'');
          end;  
         writeChar('A');
         sleep(50)
       end;
     end;   
    {PWM Emulator--------------------}
   {writeString('1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A'+
    '1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A');}
   //writeString('11A11111A11111111A111111111A111111A111111111A');
   try
    writeln('read it: '+readchar)
    writeln(itoa(ord(readchar)))
    writeln(itoa(ord('1')))
   except 
     //((writeChar('A');
    Close;
    FreeOnRelease;
    end;
  Close;
  FreeOnRelease;
  end;
 end;
 
  procedure DirectCOMCallASyncPro;
  var key: byte;
  begin
  with TAfComPort.create(NIL) do begin
    //core:= core1; 
    comnumber:= 4;
    BaudRate:= br9600; //br9600;
    {Parity:= None;
    Databits:= db8;
    Stopbits:= sbone;
    flowcontrol:= fwnone; }
    //checkClose;
    Open;
    //autoopen:= true;
    //active:= true;
    ExecuteCOMDialog;
    //AddStringToLog
     //  OnDataRecived:= @TPortForm1_AfComPort1DataRecieved;
    //writeString('1');
    // writedatastring('1',1);
    //putchar
  {for i:= 0 to 255 do begin
    writeChar(chr(i));
    writeln(chr(i))
    //writeln('read it: '+readchar)
    end;}
    //writeChar(chr(ord(49)));
    //writeChar('1');
    {PWM Emulator--------------------}
   writeString('1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A'+
    '1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A');
   //writeString('111111A111111111A11111111A111111111A111111A111111111A');
   memo2.setfocus;
   it:= 0;
   repeat 
     key:= random(2);
     writeln(itoa(key));
     writeChar('1');
     //sleep(1333)
     inc(it)
     if key = 1 then begin
       //sleep(200)   //500
       MakeSound(550, 150, 60,'');  //350
     end
       else begin //sleep(100);
       MakeSound(550, 60, 60,'');   //150
     end;  
     writeChar('A');
       sleep(10)
     if it mod (random(3)+2) = 0 then begin 
        sleep(180);
       writeln('---simul word end');
     end;    
   until isKeypressed; 
   try
     writeln('read it: '+readchar)
     writeln(itoa(ord(readchar)))
     writeln(itoa(ord('1')))
   except 
     //((writeChar('A');
     Close;
     FreeOnRelease;
   end;
  Close;
  FreeOnRelease;
 end;
    // show a possible cast to core
    //TAfComPortCore(Afcomport1).DirectWrite:= True;
    //OnDataRecived:= @TPortForm1_AfComPort1DataRecieved;
end; 

  

function GetEvenNumbersAmount(const x: array of integer; count,i:integer):integer;
begin
   for i:= 0 to length(X)-1 do 
    if((x[i] <> 0) and (x[i] mod 2=0)) then begin
     inc(count)
     //write(inttostr(X[i-1])+ ' ')  :debug
    end;
   result:=count;
   //i:=i+1;
   //result:=GetOddNumbersAmount(x, count, i);  : recursion
end;


function clockcount(apause: integer): cardinal;
var gtime, cnt: cardinal;
begin
  gtime:= gettickcount;
  cnt:= 0;
  repeat
    inc(cnt)
    //sleep(500) :debug
  until gettickcount = gtime + apause;
  result:= cnt
end;    

function clockcount2(apause: integer): cardinal;
var gtime, cnt: cardinal;
begin
  gtime:= gettickcount;
  cnt:= 0;
  repeat
    inc(cnt)
    //sleep(500) :debug
  until gettickcount - apause > gtime;
  result:= cnt
end;    

  
procedure noteme(Sender: TObject);
begin
  //Diagramm.Show();
  writeln('com done');
end;

procedure SetArrayLength3Integer(arr: array of array of integer; asize1, asize2: integer);
var i,j: integer;
begin
   for i:= 0 to asize1-1 do
    for j:= 0 to asize2-1 do
     SetArrayLength(arr[i][j], asize2-1);
end;    


type mob = procedure; // of object;
  type TFarProc2 = ___Pointer;
  
var i, j: integer;
   serc:  TSerialConfig;
   comlist: TStringlist;
  // var X: array[1..10] of integer;
   var X: array of integer;
   xx: array of array of integer;
   
    amount: integer;
    var mba: array of byte; //TBytearray; //array of byte;
     var buf: byte;
     myobj: TObject;
     myobj2: TFarProc2;
     

begin

  setlength(X,10);
  myobj:= Tobject.create;
  //myobj.size
  //myobj.tag:= 
  myobj.free;
  //setarraylength(X,10);
  //SetArrayLength2integer
  {SetArrayLength(XX,11);
  SetArrayLength2Integer(xx, 10,10);
  
   for i:= 0 to 10 - 1 do         //temp layer
    for j:= 0 to 10 - 1 do 
        xx[i][j]:= random(1000);
  for i:= 0 to 10 - 1 do
    for j:= 0 to 10 - 1 do begin
     write(inttostr(XX[i][j])+ #9);
        if j= 10-1 then
        writeln('');
    end;}  
      
 
  //allocates an array of 10 integers, indexed 0 to 9.
  //Dynamic arrays are always integer-indexed, always starting from 0. 
  for it:=0 to 9 do begin
    X[it]:= random(100);
    write(inttostr(X[it])+ ' ')
  end;
  writeln('');
  amount:= GetEvenNumbersAmount(X, 0, 1);
  writeln('Amount of even numbers: '+inttostr(amount));
  
  //with TTComPort.create(self) do begin
    //baudrate
    //Free;
  //end;
 
  with TComPortInterface.create do begin
    if iscomport then
      connect;
    baudrate:= 9600;
    parity:= parNone;
    rescanPorts;
    //connect;
    //writeln(ComPorts[1].getitem)
    writeln('comport found at nr: '+itoa(ComPorts[0].nr));
    //writebyte(49)
    writebyte(ord('1'))
    sleep(1000)
    //writebyte(65)
    writebyte(ord('A'))
    ReadByte(buf)
    writeln('buf back: '+inttostr(buf))
    ReadByte(buf)
    writeln('buf back: '+inttostr(buf))
    disconnect;
    free
    //writeln(getascii)
  
  end;
  
  for it:= 1 to 64 do 
    if isCOM(it) then printF('COM avail: at %d ',[it]);
  
    //type TFNTimerProc = TFarProc;
    //type TFarProc = Pointer;
  //SetTimer(hWnd : HWND; nIDEvent, uElapse: UINT; lpTimerFunc: TFNTimerProc):UINT;
     // settimer(hinstance,0,500, myobj);
      if KillTimer(hinstance,123) then
         writeln('timer gone');
  
 (*  for i:= 1 to 64 do
    if IsCOM(i) then
      writeln('COM: ' + IntToStr(i)+ ' available'); 
  
    with TCommanager.create do begin
       comlist:= ports;
       for i:= 0 to comlist.count-1 do 
         writeln('ports '+comlist[i]);
       comlist.Free;  
       Free
    end;   
   
    with TCommanager.create do begin
       //comlist:= ports;
       for i:= 0 to ports.count-1 do 
         writeln('ports '+ports[i]);
       ports.Free;  
       Free
    end;   
    
    with  TSerial.create(self) do begin
       COMPort:= 4;
       OpenComm;
       //getconfig;
       SendSerialText('1');
       //TransmittData(mba[1],10);
       //bufrec:= 10;
       setlength(mba,10);
       mba[0]:= 123;
       //SendSerialData(TByteArray(mba), length(mba));
       delay(3000)
       SendSerialText('A');
       CloseComm
       Free;
     end;       
       
  gps.seriell:= TSerial.create(self);
       gps.Seriell.COMPort:= 4;
       gps.Seriell.Baudrate:= 9600;
       gps.Seriell.oneventchar:= @noteme;
       //gps.Seriell.getconfig;
       if gps.Seriell.OpenComm then 
         writeln('com open now');
        //break;
      //end;
      //gps.Seriell.SendSerialText('1');
       //gps.Seriell.getconfig;
       //serc:= TSerialConfig.create(self)
       writeln('config: '+ gps.Seriell.ConfigToStr(serc))
       writeln('config: '+ botostr(serc.valid))
       writeln('config: '+ inttostr(serc.comport))
      
      //gps.Seriell.SendSerialText('1111111111A1111111111111A11111111111');
      writeln('send '+inttostr(gps.Seriell.SendSerialText('111')));
      
      //if gps.Seriell.ReceiveSerialText <> '' then
      {repeat 
        gps.Seriell.ReceiveSerialText
      until gps.Seriell.ReceiveSerialText <> '';}  
        writeln('get back first: '+gps.Seriell.ReceiveSerialText);
      
      //if gps.Seriell.syncwait then
        //writeln('get back second: '+gps.Seriell.ReceiveSerialText);
      delay(2500)
      gps.Seriell.SendSerialText('A');
      writeln('get back: '+gps.Seriell.ReceiveSerialText);
      delay(500)
      writeln('get back: '+gps.Seriell.ReceiveSerialText);
      //writeln(gps.Seriell.ReceiveText()); 
  
     gps.Seriell.CloseComm
     gps.Seriell.Free;     
    //end;
  //end;       *)
  
    
    writeln('clockcount sec: '+inttostr(clockcount(1000)));
    //writeln('clockcount sec: '+inttostr(clockcount(1000)));
    writeln('clockcount sec: '+inttostr(clockcount2(1000)));
 
    {repeat 
      makesound(500,5000,40,'')
    until iskeypressed;
    memo2.setFocus; } 
      
  // Schnittstelle mit default Werten oeffnen
  //Rueckgabe := gps.Seriell.OpenComm;
   //MorseGenerator(uppercase('max box'))
   //MorseGenerator(uppercase('bern gruesst bonn zu den delphi tagen'))
   DirectCOMCallASyncPro;   
 
end.

//this is 

(*procedure SIRegister_TSerial(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSerial', 'TSerial') do
  with CL.AddClassN(CL.FindClass('TCustomSerial'),'TSerial') do begin
    RegisterProperty('TransmittData', 'TTData', iptrw);
    RegisterProperty('ReceiveData', 'TRData', iptrw);
    RegisterProperty('TransmittText', 'TTText', iptrw);
    RegisterProperty('ReceiveText', 'TRText', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free');
    RegisterMethod('Function OpenComm : boolean');
    RegisterMethod('Procedure CloseComm');
RegisterMethod('Function Purge(TxAbort,RxAbort,TxClear,RxClear:boolean):boolean');
    RegisterMethod('Procedure SetConfig( SerialConfig : TSerialConfig)');
    RegisterMethod('Function GetConfig : TSerialConfig');
    RegisterMethod('Function ConfigToStr( SerialConfig : TSerialConfig) : string');
    RegisterMethod('Function StrToConfig( CfgStr : string) : TSerialConfig');
RegisterMethod('Function SendSerialData(Data: TByteArray; DataSize: cardinal): cardinal');
RegisterMethod('Function ReceiveSerialData(var Data: TByteArray; DataSize:cardinal): cardinal');
    RegisterMethod('Function SendSerialText(Data: String): cardinal');
    RegisterMethod('Function ReceiveSerialText: string');
    RegisterProperty('BufTrm', 'integer', iptr);
    RegisterProperty('BufRec', 'integer', iptr);
    RegisterProperty('CanTransmitt', 'boolean', iptr);
    RegisterProperty('Active', 'boolean', iptrw);
    RegisterProperty('Baudrate', 'integer', iptrw);
    RegisterProperty('DataBits', 'TDataBits', iptrw);
    RegisterProperty('ParityBit', 'TParityBit', iptrw);
    RegisterProperty('StopBits', 'TStopBits', iptrw);
    RegisterProperty('BufSizeTrm', 'integer', iptrw);
    RegisterProperty('BufSizeRec', 'integer', iptrw);
    RegisterProperty('HandshakeRtsCts', 'boolean', iptrw);
    RegisterProperty('HandshakeDtrDsr', 'boolean', iptrw);
    RegisterProperty('HandshakeXOnXOff', 'boolean', iptrw);
    RegisterProperty('RTSActive', 'boolean', iptrw);
    RegisterProperty('DTRActive', 'boolean', iptrw);
    RegisterProperty('XOnChar', 'char', iptrw);
    RegisterProperty('XOffChar', 'char', iptrw);
    RegisterProperty('XOffLimit', 'integer', iptrw);
    RegisterProperty('XOnLimit', 'integer', iptrw);
    RegisterProperty('ErrorChar', 'char', iptrw);
    RegisterProperty('EofChar', 'char', iptrw);
    RegisterProperty('EventChar', 'char', iptrw);
    RegisterProperty('DataSize', 'integer', iptrw);
    RegisterProperty('ParityCheck', 'boolean', iptr);
    RegisterProperty('ContinueOnXOff', 'boolean', iptrw);
    RegisterProperty('UseErrorChar', 'boolean', iptrw);
    RegisterProperty('EliminateNullChar', 'boolean', iptrw);
    RegisterProperty('AbortOnError', 'boolean', iptrw);
    RegisterProperty('RecTimeOut', 'integer', iptrw);
    RegisterProperty('TrmTimeOut', 'integer', iptrw);
    RegisterProperty('SyncEventHandling', 'boolean', iptrw);
    RegisterProperty('EnableEvents', 'boolean', iptrw);
    RegisterProperty('SyncWait', 'boolean', iptrw);
    RegisterProperty('OnBreak', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCts', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDsr', 'TNotifyEvent', iptrw);
    RegisterProperty('OnError', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRing', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDcd', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRxChar', 'TNotifyEvent', iptrw);
    RegisterProperty('OnEventChar', 'TNotifyEvent', iptrw);
    RegisterProperty('OnTxEmpty', 'TNotifyEvent', iptrw);
    RegisterProperty('OnData', 'TNotifyEvent', iptrw);
  end;
end;

procedure SIRegister_TCOMManager(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TCOMManager') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TCOMManager') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure CheckPorts( ToPort : integer)');
    RegisterMethod('Function RecheckPorts : boolean');
    RegisterMethod('Function PortExists( Port : integer) : boolean');
    RegisterMethod('Function Port2Index( Port : integer) : integer');
    RegisterMethod('Procedure RegisterFeedback( Proc : TFeedbackProc)');
    RegisterMethod('Procedure UnregisterFeedback( Proc : TFeedbackProc)');
    RegisterMethod('Procedure AssignCOM( Instance : TCustomSerial)');
    RegisterProperty('CheckedPorts', 'integer', iptr);
    RegisterProperty('Ports', 'TStringList', iptr);
    RegisterProperty('OnPortAdded', 'TNotifyEvent', iptrw);
    RegisterProperty('OnPortRemoved', 'TNotifyEvent', iptrw);
  end;
end;

CL.AddTypeS('TSerialConfig', 'record Valid : boolean; COMPort : integer; Baud'
   +'rate : integer; DataBits : TDataBits; ParityBit : TParityBit; StopBits : T'
   +'StopBits; BufSizeTrm : integer; BufSizeRec : integer; HandshakeRtsCts : bo'
   +'olean; HandshakeDtrDsr : boolean; HandshakeXOnXOff : boolean; RTSActive : '
   +'boolean; DTRActive : boolean; XOnChar : char; XOffChar : char; XOffLimit :'
   +' integer; XOnLimit : integer; ErrorChar : char; EofChar : char; EventChar '
   +': char; ContinueOnXOff : boolean; UseErrorChar : boolean; EliminateNullChar'
   +' : boolean; AbortOnError : boolean; RecTimeOut : integer; TrmTimeOut : in'
   +'teger; end');
  



  CL.AddTypeS('TRText', 'Function  : string');
  CL.AddTypeS('TTData', 'Function ( var Data, DataSize : integer) : integer');
  CL.AddTypeS('TRData', 'Function ( var Buf, BufSize : integer) : integer');
  CL.AddTypeS('TTText', 'Function ( s : string) : integer');
 
 
 A Global Positioning System (GPS) is a space-based satellite navigation system that provides location and time information in all weather conditions,
but how does it work?     

/*
  Blink2
  Turns on an LED on for one second, then off for one second, repeatedly.
  This example code is in the mX public domain. locs=60
 */
 
// Pin 13 has an LED connected on most Arduino boards.
// give it a name:
int ledR = 11;
int led = 13;
int val = 0;
bool gorun = false;

// setup routine runs once when you press reset:
void setup() {                
  // initialize the digital pin as an output.
  pinMode(led, OUTPUT); 
  pinMode(ledR, OUTPUT); 
  Serial.begin(9600); // connect to serial port  
}

// the loop routine runs over and over again:
void loop() {
  val = Serial.read();
  //Serial.print(val, HEX); show time stream
  //Serial.write(val);
 
  if (val !=-1){ 
   
    if (val == '9')  
     gorun = true;
     else gorun = false;
 
    if (val=='1'){
      digitalWrite(ledR,HIGH);
       //delay(1000);               // wait a sec
      }
    if (val=='A'){
      digitalWrite(ledR,LOW);
      }
    
    if (val=='3'){
      digitalWrite(led,HIGH);
       delay(1000);               // wait for a second
      digitalWrite(led,LOW);
       delay(1000);               // wait for a second
      }
    if (val=='C'){
      digitalWrite(led,LOW);
      }
    Serial.write(val);            // read back to monitor
  }
  
   if (gorun == true) {
   digitalWrite(ledR, HIGH);   // turn LED on (HIGH is the voltage level)
   delay(500);                 // wait for a second
   digitalWrite(ledR, LOW);    // turn LED off by making the voltage LOW
   delay(500);                 // wait for a second
  } 
}

Problem signature:
  Problem Event Name:	APPCRASH
  Application Name:	maxbox3.exe
  Application Version:	3.9.9.98
  Application Timestamp:	53edf00b
  Fault Module Name:	libeay32.dll_unloaded
  Fault Module Version:	0.0.0.0
  Fault Module Timestamp:	4f912775
  Exception Code:	c0000005
  Exception Offset:	1000f6f0
  OS Version:	6.1.7600.2.0.0.768.3
  Locale ID:	2055
  Additional Information 1:	0a9e
  Additional Information 2:	0a9e372d3b4ad19135b953a78882e789
  Additional Information 3:	0a9e
  Additional Information 4:	0a9e372d3b4ad19135b953a78882e789

Read our privacy statement online:
  http://go.microsoft.com/fwlink/?linkid=104288&clcid=0x0409

If the online privacy statement is not available, please read our privacy statement offline:
  C:\Windows\system32\en-US\erofflps.txt

 *)

 (*TTimer = class(TComponent)
 private
   FInterval: Cardinal;
   FWindowHandle: HWND;
   FOnTimer: TNotifyEvent;
   FEnabled: Boolean;
   procedure UpdateTimer;
   procedure SetEnabled(Value: Boolean);
   procedure SetInterval(Value: Cardinal);
   procedure SetOnTimer(Value: TNotifyEvent);
   procedure WndProc(var Msg: TMessage);
 protected
   procedure Timer; dynamic;
 public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
 published
   property Enabled: Boolean read FEnabled write SetEnabled default True;
   property Interval: Cardinal read FInterval write SetInterval default 1000;
   property OnTimer: TNotifyEvent read FOnTimer write SetOnTimer;
 end; *)
 
 
{Mikrocontroller für Einsteiger (5)

Veröffentlicht in Heft 9/2014 auf Seite 62

Eines der größten Kapitel im Datenblatt des ATmega328 behandelt die drei Timer des Controllers. Ihre Anwendungen sind so vielfältig, das hier nur ein kleiner Teil der Möglichkeiten vorgestellt werden kann. Die wesentlichen Aufgabenfelder heißen Zeitmessung, Frequenzmessung, Signalerzeugung und PWM-Ausgabe.

Der Download des Artikels ist den Abo-Mitgliedern von Elektor vorbehalten. Infos zur Abo-Mitgliedschaft finden Sie unter www.elektor.de/mitgliedschaft.

    Software: 140049-11.zip

http://novafile.com/daycdq4gez4v }