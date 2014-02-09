{*****************************************************}
{ 4GEWINNT.PAS: Implementierung des Spiels 4Gewinnt   }
{ --------------------------------------------------- }
{ Autor       : Max Kleiner                           }
{ Version     : 1.5 vom 07.03.1995                    }
{ Sprache     : Borland Pascal                        }
{*****************************************************}

Program VierGewinnt;

Uses WinTypes, WinProcs, OWindows, ODialogs, Strings;


{*****************************************************}
{                  Globale Konstanten                 }
{*****************************************************}

Const cm_playerstart       = 101;
      cm_computerstart     = 102;
      cm_beenden           = 103;
      cm_anfaenger         = 201;
      cm_fortgeschrittener = 202;
      cm_experte           = 203;
      cm_meister           = 204;
      cm_info              = 301;
      wm_setzestein        = wm_user+1;
      wm_spielfeld         = wm_user+2;
      wm_rechner           = wm_user+3;
      wm_gewonnen          = wm_user+4;
      N                    = 6;
      M                    = 7;
      Blau                 = 1;
      Rot                  = 10;


{*****************************************************}
{                  Typ-Definitionen                   }
{*****************************************************}

Type SpaltenVektor = Array[1..N] Of Integer;
     ZeilenVektor  = Array[1..M] Of Integer;
     SpielMatrix   = Array[1..N] Of ZeilenVektor;

  {---------------- Applikationsobjekt -------------}
  TVierGewinnt=Object(TApplication)
    Procedure InitMainWindow; virtual;
  End;

  {------------------- Hauptfenster ----------------}
  P4GwWindow=^T4GwWindow;
  T4GwWindow=Object(TWindow)
    {--------------------- Daten ---------------------}
    Dialog                              : PDialog;
    MyMenu                              : HMenu;
    SpM                                 : SpielMatrix;
    Count                               : ZeilenVektor;
    Grad, Delta, StX, StY, L, Color,
    ComputerBegin                       : Integer;
    Berechnen, Sieger_Rot, Sieger_Blau,
    Unentschieden                       : Boolean;
    {------------------- Methoden --------------------}
    Constructor Init(AName:PChar);
    Procedure GetWindowClass(Var WndClass:TWndClass);
      virtual;
    Procedure Paint(PaintDC:HDC;
                    Var PaintInfo:TPaintStruct);
      virtual;
    Procedure Reset;
      virtual;
    Procedure Gewonnen(Var Msg:TMessage);
      virtual wm_first + wm_gewonnen;
    Procedure Spielfeld(Var Msg:TMessage);
      virtual wm_first + wm_spielfeld;
    Procedure SetzeStein(Var Msg:TMessage);
      virtual wm_first + wm_setzestein;
    Procedure WMMouseMove(Var Msg:TMessage);
      virtual wm_first+wm_MouseMove;
    Procedure WMLButtonDown(Var Msg:TMessage);
      virtual wm_first+wm_LButtonDown;
    Procedure PlayerStart(Var Msg:TMessage);
      virtual cm_first + cm_playerstart;
    Procedure ComputerStart(Var Msg:TMessage);
      virtual cm_first + cm_computerstart;
    Procedure GameOver(Var Msg:TMessage);
      virtual cm_first + cm_beenden;
    Procedure Anfaenger(Var Msg:TMessage);
      virtual cm_first + cm_anfaenger;
    Procedure Fortgeschrittener(Var Msg:TMessage);
      virtual cm_first + cm_fortgeschrittener;
    Procedure Experte(Var Msg:TMessage);
      virtual cm_first + cm_experte;
    Procedure Meister(Var Msg:TMessage);
      virtual cm_first + cm_meister;
    Procedure Info(Var Msg:TMessage);
      virtual cm_first + cm_info;
    Procedure Rechner(Var Msg:TMessage);
      virtual wm_first + wm_rechner;
  End;


{*****************************************************}
{                  Globale Variablen                  }
{*****************************************************}

Var _4Gewinnt : TVierGewinnt;


{*****************************************************}
{ FarbWert: Liefert Farbwert zurück (Hilfsfunktion)   }
{*****************************************************}

Function FarbWert(W:Word):TColorRef;
Begin
  Case W Of
    0:FarbWert:=RGB($BF,$BF,$BF);
    1:FarbWert:=RGB($00,$00,$00);
    2:FarbWert:=RGB($FF,$FF,$FF);
    3:FarbWert:=RGB($FF,$00,$ff);
    4:FarbWert:=RGB($00,$00,$00);
    5:FarbWert:=RGB($00,$00,$FF);
    6:FarbWert:=RGB($F7,$00,$00);
    7:FarbWert:=RGB($7F,$7F,$7F);
  End;
End;


{---------- Methoden der Klasse TVierGewinnt ---------}

{*****************************************************}
{ TVierGewinnt.InitMainWindow: Konsturieren des       }
{                              Fensterobjektes        }
{*****************************************************}

Procedure TVierGewinnt.InitMainWindow;
Begin
  MainWindow:=New(P4GwWindow,Init('4 Gewinnt'));
End;


{----------- Methoden der Klasse T4GwWindow ----------}

{*****************************************************}
{ T4GwWindow.Reset: Zurücksetzen der Spielfelddaten   }
{                   (Hilfprozedur)                    }
{*****************************************************}

Procedure T4GwWindow.Reset;

Var i, j : Integer;

Begin
  Berechnen:=False;
  Sieger_Rot:=False;
  Sieger_Blau:=False;
  Unentschieden:=False;
  For i:=1 To N Do
    For j:=1 To M Do SpM[i,j]:=0;
  For j:=1 To M Do Count[j]:=0;
  Delta:=0;
End;


{*****************************************************}
{ T4GwWindow.Init: Konstruktor des Hauptfensters      }
{*****************************************************}

Constructor T4GwWindow.Init;

Begin
  TWindow.Init(NIL,AName);
  Attr.Menu:=LoadMenu(HInstance,'MENU');
  Attr.X:=100;
  Attr.Y:=100;
  ATtr.W:=250;
  Attr.H:=280;
  Grad:=0;
  ComputerBegin:=0;
  Reset;
End;


{*****************************************************}
{ T4GwWindow.GetWindowClass: Cursorattribut löschen,  }
{                            Symbol laden             }
{*****************************************************}

Procedure T4GwWindow.GetWindowClass;
Begin
  TWindow.GetWindowClass(WndClass);
  With WndClass Do Begin
    HIcon:=LoadIcon(HInstance,'ICON_1');
    HCursor:=0;
  End;
End;


{*****************************************************}
{ T4GwWindow.Paint: Wird nach dem Eintreffen einer    }
{                   wm_paint-Meldung aufgerufen.      }
{                   Zeichnet das Fenster neu.         }
{*****************************************************}

Procedure T4GwWindow.Paint;

Var i, j : Word;

Begin
  If GetDeviceCaps(PaintDC,NumColors)<3 Then Color:=0
  Else Color:=4;
  SendMessage(HWindow,wm_spielfeld,0,0);
  For i:=1 To M Do
    For j:=1 To Count[i] Do Begin
      If SpM[j,i]=Rot Then
      SendMessage(HWindow,wm_setzestein,i*256+j,2);
      If SpM[j,i]=Blau Then
      SendMessage(HWindow,wm_setzestein,i*256+j,1);
    End;
  SendMessage(HWindow,wm_gewonnen,0,0);
End;


{*****************************************************}
{ T4GwWindow.SetzeStein: Reaktion auf die Meldung     }
{                        wm_setzestein                }
{                        Setzt einen Spielstein.      }
{                        Msg.wParam: Koordinaten      }
{                        Msg.lParam: Farbnummer       }
{*****************************************************}

Procedure T4GwWindow.SetzeStein;

Var Brush            : HBrush;
    DC               : HDC;
    XPos, YPos, X, Y : Integer;

Begin
  Y:=7-Msg.wParam Mod 256;
  X:=Msg.wParam Div 256;
  XPos:=StX+(X-1)*L+2;
  YPos:=StY+(Y-1)*L+2;
  DC:=GetDC(HWindow);
  Brush:=CreateSolidBrush(FarbWert(Msg.lParam+Color));
  SelectObject(DC,Brush);
  Ellipse(DC,XPos,Ypos,Xpos+L-3,Ypos+L-3);
  ReleaseDc(HWindow,DC);
  DeleteObject(Brush);
End;


{*****************************************************}
{ T4GwWindow.Spielfeld: Reaktion auf die Meldung      }
{                       wm_spielfeld.                 }
{                       Zeichnet das Spielfeld.       }
{*****************************************************}

Procedure T4GwWindow.Spielfeld;

Var Rect             : TRect;
    Brush            : HBrush;
    DC               : HDC;
    Breite, Hoehe, i : Integer;

Begin
  GetClientRect(HWindow,Rect);
  DC:=GetDC(HWindow);
  Brush:=CreateSolidBrush(FarbWert(0+Color));
  FillRect(DC,Rect,Brush);
  Breite:=(Rect.Right-20) Div M;
  Hoehe:=(Rect.Bottom-40) Div N;
  If Breite>Hoehe Then L:=Hoehe Else L:=Breite;
  Brush:=CreateSolidBrush(FarbWert(3+Color));
  SelectObject(DC,Brush);
  StX:=(Rect.Right-L*M) Div 2;
  StY:=(Rect.Bottom-L*N) Div 2;
  Rectangle(DC,StX,StY,L*M+StX+1,L*N+StY+1);
  For i:=1 To M-1 Do Begin
    MoveTo(DC,L*i+StX,StY);
    LineTo(DC,L*i+StX,StY+L*N);
  End;
  For i:=1 To N-1 Do Begin
    MoveTo(DC,StX,L*i+StY);
    LineTo(DC,L*M+StX,L*i+StY);
  End;
  ReleaseDC(HWindow,DC);
  DeleteObject(Brush);
End;


{*****************************************************}
{ T4GwWindow.Gewonnen: Reaktion auf die Meldung       }
{                      wm_gewonnen.                   }
{                      Ausgabe der Gewinnmeldung.     }
{*****************************************************}

Procedure T4GwWindow.Gewonnen;

Var Rect : TRect;
    DC   : HDC;
    GMsg : PChar;

Begin
  DC:=GetDC(HWindow);
  GMsg:='';
  If Sieger_Rot Then GMsg:='  Wow Gratulation !!!  ';
  If Sieger_Blau Then GMsg:='  Leider verloren !!!  ';
  If Unentschieden Then GMsg:='  Unentschieden !!!  ';
  If Sieger_Rot Or Sieger_Blau Or Unentschieden Then
  Begin
    GetClientRect(HWindow,Rect);
    Rect.Top:=2;
    Rect.Bottom:=24;
    SetTextColor(DC,FarbWert(2));
    SetBKColor(DC,FarbWert(1));
    DrawText(DC,GMsg,StrLen(GMsg),Rect,dt_Center);
  End;
  ReleaseDC(HWindow,DC);
End;


{*****************************************************}
{ T4GwWindow.WMMouseMove: Reaktion auf Mausbewegungen }
{*****************************************************}

Procedure T4GwWindow.WMMouseMove;

Var XPos, X      : Integer;
    Help1, Help2 : PChar;

begin
  If Not Berechnen Then Help1:=idc_Arrow
    Else Help1:=idc_wait;
  If Not Berechnen Then Help2:=idc_cross
    Else Help2:=idc_wait;
  XPos:=LoWord(Msg.LParam);
  If (XPos>StX) And (XPos<StX+M*L) And Not
     (Sieger_Rot Or Sieger_Blau Or Unentschieden) Then
  Begin
    X:=(XPos-StX) Div L+1;
    If X>7 Then X:=7;
    If X<1 Then X:=1;
    If Count[X]<N Then SetCursor(LoadCursor(0,Help2))
    Else SetCursor(LoadCursor(0,Help1));
  End
  Else SetCursor(LoadCursor(0,Help1));
End;


{*****************************************************}
{ T4GwWindow.WMLButtonDown: Reaktion auf das Drücken  }
{                           der linken Maustaste      }
{*****************************************************}

Procedure T4GwWindow.WMLButtonDown;

Var XPos, X : Word;

Begin
  XPos:=LoWord(Msg.lParam);
  If (XPos>StX) And (XPos<StX+M*L) And Not
     (Sieger_Rot Or Sieger_Blau Or Unentschieden) Then
  Begin
    X:=(XPos-StX) Div L+1;
    If X>M Then X:=M;
    If X<1 Then X:=1;
    If Count[X]<N Then Begin
      Inc(Count[X]);
      If Count[X]=N Then Inc(Delta);
      SpM[Count[X],X]:=Rot;
      SendMessage(HWindow,wm_setzestein,
                  X*256+Count[X],2);
      SendMessage(HWindow,wm_rechner,0,0);
    End;
  End;
End;


{*****************************************************}
{ T4GwWindow.ComputerStart: Reaktion auf die Auswahl  }
{                 des Menüpunktes 'Computer beginnt'  }
{*****************************************************}

Procedure T4GwWindow.ComputerStart;
Begin
  Reset;
  ComputerBegin:=1;
  SendMessage(HWindow,wm_paint,0,0);
  SendMessage(HWindow,wm_rechner,0,0);
End;


{*****************************************************}
{ T4GwWindow.PlayerStart: Reaktion auf die Auswahl    }
{                des Menüpunktes 'Spieler beginnt'    }
{*****************************************************}

Procedure T4GwWindow.PlayerStart;
Begin
  Reset;
  ComputerBegin:=0;
  SendMessage(HWindow,wm_paint,0,0);
End;

{*****************************************************}
{ T4GwWindow.GameOver: Reaktion auf die Auswahl des   }
{                      Menüpunktes 'Beenden'          }
{*****************************************************}

Procedure T4GwWindow.GameOver;
Begin
  PostQuitMessage(0);
End;


{*****************************************************}
{ T4GwWindow.Info: Reaktion auf die Auswahl des Menü- }
{                  punktes 'Info über 4Gewinnt'       }
{*****************************************************}

Procedure T4GwWindow.Info;
Begin
  Dialog:=New(PDialog,Init(@Self,'DIALOG'));
  Dialog^.Execute;
  Dispose(Dialog,Done);
End;


{ Strategie + Menü-Schwierigkeitsgrad }
{$I RECHNER.INC}

{ Laden der Ressourcen }
{$R 4GEWINNT.RES}


{*****************************************************}
{                   Hauptprogramm                     }
{*****************************************************}

Begin
  _4Gewinnt.Init('');   { Applikation initialisieren, }
  _4Gewinnt.Run;        { ausführen,                  }
  _4Gewinnt.Done;       { und wieder beenden.         }
End.
{*****************************************************}
