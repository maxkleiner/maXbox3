{*****************************************************}
{ RECHNER.INC: Include-File mit der implementierten   }
{              Strategieroutine für 4GEWINNT.PAS      }
{ --------------------------------------------------- }
{ Autor       : Max Kleiner                           }
{ Sprache     : BorlandPascal für Windows             }
{*****************************************************}


{-------------- Menü Schwierigkeitsgrad --------------}

{*****************************************************}
{ T4GwWindow.Anfänger: Reaktion auf die Auswahl des   }
{                      Menüpunktes 'Anfänger'         }
{*****************************************************}

Procedure T4GwWindow.Anfaenger;

Begin
  MyMenu:=GetMenu(HWindow);
  CheckMenuItem(MyMenu,cm_Anfaenger+Grad,
                mf_ByCommand+mf_Unchecked);
  CheckMenuItem(MyMenu,cm_Anfaenger,
                mf_ByCommand+mf_Checked);
  Grad:=0;
End;


{*****************************************************}
{ T4GwWindow.Fortgeschrittener: Reaktion auf die Aus- }
{            wahl des Menüpunktes 'Fortgeschrittener' }
{*****************************************************}

Procedure T4GwWindow.Fortgeschrittener;

Begin
  MyMenu:=GetMenu(HWindow);
  CheckMenuItem(MyMenu,cm_Anfaenger+Grad,
                mf_ByCommand+mf_Unchecked);
  CheckMenuItem(MyMenu,cm_Fortgeschrittener,
                mf_ByCommand+mf_Checked);
  Grad:=1;
End;

{*****************************************************}
{ T4GwWindow.Experte: Reaktion auf die Auswahl des    }
{                     Menüpunktes 'Experte'           }
{*****************************************************}

Procedure T4GwWindow.Experte;

Begin
  MyMenu:=GetMenu(HWindow);
  CheckMenuItem(MyMenu,cm_Anfaenger+Grad,
                mf_ByCommand+mf_Unchecked);
  CheckMenuItem(MyMenu,cm_Experte,
                mf_ByCommand+mf_Checked);
  Grad:=2;
End;


{*****************************************************}
{ T4GwWindow.Meister: Reaktion auf die Auswahl des    }
{                     Menüpunktes 'Meister'           }
{*****************************************************}

Procedure T4GwWindow.Meister;

Begin
  MyMenu:=GetMenu(HWindow);
  CheckMenuItem(MyMenu,cm_Anfaenger+Grad,
                mf_ByCommand+mf_Unchecked);
  CheckMenuItem(MyMenu,cm_Meister,
                mf_ByCommand+mf_Checked);
  Grad:=3;
End;


{*****************************************************}
{ T4GwWindow.Rechner: Reaktion auf die Meldung        }
{                     wm_rechner                      }
{                     In dieser Routine wird der Zug  }
{                     für die Computerseite mit Hilfe }
{                     Minimaxstrategie und AlphaBeta- }
{                     Abschneidung ermittelt.         }
{*****************************************************}

Procedure T4GwWindow.Rechner;

Var Bester, i, j : Integer;
    HMsg         : TMsg;
    RWert        : Array[0..40] Of Integer;
    BW           : ZeilenVektor;
    SM           : SpielMatrix;
    Abbruch      : Boolean;

Const { größtmögliche Bewertung }
      Unendlich = 32000;

      { Rechentiefe für die einzelnen Spielstärken }
      Rechentiefe : Array[0..3] Of Integer = (4,4,5,6);

      { Reihenfolge der Zugauswahl }
      ZA : ZeilenVektor = (4,3,5,2,6,7,1);

      { Wert für Position eines Steins }
      PosWert : SpielMatrix = (( 3, 4, 5, 7, 5, 4, 3),
                               ( 4, 6, 8,10, 8, 6, 4),
                               ( 5, 8,11,13,11, 8, 5),
                               ( 5, 8,11,13,11, 8, 5),
                               ( 4, 6, 8,10, 8, 6, 4),
                               ( 3, 4, 5, 7, 5, 4, 3));

      { Wert einer Reihe in der schon drei Steine }
      { derselben Farbe enthalten sind            }
      Wert3 = 30;

      { Wert einer Reihe in der schon zwei Steine }
      { derselben Farbe enthalten sind            }
      Wert2 = 8;


{*****************************************************}
{ Mit Hilfe dieser Funktion wird die jeweilige Spiel- }
{ stellung bewertet.                                  }
{*****************************************************}

Function Bewertung(Stufe : Integer) : Integer;

Var BW, S, i, j, k, Help          : Integer;
    Dreier_Rot, Dreier_Blau, Ende : Boolean;

  {-------------------------------------------------}
  { Hilfsprozedur zur Auswertung der Spielstellung  }
  {-------------------------------------------------}

  Procedure Auswertung;

  Begin
    Dreier_Rot:=S=30;
    Dreier_Blau:=S=3;
    If S>1 Then
      If S=40 Then Begin
        Bewertung:=-30000-Stufe;
        If Stufe=100 Then
          Bewertung:=-Unendlich;
        Ende:=True;
      End
      Else
        If S=4 Then Begin
          Bewertung:=30000+Stufe;
          If Stufe=100 Then
            Bewertung:=Unendlich;
          Ende:=True;
        End
        Else
          Inc(BW,RWert[S]);
  End;
  {-------------------------------------------------}

Begin
  BW:=0;

  {-------------------------------------------------}
  { Bewertungskriterium 1:                          }
  {   Werte der einzelnen Spielsteinpositionen      }
  {-------------------------------------------------}
  For j:=1 To M Do
    For i:=1 To Count[j] Do Begin
      If SM[i,j]=1 Then
        BW:=BW+PosWert[i,j];
      If SM[i,j]=10 Then
        BW:=BW-PosWert[i,j];
    End;

  {-------------------------------------------------}
  { Bewertungskriterium 2:                          }
  {   Bewertung der jeweiligen Zweier-, Dreier- und }
  {   Viererreihen der Spielstellung                }
  {-------------------------------------------------}

  Ende:=False;

  {-------- senkrechte Reihen --------}
  For j:=1 To M Do Begin
    Help:=Count[j];
    If Help>3 Then Help:=3;
    For i:=1 To Help Do Begin
      S:=SM[i,j]+SM[i+1,j]+SM[i+2,j]+SM[i+3,j];
      Auswertung;
      If Ende Then Exit;
      If Dreier_Rot Then
        For k:=0 To 3 Do
          If SM[i+k,j]=0 Then
            If i+k And 1=ComputerBegin Then
              Dec(BW,RWert[3]);
      If Dreier_Blau Then
        For k:=0 To 3 Do
          If SM[i+k,j]=0 Then
            If i+k And 1=1-ComputerBegin Then
              Inc(BW,RWert[3]);
    End;
  End;

  {-------- waagrechte Reihen --------}
  For j:=1 To M-3 Do
    For i:=1 To N Do Begin
      S:=SM[i,j]+SM[i,j+1]+SM[i,j+2]+SM[i,j+3];
      Auswertung;
      If Ende Then Exit;
      If Dreier_Rot And (j>1) Then
        If j And 1=ComputerBegin Then
          Dec(BW,3*RWert[3]);
      If Dreier_Blau And (j>1) Then
        If j And 1=1-ComputerBegin Then
          Inc(BW,3*RWert[3]);
    End;

  {-------- diagonale Reihen --------}
  For i:=1 To N-3 Do
    For j:=1 To M-3 Do Begin
      S:=SM[i,j]+SM[i+1,j+1]+SM[i+2,j+2]+SM[i+3,j+3];
      Auswertung;
      If Ende Then Exit;
      If Dreier_Rot Then
        For k:=0 To 3 Do
          If SM[i+k,j+k]=0 Then
            If i+k And 1=ComputerBegin Then
              Dec(BW,2*RWert[3]);
      If Dreier_Blau Then
        For k:=0 To 3 Do
          If SM[i+k,j+k]=0 Then
            If i+k And 1=1-ComputerBegin Then
              Inc(BW,2*RWert[3]);
      S:=SM[i+3,j]+SM[i+2,j+1]+SM[i+1,j+2]+SM[i,j+3];
      Auswertung;
      If Ende Then Exit;
      If Dreier_Rot Then
        For k:=0 To 3 Do
          If SM[i+3-k,j+k]=0 Then
            If i+3-k And 1=ComputerBegin Then
              Dec(BW,2*RWert[3]);
      If Dreier_Blau Then
        For k:=0 To 3 Do
          If SM[i+3-k,j+k]=0 Then
            If i+3-k And 1=1-ComputerBegin Then
              Inc(BW,2*RWert[3]);
    End;
  Bewertung:=BW;
End;


{*****************************************************}
{ Ermittlung des besten Zuges für den Computer mit    }
{ Hilfe der MiniMax-Strategie und der AlphaBeta-      }
{ Abschneidung.                                       }
{ Diese rekursive Funktion liefert schließlich den    }
{ Wert der Spielstellung zurück. Der beste Spielzug   }
{ ist dann in der Variable Bester abgelegt.           }
{*****************************************************}

Function MiniMax(Wert,Tiefe,Alpha:Integer) : Integer;

Var i, j, Help, Zug, Beta : Integer;
    AlphaBetaAbbruch      : Boolean;

Begin
  If Not Abbruch Then Begin
    If (Abs(Bewertung(Tiefe+1))>=29000) Or
       (Count[1]+Count[2]+Count[3]+Count[4]+
        Count[5]+Count[6]+Count[7]>=42) Then
      MiniMax:=Bewertung(Tiefe+1)
    Else Begin
      While PeekMessage(HMsg,HWindow,0,0,pm_Remove) Do
        If (HMsg.Message=wm_SysCommand) And
           (HMsg.WParam=sc_Close) Then
          Abbruch:=True
        Else
        If (HMsg.Message<>wm_LButtonDown) And
           (HMsg.Message<>wm_command) Then Begin
          TranslateMessage(HMsg);
          DispatchMessage(HMsg);
        End;
      If Wert=1 Then
        Beta:=-Unendlich
      Else
        Beta:=Unendlich;
      Zug:=0;
      AlphaBetaAbbruch:=False;
      If Tiefe>0 Then Begin
        For i:=1 To M Do Begin
          j:=ZA[i];
          If (Count[j]<N) And Not AlphaBetaAbbruch Then
          Begin
            Inc(Count[j]);
            SM[Count[j],j]:=Wert;
            If Tiefe>1 Then
              Help:=MiniMax(Blau+Rot-Wert,Tiefe-1,Beta)
            Else
              Help:=(Bewertung(Tiefe));
            SM[Count[j],j]:=0;
            Dec(Count[j]);
            If Wert=Blau Then Begin
              If Help>Beta Then Begin
                Beta:=Help;
                Zug:=j;
              End;
              If Beta>Alpha Then
                AlphaBetaAbbruch:=True;
            End
            Else Begin
              If Help<Beta Then Begin
                Beta:=Help;
                Zug:=j;
              End;
              If Beta<Alpha Then
                AlphaBetaAbbruch:=True;
            End;
          End;
        End;
        MiniMax:=Beta;
      End
      Else MiniMax:=(Bewertung(Tiefe+1));
    End;
    Bester:=Zug;
  End;
End;


{*****************************************************}
{ Hilfsfunktion zur Bestimmung, ob das Spiel noch     }
{ fortgesetzt werden kann.                            }
{*****************************************************}

Function SpielEnde : Boolean;

Begin
  SpielEnde:=True;
  If Bewertung(100)<=-Unendlich Then
    Sieger_Rot:=True
  Else
    If Bewertung(100)>=Unendlich Then
      Sieger_Blau:=True
    Else
      If Count[1]+Count[2]+Count[3]+Count[4]+
         Count[5]+Count[6]+Count[7]=N*M Then
        Unentschieden:=True
      Else
        SpielEnde:=False;
End;


{*****************************************************}
{      Hauptteil der Methode T4GwWindow.Rechner       }
{*****************************************************}

Begin
  For i:=0 To 40 Do RWert[i]:=0;
  RWert[3]:=Wert3;
  RWert[30]:=-Wert3;
  RWert[2]:=Wert2;
  RWert[20]:=-Wert2;
  SM:=SpM;
  If Not SpielEnde Then Begin
    SetCursor(LoadCursor(0,idc_wait));
    Berechnen:=True;
    Abbruch:=False;
    MiniMax(Blau,Rechentiefe[Grad]+Delta,Unendlich);
    If Abbruch Then PostQuitMessage(0)
    Else
    If (Count[Bester]<N) And (Bester>0) Then Begin
      Inc(Count[Bester]);
      If (Count[Bester]=N) And (Grad>0) Then
        Inc(Delta);
      SpM[Count[Bester],Bester]:=Blau;
      SendMessage(HWindow,wm_setzestein,
                  Bester*256+Count[Bester],Blau);
      SM:=SpM;
    End;
  End;
  SpielEnde;
  SendMessage(HWindow,wm_gewonnen,0,0);
  Berechnen:=False;
  SetCursor(LoadCursor(0,idc_arrow));
End;
{*****************************************************}
