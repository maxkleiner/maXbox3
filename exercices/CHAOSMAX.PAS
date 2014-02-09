program Chaos;

uses
       Dos, Crt, Graph,
       Cursor1, Zeit1,                             {eigne units}
       Bgidriv, Bgifont;

       (* Zeichensaetze und Grafiktreiber werden in Objektcode genommen *)


var
  graphdriver : integer;  { the graphics device driver }
  graphmode   : integer;  { the graphics mode value }
  maxy        : extended; { the maximum resolution of the screen }
  errorcode   : integer;  { reports any graphics errors }
  maxcolor    : word;     { the maximum color value available }
  ch          : char;
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
  C           : Cursor;
  sss,z       : Integer;
    Pi2       : real;
    xr, yr    : real;
  xxx,yyy,k   : integer;
    Amplitude : real;
    yNull     : real;                   (* Bildschirmmitte *)
    xBreite   : integer;                (* Pixelbreite von 1 x auf Schirm *)
    yBreite   : integer;


type
     WeltZeit = object(zeit)                    {inheritance,heredity !!}
         CityName: String[16];
          TOffset: Integer;
            Zeile: Integer;
           Spalte: Integer;
        procedure  SetCityTime(NewCityName:String;
                               NewTOffset,NewSpalte,NewZeile:Integer);
        procedure  ShowCityTime;
     end;




procedure initialize;
begin
  directvideo := false;
  clrscr;
  graphdriver := detect;                             { use autodetection }
  initgraph(graphdriver, graphmode, 'tur\bgi');      { activate graphics }
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
    { "Registrierung" aller Zeichens„tze (aus FONTS.TPU) }
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
  outtextxy(68,2,'Logistic Map and Graphic Iteration ');
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
    for j:=1 to 800 do x:=r*x*(1-x);
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
  outtextxy(230,2,'Ljapunov Exponent');
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
  outtextxy(369,round(126*maxy),'rì');
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
  outtextxy(200,2,'1st Enlargement');
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
  outtextxy(200,2,'1st Enlargement');
  setcolor(white);
  outtextxy(396,2,'Ljapunov Exponent');
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
  outtextxy(200,2,'2nd Enlargement');
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
  outtextxy(50,round(283*maxy),'f(æ,x) = 1 - æxý');
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
  outtextxy(560,round(378*maxy),'æ');
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
    outtextxy(20*xw,3*yw,'Chaos Total');
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
    setcolor(col);
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


{*********************************Timelove*******************************}

procedure WeltZeit.SetCityTime(NewCityName: String;
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
  
procedure timelove;
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
 C.On;
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

procedure sex;
begin
  cleardevice;
  repeat
    bs:=0;
    settextstyle(triplexfont,horizdir,4);
    if maxcolor>1 then setcolor(14);
    outtextxy(5*xw,9*yw,'Na ja, hab ich`s mir doch gedacht... ');
    getposbut(bs,horiz,vert);
  until bs=2;
end;

procedure bye;
begin
  cleardevice;
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
  c.off;
  repeat
    gotoxy(32,6);
    writeln('N o n l i n e a r');
    gotoxy(25,7);
    writeln('D y n a m i c a l  S y s t e m s');
    gotoxy(39,9); writeln('by');
    gotoxy(33,11);
    writeln('   MAGIC ///');
    gotoxy(33,12);
    writeln('  /// LOGIC ');
  until keypressed;
  if not driverinstalled then
  begin
    writeln;
    write ('Mouse Driver not loaded');
    writeln;
    halt(1)
  end;
  initialize;
  registrieren;
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
  outtextxy(12*xw,round(27*maxy),' CHAOS');
  outtextxy(12*xw,round(30*maxy),'__________________________');
  outtextxy(12*xw,round(71*maxy),'       and LOVE');
  settextstyle(triplexfont,horizdir,3);
  if maxcolor>1 then setcolor(14);
  outtextxy(18*xw,9*yw,'Love and Chaos ');
  outtextxy(18*xw,11*yw,'Time, Love and Chaos');
  outtextxy(18*xw,13*yw,'Randomwalk and Love');
  outtextxy(18*xw,15*yw,'Hate, Love and Chaos');
  outtextxy(18*xw,17*yw,'Sex and Chaos');
  if maxcolor>1 then setcolor(12);
  outtextxy(13*xw,21*yw,'Stop the Show');
  if maxcolor>1 then setcolor(10);
  outtextxy(13*xw,24*yw-2*xw,
  'Mouse left to choice, right to continue');
  putpoint;
  menu:=(((vert div yw) - 5) div 2);
  if menu<= 8 then
  begin
    case menu of
        2: logistic_map;
        3: timelove;
        4: begin
           walki;
           end;
        5: lorenz;
        6: sex;
        8: bye;
    end;
  end;
  until menu>=8;
  closegraph;
end.
