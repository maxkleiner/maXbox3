 program option1;

 //uses crt;

 type
   option = record
      mazenum, speed : Byte;
   end;

  walls = record
    startx, starty, endx, endy : byte;
  end;

  maze = record
    mazetype, WallNum, X, Y : byte;
    wall    : array[1..20] of walls;
  end;


  var
    op      : option;
    //options : file of option;
    m       : maze;
    //mazes   : file of maze;
    temp    : integer;

  Procedure Error(Code : Byte);
  Begin
  End;

  Procedure DecodeMaze;
  Var i, j, k, Count, Code  : integer;
      Line                  : String;
      //Level                 : TextFile;
  Begin
    //Assign2(Level,'Level.Txt');
    //Reset(Level);
    //Readln(Level, Line);
    Val(Line, Integer(M.Mazetype), Code);
    If (M.MazeType > 2) Or (M.MazeType < 1) Then Error(1);
    //Readln(Level, Line);
    Val(Copy(Line,1,2), integer(M.X), Code);
    Val(Copy(Line,4,2), integer(M.Y), Code);
    //Readln(Level);
    Count := 1;
    Case M.MazeType of
     1 : Begin
          For i := 2 to 75 do
            Begin
              {Close(Level);
              Reset(Level);
              Readln(Level);
              Readln(Level);
              Readln(Level);
              Readln(Level,Line);}
              J := 4;
              Repeat
                If Line[i] = 'W' Then
                  Begin
                    M.Wall[Count].StartX := i + 2;
                    M.Wall[Count].StartY := j;
                    Repeat
                      //Readln(Level, Line);
                      Inc(J);
                    Until (Line[i] = ' ') or (Line[i] = 'B');
                    M.Wall[Count].EndY := J - 1;
                    If (Count < 20) Then Inc(Count)
                     Else Error(2);
                  End;
                //Readln(Level, Line);
                Inc(J);
              Until j = 25;
            End;
         M.WallNum := Count - 1;
         End;

    2 : Begin
          For J := 4 to 23 do
            Begin
              //Readln(Level,Line);
              i := 2;
              Repeat
                If Line[i] = 'W' Then
                  Begin
                    M.Wall[Count].StartX := i + 2;
                    M.Wall[Count].StartY := j;
                    Repeat
                      Inc(i);
                    Until (Line[i] = ' ') Or (Line[i] = 'B');
                    M.Wall[Count].EndX := i + 1;
                    If (Count < 20) Then Inc(Count)
                     Else Error(2);
                  End;
                Inc(i);
              Until i = 78;
            End;
         M.WallNum := Count - 1;
         End;
    End;
    //Close(Level);
  End;

  Procedure writemazes;
    begin
     //reset(mazes);
     //rewrite(mazes);
     begin
      case op.mazenum of
      1 : begin
           m.mazetype := 2;
           m.wallnum := 2;
           m.wall[1].startx := 3;
           m.wall[1].starty := 3;
           m.wall[1].endy := 4;
           m.wall[2].startx := 3;
           m.wall[2].starty := 4;
           m.wall[2].endy := 6;
          end;
      2 : begin
           m.mazetype := 1;
           m.wallnum := 4;
           m.wall[1].startx := 16;
           m.wall[1].starty := 10;
           m.wall[1].endy   := 17;
           m.wall[2].startx := 32;
           m.wall[2].starty := 10;
           m.wall[2].endy   := 17;
           m.wall[3].startx := 48;
           m.wall[3].starty := 10;
           m.wall[3].endy   := 17;
           m.wall[4].startx := 64;
           m.wall[4].starty := 10;
           m.wall[4].endy   := 17;
          end;
      3 : begin
           m.mazetype := 1;
           m.wallnum :=  4;
           m.wall[1].endx := 11;
           m.wall[1].starty := 4;
           m.wall[1].endy   := 20;
           m.wall[2].startx := 21;
           m.wall[2].starty := 8;
           m.wall[2].endy   := 22;
           m.wall[3].startx := 30;
           m.wall[3].starty := 4;
           m.wall[3].endy   := 20;
           m.wall[4].startx := 40;
           m.wall[4].starty := 8;
           m.wall[4].endy   := 22;
          end;
      4 : begin
           m.mazetype := 2;
           m.wallnum :=  6;
           m.wall[1].startx := 7;
           m.wall[1].starty := 8;
           m.wall[1].endx   := 37;
           m.wall[2].startx := 40;
           m.wall[2].starty := 8;
           m.wall[2].endx   := 74;
           m.wall[3].startx := 7;
           m.wall[3].starty := 13;
           m.wall[3].endx   := 37;
           m.wall[4].startx := 40;
           m.wall[4].starty := 13;
           m.wall[4].endx   := 74;
           m.wall[5].startx := 7;
           m.wall[5].starty := 18;
           m.wall[5].endx   := 37;
           m.wall[6].startx := 40;
           m.wall[6].starty := 18;
           m.wall[6].endx   := 74;
          end;
      5 : begin
           m.mazetype := 2;
           m.wallnum := 3;
           m.wall[1].startx := 4;
           m.wall[1].starty := 8;
           m.wall[1].endx   := 40;
           m.wall[2].startx := 4;
           m.wall[2].starty := 16;
           m.wall[2].endx   := 20;
           m.wall[3].startx := 36;
           m.wall[3].starty := 12;
           m.wall[3].endx   := 77;
          end;
      6 : DecodeMaze;
      end;
     //seek(mazes, filesize(mazes));
     //write(mazes, m);
     //close(mazes);
     end;
   end;

  //var label 1;
  begin
   {if paramstr(1) <> '/?' then
   begin
     assign(mazes, 'mazes.sna');
     assign(options, 'option.sna');
     Clrscr;
        reset(options);
        rewrite(options);
        if ParamCount < 2 then
         begin
           1: if op.mazenum > 5 then writeln('There are only 6 mazes!!');
           gotoxy(2,30);
           writeln('What maze do you want to play in? 1 = none');
           read(op.mazenum);
           Repeat
             writeln('How fast do you want your snake to go?');
             read(op.speed);
           Until Op.Speed <= 10;
         end
       else
         begin
             val(paramstr(1),op.mazenum,temp);
             val(paramstr(2),op.speed,temp);
             if op.mazenum > 6 then goto 1;
             Writeln('Maze := ',op.mazenum,' Speed := ',op.speed);
             readkey;
         end;
         op.speed := op.speed * 20;
         write(options, op);
         writemazes;
         close(options);
        end
        else
         begin
           clrscr;
           writeln('Options.exe [/?] [Maze Number] [Snake Speed]');
           writeln;
           writeln('   if you want to run through parameters, you have to use both');
           writeln('                 Maze number and speed.');
           Writeln;
           Writeln('              [/?] : This Help screen');
           writeln('     [Maze Number] : The maze you want to play in');
           writeln('     [Snake Speed] : It''s quite self-explanatory!');
           readkey;
         end; }
  end.