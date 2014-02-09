program hanoi;
uses crt;

var high: integer;
    a,b,c: char;

procedure move(high: integer;
               a,c,b: char);

begin
if high>1 then
   begin
    {  move(high-1,a,b,c);}
        writeln('move from        ' ,a, ' to   '  ,c);
      move(high-1,b,c,a);
   end
  else  writeln('last move from   ' ,a, ' to   '  ,c)
 end;

begin
write('how much');
readln(high);
move(high,'a','b','c');
end.