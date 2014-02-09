{****************************************************************************}
UNIT Bahnunit;
{****************************************************************************}

{  SUBROUTINEN FUER DIE EISENBAHNSTEUERUNG WORKSHOP SS 86
   ERSTELLT: RENE REHMANN IAM 17.3.86
   MODIFIZIERT: RENE REHMANN IAM 28.4.86
   MODIFIZIERT: RENE REHMANN IAM 19.5.87
   MODIFIZIERT: BENJAMIN HAAS (hs), 20.4.91
                   UMWANDLUNG IN UNIT FUER TP 5.0
   MODIFIZIERT : Delay in Prozedur Init eingebaut, Graphik als Variable
   definiert, nicht als Konstante. Wird In Unit Init_Anl gesetzt.
}

{$S+} { Enable stack checking       }
{$V-} { Var string checking relaxed }
{$R-} { Range checking off          }

{****************************************************************************}
INTERFACE
{****************************************************************************}

Uses
   Crt,
   Dos;

CONST
  graphik    : BOOLEAN = true;
  simulation : BOOLEAN = false;

  {  ANLAGEN-SPEZIFISCHE PARAMETER                                           }

  num_signals = 14;                   {  ANZAHL DER SIGNALE                  }
  num_shunts = 6;                     {  ANZAHL DER WEICHEN                  }
  num_sensors = 21;                   {  ANZAHL DER SENSOREN                 }
  num_trains = 2;                     {  ANZAHL DER ZUEGE                    }
  max_speed = 3;                      {  maximale erlaubte Geschwindigkeit   }
  train_numbers : ARRAY[1..2] OF INTEGER = (22,44);

TYPE
  sensor_type = 1..num_sensors;
  sensor_status = (inactive, clock_dir, counterclock_dir);
  sensor_array_type = ARRAY[sensor_type] OF sensor_status;
  train_type = 1..num_trains;
  speed_type = 0..max_speed;
  signal_state = (red_on, green_on);
  signal_type = 1..num_signals;
  shunt_state = (main,side);
  shunt_type = 1..num_shunts;



PROCEDURE init;

PROCEDURE finish;

PROCEDURE Chg_Light(signal_nr : signal_type;
                    state : signal_state);

PROCEDURE Chg_shunt(shunt_nr : shunt_type;
                    state    : shunt_state);

PROCEDURE Chg_Train(train_nr : train_type;
                    speed : speed_type;
                    dir_chg : BOOLEAN;
                    funct : BOOLEAN);

PROCEDURE Get_Sensor(VAR Sensor_Array : Sensor_array_type);

PROCEDURE Stop;

PROCEDURE Free;

PROCEDURE Line;
{****************************************************************************}
IMPLEMENTATION
{****************************************************************************}

TYPE
  cursor_type = (cur_off, cur_on);

CONST

  {  ANLAGEN-SPEZIFISCHE PARAMETER                                           }

  num_decoder = 3;                    {  # DECODER = (num_sensors DIV 8) + 1 }
  num_bytes = 6;                      {  # BYTES VON V.24 = 2*num_decoder    }

  {  KONSTANTEN, WELCHE VON DER GRAPHIK BENOETIGT WERDEN                     }

  normal = 15;                        {  FARBE DER SCHIENEN = WEISS          }
  weiss = 15;                         {  FARBE DER SENSOREN (inactive)= WEISS}
  rot_blink = 28;                     {  FARBE DER SENSOREN = ROT - BLINKEND }
  rot = 12;                           {  FARBE DER SIGNALE (stop) = ROT      }
  gruen = 10;                         {  FARBE DER SIGNALE (fahren) = GRUEN  }
  hintergrund = 0;                    {  FARBE DES HINTERGRUNDS = SCHWARZ    }
  cursor_off : cursor_type =          {  CURSOR NICHT SICHTBAR               }
               cur_off;
  cursor_on : cursor_type =           {  CURSOR NORMALZUSTAND                }
              cur_on;
  int8vec  : pointer = nil;           { zum speichern des interrupt 8 vectors}
  Magnet_set  : BOOLEAN = FALSE;
  time_out    : INTEGER = 0;


TYPE
  new_sensor_type = 0..num_sensors;
  sensor_dir = clock_dir..counterclock_dir;
  one_two = 1..2;
  byte_type = ARRAY[one_two] OF BYTE;

VAR
  train_position : ARRAY[1..num_trains] OF new_sensor_type;
  train_dir      : ARRAY[1..num_trains] OF sensor_dir;
  old_sensor_array : sensor_array_type;


  {--------------------------------------------------------------------------}
  { Graphik - Routinen                                                       }
  {--------------------------------------------------------------------------}

  {  ZEICHNET DIE SCHIENEN AUF DEM BILDSCHIRM                                }

PROCEDURE line;

  TYPE
    linetypev = RECORD
                  bx : INTEGER;
                  by : INTEGER;
                  ey : INTEGER;
                  t : INTEGER;
                END;
    linetypeh = RECORD
                  bx : INTEGER;
                  by : INTEGER;
                  ex : INTEGER;
                  t : INTEGER;
                END;
    shunttype = RECORD
                  x : INTEGER;
                  y : INTEGER;
                  t : INTEGER;
                END;

  CONST
    linev : ARRAY[1..3] OF linetypev =
  ((bx :  2; by : 4; ey : 21; t : 221), (bx : 35; by :  5; ey : 20; t : 222),
   (bx : 39; by : 4; ey : 21; t : 222));
    lineh : ARRAY[1..4] OF linetypeh =
  ((bx :  2; by :  3; ex : 39; t : 220), (bx :  7; by :  5; ex : 27; t : 220),
   (bx :  7; by : 20; ex : 27; t : 223), (bx :  2; by : 22; ex : 39; t : 223));
    shunt : ARRAY[1..4] OF shunttype =
  ((x :  6; y : 5; t : 222), (x :  6; y : 20; t : 222),
   (x : 28; y : 5; t : 221), (x : 28; y : 20; t : 221));
  VAR
    i : INTEGER;
    j : INTEGER;

  BEGIN
    TEXTCOLOR(normal);
    FOR i := 1 TO 4 DO
      BEGIN
        GOTOXY(lineh[i].bx, lineh[i].by);
        FOR j := lineh[i].bx TO lineh[i].ex DO
          BEGIN
            WRITE(CHR(lineh[i].t));
          END;
      END;
    FOR i := 1 TO 3 DO
      FOR j := linev[i].by TO linev[i].ey DO
        BEGIN
          GOTOXY(linev[i].bx, j);
          WRITE(CHR(linev[i].t));
        END;
    FOR i := 1 TO 4 DO
      BEGIN
        GOTOXY(shunt[i].x, shunt[i].y);
        WRITE(CHR(shunt[i].t));
      END;
  END;                                {   line                               }

  {  WECHSELT DIE FARBE DES SIGNAL signal-nr AUF light                       }

PROCEDURE chg_signal_g(signal_nr : signal_type;
                       light : signal_state);

  TYPE
    signaltype = RECORD
                   x : INTEGER;
                   y : INTEGER;
                 END;
  CONST
    signal : ARRAY[1..num_signals] OF signaltype =
    ((x : 24; y :  2), (x : 10; y :  2), (x : 24; y :  7), (x : 10; y :  7),
     (x :  3; y :  2), (x :  3; y : 23), (x : 10; y : 23), (x : 24; y : 23),
     (x : 10; y : 18), (x : 24; y : 18), (x : 38; y : 18), (x : 38; y :  7),
     (x : 34; y : 18), (x : 34; y : 7));
    signal_sign = 2;                  {  ASCII - Code 2                      }
    signal_color : ARRAY[0..1] OF INTEGER = (rot, gruen);


  BEGIN
    GOTOXY(signal[signal_nr].x, signal[signal_nr].y);
    TEXTCOLOR(signal_color[ORD(light)]);
    IF LIGht = green_on then WRITE('+') else WRITE('-');
  END;                                {  chg_signal_g                        }

  {  WECHSELT FARBE DES SENSORS sensor_nr AUF on_off                         }

PROCEDURE put_on_off_sensor(sensor_nr : sensor_type;
                            on_off : sensor_status);

  TYPE
    sensortype = RECORD
                   x : INTEGER;
                   y : INTEGER;
                 END;

  CONST
    sensor : ARRAY[1..num_sensors] OF sensortype =
    ((x : 25; y :  3), (x :  9; y :  3), (x : 25; y :  5), (x :  9; y :  5),
     (x :  4; y :  3), (x :  4; y : 22), (x :  9; y : 22), (x : 25; y : 22),
     (x :  9; y : 20), (x : 25; y : 20), (x : 38; y : 22), (x : 38; y :  3),
     (x : 35; y : 19), (x : 35; y :  6), (x : 17; y :  3), (x : 17; y :  5),
     (x :  2; y : 12), (x : 17; y : 22), (x : 17; y : 20), (x : 39; y : 12),
     (x : 35; y : 12));
    sensor_sign = 9;
    sensor_color : ARRAY[0..2] OF INTEGER = (weiss, rot_blink, rot_blink);

  BEGIN
    GOTOXY(sensor[sensor_nr].x, sensor[sensor_nr].y);
    TEXTCOLOR(sensor_color[ORD(on_off)]);
    WRITE(CHR(sensor_sign));
    textcolor(10);   {AG}
  END;                                {  put_on_off_sensor                   }

  {  AENDERT IN GRAPHIK DIE WEICHENSTELLUNG DER WEICHE shunt_nr AUF position }

PROCEDURE chg_shunt_g(shunt_nr : shunt_type;
                      position : shunt_state);

  TYPE
    shunttype = RECORD
                  x1 : INTEGER;
                  y1 : INTEGER;
                  t1 : INTEGER;
                  x2 : INTEGER;
                  y2 : INTEGER;
                  t2 : INTEGER;
                END;

  CONST
    shunt : ARRAY[1..num_shunts] OF shunttype =
    ((x1 : 27; y1 :  3; t1 : 220; x2 : 28; y2 :  4; t2 :  221),
     (x1 :  7; y1 :  3; t1 : 220; x2 :  6; y2 :  4; t2 :  222),
     (x1 :  7; y1 : 22; t1 : 223; x2 :  6; y2 : 21; t2 :  222),
     (x1 : 27; y1 : 22; t1 : 223; x2 : 28; y2 : 21; t2 :  221),
     (x1 : 36; y1 : 22; t1 : 223; x2 : 35; y2 : 21; t2 : 222),
     (x1 : 36; y1 :  3; t1 : 220; x2 : 35; y2 :  4; t2 : 222));

  VAR
    sign1 : INTEGER;
    sign2 : INTEGER;

  BEGIN
    TEXTCOLOR(normal);
    IF ORD(position) = 0
    THEN
      BEGIN
        sign1 := shunt[shunt_nr].t1;
        sign2 := 32;                  {  blank  }
      END
    ELSE
      BEGIN
        sign1 := 32;                  {  blank  }
        sign2 := shunt[shunt_nr].t2;
      END;
    GOTOXY(shunt[shunt_nr].x1, shunt[shunt_nr].y1);
    WRITE(CHR(sign1));
    GOTOXY(shunt[shunt_nr].x2, shunt[shunt_nr].y2);
    WRITE(CHR(sign2));
  END;                                {  chg_shunt_g                         }

  {  AENDERT DEN CURSOR AUF curtype                                          }

PROCEDURE set_cursor(curtype : cursor_type);

  CONST
    cursor : ARRAY[0..1] OF INTEGER =
             ($0801, $0607);

  VAR
    regs : registers;

  BEGIN
    regs.ax := $0100;
    regs.cx := cursor[ORD(curtype)];
    INTR($10, regs);
  END;                                {  set_cursor                          }

PROCEDURE Chg_sensor(Sensor_Array : Sensor_array_type);

TYPE
  new_shunt_type  = main..side;

CONST
  sensor_position : ARRAY[1..num_sensors,sensor_dir,shunt_state]
                    OF sensor_type =
  (((12,14),(15,15)),((15,15),( 5, 5)),((12,14),(16,16)),((16,16),( 5, 5)),
   (( 2, 4),(17,17)),((17,17),( 7, 9)),(( 6, 6),(18,18)),((18,18),(11,13)),
   (( 6, 6),(19,19)),((19,19),(11,13)),(( 8,10),(20,20)),((20,20),( 1, 3)),
   (( 8,10),(21,21)),((21,21),( 1, 3)),(( 1, 1),( 2, 2)),(( 3, 3),( 4, 4)),
   (( 5, 5),( 6, 6)),(( 7, 7),( 8, 8)),(( 9, 9),(10,10)),((11,11),(12,12)),
   ((13,13),(14,14)));

VAR
  stop        : BOOLEAN;
  other       : BOOLEAN;
  found       : BOOLEAN;
  next        : sensor_type;
  sensor      : sensor_type;
  zug         : train_type;
  other_train : train_type;
  block_chg   : new_shunt_type;

BEGIN
  FOR next := 1 TO num_sensors DO
    IF sensor_array[next] = inactive
      THEN
        sensor_array[next] := old_sensor_array[next];
  FOR zug := 1 TO num_trains DO
    BEGIN
      stop := FALSE;
      IF train_position[zug] <> 0
        THEN
          WHILE(NOT stop) DO
          BEGIN
            stop := TRUE;
            FOR block_chg := main TO side DO
              BEGIN
                IF sensor_array[train_position[zug]] = inactive
                  THEN next := Sensor_position[train_position[zug],
                               train_dir[zug],block_chg]
                  ELSE next := Sensor_position[train_position[zug],
                               sensor_array[train_position[zug]],block_chg];
                IF sensor_array[next] <> inactive
                  THEN
                    BEGIN
                      sensor_array[train_position[zug]] := inactive;
                      put_on_off_sensor(train_position[zug],inactive);
                      train_position[zug] := next;
                      put_on_off_sensor(train_position[zug],
                                        sensor_array[train_position[zug]]);
                      stop := FALSE;
                    END;
              END;
          END;
    END;
  FOR zug := 1 TO num_trains DO
    IF train_position[zug] = 0
      THEN
        BEGIN
          found := FALSE;
          FOR sensor := 1 TO num_sensors DO
            IF (sensor_array[sensor] <> inactive) AND (NOT found)
              THEN
                BEGIN
                  other := FALSE;
                  FOR other_train := 1 TO num_trains DO
                    IF sensor = train_position[other_train]
                      THEN
                        other := TRUE;
                  IF NOT other
                    THEN
                      BEGIN
                        stop  := FALSE;
                        found := TRUE;
                        train_position[zug] := sensor;
                        train_dir[zug] := sensor_array[sensor];
                        put_on_off_sensor(train_position[zug],
                                          sensor_array[train_position[zug]]);
                        WHILE(NOT stop) DO
                          FOR block_chg := main TO side DO
                            BEGIN
                              stop := TRUE;
                              next := Sensor_position[train_position[zug],
                                      sensor_array[train_position[zug]],
                                      block_chg];
                              IF sensor_array[next] <> inactive
                                THEN
                                  BEGIN
                                    sensor_array[train_position[zug]] :=
                                                               inactive;
                                    put_on_off_sensor(train_position[zug],
                                                      inactive);
                                    train_position[zug] := next;
                                    put_on_off_sensor(train_position[zug],
                                            sensor_array[train_position[zug]]);
                                    stop := FALSE;
                                  END;
                            END;
                      END;
                END;
        END;
  old_sensor_array := sensor_array;

END;                                  { Chg_sensor                           }

  {  INITIALISIERT DIE GRAPHIK-ATTRIBUTE                                     }

PROCEDURE init_g;

  VAR
    i : INTEGER;

  BEGIN
    TEXTMODE(C80);
    TEXTBACKGROUND(Hintergrund);
    CLRSCR;
    set_cursor(cursor_off);
    line;
    FOR i := 1 TO num_signals DO
      chg_signal_g(i, red_on);
    FOR i := 1 TO num_sensors DO
      put_on_off_sensor(i, inactive);
    FOR i := 1 to num_sensors DO
      old_sensor_array[i] := inactive;
    FOR i := 1 to num_trains DO
      train_position[i] := 0;
  END;

  {  STELLT GRAPHIK-ATTRIBUTE WIEDER ZURUECK                                 }

PROCEDURE finish_p;

  BEGIN
    set_cursor(cursor_on);
    TEXTMODE(C80);
  END;                                {   finish                             }

  {--------------------------------------------------------------------------}
  { Routinen fuer Kommunikation mit V.24 Schnittstelle                       }
  {--------------------------------------------------------------------------}

  {  INITIALISIERT SERIELLE SCHNITTSTELLE AUF 2400 BAUD, 8 DATENBIT          }
  {  1 STARTBIT, 1 STOPBIT, KEIN PARITYBIT                                   }

PROCEDURE init_port;

  {  SCHREIBT info AUF SERIELLE SCHNITTSTELLE                                }

  VAR
    reg : registers;

BEGIN
  reg.ax := $00A3;                   { Initialisierung wie oben beschrieben  }
  reg.dx := $0000;                   { des 1. asynchronen Ports              }
  INTR($14,reg);
END;

{ Schreibt count mal info - byte auf V24-Schnittstelle                       }

PROCEDURE write_to_port(count : one_two;
                        info  : byte_type);

  VAR
    reg : registers;


BEGIN
{  repeat begin
         reg.ax     := PORT[$3fe];
  end;
  until ((reg.ax AND 16)=16); }
  delay(20);
  reg.ax := $0100 + info[1];
  reg.dx := $0000;
  INTR($14,reg);
  IF count > 1
    THEN
      BEGIN
        DELAY(20);
        Port[$3f8] := info[2];
      END;
END;

PROCEDURE old_write_to_port(count : one_two;
                        info  : byte_type);

  VAR
    reg : registers;

BEGIN
  reg.ax := $0100 + info[1];
  reg.dx := $0000;
  INTR($14,reg);
  IF count > 1
    THEN
      BEGIN
        DELAY(10);
        Port[$3f8] := info[2];
      END;
END;


PROCEDURE timer_init(Flags,CS,IP,AX,BX,CX,DX,SI,DI,DS,ES,BP: word);
interrupt;
var wart : word;
BEGIN
  INLINE(
         $8C/$D8/                     { MOV  AX,DS    ;changed, because of   }
                                      {                new memory model (hs) }
         $8E/$C0/                     { MOV  ES,AX                           }
         $BF/magnet_set/              { MOV  DI,OFS magnet_set               }
         $26/$8A/$05/                 { MOV  AL,ES:[DI]                      }
         $30/$E4/                     { XOR  AH,AH                           }
         $08/$C0/                     { OR   AL,AL                           }
         $75/$02/                     { JNZ  count                           }
         $EB/$29/                     { JMP  return                          }
{count}  $8C/$D8/                     { MOV  AX,DS    ;changed, because of   }
                                      {                new memory model (hs) }
         $8E/$C0/                     { MOV  ES,AX                           }
         $BF/time_out/                { MOV  DI,OFS time_out                 }
         $26/$8B/$05/                 { MOV  AX,ES:[DI]                      }
         $40/                         { INC  AX                              }
         $26/$89/$05/                 { MOV  ES:[DI],AX                      }
         $3D/$12/$00/                 { CMP  AX,0018                         }
         $74/$02/                     { JE   reset                          }
         $EB/$14/                     { JMP  return                          }
{reset}  $BA/$00/$00/                 { MOV  DX,0000                         }
         $B8/$20/$01/                 { MOV  AX,0120                         }
         $CD/$14/                     { INT  14                              }
         $8C/$D8/                     { MOV  AX,DS    ;changed, because of   }
                                      {                new memory model (hs) }
         $8E/$C0/                     { MOV  ES,AX                           }
         $BF/magnet_set/              { MOV  DI,OFS magnet_set               }
         $B0/$00/                     { MOV  AL,00                           }
         $26/$88/$05/                 { MOV  ES:[DI],00                      }
{return} $FB);                        { STI                                  }
END;                                  { timer_init                           }

PROCEDURE setupints;
  { store the normal int 8 vector and replace it}
BEGIN
  GetIntVec($1c,int8vec);
  INLINE($FA);                        { turn off interrupts                  }
  SetIntVec($1c,@timer_init);
  INLINE($FB);                        { Turn on interrupts                   }
END;                                  { setupints                            }

PROCEDURE restoreints;
  { restore the int 8 vector to what it was on entry}
BEGIN
  INLINE($FA);
  SetIntVec($1c,int8vec);             {set int 8 vector                      }
  INLINE($FB);
END;                                  {restoreints                           }

PROCEDURE Get_Sensor_p(VAR Sensor_Array : Sensor_array_type);

  CONST
    read_sensors = 128;
    sensor_numbers : ARRAY[1..24] OF INTEGER =
                     (  5,  2,  4,  0, 17,  9,  7,  6,  8, 10, 21,  0, 16,
                       15, 19, 18, 20,  0, 12, 14,  1,  3, 11, 13);

  TYPE
    num_byte_type   = 1..num_bytes;
    byte_array_type = ARRAY[1..num_bytes] OF BYTE;

  VAR
    byte_array : byte_array_type;
    i : INTEGER;
    j : INTEGER;

     {--------------------------------------------------------------------------}
     { Assembler - Routine von Dataset V_24.COM (zeitkritisch)                  }
     {   uebersetzt in inline, B.Haas, 23.5.91                                  }
     {--------------------------------------------------------------------------}

     {  LIEST number_of_bytes BYTES VON SERIELLER SCHNITTSTELLE IN byte_array,  }
     {  NACHDEM command GESCHRIEBEN WURDE                                       }
     PROCEDURE read_from_port(number_of_bytes : INTEGER; command : BYTE;
                                 VAR byte_array : byte_array_type);
     var wart : word;
     BEGIN
             repeat begin
                    wart    := PORT[$3fe];
             end;
             until ((wart AND 16)=16);
             delay(20);
        inline(
               $57/             { PUSH	DI                           }
               $BA/$FD/$03/     { MOV	DX,03FD                      }
               $EC/             { IN	AL,DX                        }
               $24/$FC/         { AND	AL,FC                        }
               $EE/             { OUT	DX,AL                        }
               $BA/$00/$00/     { MOV	DX,0000                      }
               $8E/$46/$08/     { MOV	ES,[BP+08] = seg(byte_array) }
               $8B/$7E/$06/     { MOV	DI,[BP+06] = ofs(byte_array) }
               $8B/$4E/$0C/     { MOV	CX,[BP+0C] = number_of_bytes }
               $8A/$46/$0A/     { MOV	AL,[BP+0A] = command         }
               $B4/$01/         { MOV	AH,01                        }
               $CD/$14/         { INT	14                           }
        {LBL:} $B8/$00/$02/     { MOV	AX,0200                      }
               $CD/$14/         { INT	14                           }
               $26/             { ES:                                }
               $88/$05/         { MOV	[DI],AL                      }
               $47/             { INC	DI                           }
               $E2/$F5/         { LOOP	LBL                          }
               $5F              { POP	DI                           }
              )
     END;


  BEGIN
    FOR i := 1 TO num_sensors DO
      Sensor_Array[i] := inactive;
    FOR i := 1 TO num_bytes DO
      byte_array[i] := 0;
    Restoreints;
    Read_from_Port(num_bytes, read_sensors+num_decoder,byte_array);
    Setupints;
    FOR i := 1 TO num_bytes DO
      FOR j := 1 TO 4 DO
        BEGIN
          IF (byte_array[i] MOD 4) = 2
            THEN
              Sensor_Array[sensor_numbers[((i-1)*4)+j]]
                             := clock_dir
            ELSE
              IF (byte_array[i] MOD 4) = 1
                THEN
                  Sensor_Array[sensor_numbers[((i-1)*4)+j]]
                             := counterclock_dir;
          byte_array[i] := byte_array[i] SHR 2;
        END;
  END;                                {  Get_Sensor_p                        }

PROCEDURE Chg_Train_p(train_nr : train_type;
                      speed : speed_type;
                      dir_chg : BOOLEAN;
                      funct : BOOLEAN);

  CONST
    function_level = 16;
    dir_chg_level = 15;
    speed_array : ARRAY[0..max_speed] OF BYTE =
                    (0,4,6,7);

  VAR
    temp   : BOOLEAN;
    bytes  : byte_type;

  BEGIN
    temp := magnet_set;
    magnet_set := FALSE;
    bytes[2] := train_numbers[train_nr];
    IF dir_chg
    THEN
      IF funct
      THEN
        BEGIN
          bytes[1] := function_level+dir_chg_level;
          Write_to_Port(2,bytes);
        END
      ELSE
        BEGIN
          bytes[1] := dir_chg_level;
          Write_to_Port(2,bytes);
        END
    ELSE
      IF funct
      THEN
        BEGIN
          bytes[1] := function_level+speed_array[speed];
          Write_to_Port(2,bytes);
        END
      ELSE
        BEGIN
          bytes[1] := speed_array[speed];
          Write_to_Port(2,bytes);
        END;
    magnet_set := temp;
  END;                                { Chg_train_p                          }

PROCEDURE Chg_Light_p(signal_nr : signal_type;
                      state : signal_state);

  CONST
    signals : ARRAY[signal_type] OF BYTE = ( 14, 26, 15, 27, 28, 20, 18,
                                             6, 19,  7,  2, 10,  3, 11);
    sig_state : ARRAY[0..1] OF BYTE = (34, 33);

  VAR
    bytes : byte_type;

  BEGIN
    magnet_set := FALSE;
    bytes[1] := sig_state[ORD(state)];
    bytes[2] := signals[signal_nr];
    Write_to_Port(2,bytes);
    Magnet_set := TRUE;
    Time_out   := 0;
  END;                                { Chg_Light_p                          }

PROCEDURE Chg_shunt_p(shunt_nr : shunt_type;
                      state : shunt_state);

  CONST
    shunts : ARRAY[shunt_type] OF BYTE = (13, 25, 17, 5, 1, 9);
    shu_state : ARRAY[0..1] OF BYTE = (33, 34);

  VAR
    bytes : byte_type;

  BEGIN
    magnet_set  := FALSE;
    bytes[1] := shu_state[ORD(state)];
    bytes[2] := shunts[shunt_nr];
    Write_to_Port(2,bytes);
    Magnet_set := TRUE;
    Time_out   := 0;
  END;                                { Chg_shunt_p                          }

PROCEDURE Stop_p;

CONST
  Nothalt = 97;

VAR
  bytes : byte_type;

BEGIN
  delay(100);
  bytes[1] := Nothalt;
  old_Write_to_Port(1,bytes);
END;                                  { Stop_p                               }

PROCEDURE Free_p;

CONST
  Go      = 96;

VAR
  bytes : byte_type;

BEGIN
  bytes[1] := Go;
  Write_to_Port(1,bytes);
END;

  {--------------------------------------------------------------------------}
  { Allgemeine Routinen                                                      }
  {--------------------------------------------------------------------------}

PROCEDURE init;

VAR
  Sensor_Array  : Sensor_array_type;
  i             : INTEGER;

  BEGIN
    CheckBreak := false;    { Disable program break with Ctrl-Break }
    IF graphik THEN init_g;
    IF NOT simulation
      THEN
        BEGIN
          delay(100);
          init_port;
          setupints;
          free_p;
          FOR i := 1 to num_trains DO begin
            Chg_Train_p(i,0,false,false);
          end;
          FOR i:= 1 to num_signals DO BEGIN
            Chg_Light_p(i,red_on);
          END;
          FOR i := 1 to num_shunts DO
            Chg_shunt_p(i,main);
          Get_Sensor_p(Sensor_array);
        END;
  END;                                { init                                 }

PROCEDURE finish;

  VAR
    bytes : byte_type;

  BEGIN
    IF graphik THEN finish_p;
    IF NOT simulation
      THEN
        BEGIN
          restoreints;
          bytes[1] := 32;
          old_Write_to_port(1,bytes);     { reset magnetic elements              }
        END;
  END;                                { finish                               }

PROCEDURE Chg_Light(signal_nr : signal_type;
                    state : signal_state);

BEGIN
  IF graphik THEN Chg_Signal_g(signal_nr,state);
  IF NOT simulation THEN Chg_Light_p(signal_nr,state);
END;                                  { Chg_Light                            }

PROCEDURE Chg_shunt(shunt_nr : shunt_type;
                    state    : shunt_state);

BEGIN
  IF graphik THEN Chg_shunt_g(shunt_nr,state);
  IF NOT simulation THEN Chg_shunt_p(shunt_nr,state);
END;                                  { Chg_shunt                            }

PROCEDURE Chg_Train(train_nr : train_type;
                    speed : speed_type;
                    dir_chg : BOOLEAN;
                    funct : BOOLEAN);

BEGIN
  IF NOT simulation THEN Chg_Train_p(train_nr,speed,dir_chg,funct);
END;                                  { Chg_Train                            }

PROCEDURE Get_Sensor(VAR Sensor_Array : Sensor_array_type);

BEGIN
  IF NOT simulation THEN Get_Sensor_p(Sensor_Array)
  else writeln('wrong');
  IF graphik THEN Chg_Sensor(Sensor_Array);
END;                                  { Get_sensor                           }

PROCEDURE Stop;

BEGIN
  IF NOT simulation THEN Stop_p;
END;                                  { Stop                                 }

PROCEDURE Free;

BEGIN
  IF NOT simulation THEN Free_p;
END;                                  { Free                                 }

{****************************************************************************}

END.
{****************************************************************************}
