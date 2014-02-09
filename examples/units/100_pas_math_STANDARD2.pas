(******************************************************************************)
(*									      *)
(*	Dr. William T. Verts (C) April 2, 1996				      *)
(*									      *)
(*	This Pascal unit contains a number of type and procedure definitions  *)
(*	for use by Amherst College CS32 students, directly or as reference,   *)
(*	however they see fit.						      *)
(*	test for maXbox Feb. 2010, loc's = 472                  	      *)
(******************************************************************************)

Unit Math_Standards;

Interface

//uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  //SysUtils, Classes, Messages, Controls, StdCtrls,
  //JvCtrls, JvListBox;
  
{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL: https://jvcl.svn.sourceforge.net/svnroot/jvcl/branches/JVCL3_40_PREPARATION/run/JvPlaylist.pas $';
    Revision: '$Revision: 12461 $';
    Date: '$Date: 2009-08-14 19:21:33 +0200 (ven., 14 août 2009) $';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}
  
  
 
Const	ZERO		= 0 ;
	BLANK		= ' ' ;
	QUOTE		= '''' ;
	DQUOTE		= '"' ;
	PI		= 3.14159265358979323846 ;

Type	Color		= Record
				Red	: Byte	;
				Green	: Byte	;
				Blue	: Byte	;
			  End ;

	Point_2D	= Record
				X	: double;
				Y	: double;
			  End ;

	Point_3D	= Record
				X	: double ;
				Y	: double ;
				Z	: double ;
			  End ;

	Parametric	= Record
				Offset	: double ;
				Scale	: double ;
			  End ;

	Line_2D		= Record
				X	: Parametric ;
				Y	: Parametric ;
			  End ;

	Line_3D		= Record
				X	: Parametric ;
				Y	: Parametric ;
				Z	: Parametric ;
			  End ;

	AVector3		= Array [1..3] Of double ;
	TMatrix3                = Array [1..3] of AVector3; //double;
	AMatrix3		= Array [1..3] of TMatrix3;

Function  Letter_ORD	(CH:Char) : Integer ;
Function  Radians	(Degrees:double) : double ;
Function  Degrees	(Radians:double) : double ;
Function  Maximum	(M,N:double) : double ;
Function  Minimum	(M,N:double) : double ;
Function  Greater	(M,N:LongInt) : LongInt ;
Function  Lesser	(M,N:LongInt) : LongInt ;
Function  IFi		(B:Boolean ; M,N:LongInt) : LongInt ;
Function  IFr		(B:Boolean ; M,N:double) : double ;
Procedure iSwap		(Var M,N:LongInt) ;
Procedure rSwap		(Var M,N:double) ;

Function  Length_XY	(X1,Y1,X2,Y2:double) : double ;
Function  Length_XYZ	(X1,Y1,Z1,X2,Y2,Z2:double) : double ;
Function  Length_2D	(P1,P2:Point_2D) : double ;
Function  Length_3D	(P1,P2:Point_3D) : double ;
//Function  Length_Vector	(V1,V2:Vector3) : double ;

Function  Get_Value	(P:Parametric ; T:double) : double ;
Procedure Get_Parametric(Var mResult:Parametric ; P1,P2:double) ;
Procedure Get_Line_3D	(Var mResult:Line_3D    ; P1,P2:Point_3D) ;
Procedure Get_Line_2D	(Var mResult:Line_2D    ; P1,P2:Point_2D) ;
Procedure Get_Point_3D	(Var mResult:Point_3D   ; L:Line_3D ; T:double) ;
Procedure Get_Point_2D	(Var mResult:Point_2D   ; L:Line_2D ; T:double) ;
Procedure Get_Normal_2D	(Var vResult:Line_2D    ; L:Line_2D ; P:Point_2D) ;

Procedure Identity	(Var vResult:TMatrix3) ;
Procedure Translate	(Var vResult:TMatrix3 ; Tx,Ty:double) ;
Procedure Scale		(Var vResult:TMatrix3 ; Sx,Sy:double) ;
Procedure Rotate	(Var vResult:TMatrix3 ; Radians:double) ;
Procedure Multiply	(Var vResult:TMatrix3 ; M1,M2:TMatrix3) ;
Procedure Transform	(Var vRes: AVector3 ; M:TMatrix3 ; V:AVector3) ;  

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)

Implementation

(******************************************************************************)
(* Utility routines							      *)
(******************************************************************************)
(*----------------------------------------------------------------------------*)
(* Convert a letter into an integer, where 'a' & 'A' = 1, 'b' & 'B' = 2, etc. *)
(*----------------------------------------------------------------------------*)

Function  Letter_ORD (CH:Char) : Integer ;
Begin	(***)
	//If CH In ['A']['Z'] Then Letter_ORD := Ord(CH) - Ord('A') Else
	//If CH In ['a'..'z'] Then Letter_ORD := Ord(CH) - Ord('a') Else
				 //result:= ZERO ;
End;

(*----------------------------------------------------------------------------*)
(* Convert angle from degree measure [0..360] into radian measure [0..2PI]    *)
(*----------------------------------------------------------------------------*)

Function Radians (Degrees:double) : double ;
Begin	(***)
	result:= Degrees / 180.0 * PI ;
End ;

(*----------------------------------------------------------------------------*)
(* Convert angle from radian measure [0..2pi] into degree measure [0..360]    *)
(*----------------------------------------------------------------------------*)

Function Degrees (Radians:double) : double ;
Begin	(***)
	result:= Radians / PI * 180.0 ;
End ;

(*----------------------------------------------------------------------------*)
(* Return the maximum of the two double arguments				      *)
(*----------------------------------------------------------------------------*)

Function  Maximum (M,N:double) : double ;
Begin	(***)
	If M > N Then result:= M
		 Else result:= N ;
End ;

(*----------------------------------------------------------------------------*)
(* Return the minimum of the two double arguments				      *)
(*----------------------------------------------------------------------------*)

Function  Minimum (M,N:double) : double ;
Begin	(***)
	If M < N Then result:= M
		 Else result:= N ;
End ;

(*----------------------------------------------------------------------------*)
(* Return the maximum of the two integer arguments			      *)
(*----------------------------------------------------------------------------*)

Function  Greater (M,N:LongInt) : LongInt ;
Begin	(***)
	If M > N Then result:= M
		 Else result:= N ;
End ;

(*----------------------------------------------------------------------------*)
(* Return the minimum of the two integer arguments			      *)
(*----------------------------------------------------------------------------*)

Function  Lesser (M,N:LongInt) : LongInt ;
Begin	(***)
	If M < N Then result:= M
		 Else result:= N ;
End ;

(*----------------------------------------------------------------------------*)
(* Return the 1st argument if B is true, the second if B is false (integer)   *)
(*----------------------------------------------------------------------------*)

Function IFi (B:Boolean ; M,N:LongInt) : LongInt ;
Begin	(***)
	If B Then result:= M Else result:= N ;
End ;

(*----------------------------------------------------------------------------*)
(* Return the 1st argument if B is true, the second if B is false (double)      *)
(*----------------------------------------------------------------------------*)

Function IFr (B:Boolean ; M,N:double) : double ;
Begin	(***)
	If B Then result:= M Else result:= N ;
End ;

(*----------------------------------------------------------------------------*)
(* Exchange the two integer arguments					      *)
(*----------------------------------------------------------------------------*)

Procedure iSwap (Var M,N:LongInt) ;
    Var	Temp : LongInt ;
Begin	(***)
	Temp	:= M ;
	M	:= N ;
	N	:= Temp ;
End ;

(*----------------------------------------------------------------------------*)
(* Exchange the two double arguments					      *)
(*----------------------------------------------------------------------------*)

Procedure rSwap (Var M,N:double) ;
    Var	Temp : double ;
Begin	(***)
	Temp	:= M ;
	M	:= N ;
	N	:= Temp ;
End ;

(******************************************************************************)
(* Euclidean Length routines						      *)
(******************************************************************************)
(*----------------------------------------------------------------------------*)
(* Return the distance between 2D points <X1,Y1> and <X2,Y2>		      *)
(*----------------------------------------------------------------------------*)

Function  Length_XY	(X1,Y1,X2,Y2:double) : double ;
    Var	Min	: double ;
	Max	: double ;
Begin	(***)
	Min	:= Abs(X2 - X1) ;
	Max	:= Abs(Y2 - Y1) ;
	If Min > Max Then rSwap(Min, Max) ;

	If Max <= ZERO Then result:= 0.0
		       Else result:= Max * Sqrt(1.0 + power((Min/Max),2)) ;
End ;

(*----------------------------------------------------------------------------*)
(* Return the distance between 3D points <X1,Y1,Z1> and <X2,Y2,Z2>	      *)
(*----------------------------------------------------------------------------*)

Function  Length_XYZ	(X1,Y1,Z1,X2,Y2,Z2:double) : double ;
Begin	(***)
	result:= Sqrt(power((X2-X1),2) + power((Y2-Y1),2) + power((Z2-Z1),2)) ;
End ;

(*----------------------------------------------------------------------------*)
(* Return the distance between 2D points P1 and P2			      *)
(*----------------------------------------------------------------------------*)

Function Length_2D (P1,P2:Point_2D) : double ;
Begin	(***)
	result:= Length_XY(P1.X, P1.Y, P2.X, P2.Y) ;
End ;

(*----------------------------------------------------------------------------*)
(* Return the distance between 3D points P1 and P2			      *)
(*----------------------------------------------------------------------------*)

Function Length_3D (P1,P2:Point_3D) : double ;
Begin	(***)
	result:= Length_XYZ(P1.X, P1.Y, P1.Z, P2.X, P2.Y, P2.Z) ;
End ;

(*----------------------------------------------------------------------------*)
(* Return the distance between vectors V1 and V2, but where the Vector3 type  *)
(* is treated as a homogeneous coordinate in 2D (3rd array element ignored)   *)
(*----------------------------------------------------------------------------*)

Function  Length_Vector	(V1,V2:AVector3) : double ;
Begin	(***)
	result:= Length_XY(V1[1], V1[2], V2[1], V2[2]) ;
End ;

(******************************************************************************)
(* Parametric line and point routines					      *)
(******************************************************************************)
(*----------------------------------------------------------------------------*)
(* Compute the value along a 1D parametric (used in groups for 2D and 3D)     *)
(*----------------------------------------------------------------------------*)

Function Get_Value (P:Parametric ; T:double) : double ;
Begin	(***)
	result:= (P.Scale * T) + P.Offset ;
End ;

(*----------------------------------------------------------------------------*)
(* Create a 1D parametric given two valid values along the 1D "line"	      *)
(*----------------------------------------------------------------------------*)

Procedure Get_Parametric (Var mResult: Parametric ; P1,P2:double) ;
Begin	(***)
	mResult.Offset	:= P1 ;
	mResult.Scale	:= (P2 - P1) ;
End ;

(*----------------------------------------------------------------------------*)
(* Create a 3D line from two 3D points (build 3 parametrics)		      *)
(*----------------------------------------------------------------------------*)

Procedure Get_Line_3D (Var mResult:Line_3D ; P1,P2:Point_3D) ;
Begin	(***)
	Get_Parametric (mResult.X, P1.X, P2.X) ;
	Get_Parametric (mResult.Y, P1.Y, P2.Y) ;
	Get_Parametric (mResult.Z, P1.Z, P2.Z) ;
End ;

(*----------------------------------------------------------------------------*)
(* Create a 2D line from two 2D points (build 2 parametrics)		      *)
(*----------------------------------------------------------------------------*)

Procedure Get_Line_2D (Var mResult:Line_2D ; P1,P2:Point_2D) ;
Begin   (***)
	Get_Parametric (mResult.X, P1.X, P2.X) ;
	Get_Parametric (mResult.Y, P1.Y, P2.Y) ;
End ;

(*----------------------------------------------------------------------------*)
(* Given a 3D parametric line, find the 3D point corresponding to parameter T *)
(*----------------------------------------------------------------------------*)

Procedure Get_Point_3D (Var mResult:Point_3D ; L:Line_3D ; T:double) ;
Begin	(***)
	mResult.X := Get_Value(L.X, T) ;
	mResult.Y := Get_Value(L.Y, T) ;
	mResult.Z := Get_Value(L.Z, T) ;
End ;

(*----------------------------------------------------------------------------*)
(* Given a 2D parametric line, find the 2D point corresponding to parameter T *)
(*----------------------------------------------------------------------------*)

Procedure Get_Point_2D (Var mResult:Point_2D ; L:Line_2D ; T:double) ;
Begin	(***)
	mResult.X := Get_Value(L.X, T) ;
	mResult.Y := Get_Value(L.Y, T) ;
End ;

(*----------------------------------------------------------------------------*)
(* Return a 2D line which passes through 2D point and is normal to given line *)
(*----------------------------------------------------------------------------*)

Procedure Get_Normal_2D (Var vResult:Line_2D ; L:Line_2D ; P:Point_2D) ;
Begin	(***)
	vResult.X.Offset := P.X ;
	vResult.X.Scale  := -L.Y.Scale ;
	vResult.Y.Offset := P.Y ;
	vResult.Y.Scale  := L.X.Scale ;
End ;

(******************************************************************************)
(* 3x3 Matrix and 3 element Vector routines				      *)
(******************************************************************************)
(*----------------------------------------------------------------------------*)
(* Return an identity matrix (zeros everywhere except ones along the diagonal *)
(*----------------------------------------------------------------------------*)

Procedure Identity (Var vResult: TMatrix3);

Var	I, J	: Integer ;

Begin	(***)
	For I := 1 To 3 Do
		For J := 1 To 3 Do
			vResult[I][J]:= Ord(I=J) ;
End ;

(*----------------------------------------------------------------------------*)
(* Create a matrix for translating a point by <Tx,Ty>			      *)
(*----------------------------------------------------------------------------*)

Procedure Translate (Var vResult: TMatrix3 ; Tx,Ty:double) ;
Begin	(***)
	Identity (vResult) ;
	vResult[1][3]:= Tx ;
	vResult[2][3]:= Ty ;
End ;

(*----------------------------------------------------------------------------*)
(* Create a matrix for scaling a point by <Sx,Sy>			      *)
(*----------------------------------------------------------------------------*)

Procedure Scale (Var vResult: TMatrix3 ; Sx,Sy:double) ;
Begin	(***)
	Identity (vResult) ;
	vResult[1][1]:= Sx ;
	vResult[2][2]:= Sy ;
End ;

(*----------------------------------------------------------------------------*)
(* Create a matrix for rotating a point around the origin by a given angle    *)
(*----------------------------------------------------------------------------*)

Procedure Rotate (Var vResult: TMatrix3 ; Radians:double) ;

    Var	Sine	: double ;
	Cosine	: double ;

Begin	(***)
	Sine	:= Sin(Radians) ;
	Cosine	:= Cos(Radians) ;
	Identity (vResult) ;
	vResult[1][1] :=  Cosine ;
	vResult[1][2] := -Sine ;
	vResult[2][1] :=  Sine ;
	vResult[2][2] :=  Cosine ;
End ;

(*----------------------------------------------------------------------------*)
(* Multiply two matrices together to create a third matrix		      *)
(*----------------------------------------------------------------------------*)

Procedure Multiply (Var vResult: TMatrix3 ; M1,M2: TMatrix3) ;

    Var	I, J, K	: Integer ;
	Temp	: double ;

Begin	(***)
	For I := 1 To 3 Do
		For J := 1 To 3 Do
			Begin	(***)
				Temp := 0.0 ;
				For K := 1 To 3 Do
					Temp := Temp + (M1[I][K] * M2[K][J]) ;
				vresult[I][J] := Temp ;
			End ;
End ;

(*----------------------------------------------------------------------------*)
(* Multiply a matrix times a vector to create a new vector (transform a point)*)
(*----------------------------------------------------------------------------*)

Procedure Transform (Var vRes: AVector3 ; M: TMatrix3 ; V: AVector3) ;

    Var	I, J	: Integer ;
	Temp	: double ;

Begin	(***)
	For I := 1 To 3 Do
		Begin	(***)
			Temp := 0.0 ;
			For J := 1 To 3 Do Temp := Temp + (M[I][J] * V[J]) ;
			vRes[I] := Temp ;
		End ;
End ; 

(******************************************************************************)
var mmat: TMatrix3;
    i,j: byte;    
    p1,p2: Point_2D;

//main with some examples
begin
  mmat[1][1]:= 2;
  mmat[1][2]:= 4;
  mmat[1][3]:= 7;
  mmat[2][1]:= 1;
  mmat[2][2]:= 5;
  mmat[2][3]:= 6;
  mmat[3][1]:= 3;
  mmat[3][2]:= 5;
  mmat[3][3]:= 7;
  p1.x:= 5
  p1.y:= 5
  p2.x:= 10
  p2.y:= 10

  //Return identity matrix (zeros everywhere except ones along the diagonal
  //Identity (mmat);

  writeln(floatToStr(Length_2D(p1,p2)));
  writeln(floattoStr(length_XY(5,5,10,10)))
  writeln('');
  for i:= 1 to 3 do begin
    for j:= 1 To 3 Do 
      write(floattostr(mmat[i][j]));
    writeln('');
  end;   	

End.