(************************************************************************)
(*                                                                      *)
(*       Präzisionszeitmessung für Windows (32 Bit)                     *)
(*                                                                      *)
(*   (c) 1996-2006 Rainer Reusch & Toolbox                              *)
(*                                                                      *)
(*   Borland Delphi ab 5.0                                              *)
(*                                                                      *)
(****V2.1****************************************************************)

{
Diese Unit stellt Routinen zur Verfügung, um Laufzeitmessungen und
zeitlich gesteuerte Abläufe im Mikrosekundenbereich durchzuführen.
Beachten Sie, daß alle Routinen Eigenzeiten haben, die hier naturgemäß
nicht kompensiert werden können. Beispielsweise sind Verzögerungen
mit PrecDelay nie kürzer als ihre Eigenzeit.

Änderungen in V2.0:
- nur 32 Bit, für Delphi ab V5

Änderungen in V2.1:
- Statt von einer festen Systemfrequenz auszugehen, wird diese nun ermittelt (k).
- Kleine Optimierungen in PrecDelay
- GetDelayMinTime nun öffentlich zugänglich

change to V2.2
  add information to clock stat, Max
}

unit Prectime;

interface

//uses
  //Windows;

procedure PrecCount(var t : int64);
{ Erfassen des Zählerstandes }

function DeltaPrecCount(var t1, t2 : int64) : longint;
{ Liefert die Differenz t2-t1 aus zwei Zählerständen
  Hinweis: Das Funktionsergebnis ist "nur" 32 Bit breit }

function DeltaPrecTime(var t1, t2 : int64) : longint;
{ Liefert die Differenz t2-t1 aus zwei Zählerständen
  als Ergebnis in Mikrosekunden
  Hinweis: Das Funktionsergebnis ist "nur" 32 Bit breit }

procedure PrecDelay(MicroSeconds : longint);
{ Verzögerungsroutine
  mit einer Auflösung in Mikrosekunden
  MicroSeconds darf nicht größer als 1799798562
  (eine knappe halbe Stunde) sein!
  Weiterhin kann sie Zeitangaben unterhalb DelayMinTime nicht umsetzen
  (Verzögerungszeit ist mind. DelayMinTime) }

procedure GetDelayMinTime;
{ Ermittlung der Eigenzeit der PrecDelay-Routine aus 16 Delay-Durchläufen
  (wird automatisch ausgeführt) }

var
  DelayMinTime : longint;   { Nur lesen! Eigenzeit der Delay-Routine
                              in Mikrosekunden. Verzögerungen der PrecDelay-
                              Routine unterhalb dieses Wertes sind nicht
                              möglich. Wert ist rechnerabhängig. }

implementation

var
  k : int64;  // Quarzfrequenz des Timers (1193180Hz)

procedure PrecCount(var t : int64);
begin
  QueryPerformanceCounter(t);
end;

function DeltaPrecCount(var t1, t2 : int64) : longint;
begin
  result:= t2-t1;
end;

function DeltaPrecTime(var t1, t2 : int64) : longint;
var
  D : extended;
begin
  D:=t2-t1;
  result:= round(1000000*D/k);
end;

procedure PrecDelay(MicroSeconds : longint);
var
  n, t1, t2 : int64;
begin
  if MicroSeconds>DelayMinTime then MicroSeconds:=MicroSeconds-DelayMinTime
                               else MicroSeconds:=0;
  if MicroSeconds>0 then begin
    n:=round((k/1000000)*MicroSeconds);
    PrecCount(t1);
    repeat
      PrecCount(t2);
    until (t2-t1)>=n;
  end;
end;

procedure GetDelayMinTime;
{ Ermittlung der Eigenzeit der PrecDelay-Routine aus 16 Delay-Durchläufen }
var
  i : word;
  t : longint;
  TP1, TP2 : int64;
begin
  DelayMinTime:=0;
  PrecDelay(2);
  t:=0;
  for i:=0 to 15 do begin
    PrecCount(TP1);
    PrecDelay(2);
    PrecCount(TP2);
    t:=t+DeltaPrecTime(TP1,TP2);
  end;
  DelayMinTime:=(t div 16)-2;
end;

  //var xs: TApplicationState

begin
  //1545180973609
  precCount(k)
  writeln('prec count: '+inttostr64(k));
  k:= 0;
  QueryPerformanceFrequency(k);
  //974150
  writeln('prec freq: '+inttostr64(k));
  GetDelayMinTime;
  writeln('own time: '+inttostr(DelayMinTime))
end.

{begin
end.
doc:

 Well it returns the number of ticks on the high resolution system clock, which I think is hardware dependant, and that's why you need to use QueryPerformanceFrequency to figure out the frequency of that clock. On my system the frequency is 2,272,000 hz, or about 2.272 ticks per microsecond. –  Ramónster Nov 15 '09 at 23:35 

 Not related to CPU frequency in general
The high frequency counter need not be tied to the CPU frequency at all. It will only resemble the CPU frequency is the system actually uses the TSC (TimeStampCounter) underneath. As the TSC is generally unreliable on multi-core systems it tends not to be used. When the TSC is not used the ACPI Power Management Timer (pmtimer) may be used. You can tell if your system uses the ACPI PMT by checking if QueryPerformanceFrequency returns the signature value of 3,579,545 (ie 3.57MHz). If you see a value around 1.19Mhz then your system is using the old 8245 PIT chip. Otherwise you should see a value approximately that of your CPU frequency (modulo any speed throttling or power-management that might be in effect.) 
 
ref :

http://www.numberempire.com/974150
}