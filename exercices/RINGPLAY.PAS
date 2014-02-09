program ring;
{
    SYNOPSIS: Makes a telephone bell sound, turbo pascal 3.
    History:  Was sample code.
    Author:   GPL(C) Mohsin Ahmed
    Date:     Dec 21 02:11 1991

}
  type   noterecord = record
                     C,CF,D,DF,E,F,FF,G,GF,A,AF,B: integer;
                  end;
  const  notes: noterecord =
             (C:1;CF:2;D:3;DF:4;E:5;F:6;FF:7;G:8;GF:9;A:10;AF:11;B:12);

{--------------------------------------------------------------}
procedure play(octave,note,duration: integer);
                  var    f: real;  i: integer;
      begin
      f := 32.625;
      for i := 1 to octave do  f := f * 2;
      for i := 1 to note - 1 do  f := f * 1.059463094;
     if duration <> 0 then
          begin
          sound(round(f));
          delay(duration);
          nosound;
          end
     else
          sound(round(f));
     end;

{--------------------------------------------------------------}
  var ch  : char;
      i,j : integer;
begin
repeat
  for j := 1 to 7 do
         with notes do
            begin
            play(4,D,30);
            delay(18);
            play(4,D,20);
            end;
  delay(150);
  for j := 1 to 7 do
         with notes do
            begin
            play(4,D,30);
            delay(18);
            play(4,D,20);
            end;
  delay(1300);
  until keypressed;
end.
{--------------------------------------------------------------}
