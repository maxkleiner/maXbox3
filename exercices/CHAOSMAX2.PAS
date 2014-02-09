program Chaos;
{$N+}

uses
       Dos, Crt, Graph, Maus,
       {Cursor1, Zeit1,}                             {eigne units}
       drivers, fonts; {Bgidriv, Bgifont;}

       (* Zeichensaetze und Grafiktreiber werden in Objektcode genommen *)

const
      ccc=   1;                                     {sound}
      dd=   3;
      ee=   5;
      ff=   6;
      gg=   8;
      aa=  10;
      bb=  11;
      hh=  12;
var
  graphdriver : integer;  { the graphics device driver }
  graphmode   : integer;  { the graphics mode value }
  maxy        : extended; { the maximum resolution of the screen }
  errorcode   : integer;  { reports any graphics errors }
  maxcolor    : word;     { the maximum color value available }
  ch,esc      : char;
  chs         : char;
  a,b,x,y,h,t,xa,ya,xs,ys,ys2,dx,dy,dely             : extended;
  count,xi,yi,uu1,xsc,ysc,vv1,ui,vi,xx1,yy1,t1,t2    : integer;
  rad,cc,menu,xm,ym,i,j,v1,v2,x1,y1,x2,y2,heit,xw,yw : integer;
  circ                                : pointer;
  status, nobuttons, bs, horiz, vert  : integer;
  gname,s,ss,st                       : string;
  df          : text;
  datin       : file of byte;
  byt         : byte;
  col         : word;
  regset      : registers;
 { C           : Cursor;}
  sss,z       : Integer;
    Pi2       : real;
    xr, yr    : real;
  xxx,yyy,k   : integer;
    Amplitude : real;
    yNull     : real;                   (* Bildschirmmitte *)
    xBreite   : integer;                (* Pixelbreite von 1 x auf Schirm *)
    yBreite   : integer;


{type
     WeltZeit = object(zeit)
              CityName: String[16];
          TOffset: Integer;
            Zeile: Integer;
           Spalte: Integer;
        procedure  SetCityTime(NewCityName:String;
                               NewTOffset,NewSpalte,NewZeile:Integer);
        procedure  ShowCityTime;
     end;}




procedure initialize;
begin
  directvideo := false;
  clrscr;
  graphdriver := detect;                             { use autodetection }
  initgraph(graphdriver, graphmode, 'bp\bgi');      { activate graphics }
  errorcode := graphresult;                          { error? }
  if errorcode <> grok then
  begin
    writeln('graphics error: ', grapherrormsg(errorcode));
    halt(1);
  end;
  maxcolor := getmaxcolor;  { get the maximum allowable drawing color }
  maxy := getmaxy/399;      { get screen resolution values }
  xw   := 8;  yw := round(16*maxy);
end;                                             { initialize }

PROCEDURE Registrieren;
  PROCEDURE Abort(message : string); {Unterprozedur}
    BEGIN
      writeln ('Treiber ', message, ' falsch geladen!');
    END;

  BEGIN {PROCEDURE Registrieren}
    { "Registrierung" aller ZeichensÑtze (aus FONTS.TPU) }
    IF RegisterBGIfont(@GothicFontProc) < 0
      THEN Abort('Gothic');
    IF RegisterBGIfont(@SansSerifFontProc) < 0
      THEN Abort('SansSerif');
    IF RegisterBGIfont(@SmallFontProc) < 0
      THEN Abort('Small');
    IF RegisterBGIfont(@TriplexFontProc) < 0
      THEN Abort('Triplex');

    { "Registrierung" aller Grafik-Treiber (aus DRIVERS.TPU)}
    IF RegisterBGIdriver(@CGADriverProc) < 0
      THEN Abort('CGA');
    IF RegisterBGIdriver(@EGAVGADriverProc) < 0
      THEN Abort('EGA/VGA');
    IF RegisterBGIdriver(@ATTDriverProc) < 0
      THEN Abort('AT&T');
    IF RegisterBGIdriver(@PC3270DriverProc) < 0
      THEN Abort('PC 3270');
    IF RegisterBGIDriver(@HercDriverProc) < 0
      THEN Abort('Herkules');
      END; {PROCEDURE Registrieren}



procedure cirgen;         {generate circle as sprite}
const
  startx = 100;
  starty = 50;
var
  ulx, uly, lrx, lry ,size : word;
begin
  rad:=4;
  cleardevice;
  setcolor(lightred);
  circle(startx, starty, rad);
  setfillstyle(solidfill,lightred);
  floodfill(startx,starty,lightred);
  ulx := startx-rad-1;
  uly := starty-rad-1;
  lrx := startx+rad+1;
  lry := starty+rad+1;
  size:= imagesize(ulx, uly, lrx, lry);
  getmem(circ, size);
  getimage(ulx, uly, lrx, lry, circ^);
  putimage(ulx, uly, circ^, xorput);               { erase image }
end;


procedure drawcross(m,n:integer);
begin
  setlinestyle(solidln,0,thickwidth);
  line(m-4,n,m+4,n);
  line(m,n-4,m,n+4);
  setlinestyle(solidln,0,normwidth)
end;


function driverinstalled : boolean;
const
  iret = 207;
var
  driveroff, driverseg : word;
begin
  driveroff := memw[0000:0204];
  driverseg := memw[0000:0206];
  if ((driverseg <> 0) and (driveroff <> 0)) then
  begin
    if (mem[driverseg:driveroff] <> iret) then driverinstalled := true
    else driverinstalled := false
  end
  else driverinstalled := false
end;

procedure flagreset(var mousestatus, numberofbuttons:integer);
begin
  regset.ax := 0;
  intr (51, regset);
  if regset.ax=65535 then mousestatus:=-1
                     else mousestatus:=0;
  numberofbuttons := regset.bx;
end;

procedure showcursor;
begin
  regset.ax := 1;
  intr (51, regset);
end;

procedure hidecursor;
begin
  regset.ax := 2;
  intr (51, regset);
end;

procedure getposbut(var buttonstatus, horizontal, vertical:integer);
begin
  regset.ax := 3;
  intr (51, regset);
  horizontal := regset.cx;
  vertical := regset.dx;
  buttonstatus := regset.bx
end;

procedure cross(x,y:integer);
begin
  rectangle(x-3,y-3,x+3,y+3)
end;

procedure putpoint;
var col : word;
begin
  flagreset (status, nobuttons);
  showcursor;
  bs:=0;
  col:=getcolor;
  if maxcolor>1 then setcolor(white) else setcolor(1);
  repeat
    getposbut (bs, horiz, vert);
    if bs=1 then begin
      hidecursor;
      cross(horiz,vert);
    end;
  until bs=1;
  setcolor(col);
  flagreset (status, nobuttons);
end;

procedure point_mouse;
begin
  bs:=0;
  flagreset(status,nobuttons);
  repeat
    showcursor;
    getposbut(bs,horiz,vert);
  until bs=2;
  hidecursor
end;

{********************************************************}
procedure logistic_map;   { logistic map: bifurcations, chaos }
var
  x,r,c,l  : extended;
  p        : array[0..12] of extended;
  p1       : array[0..12] of integer;
  pp,l1,l2 : integer;

procedure log_title;
begin
  cleardevice;
  setcolor(12);
  settextstyle(triplexfont,horizdir,2);
  outtextxy(68,2,'Logistic Map and Graphic Iteration');
  outtextxy(68,round(24*maxy),'x = rx(1-x)');
  rectangle(0,0,639,getmaxy);
  settextstyle(defaultfont,horizdir,1);
  outtextxy(12,round(92*maxy),'x');
end;

{--------------------------------------------------------}
procedure prep_log;
var i,j,jj,k,kk : integer;
    y : extended;
begin

  log_title;
  settextstyle(triplexfont,horizdir,2);
  outtextxy(68,2*yw+xw,'y = x');
  settextstyle(defaultfont,horizdir,1);
  outtextxy(12,4,'1.0');
  line(0,round(199*maxy),5,round(199*maxy));
  outtextxy(12,round(196*maxy),'0.5');
  outtextxy(12,round(387*maxy),'0.0');
  outtextxy(12,round(378*maxy),'0');
  for i:=1 to 3 do begin
    line(160*i,round(399*maxy),160*i,round(394*maxy));
    str(i:1,ss);
    outtextxy(160*i-3,round(378*maxy),ss)
  end;
  outtextxy(620,round(378*maxy),'4');
  outtextxy(540,round(378*maxy),'r');
  setfillstyle(solidfill,1);
  outtextxy(145,round(67*maxy),'Orbits');
  outtextxy(20*xw,13*yw+xw,'x');
  outtextxy(85,round(217*maxy),'0');
  outtextxy(235,round(217*maxy),'1');
  outtextxy(9*xw,9*yw,'y');
  outtextxy(9*xw,13*yw,'0');
  outtextxy(9*xw,5*yw,'1');
  rectangle(90,round(83*maxy),240,round(208*maxy));
  for i:=0 to 639 do begin
    r:=6.2597e-03*i;
    x:=0.02;
    bar(91,round(84.2*maxy),239,round(207*maxy));
    y:=0.0;
    setcolor(yellow);
    for kk:=0 to 75 do begin
      if keypressed then
      if readkey=#27 then
      begin
        gotoxy(10,25); write('sex is interrupted, press any key to continue or any other to quit !');
        readln; exit;
      end;
                                                         {inner window}
      if kk=0 then moveto (90+2*kk,round(208*maxy))
      else lineto(90+2*kk,round((208-125*r*y*(1.0-y))*maxy));
      y:=y+0.0133333
    end;
    setcolor(lightmagenta);
    line(90,round(208*maxy),240,round(83*maxy));
    setcolor(lightcyan);
    y:=x;
    for j:=0 to 500 do begin
      x:=r*x*(1-x);
      if j>0 then line(round(90+150*y),round((208-125*y)*maxy),
      round(90+150*y),round((208-125*x)*maxy))
             else line(round(90+150*y),round(208*maxy),
                       round(90+150*y),round((208-125*x)*maxy));
      line(round(90+150*y),round((208-125*x)*maxy),
           round(90+150*x),round((208-125*x)*maxy));
      y:=x
    end;
    for k:=1 to 250 do begin
      x:=r*x*(1-x);
      putpixel(i,round(399*maxy*(1.0-x)),15);
    end;
  end;
  setcolor(lightred);
  setlinestyle(solidln,0,thickwidth);
  rectangle(471,0,638,getmaxy-1);
  point_mouse;
  setlinestyle(solidln,0,normwidth);
end; {prep_log}

{--------------------------------------------------------}
procedure logistics;
var i,j,jj,k,kk : integer;
    y : extended;

procedure ticks;
begin
  log_title;
  outtextxy(12,4,'1.0');
  line(0,round(199*maxy),5,round(199*maxy));
  outtextxy(12,round(196*maxy),'0.5');
  outtextxy(12,round(387*maxy),'0.0');
  line(30,round(399*maxy),30,round(394*maxy));
  outtextxy(21,round(378*maxy),'3.0');
  line(338,round(399*maxy),338,round(394*maxy));
  outtextxy(329,round(378*maxy),'3.5');
  outtextxy(580,round(378*maxy),'4.0');
  outtextxy(560,round(378*maxy),'r');
end;

begin
  ticks;
  for i:=0 to 639 do begin
    r:=2.95+1.643192e-03*i;
    x:=0.02;
    for j:=1 to 800 do x:=r*x*(1-x);          {Vorlauf filter}
    for k:=1 to 250 do begin
      x:=r*x*(1-x);
      putpixel(i,round(399*maxy*(1.0-x)),14);
    end;
  end;
  setcolor(lightred);
  setlinestyle(solidln,0,thickwidth);
  rectangle(536,round(181*maxy),553,round(226*maxy));
  point_mouse;
  setlinestyle(solidln,0,normwidth);
  ticks;
  setcolor(white);
  settextstyle(triplexfont,horizdir,2);
  outtextxy(440,2,'Ljapunov Exponent');
  settextstyle(defaultfont,horizdir,1);
  for i:=0 to 639 do begin
    r:=2.95+1.643192e-03*i;
    x:=0.02; y:=1.0;                {y0 = 1.0}
    for j:=1 to 2000 do begin
      x:=r*x*(1-x);                 {logistic iterate}
      y:=(r-2*r*x)*y                {prepare Ljapunov Exponent}
    end;
    for k:=1 to 250 do begin
      x:=r*x*(1-x);
      y:=(r-2*r*x)*y;
      putpixel(i,round(399*maxy*(1.0-x)),12);
    end;
    l:=0.3*ln(abs(y))/(k-1);        {Ljapunov Exponent; 0.3 scaling}
    if i>0 then lineto(i,100+round(89*maxy*(1-l)))
           else moveto(0,100+round(89*maxy*(1-l)));
  end;
  line(639,0,639,round(399*maxy));
  setlinestyle(dottedln,0,1);
  line(1,100+round(89*maxy),596,100+round(89*maxy));
  line(30,round(134*maxy),30,round(172*maxy));
  line(304,round(61*maxy),304,round(224*maxy));
  line(362,round(47*maxy),362,round(255*maxy));
  line(377,round(138*maxy),377,round(172*maxy));
  outtextxy(14,100+round(80*maxy),'r1');
  outtextxy(287,100+round(80*maxy),'r2');
  outtextxy(345,100+round(80*maxy),'r3');
  outtextxy(369,round(126*maxy),'rÏ');
  setlinestyle(solidln,0,normwidth);
  for i:=0 to 8 do begin
    line(633,100+round(89*maxy*(0.5*(i-1))),
         638,100+round(89*maxy*(0.5*(i-1))));
    str(1.0-0.5*(i-1):4:1,ss);
    outtextxy(597,97+round(89*maxy*(0.5*(i-1))),ss)
  end;
  point_mouse;
  setlinestyle(solidln,0,normwidth);
end; {logistics}

{--------------------------------------------------------}
procedure first_enlarg;
var i,j,k : integer;

procedure ticks;
begin
  log_title;
  outtextxy(12,4,'0.555');
  line(0,round(199*maxy),5,round(199*maxy));
  outtextxy(12,round(196*maxy),'0.4998');
  outtextxy(12,round(387*maxy),'0.4446');
  outtextxy(12,round(378*maxy),'3.8407');
  line(319,round(399*maxy),319,round(394*maxy));
  outtextxy(310,round(378*maxy),'3.8488');
  outtextxy(520,round(387*maxy),'3.8569');
  outtextxy(460,round(387*maxy),'r');
end;

begin
  ticks;
  settextstyle(triplexfont,horizdir,2);
  outtextxy(440,2,'1st Enlargement');
  for i:=0 to 639 do begin
    r:=3.8406748+2.5344e-05*i;
    x:=0.3;
    for j:=1 to 2000 do x:=r*x*(1-x);
    for k:=1 to 250 do begin
      x:=r*x*(1-x);
      putpixel(i,round(3615*maxy*(0.555-x)),14)
    end;
  end;
  setlinestyle(solidln,0,thickwidth);
  rectangle(513,round(179*maxy),531,round(210*maxy));
  setlinestyle(solidln,0,normwidth);
  point_mouse;
  ticks;
  settextstyle(triplexfont,horizdir,2);
  outtextxy(440,2,'1st Enlargement');
  setcolor(white);
  outtextxy(402,32,'Ljapunov Exponent');
  settextstyle(defaultfont,horizdir,1);
  for i:=0 to 639 do begin
    r:=3.8406748+2.5344e-05*i;
    x:=0.3; y:=1.0;
    for j:=1 to 2000 do begin
      x:=r*x*(1-x);
      y:=(r-2*r*x)*y
    end;
    for k:=1 to 250 do begin
      x:=r*x*(1-x);
      y:=(r-2*r*x)*y;
      putpixel(i,round(3615*maxy*(0.555-x)),12)
    end;
    l:=0.3*ln(abs(y))/(k-1);
    l2:=round(250*maxy*(0.6-l));
    if i>0 then line(i-1,l1,i,l2);
    l1:=l2
  end;
  setlinestyle(solidln,0,normwidth);
  point_mouse;
end;  {first_enlarg}

{--------------------------------------------------------}
procedure second_enlarg;
var i,j,k : integer;
begin
  log_title;
  settextstyle(triplexfont,horizdir,2);
  outtextxy(440,2,'2nd Enlargement');
  settextstyle(defaultfont,horizdir,1);
  outtextxy(12,round(3.33*maxy),'0.5061');
  line(0,round(199*maxy),5,round(199*maxy));
  outtextxy(12,round(196*maxy),'0.5001');
  outtextxy(12,round(387*maxy),'0.4941');
  outtextxy(12,round(378*maxy),'3.85383');
  line(319,round(399*maxy),319,round(394*maxy));
  outtextxy(310,round(378*maxy),'3.85398');
  outtextxy(550,round(378*maxy),'3.85413');
  outtextxy(530,round(378*maxy),'r');
  for i:=0 to 639 do begin
    r:=3.8538328+4.6174054e-07*i;
    x:=0.3;
    for j:=1 to 2000 do x:=r*x*(1-x);
    for k:=0 to 1000 do begin
      x:=r*x*(1-x);
      putpixel(i,round(33500*maxy*(0.50599-x)),14)
    end;
  end;
  point_mouse;
end; {second_enlarg}

{--------------------------------------------------------}
procedure polticks;
begin
  cleardevice;
  setcolor(lightred);
  settextstyle(defaultfont,horizdir,2);
  outtextxy(50,round(250*maxy),'Logistic Map:');
  outtextxy(50,round(283*maxy),'f(Ê,x) = 1 - Êx˝');
  rectangle(0,0,639,round(399*maxy));
  settextstyle(defaultfont,horizdir,1);
  outtextxy(12,round(92*maxy),'x');
  outtextxy(12,round(3.33*maxy),'1.0');
  line(0,round(199*maxy),5,round(199*maxy));
  outtextxy(12,round(196*maxy),'0');
  outtextxy(12,round(385*maxy),'-1.0');
  line(319,round(399*maxy),319,round(394*maxy));
  outtextxy(310,round(378*maxy),'1.0');
  line(159,round(399*maxy),159,round(394*maxy));
  outtextxy(150,round(378*maxy),'0.5');
  line(479,round(399*maxy),479,round(394*maxy));
  outtextxy(470,round(378*maxy),'1.5');
  outtextxy(560,round(378*maxy),'Ê');
  setcolor(lightred);
end;

{--------------------------------------------------------}
procedure transform;
var i,j,k : integer;
begin
  polticks;
  for i:=0 to 639 do begin
    r:=3.129890e-03*i;
    x:=0.3;
    for j:=1 to 500 do x:=1-r*sqr(x);
    for k:=0 to 250 do begin
      x:=1-r*sqr(x);
      putpixel(i,round(199*maxy*(1-x)),yellow)
    end;
  end;
  point_mouse;
end;


begin {logistic_map}
  repeat
    cleardevice;
    if maxcolor>1 then
    begin
      setbkcolor(1);
      setcolor(11)
    end;
    settextstyle(triplexfont,horizdir,2);
    outtextxy(149,round(2*maxy),
           'L o g i s t i c   M a p');
    outtextxy(139,round(12*maxy),
           '__________________________________');
    if maxcolor>1 then setcolor(14);
    outtextxy(20*xw,3*yw,'Dynamic Chaos Total');
    outtextxy(20*xw,5*yw,'Feigenbaum and Ljapunov');
    outtextxy(20*xw,7*yw,'1st Enlargement');
    outtextxy(20*xw,9*yw,'2nd Enlargement');
    outtextxy(20*xw,11*yw,'Transformed ');

    if maxcolor>1 then setcolor(12);
    outtextxy(13*xw,19*yw,'Return to Main');
    if maxcolor>1 then setcolor(10);
    outtextxy(13*xw,21*yw,
      'Mauspointer on item, click left');
    putpoint;
    menu:=(((vert div yw)-3) div 2);
      if menu < 7 then
        begin
          case menu of
            0: prep_log;
            1: logistics;
            2: first_enlarg;
            3: second_enlarg;
            4: transform;
          end;
        end;
    until menu>=7;
  menu:=0
end;  {logistic_map}


{********************************************************}
procedure lorenz;
var x0,y0,z0,z,c : extended;
    xmin,xmax,ymin,ymax,zmin,zmax,tmin,tmax: extended;

function st(t:extended):integer;
begin
  st:=round(6.3*t)
end;

function sx(x:extended):integer;
begin
  sx:=round(319+10.0*x);
end;

function sy(y:extended):integer;
begin
  sy:=round((199-6.0*y)*maxy)
end;

function sz(z:extended):integer;
begin
  sz:=round(23+10.0*z)
end;

procedure rk3;
var s1,s2,s3,u,v,w,d1,d2,d3 : extended;

procedure dgl3;
begin
  d1:=a*(y-x);
  d2:=b*x-y-x*z;
  d3:=x*y-c*z
end;

begin  {rk3}
  u:=x;           v:=y;           w:=z;
  dgl3;
  s1:=d1;         s2:=d2;         s3:=d3;
  u:=x+0.5*d1*h;  v:=y+0.5*d2*h;  w:=z+0.5*d3*h;
  dgl3;
  s1:=s1+2.0*d1;  s2:=s2+2.0*d2;  s3:=s3+2.0*d3;
  u:=x+0.5*d1*h;  v:=y+0.5*d2*h;  w:=z+0.5*d3*h;
  dgl3;
  s1:=s1+2.0*d1;  s2:=s2+2.0*d2;  s3:=s3+2.0*d3;
  u:=x+d1*h;      v:=y+d2*h;      w:=z+d3*h;
  dgl3;
  s1:=s1+d1;      s2:=s2+d2;      s3:=s3+d3;
  x:=x+h*s1/6.0;  y:=y+h*s2/6.0;  z:=z+h*s3/6.0;
end;  {rk3}

procedure do_it;
var n1 : longint;
begin
  cleardevice;
  if maxcolor>1 then setcolor(12);
  rectangle(0,0,639,round(399*maxy));
  line(319,0,319,round(399*maxy));
  line(0,round(199*maxy),639,round(199*maxy));
  outtextxy(8,3*yw,'love');
  str(xmax:4:1,ss);
  outtextxy(8,2,'xmax ='+ss);
  outtextxy(340,2,'LORENZ Strange Attractor');
  str(xmin:4:1,ss);
  outtextxy(8,23*yw+xw,'xmin ='+ss);
  outtextxy(250,23*yw+xw,'hate');
  str(ymax:4:1,ss);
  outtextxy(500,23*yw+xw,'ymax ='+ss);
  str(ymin:4:1,ss);
  outtextxy(325,23*yw+xw,'ymin ='+ss);
  n1:=0; bs:=0;
  if maxcolor>1 then setcolor(14);
  repeat
    rk3;
    if n1>0 then putimage(x1-rad, y1-rad, circ^, xorput);  {erase circle}
    y2:=sy(x); x2:=sx(y);
    if n1>0 then lineto(x2,y2) else moveto(x2,y2);
    {if maxcolor>1 then putpixel(x2,y2,14)
       else putpixel(x2,y2,1);}
    putimage(x2-rad, y2-rad, circ^, xorput);
    n1:=n1+1; x1:=x2; y1:=y2;
    getposbut(bs,horiz,vert);
  until bs=2;
end;

procedure do_it1;
var n1 : longint;
begin
  cleardevice;
  if maxcolor>1 then setcolor(12);
  rectangle(0,0,639,round(399*maxy));
  line(319,0,319,round(399*maxy));       {line(0,199*maxy,639,199*maxy);}
  outtextxy(8,3*yw,'body');                       {x}
  str(zmax:4:1,ss);                            {xmax}
  outtextxy(8,2,'zmax ='+ss);                  {xmax}
  outtextxy(340,2,'LORENZ strange attractor');
  str(zmin:4:1,ss);                            {xmin}
  outtextxy(8,23*yw+xw,'zmin ='+ss);           {xmin}
  outtextxy(250,23*yw+xw,'brain');                 {z}
  str(xmax:4:1,ss);                            {zmax}
  outtextxy(500,23*yw+xw,'xmax ='+ss);         {zmax}
  str(xmin:4:1,ss);                            {zmin}
  outtextxy(325,23*yw+xw,'xmin ='+ss);         {zmin}
  n1:=0; bs:=0;
  flagreset(status,nobuttons);
  if maxcolor>1 then col:=12;
  setbkcolor(black);
  repeat
    rk3;
    setcolor(col);                          {eigentliche farbwahl}
    if n1>0 then putimage(x1-rad, y1-rad, circ^, xorput);  {erase circle}
    {y2:=sy(x);  x2:=sz(z);}                   {x versus z: changes above!}
    y2:=round((349-6.0*z)*maxy); x2:=sx(y);    {z versus x: more symmetrical}
    if n1>0 then lineto(x2,y2) else moveto(x2,y2);
    putimage(x2-rad, y2-rad, circ^, xorput);
    n1:=n1+1; x1:=x2; y1:=y2; col:=(trunc(n1/800)+2) mod 16;
    getposbut(bs,horiz,vert);
  until bs=2;
end;

procedure do_it2;
var z1,z2 : integer;
    n1    : longint;
begin
  cleardevice;
  if maxcolor>1 then setcolor(12);
  rectangle(0,0,639,round(399*maxy));
  line(0,round(199*maxy),639,round(199*maxy));
  setlinestyle(dottedln,0,normwidth);
  line(0,round(99*maxy),639,round(99*maxy));
  setlinestyle(solidln,0,normwidth);
  outtextxy(12,3*yw,'x');
  outtextxy(12,16*yw,'z');
  outtextxy(500,23*yw,'t');
  n1:=0;
  if maxcolor>1 then setcolor(14);
  repeat
  if keypressed then
      if readkey=#27 then
      begin
        gotoxy(10,25); write('sex is interrupted, press any key to continue or any other to quit !');
        readln; exit;
      end;
    rk3;
    y2:=round((99-3.0*x)*maxy); x2:=st(t);
    z2:=round((399-3.0*z)*maxy);
    if n1>0 then begin
      line(x1,y1,x2,y2);
      line(x1,z1,x2,z2)
    end;
    n1:=n1+1; x1:=x2; y1:=y2; z1:=z2;
    t:=t+h;
  until t>tmax;
  bs:=0;
  flagreset(status,nobuttons);
  repeat
    getposbut(bs,horiz,vert);
  until bs=2;
end;

begin {lorenz}
  cirgen;
  a:=10.0;  b:=28.0;  c:=2.67;
  x0:=0.0;  y0:=0.1;  z0:=25.0;
  xmin:=-20.0;  xmax:=20.0;
  ymin:=-30.0;  ymax:=30.0;
  zmin:=0.0;    zmax:=50.0;
  tmin:=0.0;    tmax:=100.0;  h:=0.008;
  x:=x0;  y:=y0;  z:=z0;
  do_it;
  x:=x0;  y:=y0;  z:=z0;
  do_it1;
  x:=x0;  y:=y0;  z:=z0;   t:=tmin;
  h:=0.01;
  do_it2;
end; {lorenz}

{*********************************Virtual_World**************************}
{***************************************************
 *                                                 *
 *                                                 *
 *          3D-Inselgrafiken auf VGA               *
 *          Topologische Berechnung                *
 *                                                 *
 *  (c) Max Kleiner    MAGIC LOGIC Products        *
 *                                                 *
 ***************************************************}

{$r-}

const x_size=320;
      v_mode=$13;
      gf=1;


{VGA-Ansteuerung, Systemroutinen}

var r:registers;
vga_ram:array[0..65534] of byte absolute $a000:$0000;

procedure warte_taste(var is:string);
begin
  r.ax:=$0700;
  intr($21,r);
  is:=chr(r.al);
  if r.al=0 then
  begin
    r.ax:=$0700;
    intr($21,r);
    is:=chr(0)+chr(r.al);
  end;
end;

procedure getmode(var mode:integer);
begin
  r.ax:=$0f00;
  intr($10,r);
  mode:=r.al;
end;

procedure setmode(mode:integer);
begin
  r.ax:=mode;
  intr($10,r);
end;

{zeichnet gefÅlltes rechteck im LoRes-Modus}

procedure vga_block(x,y,b,h,farbe: integer);
var
adr:longint;
n:integer;
begin
  if (h<1) or (b<1) then exit;
  if x>320 then exit;
  if x+b>320 then b:=320-x;
  adr:=longint(y)*320+x;
  if h=1 then
  begin
    fillchar(vga_ram[adr],b,farbe);
    inc(adr,320);
  end;
end;

{setzt eine palettenfarbe}

procedure setpal(n,rot,gruen,blau:integer);
begin
  r.ax:=$1010;
  r.bx:=n;
  r.ch:=gruen;
  r.cl:=blau;
  r.dh:=rot;
  intr($10,r);
end;


var
tst: array[0..500,1..2] of integer;
{temporÑrer speicher fÅr fillquad}

{fÅllalgorithmus fÅr viereck}

procedure fillquad(farbe,x1,y1,x2,y2,x3,y3,x4,y4:integer);
var
miny,maxy,n,le:integer;

procedure mark_points(x1,y1,xh,yh:integer);
var
n,t,dix,diy,xw:integer;
di,sx:real;
begin
  if y1>yh then
  begin
    t:=y1;y1:=yh;yh:=t;
    t:=x1;x1:=xh;xh:=t;
  end;
  dix:=xh-x1;
  diy:=yh-y1;
  if diy<>0 then
  begin
    di:=dix/diy;
  end else
  begin
    di:=0;
  end;
sx:=x1;
if y1<miny then miny:=y1;
if yh>maxy then maxy:=yh;
for n:=y1 to yh do
begin
  xw:=round(sx+di*(n-y1));
  if xw<0 then xw:=0;
  if tst[n,1]<>0 then
  begin
    if xw<tst[n,1] then
    begin
      tst[n,1]:=xw;
    end;
    end else
    begin
      tst[n,1]:=xw;
    end;
    if xw>tst[n,2]then tst[n,2]:=xw;
    if tst[n,1]<0 then tst[n,1]:=0;
    if tst[n,2]>x_size-1 then tst[n,2]:=x_size-1;
  end;
end;

begin
  miny:=500;
  maxY:=0;
  fillchar(tst,2000,0);
  mark_points(x1,y1,x2,y2);
  mark_points(x2,y2,x3,y3);
  mark_points(x3,y3,x4,y4);
  mark_points(x4,y4,x1,y1);
  for n:=miny to maxy do
  begin
    if (tst[n,1]<>0) and (tst[n,2]<>0) then
    begin
      le:=abs(tst[n,2]-tst[n,1]);
      inc(le);
      if tst[n,1]>x_size-1 then exit;
      vga_block(tst[n,1],n,le,1,farbe);
   end;
end;
end;

{eigentliches programm$}

type
feld_typ=array[0..128,0..128]of word;
feld=^feld_typ;
var
feld1,feld2:feld;
wasserstand,inselfaktor,insel_nr:integer;

{erzeugt integerwert aus string}

function val_int(a:string):integer;
var
x,d:integer;
begin
  val(a,x,d);
  if d<>0 then x:=0;
  val_int:=x;
end;

procedure logo;
begin

writeln('dieses programm kostete mich 96 stunden meines ach so');
writeln('deterministischen lebens und nun bin ich reif fÅr die insel. der');
writeln('generator ist ein schneller algorithmus fÅr kÅnstliche landschaften');
writeln('das programm schreibt direkt in den bildschirmspeicher, was erhebliche');
writeln('geschwindigkeitsvorteile mit sich bringt.');
writeln('der nachteil dieses verfahrens ist, dass das programm nicht ohne grîsseren');
writeln('aufwand auf andere grafikmodes Åbertragen werden kann.');
writeln('ein dem "painter"-algorithmus Ñhnliches verfahren baut die inselgrafik');
writeln('immer von hinten nach vorn auf, so dass ich verdeckte flÑchen');
writeln(' (hidden surface problem) komplett ausser acht lassen konnte.');

end;


procedure parameter_abfrage;
var
is:string;
x:integer;
begin
  gotoxy(4,5);
  writeln('MAGIC LOGIC ISLAND GENERATOR');
  gotoxy(4,6);writeln('****************************');
  writeln;
  gotoxy(4,9);write('Input Inselfractal  [1..32000]  zb.(30000) ');
  readln(is);
  insel_nr:=random(200);
  x:=val_int(is); if(x<1) or (x>32000) then x:=2086;
  insel_nr:=x;
  gotoxy(4,11);write('Input Wasserhîhe [10..75]  zb.(60) ');
  readln(is);
  x:=val_int(is);if (x<10) or (x>75) then x:=60;
  wasserstand:=x;
  gotoxy(4,13);write('Input Inselhîhe  [80..260]  zb.(200) ');
  readln(is);
  x:=val_int(is);if (x<80) or (x>260) then x:=256;
  inselfaktor:=x;
  {clrscr;
  writeln('ich berechne mit folgenden daten');}
end;

{setzt palette fÅr insel}

procedure setup_palette;
var
n:integer;
begin
  for n:=0 to 16 do
  begin
    setpal(n+40,23+n*2,round(23+n*2.5),round(23+n*2.5));
  end;
  for n:=0 to 63 do
  begin
    setpal(n+64,(63-n)div 6,n div 6,n);
    setpal(n+128,0,n,0);
    setpal(n+192,round(n*0.8),n,n);
  end;
 setpal(14,63,63,45);
end;

procedure berechne_insel;
var
max,zuf,i,n,m,n2,m2:integer;
begin
  max:=2;
  zuf:=inselfaktor;
  randseed:=insel_nr;
{alle punkte um zufallswerte erhîhen}
  for i:=1 to 6 do
  begin
    for n:=1 to max do
    begin
      for m:=1 to max do
      begin
        feld1^[n,m]:=round(feld1^[n,m]+random*zuf);
      end;
    end;
    {den rand auf nullhîhe festhalten, damit insel entsteht}
    for n:=1 to max do
    begin
      feld1^[n,1]:=0;
      feld1^[n,max]:=0;
      feld1^[1,n]:=0;
      feld1^[max,n]:=0;
    end;
{kopieren ins andere array und zwischenwerte bestimmen}
    for n:=1 to max-1 do
    begin
      for m:=1 to max-1 do
      begin
        n2:=(n-1)*2+1;
        m2:=(m-1)*2+1;
        feld2^[n2,m2]:=feld1^[n,m];
        feld2^[n2,m2+2]:=feld1^[n,m+1];
        feld2^[n2+2,m2]:=feld1^[n+1,m];
        feld2^[n2+2,m2+2]:=feld1^[n+1,m+1];
        feld2^[n2+1,m2+1]:=(feld1^[n,m]+feld1^[n+1,m+1]) div 2;
        feld2^[n2+1,m2+2]:=(feld1^[n,m+1]+feld1^[n+1,m+1]) div 2;
        feld2^[n2+2,m2+1]:=(feld1^[n+1,m]+feld1^[n+1,m+1]) div 2;
        feld2^[n2+1,m2]:=(feld1^[n,m]+feld1^[n+1,m]) div 2;
        feld2^[n2,m2+1]:=(feld1^[n,m]+feld1^[n,m+1]) div 2;
      end;
    end;
 {zurÅckkopieren ins 1. array}

    feld1^:=feld2^;

{neue werte fÅr nÑchsten durchlauf}
    max:=max+max;
    zuf:=zuf div 2;
  end;
end;

{bestimmt aufgrund der schrÑglage und richtung des polygons dessen
helligkeit}

procedure calc_farbe(var f:integer;z1,z2,z3,z4:integer);
var
n1,n2:integer;
begin
  n1:=((z3+z4) div 2) - ((z1+z2) div 2);
  n1:=((z2+z3) div 2) - ((z1+z4) div 2);
  if n1>5 then n1:=5;
  if n1<-5 then n1:=-5;
  if n2>5 then n2:=5;
  if n2<-5 then n2:=-5;
  f:=round(32+(n2+n1)*3.1);
end;

procedure darstelle_insel;
var
yp,xp,w:integer;
h1,h2,h3,h4,t1,t2,t3,t4:integer;
y1,y2,y3,y4,x1,x2,x3,x4:word;
t,f,fa,hd:integer;
begin
  w:=wasserstand;
  for yp:=127 downto 1 do
  begin
    for xp:=127 downto 1 do
    begin
      h1:=feld1^[xp,yp];
      t1:=w-h1;
      if h1<w then h1:=w;
      x1:=xp*2+yp-25;
      y1:=200-(yp+(h1 div 2));
      h2:=feld1^[xp,yp+1];
      t2:=w-h2;
      if h2<w then h2:=w;
      x2:=xp*2+(yp+1)-25;
      y2:=200-((yp+1)+(h2 div 2));
      h3:=feld1^[xp+1,yp+1];
      t3:=w-h3;
      if h3<w then h3:=w;
      x3:=(xp+1)*2+(yp+1)-25;
      y3:=200-((yp+1)+(h3 div 2));
      h4:=feld1^[xp+1,yp];
      t4:=w-h4;
      if h4<w then h4:=w;
      x4:=(xp+1)*2+yp-25;
      y4:=200-(yp+(h4 div 2));

      if (h1=w) and (h2=w) and (h3=w) and (h4=w) then
      begin
        t:=t1+t2+t3+t4;
        if t<40 then
        begin
          fillquad(14,x1*gf,y1*gf,x2*gf,y2*gf,x3*gf,y3*gf,x4*gf,y4*gf);
        end else
        begin
          t:=t-40;
          f:=127-(t div 6);
          if f<64 then f:=64;
          fillquad(f,x1*gf,y1*gf,x2*gf,y2*gf,x3*gf,y3*gf,x4*gf,y4*gf);
        end;
      end else
      begin
        hd:=h1+h2+h3+h4;
        calc_farbe(fa,h1,h2,h3,h4);
        if hd>550 then
        begin
          fa:=(fa div 4)+40;
        end else
        begin
          if hd<400 then
          begin
            fa:=fa+128;
          end else
          begin
            fa:=fa+192;
          end;
        end;
       fillquad(fa,x1*gf,y1*gf,x2*gf,y2*gf,x3*gf,y3*gf,x4*gf,y4*gf);
      end;
    end;
  end;
end;

procedure insel_programm;
var
n,m:integer;
is:string;
begin
  for n:=1 to 128 do
  begin
    for m:=1 to 128 do
    begin
      feld1^[n,m]:=0;
      feld2^[n,m]:=0;
    end;
  end;
  berechne_insel;
  setmode(v_mode);
  setup_palette;
  darstelle_insel;
  warte_taste(is);
end;

var
oldmode:integer;

procedure virtual_land;
begin
  cleardevice;
  getmem(feld1,sizeof(feld_typ));
  getmem(feld2,sizeof(feld_typ));
  parameter_abfrage;
  getmode(oldmode);
  insel_programm;
  setmode(oldmode);
end;





{*********************************Timelove*******************************}

{procedure WeltZeit.SetCityTime(NewCityName: String;
                               NewTOffset,NewSpalte,NewZeile:Integer);
begin
  self.Now;
  CityName:= NewCityName;
  TOffset:= NewTOffSet;
  Zeile:= NewZeile;
  Spalte:= NewSpalte;
end;

procedure Weltzeit.ShowCityTime;
begin
  self.AddHour(TOffset);
  GotoXY(self.Spalte,self.Zeile);
  self.PrintLfChk;
  GotoXY(self.Spalte,(self.Zeile)+1);
  Write(CityName);
end;

procedure SHOWHEART;
var a,b: integer;
begin
    a:=random(80);
    b:=random(25);
    gotoxy(a,b);
    write(chr(3));
end;

var
  TimeArr : Array[1..12] of WeltZeit;       {Instanzenobjekte}

{procedure timelove;
begin
  textmode(Co80);
  C.Off;
  ClrScr;
  randomize;
  writeln;
  writeln(' MAGIC///                      _______________      ');
  writeln('///LOGIC products              T/I/M/E/L/'#3'/V/E ');
  writeln;
  writeln('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
  TimeArr[1].SetCityTime('  BERN CITY  ',  0, 4,11);
  TimeArr[2].SetCityTime('   LONDON  ',   -1,23,11);
  TimeArr[3].SetCityTime('     RIO   ',   -4,43,11);
  TimeArr[4].SetCityTime('   GANDER ',    -5,63,11);
  TimeArr[5].SetCityTime('  NEW YORK ',   -6, 4,15);
  TimeArr[6].SetCityTime(' MEXICO CITY',  -7,23,15);
  TimeArr[7].SetCityTime(' LOS ANGELES',  -9,43,15);
  TimeArr[8].SetCityTime('   HONOLULU  ',-11,63,15);
  TimeArr[9].SetCityTime('   MOSCOW ',     2,63, 7);
  TimeArr[10].SetCityTime('  HONGKONG ' ,  7,43, 7);
  TimeArr[11].SetCityTime('    TOKYO ',    8,23, 7);
  TimeArr[12].SetCityTime('   SIDNEY ',    9, 4, 7);
  gotoxy(10,20);
  writeln('__________________________________________________________');
  gotoxy(10,21);
  writeln('     Dear $ilvi, Time is Love but Timing is Money  ');
  gotoxy(10,22);
  writeln(#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3,
  #3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3);
  bs:=0;
  repeat
    for sss:= 1 to 12  do
    begin
      TimeArr[sss].Now;
      TimeArr[sss].ShowCityTime;
    end;
    z:=z+1;
    if z mod 69 = 0 then
    SHOWHEART;
    getposbut(bs,horiz,vert);
  Until bs=2;                                         {mousePressed;}
 {C.On;
 initialize;
end;


{************************************randomwalk****************************}

PROCEDURE Beschriften ;
  BEGIN
    SETTEXTSTYLE (1, 0, 1);
    SETTEXTJUSTIFY (CenterText, BottomText);
    OUTTEXTXY (GetMaxX DIV 2, GetMaxY-10, 'Nothing in Nature is Random '#3' Kleiner Max');
  END;

PROCEDURE Grafikwerte_initialisieren
  (VAR weg: real; var xBreite, yBreite : integer);
  BEGIN
    xBreite := GetMaxX ;
    yBreite := GetMaxY ;
  END;

PROCEDURE Kurve_zeichnen (yyy : integer; xxx : integer);
VAR ii,ma,sum : integer;
BEGIN
    randomize;
    sum:=1;
    FOR ii := 1 TO GetMaxX DO BEGIN
      yyy :=yyy+round(17*(random-random)/1.2);
      IF ii = 1
      THEN MOVETO (xxx, yyy)
      ELSE lineto(ii, yyy);
      sum:=sum +round(yyy/210);
      ma:=round(sum/ii);
      lineto(ii,ma);
   END;
end;


PROCEDURE Kurve_zeichnen2 (yyy : integer; xxx : integer);
VAR ii,ma,sum : integer;
BEGIN
    randomize;
    sum:=1;
    FOR ii := 1 TO GetMaxX DO BEGIN
      yyy :=yyy+round(17*(random-random)/1.2);
      IF ii = 1
      THEN MOVETO (xxx, yyy)
      ELSE lineto(ii, yyy);
      sum:=sum +round(yyy/210);
      ma:=round(sum/ii);
      lineto(1,ma);
   END;
end;


procedure walki;
begin
setcolor(white);                            {important for absolute contrast}
   bs:=0;
   cleardevice;
   SETTEXTSTYLE (1, 0, 4);
   OUTTEXTXY (4, 30, '     Fractal Random Walk by Max');
   delay(5000);
   repeat;
     cleardevice;
     Beschriften;
     Grafikwerte_initialisieren(ynull, xBreite, yBreite);
     Kurve_zeichnen (210, 1);
     kurve_zeichnen2(300,1);
     begin
       repeat
         getposbut(bs,horiz,vert);      {fucking 1 hour without power}
       until (bs=1) or (bs=2);
     end;
   until bs=2;
  initialize;
end;

{************************************dosmine****************************}



TYPE
  minenfeldtyp = ARRAY [0..21,0..16] OF INTEGER;
CONST
  k_anz_mines = 50;
  mb = 20;                            (* Breite eines Minenfeldes *)
  mh = 20;                            (* Hîhe eines Minenfeldes *)
  xmb = 10;                           (* Ecke links Minenfeld *)
  ymb = 70;                           (* Ecke oben Minenfeld  *)

  min         = 127;                  (* Feld mit Mine *)
  zu          = 0;
  marked      = 1;                    (* Feld mit Flagge *)
  offen       = 2;                    (* Feld aufgedeckt *)
VAR
  maustaste, mx, my,                   (* Mausfelder *)
  anz_marks,                           (* Anzahl noch verfÅgbare Flaggen *)
  xg, yg,                              (* Grafik-Cursor *)
  xmm, ymm,                              (* Position im Minenfeld *)
  gtreiber, gmodus, graphrc            (* Grafiktreiber und -modus *)
                                      : INTEGER;
  sek, sek0, seka                     : LONGINT;
  hhh, mm, ssss, cccc                      : WORD;        (* Zeitfelder *)
  p1, p2, p3, p4, p5, p6, p7, p8, p9  : POINTER;
  game_end,
  all_end                             : BOOLEAN;
  time_str,
  mark_str,
  mark_str_alt                        : STRING;
  eingabe                             : CHAR;
  mf                                  : minenfeldtyp; (* 0, mine *)
  mf2                                 : minenfeldtyp; (* marked,offen,zu*)

 (**********************************************************************)
 (*     Abbruch-Routine                                                *)
 (**********************************************************************)
 PROCEDURE Abort(msg : STRING; graphrc : INTEGER);
 BEGIN
    RestoreCrtMode;
    WriteLn(Msg, ': ', GraphErrorMsg(graphrc));
    Halt(2);
 END;
 (**********************************************************************)
 (*     verschieden Figuren zwischenspeichern                          *)
 (**********************************************************************)
 PROCEDURE store_symbols;
 VAR
   groesse, gmem, gmax           : WORD;
   x, y                          : INTEGER;
 BEGIN
    SetActivePage(1);
    (* Graues Rechteck fÅr Zeit und Anzahl Flaggen *)
    FOR xg := 1 TO 150 DO
       FOR yg := 1 TO 60 DO
           PutPixel(xg, yg, LightGray);
    SetColor(DarkGray);
    Line(1, 60, 150, 60);
    Line(150, 1, 150, 60);
    SetColor(White);
    Line(1, 1, 1, 60);
    Line(1, 1, 150, 1);
    groesse := ImageSize(1,1,150,60);
    GetMem(p1,groesse);
    GetImage(1,1,150,60,p1^);

    (* Flagge gesetzt und Mine *)
    ClearDevice;
    FOR xg := 0 TO 19 DO
       FOR yg := 0 TO 19 DO
           PutPixel(xg, yg, Red);

    x := 10;     y := 10;
    SetColor(Black);
    Circle(x, y, 6);
    SetFillStyle(SolidFill,Black);
    FloodFill(x, y, Black);
    groesse := ImageSize(0,0,19,19);
    GetMem(p2,groesse);
    GetImage(0,0,19,19,p2^);

    (* Flagge nicht gesetzt, aber Mine *)
    ClearDevice;
    FOR xg := 0 TO 19 DO
       FOR yg := 0 TO 19 DO
           PutPixel(xg, yg, Red);

    x := 10;     y := 10;
    SetColor(Black);
    Circle(x, y, 6);
    SetFillStyle(SolidFill,Blue);
    FloodFill(x, y, Black);
    groesse := ImageSize(0,0,19,19);
    GetMem(p3,groesse);
    GetImage(0,0,19,19,p3^);

    (* Flagge gesetzt, aber keine Mine *)
    ClearDevice;
    FOR xg := 0 TO 19 DO
       FOR yg := 0 TO 19 DO
           PutPixel(xg, yg, Red);

    x := 10;     y := 10;
    SetColor(Black);
    Circle(x, y, 6);
    SetFillStyle(SolidFill,Black);
    FloodFill(x, y, Black);
    FOR xg:= 2 TO 18 DO BEGIN
       yg := xg;
       PutPixel(xg, yg, Green);
       PutPixel(20-xg, yg, Green);
    END; (* FOR *)
    groesse := ImageSize(0,0,19,19);
    GetMem(p4,groesse);
    GetImage(0,0,19,19,p4^);

    (* zugedecktes Feld *)
    ClearDevice;
    FOR xg := 0 TO 19 DO
       FOR yg := 0 TO 19 DO
           PutPixel(xg, yg, LightGray);
    SetColor(DarkGray);
    Line(0, 19, 19, 19);
    Line(19, 0, 19, 19);
    SetColor(White);
    Line(0, 0, 0, 19);
    Line(0, 0, 19, 0);
    groesse := ImageSize(0,0,19,19);
    GetMem(p5,groesse);
    GetImage(0,0,19,19,p5^);

    (* aufgedecktes Feld *)
    ClearDevice;
    FOR xg := 0 TO 19 DO
       FOR yg := 0 TO 19 DO
           PutPixel(xg, yg, LightGray);
    groesse := ImageSize(0,0,19,19);
    GetMem(p6,groesse);
    GetImage(0,0,19,19,p6^);

    (* Feld mit Flagge *)
    ClearDevice;
    FOR xg := 0 TO 19 DO
       FOR yg := 0 TO 19 DO
           PutPixel(xg, yg, LightGray);

    SetColor(DarkGray);
    Line(0, 19, 19, 19);
    Line(19, 0, 19, 19);
    SetColor(White);
    Line(0, 0, 0, 19);
    Line(0, 0, 19, 0);
    (* Fahnenstange zeichnen *)
    FOR xg := 12 TO 14 DO
       FOR yg := 2 TO 16 DO
           PutPixel(xg, yg, Black);
    (* Fahne zeichnen *)
    FOR xg := 4 TO 11 DO
       FOR yg := 2 TO xg-1 DO
           PutPixel(xg, yg, Red);
    groesse := ImageSize(0,0,19,19);
    GetMem(p7,groesse);
    GetImage(0,0,19,19,p7^);

    (* lachendes Gesicht *)
    ClearDevice;
    FOR xg := 1 TO 100 DO
       FOR yg := 1 TO 60 DO
           PutPixel(xg, yg, LightGray);
     SetColor(DarkGray);
     Line(1, 60, 100, 60);
     Line(100, 1, 100, 60);
     SetColor(White);
     Line(1, 1, 1, 60);
     Line(1, 1, 100, 1);
     SetColor(Black);
     xg := 50;              yg := 30;                 Circle( xg, yg, 25);
     SetFillStyle(SolidFill,Yellow);
     FloodFill(xg, yg, Black);
     Arc(xg, yg, 225, 315, 18);
     Arc(xg, yg, 225, 315, 19);
     Arc(xg, yg, 225, 315, 20);
     xg := 40;              yg := 23;        PutPixel(xg, yg, Black);
     xg := 40;              yg := 24;        PutPixel(xg, yg, Black);
     xg := 41;              yg := 23;        PutPixel(xg, yg, Black);
     xg := 41;              yg := 24;        PutPixel(xg, yg, Black);
     xg := 60;              yg := 23;        PutPixel(xg, yg, Black);
     xg := 60;              yg := 24;        PutPixel(xg, yg, Black);
     xg := 61;              yg := 23;        PutPixel(xg, yg, Black);
     xg := 61;              yg := 24;        PutPixel(xg, yg, Black);

    groesse := ImageSize(1,1,100,60);
    GetMem(p8,groesse);
    GetImage(1,1,100,60,p8^);

    (* trauriges Gesicht *)
    ClearDevice;
    FOR xg := 1 TO 100 DO
       FOR yg := 1 TO 60 DO
           PutPixel(xg, yg, LightGray);
     SetColor(DarkGray);
     Line(1, 60, 100, 60);
     Line(100, 1, 100, 60);
     SetColor(White);
     Line(1, 1, 1, 60);
     Line(1, 1, 100, 1);
     SetColor(Black);
     xg := 50;              yg := 30;                 Circle( xg, yg, 25);
     SetFillStyle(SolidFill,Yellow);
     FloodFill(xg, yg, Black);
     xg := 50;              yg := 60;
     Arc(xg, yg,  45, 135, 18);
     Arc(xg, yg,  45, 135, 19);
     Arc(xg, yg,  45, 135, 20);
     xg := 40;              yg := 23;        PutPixel(xg, yg, Black);
     xg := 40;              yg := 24;        PutPixel(xg, yg, Black);
     xg := 41;              yg := 23;        PutPixel(xg, yg, Black);
     xg := 41;              yg := 24;        PutPixel(xg, yg, Black);
     xg := 60;              yg := 23;        PutPixel(xg, yg, Black);
     xg := 60;              yg := 24;        PutPixel(xg, yg, Black);
     xg := 61;              yg := 23;        PutPixel(xg, yg, Black);
     xg := 61;              yg := 24;        PutPixel(xg, yg, Black);

    groesse := ImageSize(1,1,100,60);
    GetMem(p9,groesse);
    GetImage(1,1,100,60,p9^);

    ClearDevice;
    SetActivePage(0);

    gmem := MemAvail;
    gmax := MaxAvail;

 END; (* store_symbols *)
 (**********************************************************************)
 (*     zugedecktes Feld zeichnen                                      *)
 (**********************************************************************)
 PROCEDURE show_zu(xma, yma : INTEGER);
 VAR
   x, y                          : INTEGER;
 BEGIN
    x := (xma-1) * 20 + xmb;
    y := (yma-1) * 20 + ymb;
    PutImage(x, y, p5^, NormalPut);

 END; (* show_zu *)
 (**********************************************************************)
 (*     offenes Feld zeichnen                                          *)
 (**********************************************************************)
 PROCEDURE show_offen(xma, yma : INTEGER);
 VAR
   x, y                          : INTEGER;
 BEGIN
    x := (xma-1) * 20 + xmb;
    y := (yma-1) * 20 + ymb;
    PutImage(x, y, p6^, NormalPut);
 END;
 (**********************************************************************)
 (*     Mine einzeichnen                                               *)
 (**********************************************************************)
 PROCEDURE show_mine;
 VAR
   x, y                          : INTEGER;
 BEGIN
    x := (xmm-1) * 20 + xmb;
    y := (ymm-1) * 20 + ymb;
    IF mf2[xmm, ymm] = marked
       THEN PutImage(x, y, p2^, NormalPut)
       ELSE PutImage(x, y, p3^, NormalPut);
 END; (* show_mine *)
 (**********************************************************************)
 (*     PushButton zeichnen                                            *)
 (**********************************************************************)
 PROCEDURE draw_PushButton(x, y: INTEGER; text : STRING);
 VAR
   x1, x2, y1, y2, i             : INTEGER;
 BEGIN

    x1 := x;    x2 := x1 + 105;
    y1 := y;    y2 := y1 +  18;
    SetColor(Black);
    Bar(x1, y1, x2, y2);
    SetFillStyle(SolidFill, LightGray);
    FloodFill(x1+5, y1+5, Black);
    SetColor(White);
    FOR i := 0 TO 0 DO BEGIN
       Line(x1+i,y1+i,x1+i,y2-i);
       Line(x1+i,y2-i,x2-i,y2-i);
    END;
    SetColor(DarkGray);
    FOR i := 0 TO 0 DO BEGIN
       Line(x2-i,y1+i,x2-i,y2-i);
       Line(x1+i,y1+i,x2-i,y1+i);
    END;
    SetColor(Black);
    OutTextXY(x1+9, y1+5, text);

 END; (* draw_pushbutton *)
 (**********************************************************************)
 (*     zu unrecht gesetzte als durchgekreuzte Minen anzeigen          *)
 (**********************************************************************)
 PROCEDURE cross_mine;
 VAR
   x, y                          : INTEGER;
 BEGIN
    x := (xmm-1) * 20 + xmb;
    y := (ymm-1) * 20 + ymb;
    PutImage(x, y, p4^, NormalPut);
 END; (* cross_mine *)
 (**********************************************************************)
 (*     anfangsverarbeitung                                            *)
 (**********************************************************************)
 PROCEDURE all_init;
 CONST
    suchBGI = 'c:\bp\bgi';
 BEGIN
   all_end := FALSE;

  {IF RegisterBGIdriver(@EGAVGADriverProc) < 0
      THEN Abort('EGA/VGA',GraphResult);
   IF RegisterBGIfont(@TriplexFontProc) < 0
      THEN abort('Triplex',GraphResult);
   gmodus   := VGAHi;
   gtreiber := VGA;
   InitGraph(gtreiber, gmodus, suchBGI);
   graphrc := GraphResult;
   IF graphrc <> grok
      THEN Abort('Fehler beim Aufruf Grafiktreiber',graphrc);}

   IF mausinit
      THEN MausPfeilEin
      ELSE BEGIN
           WriteLn('=============');
           WriteLn('Keine Maus da');
           WriteLn('=============');
           REPEAT UNTIL KEYPRESSED;
   END; (*IF*)
   store_symbols;
 END;
 (**********************************************************************)
 (*     schlussverarbeitung                                            *)
 (**********************************************************************)
 PROCEDURE all_schluss;
 BEGIN
   RestoreCrtMode;
   ClrScr;
 END;
 (**********************************************************************)
 (*     Zeitanzeige nachfÅhren                                         *)
 (**********************************************************************)
 PROCEDURE write_time(s : LONGINT);
 VAR
    mausimfeld : BOOLEAN;
    pwt        : POINTER;
    groesse    : WORD;
 BEGIN
   mausimfeld := MausIn(260, 10, 360, 70);
   IF mausimfeld THEN
      MausPfeilAus;
   SetActivePage(1);
   PutImage(260,10,p1^,NormalPut);
   SetTextStyle(DefaultFont,HorizDir,3);
   SetColor(Black);
   Str(s:3,time_str);
   OutTextXY(285,35,time_str);
   groesse := ImageSize(260, 10, 359, 69);
   GetMem(pwt, groesse);
   GetImage(260, 10, 359, 69, pwt^);
   SetActivePage(0);
   PutImage(260, 10, pwt^, NormalPut);
   FreeMem(pwt, groesse);
   SetTextStyle(DefaultFont,HorizDir,1);
   IF mausimfeld THEN
      MausPfeilEin;
 END;
 (**********************************************************************)
 (*     Anzahl Flaggen nachfÅhren                                      *)
 (**********************************************************************)
 PROCEDURE write_mines;
 VAR
    mausimfeld : BOOLEAN;
    pwt        : POINTER;
    groesse    : WORD;
 BEGIN
   mausimfeld := MausIn(10, 10, 160, 70);
(* IF mausimfeld THEN
      MausPfeilAus; *)
   SetActivePage(1);
   PutImage(10, 10, p1^, NormalPut);
   SetTextStyle(DefaultFont, HorizDir, 3);
   SetColor(Black);
   Str(anz_marks:3, mark_str);
   OutTextXY(35, 35, mark_str);
   groesse := ImageSize(10, 10, 159, 69);
   GetMem(pwt,groesse);
   GetImage(10, 10, 159, 69, pwt^);
   SetActivePage(0);
   MausPfeilAus;
   PutImage(10, 10, pwt^, NormalPut);
   FreeMem(pwt, groesse);
   SetTextStyle(DefaultFont, HorizDir, 1);
(* IF mausimfeld THEN *)
      MausPfeilEin;
 END;
 (**********************************************************************)
 (*     Anzahl benachbarte Minen berechnen                             *)
 (**********************************************************************)
 FUNCTION minesaround(x, y : INTEGER):INTEGER;
 VAR
   i                         : INTEGER;
 BEGIN
   i := 0;
   IF mf[x, y] <> min THEN BEGIN
      IF mf[x-1, y-1] = min THEN INC(i);
      IF mf[x-1, y]   = min THEN INC(i);
      IF mf[x-1, y+1] = min THEN INC(i);
      IF mf[x  , y-1] = min THEN INC(i);
      IF mf[x  , y+1] = min THEN INC(i);
      IF mf[x+1, y-1] = min THEN INC(i);
      IF mf[x+1, y]   = min THEN INC(i);
      IF mf[x+1, y+1] = min THEN INC(i);
   END;
   minesaround := i;
 END; (*minesaround*)

 (**********************************************************************)
 (*     Minen im Minenfeld verteilen                                   *)
 (**********************************************************************)
 PROCEDURE set_mines;
 VAR
   anz_mines
                                : INTEGER;
 BEGIN
    RANDOMIZE;
    anz_mines := 0;
    REPEAT
       xmm := RANDOM(19) + 1;
       ymm := RANDOM(14) + 1;
       IF mf[xmm, ymm] <> min
          THEN BEGIN
          mf[xmm, ymm] := min;
                                   { show_mine;}
          INC(anz_mines);
       END;
    UNTIL anz_mines = k_anz_mines;
 END;
 (**********************************************************************)
 (*     Werte der benachbarten Minen eintragen                         *)
 (**********************************************************************)
 PROCEDURE set_numbers;
 BEGIN
   FOR xmm := 1 to 20 DO
      FOR ymm := 1 to 15 DO
          IF mf[xmm, ymm] <> min
             THEN mf[xmm, ymm] := minesaround(xmm, ymm);
 END;
 (**********************************************************************)
 (*     anfangsverarbeitung vor einem spiel                            *)
 (**********************************************************************)
 PROCEDURE game_init;
 VAR
   x,y                           : INTEGER;
 BEGIN
   game_end     := FALSE;
   anz_marks    := 50;
   mark_str_alt := ' ';
   FOR xmm := 0 TO 21 DO
      FOR ymm := 0 TO 16 DO BEGIN
         mf[xmm, ymm]  := 0;
         mf2[xmm, ymm] := 0;
      END;

   MausPfeilAus;

   (* Spielfeld zeichnen *)
   PutImage( 10, 10, p1^, NormalPut);
   PutImage(160, 10, p8^, NormalPut);
   PutImage(260, 10, p1^, NormalPut);

   (* einzelne Minenfelder *)
   FOR xmm := 1 TO 20 DO
      FOR ymm := 1 TO 15 DO
         show_zu(xmm, ymm);

   (* Uhr auf Null stellen *)
   write_time(0);
   GetTime(hhh,mm,ssss,cccc);
   sek0 := ssss + mm*60 + hhh*3600;
   seka := 0;
   (* Minen im Minenfeld verteilen *)
   set_mines;
   (* Anzahl benachbarter Minen in Felder eintragen *)
   set_numbers;
   (* Anzeige Anzahl Minen nachfÅhren*)
   write_mines;
   (* PushButtons zeichnen*)
   Draw_PushButton(450,150,'MAGIC LOGIC');
   Draw_PushButton(450,200,'Ende');
   Draw_PushButton(450,300,'Neues Spiel');
   Draw_PushButton(450,350,'for Silvi');
   Draw_PushButton(450,400,'from Maxli');
   MausPfeilEin;
 END;
 (**********************************************************************)
 (*     endverarbeitung nach einem spiel                               *)
 (**********************************************************************)
 PROCEDURE game_schluss;

 var treffer: integer;

 BEGIN
 treffer:=0;
   MausPfeilAus;
   IF anz_marks > 0 THEN BEGIN
      (* 0815 Gesicht *)
      PutImage(160, 10, p9^, NormalPut);

      (* Alle Minen Anzeigen *)
      FOR xm := 1 TO 20 DO
         FOR ymm := 1 TO 15 DO BEGIN
             IF mf[xmm, ymm] = min
                THEN show_mine;
             IF (mf[xmm, ymm] <> min) AND (mf2[xmm, ymm] = marked)
                THEN cross_mine;
         END; (* FOR *)
   END  (* THEN *)
   ELSE BEGIN
          FOR xmm := 1 TO 20 DO
          FOR ymm := 1 TO 15 DO
          begin
            IF (mf[xmm, ymm] = min) AND (mf2[xmm, ymm] = marked)
            then
            treffer:=treffer+1;
          end;
            if treffer = 50 then
            begin
               FOR xg := 1 TO 200 DO
               PutImage(xg*2, xg*2, p8^, NormalPut);
               SetTextStyle(SansSerifFont, HorizDir, 3);
               SETTEXTJUSTIFY (CenterText, BottomText);
               OUTTEXTXY (xg*2, xg*2, '  be yourself');
            end;
        END; (* IF *)
   MausPfeilEin;
(* GoToXY(5,23);
   WriteLn('Noch ein Spielchen?   (J/N)');  eingabe := ' ';
   REPEAT
      IF KeyPressed THEN eingabe := UPCASE(ReadKey);
      IF MausKey = 1 THEN eingabe := 'J';
      IF MausKey = 2 THEN eingabe := 'N';
   UNTIL eingabe IN ['J','N'];
   IF eingabe = 'N'
      THEN all_end := TRUE
      ELSE all_end := FALSE; *)
   REPEAT
   UNTIL mauskey > 0;
   IF MausIn(450,200,600,250)
      THEN all_end := TRUE;
 END; (* game_schluss *)
 (**********************************************************************)
 (*     mitlaufende Uhr nachfÅhren                                     *)
 (**********************************************************************)
 PROCEDURE time_test;
 BEGIN
   GetTime(hhh,mm,ssss,cccc);
   sek := ssss + mm*60 + hhh*3600 - sek0;
   IF sek > seka THEN BEGIN
      write_time(sek);
      seka := sek;
   END; (* IF *)
 END;
 (**********************************************************************)
 (*     Feld als Mine kennzeichnen                                     *)
 (**********************************************************************)
 PROCEDURE mark_mine;
 VAR
   x, y                          : INTEGER;
 BEGIN
    IF mf2[xmm, ymm] = zu
      THEN BEGIN
            x := (xmm-1) * 20 + xmb;
            y := (ymm-1) * 20 + ymb;
            PutImage(x, y, p7^, NormalPut);

            mf2[xmm, ymm] := marked;
            DEC(anz_marks);
    END; (* IF *)
 END; (* mark_mine *)
 (**********************************************************************)
 (*     Flagge entfernen                                               *)
 (**********************************************************************)
 PROCEDURE mark_weg;
 VAR
   x, y                          : INTEGER;
   anz_str                       : STRING;
 BEGIN
    IF mf2[xmm, ymm] = marked
       THEN BEGIN
            show_zu(xmm, ymm);
            mf2[xmm, ymm] := zu;
            INC(anz_marks);
    END;
 END; (* Flagge weg *)
 (**********************************************************************)
 (*     Feld aufdecken                                                 *)
 (**********************************************************************)
 PROCEDURE aufdecken(xma, yma: INTEGER);           {rekursion !}
 VAR
   x, y                          : INTEGER;
   anz_str                       : STRING;
 BEGIN
    IF (xma >=  1) AND
       (xma <= 20) AND
       (yma >=  1) AND
       (yma <= 15)
       THEN
            IF mf[xma, yma] = min
               THEN game_end := TRUE
               ELSE IF mf2[xma, yma] = zu
                       THEN BEGIN
                            x := (xma-1) * 20 + xmb;
                            y := (yma-1) * 20 + ymb;
                            mf2[xma, yma] := offen;
                            show_offen(xma, yma);
                            IF mf[xma, yma] = 0
                               THEN BEGIN
                                    IF mf2[xma-1, yma-1] = zu THEN
                                       aufdecken(xma-1, yma-1);
                                    IF mf2[xma-1, yma] = zu THEN
                                       aufdecken(xma-1, yma);
                                    IF mf2[xma-1, yma+1] = zu THEN
                                       aufdecken(xma-1, yma+1);
                                    IF mf2[xma, yma-1] = zu THEN
                                       aufdecken(xma,   yma-1);
                                    IF mf2[xma, yma+1] = zu THEN
                                       aufdecken(xma,   yma+1);
                                    IF mf2[xma+1, yma-1] = zu THEN
                                       aufdecken(xma+1, yma-1);
                                    IF mf2[xma+1, yma] = zu THEN
                                       aufdecken(xma+1, yma);
                                   IF mf2[xma+1, yma+1] = zu THEN
                                       aufdecken(xma+1, yma+1);
                               END
                            ELSE BEGIN
                                    Str(mf[xma, yma]:1,anz_str);
                                    OutTextXY(x+9,y+9,anz_str);
                            END;
                    END;
 END; (* aufdecken *)
 (**********************************************************************)
 (*     eingaben einlesen                                              *)
 (**********************************************************************)
 PROCEDURE read_input;
 BEGIN
   IF KEYPRESSED
      THEN BEGIN
           eingabe := ReadKey;
           CASE eingabe OF
            #27: BEGIN game_end := TRUE; all_end := TRUE END;
            'm': mark_mine;
            'a': aufdecken(xmm, ymm);
            '4': dec(xmm);
            '6': inc(xmm);
            '8': dec(ymm);
            '2': inc(ymm);
           END; (*CASE*)
   END; (*IF*)
   IF mausda THEN BEGIN
      maustaste := lastmauskey;
      MausPos(mx, my);
      IF MausIn(10,70,410,370)
         THEN BEGIN
            xmm := 1 + ((mx-10) DIV 20);
            ymm := 1 + ((my-70) DIV 20);
      END;
      IF maustaste <> 0 THEN BEGIN
         MausPfeilAus;
         CASE maustaste OF
            1 :  BEGIN
                    IF MausIn(160,10,260,70)
                       THEN game_end := TRUE;
                    IF MausIn(10,70,410,370)
                       THEN aufdecken(xmm, ymm);
                    IF MausIn(450,300,600,350)
                       THEN game_end := TRUE;
                    IF MausIn(450,200,600,250)
                       THEN BEGIN game_end := TRUE; all_end := TRUE END;
                 END;
            2 :  BEGIN
                    IF mf2[xmm, ymm] = marked
                        THEN mark_weg
                        ELSE mark_mine;
                    write_mines;
                 END;
            3 :  game_end := TRUE;
            4 :  game_end := TRUE;
         END;  (*CASE*)
         MausPfeilEin;
      END; (*IF*)
   END; (*IF*)
   IF anz_marks = 0 THEN
      game_end := TRUE;
 END; (* read_input *)

 procedure finface;
    BEGIN
      FOR xg := 1 TO 200 DO
         PutImage(xg*2, xg*2, p8^, NormalPut);
         SetTextStyle(SansSerifFont, HorizDir, 3);
         SETTEXTJUSTIFY (CenterText, BottomText);
    OUTTEXTXY (xg*2, xg*2, '  Hi Chaosmax');
        END; (* IF *)





procedure dosmine;
begin
 (**********************************************************************)
 (*     Hauptsteuerung                                                 *)
 (**********************************************************************)
 cleardevice;
 All_init;
  { finface;}
   REPEAT
      Game_init;
      REPEAT
         time_test;
         read_input;
      UNTIL game_end;
      IF NOT all_end THEN game_schluss;
   UNTIL all_end;
   {all_schluss;}
 END;

 { repeat
    bs:=0;
    settextstyle(triplexfont,horizdir,4);
    if maxcolor>1 then setcolor(14);
    outtextxy(5*xw,9*yw,'Na ja, hab ich`s mir doch gedacht... ');
    getposbut(bs,horiz,vert);
  until bs=2;
end;}

procedure TON(Octave,Note: integer);
var Frequency : real;
    I         : integer;
begin
  Frequency := 32.625;
  for I := 1 to Octave do                { Compute C in Octave             }
  Frequency := Frequency * 2;
  for I := 1 to Note - 1 do              { Increase frequency Note-1 times }
  Frequency := Frequency * 1.059463094;
  Sound(Round(Frequency));
end;


procedure bye;
begin
  cleardevice;
    TON(2,ee); delay(500); nosound;
    TON(2,aa); delay(400); nosound;
    TON(3,dd); delay(300); nosound;
    TON(3,gg); delay(200); nosound;
    TON(3,hh); delay(100); nosound;
    TON(4,ee); delay(100); nosound;
    TON(2,ee); delay(500); nosound;
    TON(2,aa); delay(400); nosound;
    TON(3,dd); delay(300); nosound;
    TON(3,gg); delay(200); nosound;
    TON(3,hh); delay(100); nosound;
    TON(4,ee); delay(100); nosound;

  repeat
    bs:=0;
    settextstyle(triplexfont,horizdir,10);
    if maxcolor>1 then setcolor(14);
    outtextxy(1*xw,4*yw,'MEGA MAX');
    settextstyle(triplexfont,horizdir,6);
    outtextxy(22*xw,20*yw,'wish you...');
    getposbut(bs,horiz,vert);
  until bs=2;
end;


begin {menu}

  window(1,1,80,25);
  textcolor(15);
  textbackground(1);
  clrscr;
  {c.off;}
  {repeat
    gotoxy(32,6);
    writeln('N o n l i n e a r');
    gotoxy(25,7);
    writeln('D y n a m i c a l  S y s t e m s');
    gotoxy(39,9); writeln('by');
    gotoxy(33,11);
    writeln('   MAGIC ///');
    gotoxy(33,12);
    writeln('  /// LOGIC ');
  until keypressed;}
  if not driverinstalled then
  begin
    writeln;
    writeln('Mouse Driver not loaded');
    writeln('Bitte mouse.com in Autoexec.bat laden');
    writeln;
    halt(1)
  end;
  registrieren;
  initialize;
  repeat
  cleardevice;
  if maxcolor>1 then
  begin
    setbkcolor(1);
    setcolor(11)
  end;
  settextstyle(triplexfont,horizdir,4);
  gotoxy(1,9); writeln(#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3,
  #3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3,
  #3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3#3);
  outtextxy(12*xw,round(27*maxy),' CHAOS MIND and LOVE ! ');
  outtextxy(12*xw,round(30*maxy),'__________________________');
  settextstyle(triplexfont,horizdir,3);
  outtextxy(12*xw,round(71*maxy),'               by MagicLogic');
  settextstyle(triplexfont,horizdir,3);
  if maxcolor>1 then setcolor(14);
  outtextxy(18*xw,9*yw,'Dynamic Chaos ');
  outtextxy(18*xw,11*yw,'Virtual World');
  outtextxy(18*xw,13*yw,'Randomwalk Love');
  outtextxy(18*xw,15*yw,'Fractal Attraction');
  outtextxy(18*xw,17*yw,'Digital Freedom');
  if maxcolor>1 then setcolor(12);
  outtextxy(13*xw,21*yw,'Stop the Show');
  if maxcolor>1 then setcolor(10);
  outtextxy(13*xw,24*yw-2*xw,
  'Mouse left to choice, right to continue');
  if keypressed then
  begin
    if readkey=#27 then exit;
  end;
  putpoint;                            {get mouse position as global}
  menu:=(((vert div yw) - 5) div 2);
  {esc:=readkey;}
  if menu<= 8 then
  begin
    case menu of
        2: logistic_map;
        3: virtual_land;
        4: begin
           walki;
           end;
        5: lorenz;
        6: dosmine;
        8: bye;
    end;
  end;
  until (menu>=8) or (esc in ['q','Q',#32]);
 closegraph;
end.
