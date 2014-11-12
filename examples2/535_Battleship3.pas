unit battleshiptUnit1;
//test drive 14
  //TODO: implement the file transfer stt to open dialog and save file
  

interface

{uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, StdCtrls, Buttons, XPMan, ExtDlgs;}

type
  mas1 = array[-1..10] of integer;
  mas = array[-1..10] of mas1;
  rmas1 = array[0..9]of real;
  rmas = array[0..9]of rmas1;
  //TfmBattle = class(TForm)
  var  
    pnFields: TPanel;
    myField: TImage;
    cField: TImage;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Panel3: TPanel;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    bbOK: TBitBtn;
    bbRe: TBitBtn;
    pnSet: TPanel;
    Label2: TLabel;
    cbF: TCheckBox;
    RadioGroup2: TRadioGroup;
    bbOkSet: TBitBtn;
    lbName: TLabel;
    Label3: TLabel;
    leName: TLabeledEdit;
    pnMes: TPanel;
    N9: TMenuItem;
    //XPManifest1: TXPManifest;
    pnLegend: TPanel;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Auto: TBitBtn;
    aMemo1: TMemo;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    rbF: TRadioButton;
    rbS: TRadioButton;
    rb3: TRadioButton;
    rb2: TRadioButton;
    rb1: TRadioButton;
    Panel4: TPanel;
    Shape1: TShape;
    Shape2: TShape;
    rbV: TRadioButton;
    rbG: TRadioButton;
    rb4: TRadioButton;
    lbMes: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure myFieldMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bbReClick(Sender: TObject);
    procedure bbOKClick(Sender: TObject);
    procedure bbOkSetClick(Sender: TObject);
    procedure cFieldMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N8Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure AutoClick(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N3Click(Sender: TObject);

  //private
    { Private declarations }
  //public
    { Public declarations }
  //end;

var
  fmBattle: TForm; //TfmBattle;
  A,B,C:mas;
  D:rmas;
  Sh,Ch,ds:array[1..4]of integer;
  p,strg:integer;
  flag,nol:boolean;
  ds1,ds2:integer;
  State:integer;
  y,z,napr,o,pp,kp:integer;
  S: Set of byte;
  //stt:File of rmas;
  stt: file;

implementation

//{$R *.dfm}

procedure InitMas(var A,B,C:mas);
var i,j:integer;
begin
  for i:=-1 to 10 do
    for j:=-1 to 10 do begin
        A[i][j]:=0;
        B[i][j]:=0;
        C[i][j]:=0;
      end;
  for i:=1 to 4 do begin
      Sh[i]:=5-i;
      Ch[i]:=5-i;
      Ds[i]:=5-i;
    end;
  p:=0;
  For j:=-1 to 10 do begin
      C[-1][j]:=-5;
      C[j][-1]:=-5;
    end;
end;

function check1(k,l,d,b:integer;A:mas):boolean;
var f:boolean;
    i,j:integer;
begin
  f:=TRUE;
  Case b of
    1:begin
        f:=True;
        i:=k-1;
        while f and (i<=k+d+1) do begin
            j:=l-1;
            while f and (j<=l+1) do begin
                f:=(A[j][i]=0);
                j:=j+1;
              end;
            i:=i+1;
          end;
      end;
    2:begin
        f:=True;
        j:=l-1;
        while f and (j<=l+d+1) do begin
            i:=k-1;
            while f and (i<=k+1) do begin
                f:=(A[j][i]=0);
                i:=i+1;
              end;
            j:=j+1;
          end;
      end;
  end;
  result:=f;
end;

function check2(k,l,d,b:integer):boolean;
var f:boolean;
begin
  f:=TRUE;
  Case b of
    1:f:=(k+d<=9);
    2:f:=(l+d<=9);
  end;
  result{check2}:=f;
end;

function check3(d:integer):boolean;
begin
  result:=(Sh[d+1]>0);
end;

procedure GetB(var B:mas);
var k,l,i,j,t,p:integer;
    f1,f2,f3,f4:boolean;
begin
  Randomize;
  f1:=False;
  f2:=False;
  f3:=False;
  f4:=False;
  repeat
    k:=Random(10);
    l:=Random(10);
    p:=Random(2)+1;
    if check1(k,l,3,p,B)and check2(k,l,3,p)
       then
        begin
          Case p of
            1: for t:=k to k+3 do
                 B[l][t]:=4;
            2: for t:=l to l+3 do
                 B[t][k]:=4;
          end;
          dec(Ch[4]);
          f4:=True;
        end;
  until f4;

  for i:=1 to 2 do
    begin
      f3:=False;
      Repeat
        k:=Random(10);
        l:=Random(10);
        p:=Random(2)+1;
        if check1(k,l,2,p,B)and check2(k,l,2,p)
           then
            begin
              Case p of
                1: for t:=k to k+2 do
                     B[l][t]:=3;
                2: for t:=l to l+2 do
                     B[t][k]:=3;
              end;
              dec(Ch[3]);
              f3:=True;
            end;
      until f3;
    end;

    for i:=1 to 3 do
    begin
      f2:=False;
      Repeat
        k:=Random(10);
        l:=Random(10);
        p:=Random(2)+1;
        if check1(k,l,1,p,B)and check2(k,l,1,p)
           then
            begin
              Case p of
                1: for t:=k to k+1 do
                     B[l][t]:=2;
                2: for t:=l to l+1 do
                     B[t][k]:=2;
              end;
              dec(Ch[2]);
              f2:=True;
            end;
      until f2;
    end;

  for i:=1 to 4 do begin
      f1:=False;
      Repeat
        k:=Random(10);
        l:=Random(10);
        p:=Random(2)+1;
        if check1(k,l,0,p,B)and check2(k,l,0,p)
           then
            begin
              Case p of
                1: B[l][k]:=1;
                2: B[l][k]:=1;
              end;
              dec(Ch[1]);
              f1:=True;
            end;
      until f1;
    end;
end;

function mru(k,l:integer;B:mas):integer;
begin
  if (B[l][k]<=0)
     then
      result:=0;
  if (B[l][k]>0)
     then
      result:=1;
end;

procedure FormActivate(Sender: TObject);
var i,j:integer;
begin
  if Fileexists('f1.stt')
    then
     begin
  AssignFile(stt,'f1.stt');
  Reset(stt);
  //Read(stt,D);
  CloseFile(stt);
     end
    else
     for i:=0 to 9 do
       for j:=0 to 9 do
         D[i][j]:=0;
  nol:=true;
  shape5.Brush.Color:=rgb(238,180,34);
  shape6.Brush.Color:=rgb(205,38,38);
  for i:=0 to 210 do
   for j:=0 to 210 do begin
      myField.Canvas.Pixels[i,j]:=clAqua;
      cField.Canvas.Pixels[i,j]:=clAqua;
     end;
  for j:=0 to 210 do
    begin
      myField.Canvas.Pixels[j,0]:=clNavy;
      myField.Canvas.Pixels[0,j]:=clNavy;
      cField.Canvas.Pixels[j,0]:=clNavy;
      cField.Canvas.Pixels[0,j]:=clNavy;
      myField.Canvas.Pixels[j,209]:=clNavy;
      myField.Canvas.Pixels[209,j]:=clNavy;
      cField.Canvas.Pixels[j,209]:=clNavy;
      cField.Canvas.Pixels[209,j]:=clNavy;
    end;
  i:=21;
  While i<=210 do
    begin
      For j:=1 to 210 do begin
          myField.Canvas.Pixels[i,j]:=clNavy;
          cField.Canvas.Pixels[i,j]:=clNavy;
          myField.Canvas.Pixels[j,i]:=clNavy;
          cField.Canvas.Pixels[j,i]:=clNavy;
        end;
      i:=i+21;
    end;
  InitMas(A,B,C);
  GetB(B);
  ds1:=0;
  ds2:=0;
  S:=[];
  o:=1;
  pp:=2;
end;



procedure myFieldMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

var i,j,k,l,t,d:integer;
begin
   k:=X div 21;
   l:=Y div 21;
   d:=3;
   If rb4.Checked
      then
       d:=3;
   If rb3.Checked
      then
       d:=2;
   If rb2.Checked
      then
       d:=1;
   If rb1.Checked
      then
       d:=0;

   If rbG.Checked
      then
       begin
         if check1(k,l,d,1,A)and check2(k,l,d,1)and check3(d)
            then begin
               for i:=k*21+1 to (k+d)*21+20 do
                 for j:=l*21+1 to l*21+20 do
                   if myField.Canvas.Pixels[i,j]<>clNavy
                      then
                       myField.Canvas.Pixels[i,j]:=clTeal;
               for t:=k to k+d do
                 A[l][t]:=d+1;
               p:=p+1;
               dec(Sh[d+1]);
               if Sh[d+1]=0
                  then
                   Case d of
                     0:rb1.Enabled:=False;
                     1:rb2.Enabled:=False;
                     2:rb3.Enabled:=False;
                     3:rb4.Enabled:=False;
                   end;
             end;
       end
      else
         begin
           if check1(k,l,d,2,A)and check2(k,l,d,2)and check3(d)
              then
               begin
                 for i:=k*21+1 to k*21+20 do
                   for j:=l*21+1 to (l+d)*21+20 do
                     if myField.Canvas.Pixels[i,j]<>clNavy
                        then
                         myField.Canvas.Pixels[i,j]:=clTeal;
                 for t:=l to l+d do
                   A[t][k]:=d+1;
                 p:=p+1;
                 dec(Sh[d+1]);
                 if Sh[d+1]=0
                  then
                   Case d of
                     0:rb1.Enabled:=False;
                     1:rb2.Enabled:=False;
                     2:rb3.Enabled:=False;
                     3:rb4.Enabled:=False;
                   end;
               end;
         end;
    If p=10
       then
        bbOK.Enabled:=True;
end;

procedure bbReClick(Sender: TObject);
var i,j:integer;
begin
  for i:=0 to 210 do
   for j:=0 to 210 do
     begin
       myField.Canvas.Pixels[i,j]:=clAqua;
       cField.Canvas.Pixels[i,j]:=clAqua;
     end;
  for j:=0 to 210 do
    begin
      myField.Canvas.Pixels[j,0]:=clNavy;
      myField.Canvas.Pixels[0,j]:=clNavy;
      cField.Canvas.Pixels[j,0]:=clNavy;
      cField.Canvas.Pixels[0,j]:=clNavy;
      myField.Canvas.Pixels[j,209]:=clNavy;
      myField.Canvas.Pixels[209,j]:=clNavy;
      cField.Canvas.Pixels[j,209]:=clNavy;
      cField.Canvas.Pixels[209,j]:=clNavy;
    end;
  i:=21;
  While i<=210 do begin
      For j:=1 to 210 do begin
          myField.Canvas.Pixels[i,j]:=clNavy;
          cField.Canvas.Pixels[i,j]:=clNavy;
          myField.Canvas.Pixels[j,i]:=clNavy;
          cField.Canvas.Pixels[j,i]:=clNavy;
        end;
      i:=i+21;
    end;
  InitMas(A,A,C);
  rb1.Enabled:=True;
  rb2.Enabled:=True;
  rb3.Enabled:=True;
  rb4.Enabled:=True;
  rb4.Checked:=True;
  bbOK.Enabled:=False;
  Auto.Enabled:=True;
end;

procedure FindDead(d:integer;B:mas;cField:TImage);
var i,j,k,l,t,p:integer;
    f1,f:boolean;
begin
   f1:=True;
   for l:=0 to 9 do
     begin
       for k:=0 to 9-d+1 do
         begin
           if (B[l][k]=-d-1)
              then
               begin
                 f:=True;
                 for t:=k+1 to k+d do
                   if B[l][t]<>-d-1
                      then
                       f:=False;
                 f1:=f;
                 if f1
                    then
                     begin
                       for i:=k*21+1 to (k+d)*21+20 do
                         for j:=l*21+1 to l*21+20 do
                           if cField.Canvas.Pixels[i,j]<>clNavy
                              then
                               cField.Canvas.Pixels[i,j]:=rgb(205,38,38);
                       for t:=k to k+d do
                         B[l][t]:=0;

                       t:=k-1;
                       for i:=(((t*21+1)+(t*21+20))div 2)-2 to(((t*21+1)+(t*21+20))div 2)+2 do
                         for j:=(((l*21+1)+(l*21+20))div 2)-2 to(((l*21+1)+(l*21+20))div 2)+2 do
                           cField.Canvas.Pixels[i,j]:=clTeal;
                       B[l][t]:=-5;
                       t:=k+d+1;
                       for i:=(((t*21+1)+(t*21+20))div 2)-2 to(((t*21+1)+(t*21+20))div 2)+2 do
                         for j:=(((l*21+1)+(l*21+20))div 2)-2 to(((l*21+1)+(l*21+20))div 2)+2 do
                           cField.Canvas.Pixels[i,j]:=clTeal;
                       B[l][t]:=-5;
                       for t:=k-1 to k+1+d do
                         begin
                           p:=l-1;
                           for i:=(((t*21+1)+(t*21+20))div 2)-2 to(((t*21+1)+(t*21+20))div 2)+2 do
                             for j:=(((p*21+1)+(p*21+20))div 2)-2 to(((p*21+1)+(p*21+20))div 2)+2 do
                               cField.Canvas.Pixels[i,j]:=clTeal;
                           B[p][t]:=-5;
                           p:=l+1;
                           for i:=(((t*21+1)+(t*21+20))div 2)-2 to(((t*21+1)+(t*21+20))div 2)+2 do
                             for j:=(((p*21+1)+(p*21+20))div 2)-2 to(((p*21+1)+(p*21+20))div 2)+2 do
                               cField.Canvas.Pixels[i,j]:=clTeal;
                           B[p][t]:=-5;
                         end;
                     end;
               end;
         end;
     end;

   f1:=True;
   for l:=0 to 9 do
     begin
       for k:=0 to 9-d+1 do
         begin
           if (B[k][l]=-d-1)
              then
               begin
                 f:=True;
                 for t:=k+1 to k+d do
                   if B[t][l]<>-d-1
                      then
                       f:=False;
                 f1:=f;
                 if f1
                    then
                     begin
                       for i:=k*21+1 to (k+d)*21+20 do
                         for j:=l*21+1 to l*21+20 do
                           if cField.Canvas.Pixels[j,i]<>clNavy
                              then
                               cField.Canvas.Pixels[j,i]:=rgb(205,38,38);
                       for t:=k to k+d do
                         B[t][l]:=0;

                       t:=k-1;
                       for i:=(((t*21+1)+(t*21+20))div 2)-2 to(((t*21+1)+(t*21+20))div 2)+2 do
                         for j:=(((l*21+1)+(l*21+20))div 2)-2 to(((l*21+1)+(l*21+20))div 2)+2 do
                           cField.Canvas.Pixels[j,i]:=clTeal;
                       B[l][t]:=-5;
                       t:=k+d+1;
                       for i:=(((t*21+1)+(t*21+20))div 2)-2 to(((t*21+1)+(t*21+20))div 2)+2 do
                         for j:=(((l*21+1)+(l*21+20))div 2)-2 to(((l*21+1)+(l*21+20))div 2)+2 do
                           cField.Canvas.Pixels[j,i]:=clTeal;
                       B[l][t]:=-5;
                       for t:=k-1 to k+1+d do
                         begin
                           p:=l-1;
                           for i:=(((t*21+1)+(t*21+20))div 2)-2 to(((t*21+1)+(t*21+20))div 2)+2 do
                             for j:=(((p*21+1)+(p*21+20))div 2)-2 to(((p*21+1)+(p*21+20))div 2)+2 do
                               cField.Canvas.Pixels[j,i]:=clTeal;
                           B[p][t]:=-5;
                           p:=l+1;
                           for i:=(((t*21+1)+(t*21+20))div 2)-2 to(((t*21+1)+(t*21+20))div 2)+2 do
                             for j:=(((p*21+1)+(p*21+20))div 2)-2 to(((p*21+1)+(p*21+20))div 2)+2 do
                               cField.Canvas.Pixels[j,i]:=clTeal;
                           B[p][t]:=-5;
                         end;
                     end;
               end;
         end;
     end;
end;

function Gen:integer;
var i:integer;
begin
  For i:=1 to 4 do
    If Ds[i]>0
       then
        result:=i;
end;

function CanBe(l,k:integer):boolean;
var f1,f2,f3:boolean;
    i,j:integer;
begin
  f1:=False;
  f2:=False;
  i:=k-Gen+1;
  While (i<=k) and not f1 do
    begin
      f3:=True;
      j:=i;
      While (j<=i+Gen-1) and f3 do
        if C[l][j]<>0
           then
            f3:=False
           else
            j:=j+1;
      f1:=f3;
      i:=i+1;
    end;
  i:=l-Gen+1;
  While (i<=l) and not f2 do
    begin
      f3:=True;
      j:=i;
      While (j<=i+Gen-1) and f3 do
        if C[j][k]<>0
           then
            f3:=False
           else
            j:=j+1;
      f2:=f3;
      i:=i+1;
    end;
  result{CanBe}:=f1 or f2;
end;

function Free(l,k:integer):boolean;
begin
  result:=(C[l][k]=0) {and (check1(l,k,gen-1,1,C)or check1(l,k,gen-1,2,C))};
  {ShowMessage(InttoStr(l)+' '+intTostr(k));
  If not (C[l,k]=0)
     then
      ShowMessage('-');   }
end;

Procedure PaintOut(l,k:integer;myField:TImage);
var i,j:integer;
begin
  for i:=(((k*21+1)+(k*21+20))div 2)-2 to(((k*21+1)+(k*21+20))div 2)+2 do
    for j:=(((l*21+1)+(l*21+20))div 2)-2 to(((l*21+1)+(l*21+20))div 2)+2 do
      myField.Canvas.Pixels[i,j]:=clTeal;
end;

Procedure PaintIn(l,k,r,g,b:integer;myField:Timage);
var i,j:integer;
begin
  for i:=k*21+1 to k*21+20 do
    for j:=l*21+1 to l*21+20 do
      myField.Canvas.Pixels[i,j]:=rgb(r,g,b);
end;

procedure ShutStat(l,k:integer);
var i,j,p,q:integer;
    max:real;
begin
  Case strg of
    1:begin
        y:=l;
        z:=k;
      end;
    2:begin
        p:=l;
        q:=k;
        max:=D[l][k];
        for i:=0 to 9 do
          for j:=0 to 9 do
            if (D[i][j]>max) and  Free(i,j)
               then
                begin
                  p:=i;
                  q:=j;
                  max:=D[i][j];
                end;
        y:=p;
        z:=q;
        //showmessage(inttostr(y)+' '+inttostr(z));
      end;
   end;
end;

procedure ShutThrough(myField:TImage;var f:boolean);
var i,j,k,l:integer;
begin
  f:=True;
  Repeat
    l:=Random(10);
    k:=Random(10);
  until Free(l,k) and CanBe(l,k);
  ShutStat(l,k);
  //ShowMessage(IntToStr(A[l,k]));
      begin
        if A[y][z]>0
           then
            begin
              pp:=pp+1;
              kp:=kp+1;
              state:=2;
              ds1:=ds1+1;
              C[y][z]:=-A[y][z];
              if A[y][z]=1
                 then
                  begin
                    Ds[1]:=Ds[1]-1;
                    state:=1;
                    C[y][z]:=-1;
                    C[y][z+1]:=-5;
                    C[y][z-1]:=-5;
                    C[y-1][z]:=-5;
                    C[y+1][z]:=-5;
                    C[y-1][z+1]:=-5;
                    C[y+1][z+1]:=-5;
                    C[y-1][z+1]:=-5;
                    C[y-1][z-1]:=-5;
                    PaintOut(y-1,z,myField);
                    PaintOut(y-1,z-1,myField);
                    PaintOut(y-1,z+1,myField);
                    PaintOut(y,z-1,myField);
                    PaintOut(y,z+1,myField);
                    PaintOut(y+1,z,myField);
                    PaintOut(y+1,z-1,myField);
                    PaintOut(y+1,z+1,myField);
                    PaintIn(y,z,205,38,38,myField);
                  end
                 else
                  begin
                    PaintIn(y,z,238,180,34,myField);
                  end;
            end
           else
            begin
              C[y][z]:=-5;
              PaintOut(y,z,myField);
              f:=False;
            end;
      end;
end;

procedure ShutAround(myField:TImage;var f:boolean;var i:integer);
var pf:boolean;
begin
  //ShowMessage(IntToStr(i));
  pf:=False;
  Repeat
  Case i of
    1:begin
        if ((y-1)>=0)and (C[y-1][z]=0)
           then
            pf:=True
           else
            i:=2;
      end;
    2:begin
        if ((z+1)<=9)and (C[y][z+1]=0)
           then
            pf:=True
           else
            i:=3;
      end;
    3:begin
        if ((y+1)<=9)and (C[y+1][z]=0)
           then
            pf:=True
           else
            i:=4;
      end;
    4:begin
        if ((z-1)>=0)and (C[y][z-1]=0)
           then
            pf:=True
           else
            i:=1;
      end;
  end;
  until pf;
  Case i of
    1:begin
        If (A[y-1][z]>0)
           then
            begin
              pp:=pp+1;
              kp:=kp+1;
              f:=True;
              ds1:=ds1+1;
              C[y-1][z]:=-A[y-1][z];
              if (A[y-1][z]=2)
                 then begin
                    Ds[2]:=Ds[2]-1;
                    C[y-2][z]:=-5;
                    C[y-2][z-1]:=-5;
                    C[y-2][z+1]:=-5;
                    C[y-1][z-1]:=-5;
                    C[y-1][z+1]:=-5;
                    C[y][z-1]:=-5;
                    C[y][z+1]:=-5;
                    C[y+1][z]:=-5;
                    C[y+1][z-1]:=-5;
                    C[y+1][z+1]:=-5;
                    state:=1;
                    PaintIn(y-1,z,205,38,38,myField);
                  end
                 else
                  begin
                    state:=3;
                    PaintIn(y-1,z,238,180,34,myField);
                  end;
            end
           else
            begin
              f:=False;
              C[y-1][z]:=-5;
              PaintOut(y-1,z,myField);
            end;
      end;
    2:begin
        If (A[y][z+1]>0)
           then
            begin
              pp:=pp+1;
              kp:=kp+1;
              f:=True;
              ds1:=ds1+1;
              C[y][z+1]:=-A[y][z+1];
              if (A[y][z+1]=2)
                 then
                  begin
                    Ds[2]:=Ds[2]-1;
                    C[y][z+2]:=-5;
                    C[y-1][z+2]:=-5;
                    C[y+1][z+2]:=-5;
                    C[y-1][z+1]:=-5;
                    C[y+1][z+1]:=-5;
                    C[y-1][z]:=-5;
                    C[y+1][z]:=-5;
                    C[y][z-1]:=-5;
                    C[y-1][z-1]:=-5;
                    C[y+1][z-1]:=-5;
                    state:=1;
                    PaintIn(y,z+1,205,38,38,myField);
                  end
                 else
                  begin
                    state:=3;
                    PaintIn(y,z+1,238,180,34,myField);
                  end;
            end
           else
            begin
              f:=False;
              C[y][z+1]:=-5;
              PaintOut(y,z+1,myField);
            end;
      end;
    3:begin
        If (A[y+1][z]>0)
           then
            begin
              pp:=pp+1;
              kp:=kp+1;
              f:=True;
              ds1:=ds1+1;
              C[y+1][z]:=-A[y+1][z];
              if (A[y+1][z]=2)
                 then
                  begin
                    Ds[2]:=Ds[2]-1;
                    C[y+2][z]:=-5;
                    C[y+2][z-1]:=-5;
                    C[y+2][z+1]:=-5;
                    C[y+1][z-1]:=-5;
                    C[y+1][z+1]:=-5;
                    C[y][z-1]:=-5;
                    C[y][z+1]:=-5;
                    C[y-1][z]:=-5;
                    C[y-1][z-1]:=-5;
                    C[y-1][z+1]:=-5;
                    state:=1;
                    PaintIn(y+1,z,205,38,38,myField);
                  end
                 else
                  begin
                    state:=3;
                    PaintIn(y+1,z,238,180,34,myField);
                  end;
            end
           else
            begin
              f:=False;
              C[y+1][z]:=-5;
              PaintOut(y+1,z,myField);
            end;
      end;
    4:begin
        If (A[y][z-1]>0)
           then
            begin
              pp:=pp+1;
              kp:=kp+1;
              f:=True;
              ds1:=ds1+1;
              C[y][z-1]:=-A[y][z-1];
              if (A[y][z-1]=2)
                 then
                  begin
                    Ds[2]:=Ds[2]-1;
                    C[y][z-2]:=-5;
                    C[y-1][z-2]:=-5;
                    C[y+1][z-2]:=-5;
                    C[y-1][z-1]:=-5;
                    C[y+1][z-1]:=-5;
                    C[y-1][z]:=-5;
                    C[y+1][z]:=-5;
                    C[y][z+1]:=-5;
                    C[y-1][z+1]:=-5;
                    C[y+1][z+1]:=-5;
                    state:=1;
                    PaintIn(y,z-1,205,38,38,myField);
                  end
                 else
                  begin
                    state:=3;
                    PaintIn(y,z-1,238,180,34,myField);
                  end;
            end
           else
            begin
              f:=False;
              C[y][z-1]:=-5;
              PaintOut(y,z-1,myField);
            end;
      end;
  end;

end;

procedure AroundDead(myField:TImage; var C:mas);
var i,j,k,l:integer;
    f:boolean;
begin
  for l:=0 to 9 do
    for k:=0 to 9 do
      begin
        f:=False;
        for i:=(((k*21+1)+(k*21+20))div 2)-2 to(((k*21+1)+(k*21+20))div 2)+2 do
          for j:=(((l*21+1)+(l*21+20))div 2)-2 to(((l*21+1)+(l*21+20))div 2)+2 do
            if (myField.Canvas.Pixels[i,j]=clTeal) and (myField.Canvas.Pixels[k*21+1,l*21+1]<>clTeal)
               then
                f:=True;
        If f
           then
            C[l][k]:=-5;
      end;
end;



procedure ShutAll(myField:TImage;var f:boolean;napr:integer; var C:mas);
var i,j,t,p:integer;
begin
  Case napr of
    1:begin
        S:=S+[byte(2),byte(4)];   //7 byte
        if ((y-pp)<0) or (C[y-pp][z]<>0)
           then
            napr:=3;
      end;
    2:begin
        S:=S+[byte(1),byte(3)];
        if ((z+pp)>9) or (C[y][z+pp]<>0)
           then
            napr:=4;
      end;
    3:begin
        S:=S+[byte(2),byte(4)];
        if ((y+pp)<0) or (C[y+pp][z]<>0)
           then
            napr:=1;
      end;
    4:begin
        S:=S+[byte(1),byte(3)];
        if ((z-pp)>9) or (C[y][z-pp]<>0)
           then
            napr:=2;
      end;
  end;
  Case napr of
    1:begin
        if A[y-pp][z]>0
           then
            begin
              inc(ds1);
              f:=True;
              C[y-pp][z]:=-A[y-pp][z];
              //ShowMessage(IntToStr(A[y-pp,z])+' A'+IntToStr(kp)+' kp');
              if A[y-pp][z]=kp+1
                 then
                  begin
                    //Showmessage('True');
                    state:=1;
                    Ds[kp+1]:=Ds[kp+1]-1;
                  end
                 else
                  begin
                    PaintIn(y-pp,z,238,180,34,myField);
                    pp:=pp+1;
                    kp:=kp+1;
                  end;
            end
           else
            begin
              f:=False;
              C[y-pp][z]:=-5;
              PaintOut(y-pp,z,myField);
              pp:=1;
              napr:=3;
            end;
      end;
    2:begin
        if A[y][z+pp]>0
           then
            begin
              inc(ds1);
              f:=True;
              C[y][z+pp]:=-A[y][z+pp];
              //ShowMessage(IntToStr(A[y,z+pp])+' A'+IntToStr(kp)+' kp');
              if A[y][z+pp]=kp+1
                 then
                  begin
                    state:=1;
                    Ds[kp+1]:=Ds[kp+1]-1;
                  end
                 else
                  begin
                    PaintIn(y,z+pp,238,180,34,myField);
                    pp:=pp+1;
                    kp:=kp+1;
                  end;
            end
           else
            begin
              f:=False;
              C[y][z+pp]:=-5;
              PaintOut(y,z+pp,myField);
              pp:=1;
              napr:=4;
            end;
      end;
    3:begin
        if A[y+pp][z]>0
           then
            begin
              f:=True;
              inc(ds1);
              C[y+pp][z]:=-A[y+pp][z];
              //ShowMessage(IntToStr(A[y+pp,z])+' A'+IntToStr(kp)+' kp');
              if A[y+pp][z]=kp+1
                 then
                  begin
                    state:=1;
                    Ds[kp+1]:=Ds[kp+1]-1;
                  end
                 else
                  begin
                    PaintIn(y+pp,z,238,180,34,myField);
                    pp:=pp+1;
                    kp:=kp+1;
                  end;
            end
           else
            begin
              f:=False;
              C[y+pp][z]:=-5;
              PaintOut(y+pp,z,myField);
              pp:=1;
              napr:=1;
            end;
      end;
    4:begin
        if A[y][z-pp]>0
           then
            begin
              inc(ds1);
              f:=True;
              C[y][z-pp]:=-A[y][z-pp];
              //ShowMessage(IntToStr(A[y,z-pp])+' A'+IntToStr(kp)+' kp');
              if A[y][z-pp]=kp+1
                 then
                  begin
                    state:=1;
                    Ds[kp+1]:=Ds[kp+1]-1;
                  end
                 else
                  begin
                    PaintIn(y,z-pp,238,180,34,myField);
                    pp:=pp+1;
                    kp:=kp+1;
                  end;
            end
           else
            begin
              f:=False;
              C[y][z-pp]:=-5;
              PaintOut(y,z-pp,myField);
              pp:=1;
              napr:=2;
            end;
      end;
  end;
end;

procedure bbOKClick(Sender: TObject);
var i,j:integer;  puf:boolean; aby: byte;
begin
  amemo1.Lines.Clear;
  for i:=0 to 9 do begin
    for j:=0 to 9 do
      aMemo1.Lines.ValueFromIndex[i]:=
      aMemo1.Lines.ValueFromIndex[i]+intToStr(A[i][j])+' ';
  //  showmessage(Memo1.Lines.ValueFromIndex[i]);
    amemo1.Lines.Add('');
   end;
  pnLegend.Visible:=True;
  Panel3.Visible:=False;
  bbRe.Visible:=False;
  cField.Enabled:=True;
  pnMes.Visible:=True;
  if flag
     then
      lbMes.Caption:='Ваш ход!'
     else
      begin

      end;
  bbOk.Visible:=False;
  Auto.Visible:=False;  
  state:=1;

  puf:=True;
  if not flag then
         Repeat
          //ShowMessage(IntToStr(state)+' state');
           
           Case state of
             1: begin
                  pp:=0;
                  kp:=0;
                  ShutThrough(myField,puf);
                end;
             2: begin
                  if {((y-1)>=0)and (C[y-1,z]=0)and} not {1>3 //[S2]} (byte(1) in S)
                     then
                      o:=1
                     else
                      begin
                      if {((z+1)<=9)and (C[y,z+1]=0) and} not (byte(2) in S)
                         then
                          o:=2
                         else
                          begin
                          if {((y+1)<=9)and (C[y+1,z]=0) and} not (byte(3) in S)
                             then
                              o:=3
                             else
                              begin
                              if {((z-1)>=0)and (C[y,z-1]=0) and} not (byte(4) in S)
                                 then
                                  o:=4;
                              end;
                          end;
                      end;
                  ShutAround(myField,puf,o);
                  aby:= o;
                  if o = 1 then S:=S+[byte(1)] else
                    if o = 2 then S:=S+[byte(2)] else
                      if o = 3 then S:=S+[byte(3)] else
                         if o = 4 then S:=S+[byte(4)];
                  
                  //S:=S+[byte(aby)];   change
                  If S=[byte(1),byte(2),byte(3),byte(4)]
                     then
                      S:=[];   
                end;
             3: begin
                  S:=[];
                  napr:=o;
                  ShutAll(myField,puf,napr,C);
                  //ShowMessage(IntToStr(pp)+' pp'+IntToStr(kp)+' kp');
                end;
           end;
           FindDead(3,C,myField);
           FindDead(2,C,myField);
           FindDead(1,C,myField);
           AroundDead(myField,C);
          // Showmessage(inttostr(ds1));
         until (not puf) or ((ds1=20)or(ds2=20));
end;


procedure bbOkSetClick(Sender: TObject);
var puf:boolean;
    i,j,k,l:integer;
begin
  pnSet.Visible:=False;
  flag:=cbF.Checked;
  if  rbF.Checked
      then
       strg:=1
      else
       strg:=2;

  myField.Enabled:=True;
  lbName.Caption:=leName.Text;
 if nol
    then
    begin
  panel3.Visible:=True;
  rb1.Enabled:=True;
  rb2.Enabled:=True;
  rb3.Enabled:=True;
  rb4.Enabled:=True;
  rb4.Checked:=True;
  bbRe.Visible:=True;
  bbOK.Visible:=True;
  bbOk.Enabled:=False;
  Auto.Visible:=True;
  Auto.Enabled:=True;
  Panel3.Enabled:=True;
  end
  else
  begin
    panel3.Visible:=False;
    cField.Enabled:=True;
    myField.Enabled:=True;
    state:=1;

  puf:=True;
  if not flag then
         Repeat
          //ShowMessage(IntToStr(state)+' state');
           
           Case state of
             1: begin
                  pp:=0;
                  kp:=0;
                  ShutThrough(myField,puf);
                end;
             2: begin
                  if {((y-1)>=0)and (C[y-1,z]=0)and} not (byte(1) in S)
                     then
                      o:=1
                     else
                      begin
                      if {((z+1)<=9)and (C[y,z+1]=0) and} not (byte(2) in S)
                         then
                          o:=2
                         else
                          begin
                          if {((y+1)<=9)and (C[y+1,z]=0) and} not (byte(3) in S)
                             then
                              o:=3
                             else
                              begin
                              if {((z-1)>=0)and (C[y,z-1]=0) and} not (byte(4) in S)
                                 then
                                  o:=4;
                              end;
                          end;
                      end;
                  ShutAround(myField,puf,o);
                //7S:=S+[byte(o)];
                 if o = 1 then S:=S+[byte(1)] else
                    if o = 2 then S:=S+[byte(2)] else
                      if o = 3 then S:=S+[byte(3)] else
                         if o = 4 then S:=S+[byte(4)];
   
                   If S=[byte(1),byte(2),byte(3),byte(4)]
                 
                 // If S=[1,2,3,4]
                     then
                      S:=[];   
                end;
             3: begin
                  S:=[];
                  napr:=o;
                  ShutAll(myField,puf,napr,C);
                  //ShowMessage(IntToStr(pp)+' pp'+IntToStr(kp)+' kp');
                end;
           end;
           FindDead(3,C,myField);
           FindDead(2,C,myField);
           FindDead(1,C,myField);
           AroundDead(myField,C);
          // Showmessage(inttostr(ds1));
         until (not puf) or ((ds1=20)or(ds2=20));
  end;

end;





procedure cFieldMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

var k,l,i,j,t,p,t1,p1:integer;
    puf:boolean;
begin
  k:=X div 21;
  l:=Y div 21;
  Case mru(k,l,B) of
    0: begin
         for i:=(((k*21+1)+(k*21+20))div 2)-2 to(((k*21+1)+(k*21+20))div 2)+2 do
           for j:=(((l*21+1)+(l*21+20))div 2)-2 to(((l*21+1)+(l*21+20))div 2)+2 do
             cField.Canvas.Pixels[i,j]:=clTeal;
         puf:=True;
         Repeat
          //ShowMessage(IntToStr(state)+' state');
           
           Case state of
             1: begin
                  pp:=0;
                  kp:=0;
                  ShutThrough(myField,puf);
                end;
             2: begin
                  if {((y-1)>=0)and (C[y-1,z]=0)and} not (byte(1) in S)
                     then
                      o:=1
                     else
                      begin
                      if {((z+1)<=9)and (C[y,z+1]=0) and} not (byte(2) in S)
                         then
                          o:=2
                         else
                          begin
                          if {((y+1)<=9)and (C[y+1,z]=0) and} not (byte(3) in S)
                             then
                              o:=3
                             else
                              begin
                              if {((z-1)>=0)and (C[y,z-1]=0) and} not (byte(4) in S)
                                 then
                                  o:=4;
                              end;
                          end;
                      end;
                  ShutAround(myField,puf,o);
                  //S:=S+[ord(o)];
                   if o = 1 then S:=S+[byte(1)] else
                    if o = 2 then S:=S+[byte(2)] else
                      if o = 3 then S:=S+[byte(3)] else
                         if o = 4 then S:=S+[byte(4)];
   
                  //If S=[1,2,3,4]
                   If S=[byte(1),byte(2),byte(3),byte(4)]
                 
                     then
                      S:=[];   
                end;
             3: begin
                  S:=[];
                  napr:=o;
                  ShutAll(myField,puf,napr,C);
                  //ShowMessage(IntToStr(pp)+' pp'+IntToStr(kp)+' kp');
                end;
           end;
           FindDead(3,C,myField);
           FindDead(2,C,myField);
           FindDead(1,C,myField);
           AroundDead(myField,C);
          // Showmessage(inttostr(ds1));
         until (not puf) or ((ds1=20)or(ds2=20));
       end;
    1: begin
         inc(ds2);
         for i:=k*21+1 to k*21+20 do
           for j:=l*21+1 to l*21+20 do
             if B[l][k]>1
                then
                 cField.Canvas.Pixels[i,j]:=rgb(238,180,34)
                else
                 begin
                   cField.Canvas.Pixels[i,j]:=rgb(205,38,38);
                 end;
         B[l][k]:=-B[l][k];
         FindDead(3,B,cField);
         FindDead(2,B,cField);
         FindDead(1,B,cField);
         FindDead(0,B,cField);
       end;

  end;
  If ds1=20
    then
     begin
       FindDead(3,C,myField);
       FindDead(2,C,myField);
       FindDead(1,C,myField);
       showmessage('Победитель - Компьютер');
       myfield.Visible:=False;
       cfield.Visible:=False;
       pnLegend.Visible:=False;

       AssignFile(stt,'f1.stt');
       Rewrite(stt);
       For i:=0 to 9 do
         For j:=0 to 9 do
           D[i][j]:=D[i][j]+0.1*A[i][j];
       //Write(stt,D);
       CloseFile(stt);
     end;
  If ds2=20
    then
     begin
       showmessage('Победитель - '+lbName.Caption);
       myfield.Visible:=False;
       cfield.Visible:=False;
       pnLegend.Visible:=False;

       AssignFile(stt,'f1.stt');
       Rewrite(stt);
       For i:=0 to 9 do
         For j:=0 to 9 do
           D[i][j]:=D[i][j]+0.1*A[i][j];
       //Write(stt,D);
       CloseFile(stt);
     end;
  // For i:=1 to 4 do
    //Showmessage(IntToStr(Ds[i]));
end;

procedure {TfmBattle.}N8Click(Sender: TObject);
begin
  fmBattle.Close;
end;


procedure N2Click(Sender: TObject);
var i,j:integer;
begin
  nol:=true;
  bbOk.Visible:=False;
  bbRe.Visible:=False;
  Auto.Visible:=False;
  pnLegend.Visible:=False;
  myfield.Visible:=True;
  myField.Enabled:=False;
  cfield.Visible:=True;
  cField.Enabled:=False;
  for i:=0 to 210 do
   for j:=0 to 210 do
     begin
       myField.Canvas.Pixels[i,j]:=clAqua;
       cField.Canvas.Pixels[i,j]:=clAqua;
     end;
  for j:=0 to 210 do begin
      myField.Canvas.Pixels[j,0]:=clNavy;
      myField.Canvas.Pixels[0,j]:=clNavy;
      cField.Canvas.Pixels[j,0]:=clNavy;
      cField.Canvas.Pixels[0,j]:=clNavy;
      myField.Canvas.Pixels[j,209]:=clNavy;
      myField.Canvas.Pixels[209,j]:=clNavy;
      cField.Canvas.Pixels[j,209]:=clNavy;
      cField.Canvas.Pixels[209,j]:=clNavy;
    end;
  i:=21;
  While i<=210 do begin
      For j:=1 to 210 do begin
          myField.Canvas.Pixels[i,j]:=clNavy;
          cField.Canvas.Pixels[i,j]:=clNavy;
          myField.Canvas.Pixels[j,i]:=clNavy;
          cField.Canvas.Pixels[j,i]:=clNavy;
        end;
      i:=i+21;
    end;
  InitMas(A,B,C);
  GetB(B);
  ds1:=0;
  ds2:=0;
  S:=[];
  o:=1;
  pp:=2;
  pnMes.Visible:=False;
  pnSet.Visible:=True;
end;

procedure N9Click(Sender: TObject);
begin
  ShowMessage('Авторы: Пунис Виктория, Юрьева Ирина. II курс II группа II подгруппа "ПМ"');
end;

procedure AutoClick(Sender: TObject);
var i,j,k,l:integer;
begin
  Initmas(A,A,C);
  for i:=0 to 210 do
   for j:=0 to 210 do
     begin
       myField.Canvas.Pixels[i,j]:=clAqua;
       cField.Canvas.Pixels[i,j]:=clAqua;
     end;
  for j:=0 to 210 do begin
      myField.Canvas.Pixels[j,0]:=clNavy;
      myField.Canvas.Pixels[0,j]:=clNavy;
      cField.Canvas.Pixels[j,0]:=clNavy;
      cField.Canvas.Pixels[0,j]:=clNavy;
      myField.Canvas.Pixels[j,209]:=clNavy;
      myField.Canvas.Pixels[209,j]:=clNavy;
      cField.Canvas.Pixels[j,209]:=clNavy;
      cField.Canvas.Pixels[209,j]:=clNavy;
    end;
  i:=21;
  While i<=210 do
    begin
      For j:=1 to 210 do
        begin
          myField.Canvas.Pixels[i,j]:=clNavy;
          cField.Canvas.Pixels[i,j]:=clNavy;
          myField.Canvas.Pixels[j,i]:=clNavy;
          cField.Canvas.Pixels[j,i]:=clNavy;
        end;
      i:=i+21;
    end;
  GetB(A);
  myField.Enabled:=False;
  Auto.Enabled:=False;
  For k:=0 to 9 do
    For l:=0 to 9 do
      if A[l][k]<>0
         then
          begin
             for i:=k*21+1 to k*21+20 do
               for j:=l*21+1 to l*21+20 do
                 if myField.Canvas.Pixels[i,j]<>clNavy
                    then
                     myField.Canvas.Pixels[i,j]:=clTeal;
          end;
  bbOk.Enabled:=True;
end;

procedure N6Click(Sender: TObject);
begin
  if SaveDialog1.Execute
     then
      begin
        aMemo1.Lines.SaveToFile(SaveDialog1.FileName);
      end;
end;

procedure N3Click(Sender: TObject);
var S1,S2:string;
    i,j,k,l:integer;
begin
  nol:=false;
  if OpenDialog1.Execute
     then
      begin
        amemo1.Lines.LoadFromFile(openDialog1.FileName);
        bbOk.Visible:=False;
        bbRe.Visible:=False;
        Auto.Visible:=False;
        pnLegend.Visible:=False;
        myfield.Visible:=True;
        myField.Enabled:=False;
        cfield.Visible:=True;
        cField.Enabled:=False;
        for i:=0 to 210 do
          for j:=0 to 210 do
            begin
              myField.Canvas.Pixels[i,j]:=clAqua;
              cField.Canvas.Pixels[i,j]:=clAqua;
            end;
        for j:=0 to 210 do
          begin
            myField.Canvas.Pixels[j,0]:=clNavy;
            myField.Canvas.Pixels[0,j]:=clNavy;
            cField.Canvas.Pixels[j,0]:=clNavy;
            cField.Canvas.Pixels[0,j]:=clNavy;
            myField.Canvas.Pixels[j,209]:=clNavy;
            myField.Canvas.Pixels[209,j]:=clNavy;
            cField.Canvas.Pixels[j,209]:=clNavy;
            cField.Canvas.Pixels[209,j]:=clNavy;
          end;
        i:=21;
        While i<=210 do begin
            For j:=1 to 210 do begin
                myField.Canvas.Pixels[i,j]:=clNavy;
                cField.Canvas.Pixels[i,j]:=clNavy;
                myField.Canvas.Pixels[j,i]:=clNavy;
                cField.Canvas.Pixels[j,i]:=clNavy;
              end;
            i:=i+21;
          end;
        InitMas(A,B,C);
        GetB(B);
        ds1:=0;
        ds2:=0;
        S:=[];
        o:=1;
        pp:=2;
        pnMes.Visible:=False;
        pnSet.Visible:=True;
        for i:=0 to 9 do begin
            j:=0;
            s1:=Copy(amemo1.Lines[i],2,length(amemo1.lines[i]));
           // showmessage(s1);
          // showmessage(inttoStr(pos(' ',s1)));
            while not (pos(' ',s1)=0) do begin
                A[i][j]:=StrToInt(Copy(s1,1,pos(' ',s1)-1));
                Inc(j);
                Delete(S1,1,pos(' ',s1));     //showmessage(s1);
              end;
          end;
      end;
  For k:=0 to 9 do
    For l:=0 to 9 do
      if A[l][k]<>0
         then
          begin
             for i:=k*21+1 to k*21+20 do
               for j:=l*21+1 to l*21+20 do
                 if myField.Canvas.Pixels[i,j]<>clNavy
                    then
                     myField.Canvas.Pixels[i,j]:=clTeal;
          end;
end;

end.
