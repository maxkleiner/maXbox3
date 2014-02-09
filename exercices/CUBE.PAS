program wuerfel;

var zahl,i,wert,res: integer;
        a,b,c,d,e,f:   integer;


function zufall: integer;
begin
     zahl:= (11*zahl-1)mod 1000;     {91}
     zufall:=zahl;
     {writeln(zahl);}
end;

function wurf(zuzahl: integer):integer;
begin
     wurf:= 1+zuzahl mod 6
end;

begin
zahl:=2;              {1,2,5,6}
a:=0; b:=0; c:=0;
d:=0; e:=0; f:=0;

      for i:= 1 to 30000 do
      begin
      res:=wurf(zufall);
      {writeln(res);}
      if res<=0 then write ('megamax');
         case res of
              1:  a:=a+1;
              2:  b:=b+1;
              3:  c:=c+1;
              4:  d:=d+1;
              5:  e:=e+1;
              6:  f:=f+1;
         end;
      end;
  writeln('z 1  ',a,'  z 2  ',b,'  z 3  ',c);
  writeln('z 4  ',d,'  z 5  ',e,'  z 6  ',f);
end.