//
// (C) 2006, Toolbox-Verlag und Wolfgang Soltendick, alle Rechte vorbehalten
//

unit Kursberechnung;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, Math, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Breite1: TLabel;
    Breite2: TLabel;
    Breite1h: TEdit;
    Breite1m: TEdit;
    Breite1s: TEdit;
    Beenden: TButton;
    km: TLabel;
    Grad1: TLabel;
    Grad2: TLabel;
    Laenge2h: TEdit;
    Laenge2m: TEdit;
    Laenge2s: TEdit;
    Breite2h: TEdit;
    Breite2m: TEdit;
    Breite2s: TEdit;
    Laenge1s: TEdit;
    Laenge1m: TEdit;
    Laenge1h: TEdit;
    Kurs: TButton;
    Entfernung: TButton;
    EntfernungText: TLabel;
    Kurs1Text: TLabel;
    Kurs2Text: TLabel;
    Laenge2: TLabel;
    Laenge1: TLabel;
    Position2: TLabel;
    Position1: TLabel;
    procedure BeendenClick(Sender: TObject);
    procedure EntfernungClick(Sender: TObject);
    procedure KursClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

{ TForm1 }

function EntfernungsBerechnung : double;
var
  Phi1:    double;   // Breite
  Phi2:    double;
  Lambda1: double;   // Laenge
  Lambda2: double;
  Wert:    integer;  // ausgelesener Wert
  Fehler:  integer;
begin
  // Werte auslesen
  // Laengen
  val (Form1.Laenge1h.Text, Wert, Fehler);
  Lambda1 := Wert;
  val (Form1.Laenge1m.Text, Wert, Fehler);
  Lambda1 := Lambda1 + Wert / 60;
  val (Form1.Laenge1s.Text, Wert, Fehler);
  Lambda1 := Lambda1 + Wert / 3600;
  val (Form1.Laenge2h.Text, Wert, Fehler);
  Lambda2 := Wert;
  val (Form1.Laenge2m.Text, Wert, Fehler);
  Lambda2 := Lambda2 + Wert / 60;
  val (Form1.Laenge2s.Text, Wert, Fehler);
  Lambda2 := Lambda2 + Wert / 3600;

  // Breiten
  val (Form1.Breite1h.Text, Wert, Fehler);
  Phi1 := Wert;
  val (Form1.Breite1m.Text, Wert, Fehler);
  Phi1 := Phi1 + Wert / 60;
  val (Form1.Breite1s.Text, Wert, Fehler);
  Phi1 := Phi1 + Wert / 3600;
  val (Form1.Breite2h.Text, Wert, Fehler);
  Phi2 := Wert;
  val (Form1.Breite2m.Text, Wert, Fehler);
  Phi2 := Phi2 + Wert / 60;
  val (Form1.Breite2s.Text, Wert, Fehler);
  Phi2 := Phi2 + Wert / 3600;

  // Umrechnung in Bogenmass
  Lambda1 := Lambda1 * Pi / 180;
  Lambda2 := Lambda2 * Pi / 180;
  Phi1 := Phi1 * Pi / 180;
  Phi2 := Phi2 * Pi / 180;

  // Berechnung
  EntfernungsBerechnung := 60*1.852/Pi*180*arccos((sin(Phi1)*sin(Phi2))+(cos(Phi1)*cos(Phi2)*cos(Lambda1-Lambda2)));

end;


procedure TForm1.EntfernungClick(Sender: TObject);
var
  Temp:  double;
begin
  // Enfernungsberechnung und Ausgabe
  Temp := EntfernungsBerechnung();
  Temp := Temp * 1000;
  Temp := int (Temp);
  Temp := Temp / 1000;
  EntfernungText.Caption := floattostr (Temp);
end;

procedure TForm1.BeendenClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.KursClick(Sender: TObject);
var
  EntfernungsAngabe: double;  // Entfernung
  Winkel:            double;  // berechneter Winkel
  Temp: double;
  Phi1:    double;   // Breite
  Phi2:    double;
  Lambda1: double;   // Laenge
  Lambda2: double;
  Wert:    integer;  // ausgelesener Wert
  Fehler:  integer;
begin
  // Entfernungsberechnung
  // Werte auslesen
  // Laengen
  val (Form1.Laenge1h.Text, Wert, Fehler);
  Lambda1 := Wert;
  val (Form1.Laenge1m.Text, Wert, Fehler);
  Lambda1 := Lambda1 + Wert / 60;
  val (Form1.Laenge1s.Text, Wert, Fehler);
  Lambda1 := Lambda1 + Wert / 3600;
  val (Form1.Laenge2h.Text, Wert, Fehler);
  Lambda2 := Wert;
  val (Form1.Laenge2m.Text, Wert, Fehler);
  Lambda2 := Lambda2 + Wert / 60;
  val (Form1.Laenge2s.Text, Wert, Fehler);
  Lambda2 := Lambda2 + Wert / 3600;

  // Breiten
  val (Form1.Breite1h.Text, Wert, Fehler);
  Phi1 := Wert;
  val (Form1.Breite1m.Text, Wert, Fehler);
  Phi1 := Phi1 + Wert / 60;
  val (Form1.Breite1s.Text, Wert, Fehler);
  Phi1 := Phi1 + Wert / 3600;
  val (Form1.Breite2h.Text, Wert, Fehler);
  Phi2 := Wert;
  val (Form1.Breite2m.Text, Wert, Fehler);
  Phi2 := Phi2 + Wert / 60;
  val (Form1.Breite2s.Text, Wert, Fehler);
  Phi2 := Phi2 + Wert / 3600;

  // Umrechnung in Bogenmass
  Lambda1 := Lambda1 * Pi / 180;
  Lambda2 := Lambda2 * Pi / 180;
  Phi1 := Phi1 * Pi / 180;
  Phi2 := Phi2 * Pi / 180;

  // Berechnung
  EntfernungsAngabe := arccos((sin(Phi1)*sin(Phi2))+(cos(Phi1)*cos(Phi2)*cos(Lambda1-Lambda2)));

  // Winkel
  Winkel := arcsin((sin(Lambda1-Lambda2)*cos(Phi2))/sin (EntfernungsAngabe))*180/Pi;

  // Runden und Ausgabe
  Temp := Winkel * 1000.0;
  Temp := int (Temp);
  Temp := Temp / 1000;
  Kurs1Text.Caption := floattostr (Temp);

  // Korrektur
  if (Phi1 < Phi2) then begin
    if (Winkel < 0) then begin
      Winkel := Winkel + 360;
    end;
  end else begin
    if (Winkel > 0) then begin
      Winkel := 180 - Winkel;
    end else begin
      Winkel := 180 + Winkel;
    end;
  end;

  // Runden und Ausgabe
  Temp := Winkel * 1000.0;
  Temp := int (Temp);
  Temp := Temp / 1000;
  Kurs2Text.Caption := floattostr (Temp);
end;

initialization
  {$I kursberechnung.lrs}

end.

