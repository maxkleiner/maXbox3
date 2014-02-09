program HaeusleBauen;
uses Crt, Graph;

const  Haus : array[1..10] of record                { Rohdaten }
                x,y,z : Integer;
                end =
               ((x:-55; y:-120; z: -75), (x:-55; y:-120; z:  0),
                (x:  0; y:-120; z: 75), (x: 55; y:-120; z:  0),
                (x: 55; y:-120; z:-75), (x: 55; y: 120; z:-75),
                (x: 55; y: 120; z:  0), (x:  0; y:120; z: 75),
                (x:-55; y: 120; z:  0), (x:-55; y: 120; z:-75));

       Folge : array[1..20] of Byte =             { Punktfolge }
               (5,1,2,3,4,5,6,7,8,9,10,6,7,4,3,8,9,2,1,10);

       Alpha   : Integer = 45;    { Drehwinkel mit Startwerten }
       Beta    : Integer = -105;
       Groesse : Real  = 1.5;       { Hausgrî·e }

type point=record
     x,y: integer;
     end;

var    Haus3D : array[1..10] of point;
       Treiber, Modus : Integer;            { fÅr Initgraph }
       Mx, My         : Integer;            { Hausmitte }
       Taste          : Char;               { fÅr Readkey }
       a:real;

procedure Projektion(Alpha, Beta,             { Drehwinkel }
                     Mx, My      : Integer;   { Mittelpunkt }
                     Groesse : Real);         { Vergrî·erung }

var  SinA, SinB, CosA, CosB : Real;     { Zwischenvariablen }
     Lauf : Integer;

begin { Projektion }
  SinA := Sin(Alpha/180*Pi);          { Bogenmassberechnungen au·erhalb }
  SinB := Sin(Beta/180*Pi);                 { der Schleife, um }
  CosA := Cos(Alpha/180*Pi);            { Rechenzeit zu sparen }
  CosB := Cos(Beta/180*Pi);
  for Lauf := 1 to 10 do                        { Umrechnungen }
    with Haus[Lauf] do
      begin { with }
      Haus3D[Lauf].x := Round((x*CosA - y*SinA)*Groesse) + Mx;
      Haus3D[Lauf].y := Round(((x*SinA + y*CosA)*CosB
                                + z*SinB)*Groesse) + My;
      end; { with }
  MoveTo(Haus3D[Folge[1]].x, Haus3D[Folge[1]].y);
  for Lauf := 2 to 20 do                 { Zeichne Hausansicht }
    with Haus3D[Folge[Lauf]] do
      LineTo(x,y);
end; { Projektion }

PROCEDURE Beschriften ;
  BEGIN
    SETTEXTSTYLE (0, 0, 2);
    OUTTEXTXY (5, 15, '       Space Race with MEGAMAX');
    settextstyle(0,0,1);
    SETTEXTSTYLE (0, 0, 1);
    SETTEXTJUSTIFY (CenterText, BottomText);
    OUTTEXTXY (GetMaxX DIV 2, GetMaxY-10, 'Virtual Reality is an Inanity '#3' Kleiner Max');
  END;



begin { Hauptprogramm }
  Treiber := Detect;
  InitGraph(Treiber, Modus, 'tur/bgi');
  Mx := GetMaxX div 2;                   { Hausmitte berechnen }
  My := GetMaxY div 2;
  repeat
  beschriften;
    Projektion(Alpha,Beta,Mx,My,Groesse);      { Haus zeichnen }
    Taste := Readkey;
    a:=1.05;
    case Taste of
     '+' : Groesse := Groesse * 1.05;                 { grî·er }
     '-' : groesse:=groesse/1.05;
     'z': begin
           repeat
           Groesse := Groesse / a;
           Projektion(Alpha,Beta,Mx,My,Groesse);     
                a:=a+0.1;
                until keypressed;
                groesse:=1.5;
           end;
     'l' :  Dec(Mx, 10);                           { nach links }
     'r' : Inc(Mx, 10);                          { nach rechts }
     'u' : Inc(My, 10);                           { nach unten }
     'o' : Dec(My, 10);                            { nach oben }
     #0  : case Readkey of
            #72 : Inc(Beta, 5);            { drehen um x-Achse }
            #80 : Dec(Beta, 5);
            #77 : Inc(Alpha, 5);           { drehen um z-Achse }
            #75 : Dec(Alpha, 5);
            end; { case }
     end; { case }
    ClearDevice;
  until Taste = #27;
  CloseGraph;
end. { Hauptprogramm }
