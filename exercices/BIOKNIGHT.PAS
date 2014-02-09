program KnightTour;
{
    Program: KnightTour
    Synopsis: Move a knight on a (n x n) chess board,
              such that it visits each and every square exactly once.
    Author: (C)GPL:  Mosh@cse.iitb.ernet.in,
    Date:            12-Sep-93
}

const maxn = 10;
var bd      : array[0..maxn,0..maxn] of integer;
    n, i, j : integer;
label found;

procedure writeit( c,i,j : integer );
  begin
    gotoxy( (i+1)*6, (j+1)*2 );
    if c = 0 then
       write( '[..]' )
    else
      write( '[',c:2,']' );
  end;

function kn( c, i, j : integer ):boolean;
    label done;
  begin
  { done }
  if c = (1+n)*(1+n)+1 then
     begin
     sound( 1000 ); delay( 1000 ); nosound;
     repeat until keypressed;
     kn := true;
     goto done;;
     end;
  { Out of board }
  if (i<0) or (i>n) or (j<0) or (j>n) then
     begin
     kn := false;
     goto done;;
     end;
  { Already toured }
  if bd[i,j] > 0 then
     begin
     kn := false;
     goto done;;
     end;

  { Let's Tour cell [i,j] }
  bd[i,j] := c;
  writeit( c, i, j );

  if kn( c+1, i+1, j+2 ) then begin kn := true; goto done;; end;
  if kn( c+1, i+1, j-2 ) then begin kn := true; goto done;; end;
  if kn( c+1, i+2, j+1 ) then begin kn := true; goto done;; end;
  if kn( c+1, i+2, j-1 ) then begin kn := true; goto done;; end;
  if kn( c+1, i-1, j+2 ) then begin kn := true; goto done;; end;
  if kn( c+1, i-1, j-2 ) then begin kn := true; goto done;; end;
  if kn( c+1, i-2, j+1 ) then begin kn := true; goto done;; end;
  if kn( c+1, i-2, j-1 ) then begin kn := true; goto done;; end;
  { No solutions, backtrack }
  kn := false;
  bd[i,j] := 0;
  writeit( 0, i, j );
  done:
  end;

begin
  clrscr;
  write(' Size of board [1..',maxn:3,'] : ');
  n := 8; {default}
  readln( n ); n := n-1;
  clrscr;
  for i := 0 to n do
    for j := 0 to n do
      begin
      bd[i,j] := 0;
      writeit( 0, i, j );
      end;

{  repeat until kn( 0, random(n), random(n) );  Random Start may do better ? }

  for i := 0 to n do
    for j := 0 to n do
      if kn( 1, i, j ) then
         goto found;
  writeln(' No Solution ');
  found:
end.
