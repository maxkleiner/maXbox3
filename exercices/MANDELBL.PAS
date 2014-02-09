{Mandelbrot Set; choose cut with mouse. ES 14.5.90}
uses crt,dos,graph;
label cont,new;
var mx,my,m,n,nmax,s,f,row,column,
    graphdriver,graphmode,xmax,ymax,ym,
    left,heit,m5,xw,yw,ix,iy  : integer;
    zx,magn2,x,y,cx,cy,dx,dy,xi,xf,yi,yf,
    xg,xj,yg,yj,zy : extended;
    colr,maxcolor  : word;
    ch     : char;
    cross  : pointer;
    status, noButtons, ks, horiz, vert  : Integer;
    regs   : registers;
    ss     : string;

procedure init;
begin
  textcolor(white);
  textbackground(blue);
  clrscr;
  writeln('Mandelbrot Set:     z(n+1) = z(n)*z(n) + c');
  writeln('------------------------------------------');
  writeln;
  writeln('Startvalues for total set in parentheses; you may');
  writeln('always interrupt with <cr> and choose a cut with');
  writeln('help of the mouse.');
  writeln;
  write('Real part of      c(min). (-2.06) ...... '); readln(xi);
  write('Imaginary part of c(min). (-1.32) ...... '); readln(yi);
  writeln;
  write('Real part of      c(max). ( 1.05) ...... '); readln(xf);
  write('Imaginary part of c(max). ( 1.32) ...... '); readln(yf);
  writeln;
  write('Maximal number of Iterations (e.g. 32) . '); readln(nmax);
  graphdriver:=detect;
  initgraph(graphdriver,graphmode,'tur\bgi');
  xmax:=getmaxx;  ymax:=getmaxy; xmax:=round(xmax*0.8844);
  yw:=round(16*getmaxy/399);
  xw:=8;
  dx:=(xf-xi)/xmax;
  dy:=(yf-yi)/ymax;
  left:=0;  heit:=479;
  m5:=round(5*getmaxy/399);
  maxcolor:=getmaxcolor
end;

procedure sprites;
const startx =100;
      starty = 80;
var i,ix,iy: integer;
    ulx,uly,lrx,lry,size : word;
begin
  setcolor(white);
  ix := startx; iy := starty;
  line(ix-5,iy,ix+5,iy);
  line(ix,iy-m5,ix,iy+m5);
  ulx:=ix-5; uly:=iy-m5;
  lrx:=ix+5; lry:=iy+m5;
  size:=imagesize(ulx,uly,lrx,lry);
  getmem(cross,size);
  getimage(ulx,uly,lrx,lry,cross^);
  putimage(ulx,uly,cross^,XORput);
end;

Procedure flush;
begin
  with regs do
    begin
      ax := $0c00;
      MsDos(regs);
    end;
end;

procedure erasetxt(iu,iv,iw:integer);
begin
  setfillstyle(emptyfill,0);
  bar(iu,iv-(textheight('m')),iw,iv+6)
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
  else
    driverinstalled := false
end;

procedure flagreset(var mousestatus, numberofbuttons:integer);
    { microsoft mouse driver system call 0
          input : ax = 0 system call 0

          output: ax --> mouse status
                   0 (false): mouse hardware and software
                              not installed
                  -1 (true) : mouse hardware and software
                              installed
                  bx --> number of mouse buttons
    }
var regset : registers;
begin
   regset.ax := 0;
   intr (51, regset);
   if regset.ax=65535 then mousestatus:=-1
                      else mousestatus:=0;
   numberofbuttons := regset.bx;
end;

procedure showcursor;
    { microsoft mouse driver system call 1
          input : ax = 1 system call 1
    }
var
  regset : registers;
begin
  regset.ax := 1;
  intr (51, regset);
end;

procedure hidecursor;
    { microsoft mouse driver system call 2
          input : ax = 2 system call 2
    }
var
  regset : registers;
begin
  regset.ax := 2;
  intr (51, regset);
end;

procedure getposbut(var buttonstatus, horizontal, vertical:integer);
    { microsoft mouse driver system call 3
          input : ax = 3 system call 3

          output: bx --> mouse button status
                  cx --> horizontal cursor position
                  dx --> vertical cursor position
    }
var
  regset : registers;
begin
  regset.ax := 3;
  intr (51, regset);
  horizontal := regset.cx;
  vertical := regset.dx;
  buttonstatus := regset.bx
end;

procedure putpoint;
var col : word;
    ii  : integer;
    rt  : array[1..2] of extended;
begin
  FlagReset (status, noButtons);
  ii:=0;
  ks:=0;
  col:=getcolor;
  if maxcolor>1 then setcolor(yellow) else setcolor(1);
  repeat
    if ii<>0 then putimage(ix-5,iy-m5,cross^,XORput);
    GetPosBut (ks, ix, iy);
    putimage(ix-5,iy-m5,cross^,XORput);
    rt[1] := (xf-xi)*(ix-left)/xmax + xi;
    str(rt[1]:9:6,ss);
    erasetxt(71*xw,7*yw,80*xw); outtextxy(71*xw,7*yw,ss);
    rt[2] := (yf-yi)*(heit-iy)/ymax + yi;
    str(rt[2]:9:6,ss);
    erasetxt(71*xw,8*yw,80*xw); outtextxy(71*xw,8*yw,ss);
    inc(ii);
  until ks=1;
  setcolor(col);
  flush;
  FlagReset (status, noButtons);
end;

procedure box(x1,y1,x2,y2:integer);{x1,y1,x2,y2 : diagonal }
begin
  setwritemode(xorput);
  rectangle(x1,y1,x2,y2);
  setwritemode(copyput)
end;

procedure pcross;                   {moveable cross}
var ii       : integer;
    rx,ry    : extended;
begin
  if maxcolor>1 then setcolor(lightmagenta);
  outtextxy(71*xw,2*yw,'Click');
  outtextxy(71*xw,3*yw,'left but.');
  outtextxy(71*xw,4*yw,'to select');
  outtextxy(71*xw,5*yw,'point.');
  if maxcolor>1 then setcolor(yellow);
  putpoint;
  outtextxy(71*xw,11*yw,'Selct box');
  outtextxy(71*xw,12*yw,'w/ mouse');
  if maxcolor>1 then setcolor(lightmagenta);
  outtextxy(71*xw,13*yw,'Stop with');
  outtextxy(71*xw,14*yw,'right but');
  if maxcolor>1 then setcolor(yellow);
  ks:=0;  ii:=0;
  regs.AX := 4;
  regs.CX := ix-20;
  regs.DX := iy-20;
  intr (51, regs);
  repeat
    getposbut(ks,horiz,vert);
    if ii<>0 then box(ix-mx,iy-my,ix+mx,iy+my);  {erase box}
    inc(ii);
    if maxcolor>1 then setcolor(yellow) else setcolor(1);
    mx:=abs(ix-horiz); my:=round(0.84806*mx);
    box(ix-mx,iy-my,ix+mx,iy+my);                {plot box}
  until ks=2;
  xj := (xf-xi)*(ix-mx-left)/xmax + xi;  {new frame dimensions }
  xg := (xf-xi)*(ix+mx-left)/xmax + xi;
  yj := (yf-yi)*(heit-iy-my)/ymax + yi;
  yg := (yf-yi)*(heit-iy+my)/ymax + yi;
  Flush;
  box(ix-mx,iy-my,ix+mx,iy+my);                  {plot box}
end;   {pcross}

procedure new_frame;
begin
  if maxcolor>1 then setcolor(lightgreen);
  moveto(71*xw,16*yw); outtext('New frame');
  outtextxy(73*xw,17*yw,'touch');
  rectangle(73*xw,17*yw-m5,78*xw,18*yw-m5);
  if maxcolor>1 then setcolor(yellow);
  moveto(71*xw,19*yw); outtext('End Mbrot');
  outtextxy(73*xw,20*yw,'touch');
  rectangle(73*xw,20*yw-m5,78*xw,21*yw-m5);
  flagreset(status,nobuttons);
  ks:=0; flush; showcursor;
  repeat
    getposbut(ks,horiz,vert);
  until ((vert=17*yw) or (vert=20*yw))
    and ((horiz>73*xw) and (horiz<78*xw));
  if (vert div yw)=17 then
    begin
      flush;  flagreset(status,nobuttons);
      xi := xj;  xf := xg;
      yi := yj;  yf := yg;
    end;
    hidecursor;
end;

begin {main}
  init;
  sprites;
  if driverinstalled=false then begin
    restorecrtmode;
    writeln('Mousedriver not installed !');
    Halt(0)
  end;
  repeat
    if yi=-1.32 then ym:=ymax div 2 else ym:=ymax;
    for row:=ym downto 0 do begin          {This is the essential iteration }
      cy:=yi+row*dy;                   {loop:     z <- zý + c           }
      for column:=0 to xmax do begin   { c = cx + i*cy is scanned over  }
        cx:=xi+column*dx;              { the real axis x, and imaginary }
        zx:=0.0; zy:=0.0;              { axis y; n = iteration counter  }
        magn2 :=0.0;  n:=0;
        while magn2<100 do begin       {This is the iteration proper:   }
          x:=zx; y:=zy;                { z <- zý + c;  zý = (x + i*y)ý =}
          zx:=sqr(x)-sqr(y)+cx;        { = xý-yý+2xyi; zx is real part  }
          zy:=2*x*y+cy;                { zy is imaginary part           }
          magn2:=sqr(zx)+sqr(zy);      { this is absolute value squared,}
          inc(n);                      { goes to ì as attractor, count  }
          if n=nmax then goto cont;    { iterations till limit lim is   }
        end; {while}                   { overtaken by magn2. 4<lim<100  }
        {if n<nmax then begin
          colr:=(n mod 15)+1;}          { 15 colorts, cyclicly }
          {putpixel(column,heit-row,colr);
          if yi=-1.32 then putpixel(column,row,colr);} {symmetric set}
        {end;}
        cont:
        if n=nmax then begin
          putpixel(column,heit-row-1,14);
          if yi=-1.32 then putpixel(column,row,14)
        end;
        if keypressed then begin
          ch:=readkey;
          goto new
        end
      end {column}
    end; {row}
    sound(392); delay(300);            {announce end of drawing }
    nosound;    delay(80);             {more music follows:}
    {sound(392); delay(80);
    nosound;    delay(80);
    sound(523); delay(600);
    nosound;    delay(300);
    sound(523); delay(80);
    nosound;    delay(80);
    sound(523); delay(80);
    nosound;    delay(80);
    sound(523); delay(80);
    nosound;    delay(80);
    sound(786); delay(800);
    nosound}
    new:
    pcross;                            {now you may choose a cut }
    new_frame;
    dx:=(xf-xi)/xmax;                  {defines the increments in}
    dy:=(yf-yi)/ymax;                  {the new coordinates      }
    cleardevice;
  until (vert div yw)=20;
  closegraph
end.
