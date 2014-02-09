program eightqueens;

type play=array[1..8,1..8]of boolean;
     rc=array[1..8] of boolean;
     ldc=array[2..16] of boolean;        {2..16}
     rdc=array[-7..7] of boolean;         {-7..7}

var  board: play;
     sr: rc;
     sld: ldc;
     srd: rdc;
  zu,zv,   row,col,i: integer;
     ans: char;

function safe(row,col: integer;
              sr: rc; sld: ldc; srd: rdc):boolean;
     begin
       safe:=sr[row] and sld[row+col] and srd[row-col]
     end;

procedure print(board: play);
var i,j: integer;
begin
zu:=zu+1;
  for i:= 1 to 8 do
  begin
    for j:= 1 to 8 do
    if board[i,j] then write (' Q') else write (' *');
    writeln;
  end;
 if zu=92 then readln;                             {to stop}
end;

procedure tryc (col:integer; var board: play);
var row: integer;
begin
  row:= 1;
  repeat
   if safe(row,col,sr,sld,srd) then
   begin
     sr[row]:=false;
     sld[row+col]:=false;
     srd[row-col]:=false;
     board[row,col]:=true;
     if col<8
     then tryc(col+1,board)
     else print(board);
     sr[row]:=true;
     sld[row+col]:=true;
     srd[row-col]:=true;
     board[row,col]:=false;
   end;
   row:=row+1;
  until row>8
end;

begin
repeat
  zu:=1;
  for row:= 1 to 8 do sr[row]:=true;
  for i:= 2 to 16 do sld[i]:= true;
  for i:=-7 to 7  do srd[i]:= true;
  for row:= 1 to 8 do
  for col:= 1 to 8 do
  board[row,col]:= false;
  tryc(1,board);
  writeln(zu);
  write('new solution ?(y/n)'); readln(ans);
  until(ans='n') or (ans='N')
end.



