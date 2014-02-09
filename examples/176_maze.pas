  Program snaky_maze;

 // this is a draft and on progess, doesn't work now!!
  //uses crt;

  Type
    stail = record
     x,y : integer;
  end;


   Ttail  = array [1..100] of stail;
        {function getx   : integer;
        function gety   : integer;
        Procedure Qeditxy(i,j:integer);
        Procedure right;
        Procedure left;
        Procedure up;
        Procedure down;
        Procedure readkeys;
        Procedure tails;
        Procedure collidewall;
        Procedure collideself;
     end;}

  topscore = record
     name : string;
     score, MazeNum : integer;
  end;

  walls = record
    startx, starty, endx, endy : byte;
  end;

  maze = record
    mazetype, WallNum, X, Y : byte;
    wall : array[1..20] of walls;
  end;

  option = record
    mazenum, speed : Byte;
  end;

  var
     ssize, x, y     : integer;
     ascore, aname      : topscore;
     op          : option;
     currentmaze : maze;
     mazes       : maze;     //file of
     //names       : file of topscore;
     //options     : file of option;
     tscore      : byte;
     oldkey      : char;
     tname       : string;
     //s           : snake;
     num, k, j   : byte;
     ax, ay, i, q: integer;
     quit        : boolean;
     tail      : TTail;
    cFrm: TForm;

  function getx : integer;
    begin
       result:= x;
    end;

  function gety : integer;
    begin
       result:= y;
    end;

  Procedure editxy(i,j:integer);
    begin
       x:= i;
       y:= j;
    end;

  Procedure right;
    begin
      inc(x);
    end;

  Procedure left;
    begin
      dec(x);
    end;

  Procedure up;
    begin
      dec(y);
    end;

  Procedure down;
  begin
    inc(y);
  end;

  Procedure collidewall;
   begin
    case currentmaze.mazetype of
    1 : begin
         for i := 1 to currentmaze.wallnum do begin
          for j := currentmaze.wall[i].starty to currentmaze.wall[i].endy do
           if (getx = currentmaze.wall[i].startx) and (gety = j)
           then quit := true;
         end;
        end;

    2 : begin
         for i := 1 to currentmaze.wallnum do begin
          for j := currentmaze.wall[i].startx to currentmaze.wall[i].endx do
           if (getx = j) and (gety = currentmaze.wall[i].starty)
           then quit := true;
         end;
        end;
    end;

      for j := 3 to 23 do
     if (getx = 3) and (gety = j)
      then quit := true;

    for j := 3 to 23 do
     if (getx = 78) and (gety = j)
      then quit := true;

    for j := 3 to 78 do
     if (getx = j) and (gety = 3)
      then quit := true;

    for j := 3 to 78 do
     if (getx = j) and (gety = 23)
      then quit := true;
  end;


  Procedure collideself;
   begin
    for j := 2 to ssize do
     for k := 2 to ssize do
      if (tail[j].x = tail[k].x) and (tail[j].y = tail[k].y)
      and (j <> k) then quit := true;
   end;

  Procedure tails;
   begin
    cFrm.canvas.font.color:= clyellow;
    tail[1].x := x;
    tail[1].y := y;
    for k := ssize downto 2 do begin
     tail[k].x := tail[k-1].x;
     tail[k].y := tail[k-1].y;
    end;
    for k := 1 to ssize do begin
     cFrm.canvas.moveto(tail[k].x,tail[k].y);
     cfrm.canvas.font.color:= clblue;
     cFrm.canvas.textout(tail[k].x,tail[k].y,'O');
     write('o')
    end;
    with cFrm.canvas do begin
    moveto(tail[ssize-1].x,tail[ssize-1].y);
    font.color:= clblue;
    textout(tail[ssize-1].x,tail[ssize-1].y,'0');
    moveto(tail[1].x,tail[1].y);
    font.color:= clred;
    textout(tail[1].x,tail[1].y,'');
    moveto(tail[ssize].x,tail[ssize].y);
    font.color:= clBlack;
    textout(tail[ssize].x,tail[ssize].y,' ');
    moveto(1,1);
    end
   end;

  Procedure drawapple;
    begin
     randomize;
      ax := random(74) + 4;  {so 4 away from wall}
      ay := random(19) + 4;  { ditto }

     case currentmaze.mazetype of
     1 : begin
          for j := 1 to currentmaze.wallnum do begin
           for i := currentmaze.wall[j].starty to currentmaze.wall[j].endy do
            if (ax = currentmaze.wall[j].startx) and (ay = i)
            then drawapple;
          end;
         end;

      2 : begin
           for j := 1 to currentmaze.wallnum do begin
            for i := currentmaze.wall[j].startx to currentmaze.wall[j].endx do
             if (ax = i) and (ay = currentmaze.wall[j].starty)
             then drawapple;
            end;
          end;
     end;
     for i := 2 to ssize do
      for j := 2 to ssize do
       if (ax = tail[i].x) and (ay = tail[j].y)
       then drawapple;

   with cFrm.canvas do begin
  
     font.color:= clred;
     textout(ax,ay,'ë');
     if (ssize - 5) > tscore then begin
       font.color:= clred;
       //gotoxy(42,1);
       font.color:= clblack;
       textout(42,1,'You : ');
       //textcolor(white + blink);
       textout(42,1, inttoStr(ssize-5));
       font.color:= clblue;
      end
     else
      begin
       font.color:= clwhite;
       //gotoxy(42,1);
       font.color:=clblack;         //textbackground(black);
       textout(42,1, 'You : '+ inttostr(ssize-5));
       if ssize = 3 then begin
          textout(42,1,'You : 0 ');
        end;
       font.color:= clblue;              //textbackground(cyan);
       end;
     font.color:= clBlack;
     end;
    end;


procedure FormKeyPress(Sender: TObject; var Key: Char);
begin
oldkey:= Key;
 if Key = #27 then cfrm.close;
end; 

Procedure readkeys;
  var m: char;
  begin        {Arrow keys: Right := N, Left := K, Up := H and Down := P}
   Case oldkey of
     'M' : m:= 'M';
     'H' : m:= 'H';
     'K' : m:= 'K';
     'P' : m:= 'P';
   End;
   //if cFrm.canvas.keypressed then m := upcase(readkey);
   m:= upcase(oldkey)
   if (oldkey = 'M') and (m = 'K') then m := oldkey;
   if (oldkey = 'H') and (m = 'P') then m := oldkey;
   if (oldkey = 'K') and (m = 'M') then m := oldkey;
   if (oldkey = 'P') and (m = 'H') then m := oldkey;
   case m of
   'H'  :  Begin
            up;
            Oldkey := 'H';
            tails;
           end;
    'K'  : Begin
            left;
            Oldkey := 'K';
            tails;
           end;
    'P'  : Begin
            down;
            Oldkey := 'P';
            tails;
           end;
    'M'  : Begin
            right;
            Oldkey := 'M';
            tails;
           end;
    '+'  : dec(op.speed);
    '-'  : inc(op.speed);
    //'U'  : readkey;
    'Q'  : quit := true;
   end;

  end;

  {Procedure addscore;
    begin
      //Clrscr;
      reset(names);
      seek(names, filesize(names));
      gotoxy(2,30);
      write('Enter your name :');
      readln(ascore.name);
      ascore.score := s.ssize - 5;
      ascore.mazenum := op.mazenum;
      write(names,ascore);
      close(names)
    end;

  Procedure clearscores;
   begin
     reset(names);
     rewrite(names);
     close(names);
   end;

  procedure printscore;
    var artscore : array [1..18] of topscore;
        temp  : topscore;
    begin
      clrscr;
      i := 2;
      reset(names);
      if ascore.name = 'cCc' then rewrite(names)
      else
      begin
       k := 0;
        while not eof(names) do
         begin
          inc(k);
          read(names,aname);
          artscore[k] := aname;
         end;
       artscore[18] := ascore;
       q := filesize(names);
       for i := 1 to q - 1 do
           for j := i + 1 to q do
            begin
             if artscore[j].score > artscore[i].score then
              begin
               temp := artscore[i];
               artscore[i] := artscore[j];
               artscore[j] := temp;
              end;
            end;
        j := 3;
        if artscore[1].name = '' then artscore[1] := ascore;
        for i := 1 to filesize(names) do
         begin
          inc(j);
          gotoxy(10,j);
          write(i,': ',artscore[i].name,'    Maze: ',artscore[i].Mazenum);
          gotoxy(40,j);
          write(artscore[i].score);
         end;
       writeln;
       writeln('           Press any key to quit');
       readkey;
       rewrite(names);
       For q := 1 to i do
        begin
         write(names,artscore[q]);
        end;

       close(names);
      end;
     end; }
     
     
procedure LoadForm;
begin
  cFrm:= TForm.create(self);
  try
    with cFrm do begin
      caption:= 'choasMAX((((((*)';  
      height:= 450;
      width:= 460;
      color:= clwhite;
      Position := poScreenCenter;
      onKeyPress:= @FormKeyPress
      show;
    end;
    Application.processMessages;
  except
    exit
  end  
end;  

  Procedure load;
    var temp     : byte;
        tempname : string;
    begin
     //point
     //print
      //reset(mazes);
      //reset(options);
      //reset(names);
      num := 1;
      //read(options,op);
      num := op.mazenum;
      //read(mazes, currentmaze);
      tscore := 0;
      tname := 'None';
      currentmaze.mazetype:= 1;
       {while not eof(names) do begin
           read(names,ascore);
           temp := ascore.score;
           tempname := ascore.name;
           if temp > tscore then
            begin
             tscore := temp;
             tname :=  tempname;
            end
           else
            temp := 0;
         end;}
     //close(mazes);
     //close(options);
     //close(names);
     loadForm;
    end;

  Procedure checkcrash;
   begin
    collidewall;
    collideself;
   end;

  Procedure initiate;
   begin
     //textcolor(white);
     writeln('Use the Arrow keys');
     writeln('to move, U to pause and Q to quit');
     writeln('Have Fun!!');
     //textcolor(white);
     oldkey := 'H';
     //readkey;

     case currentmaze.mazetype of
      1 : for j := 1 to currentmaze.wallnum do
            begin
             for i := currentmaze.wall[j].starty to currentmaze.wall[j].endy do
              begin
               //gotoxy(currentmaze.wall[j].startx,i);
               cfrm.canvas.textout(currentmaze.wall[j].startx,i,'Û'); {Û := 219}
              end;
            end;

      2 : for j := 1 to currentmaze.wallnum do
           begin
            for i := currentmaze.wall[j].startx to currentmaze.wall[j].endx do
             begin
              cfrm.canvas.textout(i,currentmaze.wall[j].starty, 'Û');
             end;
           oldkey := 'M';
          end;
    end;
    with cFrm.canvas do begin 
     for i := 3 to 78 do begin
        textout(i,23, 'Û');
      end;
     for i := 3 to 23 do begin
        textout(3,i, 'Û');
      end;
     for i := 3 to 78 do begin
        textout(i,3,'Û');
      end;
     for i := 3 to 23 do begin
        textout(78,i,'Û');
      end;
     //textcolor(white);
     textout(30,10,'Snake!');
     end;
     {gotoxy(12,1);
     write('Topscore : ',tname,' - ',tscore);
     gotoxy(53,1);
     textbackground(cyan);}
     ssize := 3;
     editxy(CurrentMaze.X,CurrentMaze.Y);
     //textcolor(cyan);
     end;

   begin
     //assign(mazes, 'mazes.sna');
     //assign(names, 'score.sna');
     //assign(options, 'option.sna');
     load;
     initiate;
     drawapple;
     readkeys;
     inc(ssize);
     readkeys;
     inc(ssize);
     repeat
      readkeys;
      application.processmessages;
      //sleep(op.speed);
      if (getx = ax)  and (gety = ay)
       then begin inc(ssize);
       if op.speed > 20 then dec(op.speed);
       drawapple;
      end;
      checkcrash;
     //cfrm.canvas.Rectangle(0, 0, cfrm.Width, cfrm.Height); 
     until quit = true;
     //textcolor(white);
     //addscore;
     //printscore;
  end.



