program 8Queens_Problem;

In the book "Algortims and Data Structures" by Wirth there is a program in
Pascal to compute all 92 solutions of the above mentioned problem. I tried
to translate his program into C++, the only small problem being that he
uses array with a starting index other than zero.


program nqueen;

{
    Synopsis: Place n queens on a n x n chess board
              so that no queen threathens
              any other queen.
    Author:   (C) GPL, Mosh@cse.iitb.ernet.in
    Date:     22-Sept-93.
    Notes:
           n         = size of chess board,
           (i,bd[i]) = position of queen in row-i, where i = 1..n.
           s         = number of solutions.
}
{ --------------------------------------------------------------- }
  uses crt;
  const max = 20;
  var   bd    : array[1..max] of integer;
        n,i,s : integer;
{ --------------------------------------------------------------- }
function check( l,m : integer ):boolean; { check if row/col l/m is safe }
     var r : integer;
     label 10;
  begin
  for r := 1 to l-1 do
     if (bd[r] = m ) or (bd[r]+(l-r) = m ) or (bd[r]-(l-r) = m ) then
        begin
        check := false;
        goto 10;
        end;
  check := true;
  10: ;
  end;

procedure place( l : integer );
    var c : integer;
        d : char;
  begin

  if l = n+1 then  { done, found a solution }
     begin
     s := s+1;
     gotoxy( 1 ,22); write(' Done, solution:   ',s:3, ', more[y/q]: ');
     sound( 400 ); delay( 10 ); nosound;
     repeat until keypressed; d := readkey; write( d );
     if d = 'q' then begin clrscr; halt; end;
     gotoxy( 1 ,22); clreol; write(' Trying, solution: ',s+1:3);
     end;

  for c := 1 to n do
      if check( l, c ) then
         begin
         bd[l] := c;
         gotoxy( l, c ); write('Q'); { place a queen at l/c }
         place( l+1 );
         gotoxy( l, c ); write('.'); { clear/backtrack for next soln }
         end;
  end;
{ --------------------------------------------------------------- }
  var l,c : integer;
begin
clrscr;
write( 'Size of chessboard: [1..',max:2,'] : '); readln( n );
clrscr;
for l := 1 to n do              { create an empty board }
   bd[l] := 0;
for l := 1 to n do
   for c := 1 to n do
     begin
     gotoxy( l, c ); write('.');
     end;
s := 0;                        { no solution yet. }
place( 1 );                    { fill the board }
clrscr;
end.
{ --------------------------------------------------------------- }
