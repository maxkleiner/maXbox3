{************************************************}
{                                                }
{   Chess - Shared DLL Example                   }
{   CHESS.DLL Interface file.                    }
{   Copyright (c) 1992 by Borland International  }
{                                                }
{************************************************}

unit ChessDll;

interface

type
  TPiece = (pEmpty, pKing, pQueen, pRook, pBishop, pKnight, pPawn);
  TColor = (cWhite, cBlack);
  TKind  = (kNormal, kEnPassant, kCastling, kPawnPromote);
  HChess = Word;

type
  TSquare = record
    Piece: TPiece;
    Color: TColor;
  end;
  TBoard = array[1..8,1..8] of TSquare;

  TLocation = record
    X: 0..8;            { 0 is off-board or empty }
    Y: 0..8;            { 0 is off-board or empty }
  end;

  PChange = ^TChange;
  TChange = record
    Piece: TPiece;
    Source: TLocation;
    Dest: TLocation;
  end;

  PMove = ^TMove;
  TMove = record
    Change: TChange;
    Capture: Boolean;
    Contents: TPiece;
    case Kind: TKind of
      kEnPassant: (EPCapture: TLocation);
      kCastling: (RookSource, RookDest: TLocation);
  end;

type
  TSearchStatus = (
    ssComplete,                 { Completed last opperation }
    ssMoveSearch,               { Searching for a move for the current
                                  player }
    ssThinkAhead,               { Thinking ahead while waiting for a
                                  SubmitMove }
    ssGameOver                  { Game is complete }
  );

  TChessStatus = (
    csNormal,                   { Nothing is special about the current state }
    csCheck,                    { The current player is in check }
    csCheckMate,                { The current player is in checkmate }
    csStaleMate,                { The game is a stalemate }
    csResigns,                  { The opponent is so far ahead there is no
                                  point in playing the game further }
    csMateFound,                { Checkmate will happen in a maximum of
                                  Count moves (Count is a parameter of
                                  GetChessStatus) }
    csFiftyMoveRule,            { The game violates the 50 move rule
                                  (stalemate) }
    csRepetitionRule);          { The game violates the 3 repetition rule
                                  (stalemate) }

type
  TChessError = (
                                { General results }
    ceOK,                       { Request sucessful }
    ceInvalidHandle,            { Handle passed is not valid }
    ceIllegalState,             { Call not legal in current state }

                                { NewGame results }
    ceOutOfMemory,              { Not enough memory to allocate game context }
    ceTooManyGames,             { Not enough game handles for new game }

                                { SubmitMove/VarifyMove/ParseMove results }
    ceInvalidMove,              { Cannot move specified piece there }
    ceIllegalMove,              { Move into or does not prevent check or
                                  castling through check }

                                { VerifyMove results }
    ceInvalidSyntax,            { Move syntax cannot be determined }
    ceAmbiguousMove,            { More then one piece fits move (i.e. if you
                                  pass in NF3 and two Knights can be there) }

                                { RetractMove results }
    ceNoMovesLeft);             { No moves left to retract }

{ Game handle management }

{ Allocates a game handle }
function NewGame(var GameHandle: HChess): TChessError;

{ Frees the game handle }
function DisposeGame(CH: HChess): TChessError;


{ Move management }

{ Parses the given Move into a change record. The syntax is as follows:

     <Location> | <Piece name><Location> | <Location><Location>

  where <Location> is in the form A3 or F5 and <Piece letter> is one of:

    P = Pawn, R = Rook, N = Knight, B = Biship, Q = Queen, K = King

  If only a Location is given and the move is ambigious it is assumed the
  piece being moved is a pawn }

function ParseMove(Move: PChar; var Change: TChange): TChessError;

{ Retracts the last move.  NOTE: Retract move should not be called
  during a search! }
function RetractMove(CH: HChess; const Move: TMove): TChessError;

{ Submits a move for the current player.  Both the "Piece" field and
  the "From" field can be empty if the move is unambigious.  This is
  only legal to call while idle or during a "think ahead" }
function SubmitMove(CH: HChess; const Change: TChange): TChessError;

{ Verify the legality of the given change but do not perform the
  change.  The "Source" and "Piece" fields can be empty if move is
  unambigious. This is only legal to call while complete or during a
  "think ahead" }
function VerifyMove(CH: HChess; const Change: TChange): TChessError;


{ Search management }

{ Starts a move search.  It will always return immediately.  You need
  to call Think to perform the actual search. TimeLimit is in 1/18ths
  of a second. }
function ComputerMove(CH: HChess; TimeLimit: LongInt): TChessError;

{ Force the computer to make a move with the information it has now.
  The move will be completed with the next call to Think. This is only
  legal while performing a move search }
function ForceMove(CH: HChess): TChessError;

{ Start using the Think time to begin a search assuming the opponent is
  going to follow the main line.  If the opponent does, the next search
  will start at the think-ahead point, otherwise a new search is started.
  This is only legal to call while idle }
function ThinkAhead(CH: HChess): TChessError;


{ Aborts the current search being performed whether started with ThinkAhead
  or ComputerMove.  The move under consideration is not performed and the
  player is unchanged.  This call is ignored if no search is active }
function AbortSearch(CH: HChess): TChessError;

{ Chess process management }

{ Gives TimeLimit ticks to the computer to think (1/18'ths of a second).
  This call performs the move search.  Think should be called whenever
  the chess program is idle, even while waiting for the opponent.
  The engine utilizes the opponents idle time to "look ahead" to
  improve the results of the next move. The number given in TimeLimit
  should be small (below 10 when searching for a computer move, below
  5 when waiting for the opponent) to allow the rest of the app to be
  responsive.  This is especially important in Windows.  }
function Think(CH: HChess; TimeLimit: LongInt;
  var Status: TSearchStatus): TChessError;


{ Board editing }

{ !!! NOTE: Board editing routines are not valid during a search }

{ Replace the current board with the given board }
function SetBoard(CH: HChess; const ABoard: TBoard): TChessError;

{ Set the current player to Player }
function SetPlayer(CH: HChess; APlayer: TColor): TChessError;

{ Make the following modification to the board.  If the "Source" Location
  is blank the piece is new, if the "Dest" Location is blank the piece is
  taken from the board. If neither are blank the piece is moved.  If the
  piece type does not match the piece in the Source location, the piece
  is changed to be the given type }
function MakeChange(CH: HChess; Color: TColor;
  const Change: TChange): TChessError;


{ Status interface }

{ Returns the status of the move search }
function GetSearchStatus(CH: HChess): TSearchStatus;

{ Returns the current status of the game }
function GetChessStatus(CH: HChess; var Count: Integer): TChessStatus;

{ Format the move as a text string }
function MoveToStr(const Move: TMove; var Str: array of Char): TChessError;

{ !!! NOTE: These functions are not valid to call during a search. }

{ Returns the last move }
function GetLastMove(CH: HChess; var Move: TMove): TChessError;

{ Returns the hint move }
function GetHintMove(CH: HChess; var Move: TMove): TChessError;

{ Returns the current state of the board.  If a search is being performed
  it is the state of the board that is being searched. }
function GetBoard(CH: HChess; var ABoard: TBoard): TChessError;

{ Return the whose turn it is }
function GetPlayer(CH: HChess): TColor;

{ Returns a list of the valid given Change.  Empty fields in the change
  record are used as wildcards in the search.  For example, if you
  want all the legal pawn moves only fill in the Piece field leaving
  the Location fields blank.  If you want all the legal moves for the
  piece on A4, fill in Source with A4 and leave Piece and Dest blank.
  Leaving all fields of Change blank will return all legal moves }
function GetValidMoves(CH: HChess; Change: TChange;
  var Moves: array of TMove): TChessError;

{ !!! NOTE: This function are only meaningful during a search }

{ Returns the current move being searched by the computer }
function GetCurrentMove(CH: HChess; var Move: TMove): TChessError;

{ Returns the current priciple line being used by the computer. }
function GetMainLine(CH: HChess; var Value: Integer;
  var Line: array of TMove): TChessError;

{ Returns the number of nodes processed during the last (or current)
  search }
function GetNodes(CH: HChess): LongInt;


implementation

function NewGame;         external 'CHESS';
function DisposeGame;     external 'CHESS';
function ParseMove;       external 'CHESS';
function RetractMove;     external 'CHESS';
function SubmitMove;      external 'CHESS';
function VerifyMove;      external 'CHESS';
function ComputerMove;    external 'CHESS';
function ForceMove;       external 'CHESS';
function ThinkAhead;      external 'CHESS';
function AbortSearch;     external 'CHESS';
function Think;           external 'CHESS';
function SetBoard;        external 'CHESS';
function SetPlayer;       external 'CHESS';
function MakeChange;      external 'CHESS';
function GetChessStatus;  external 'CHESS';
function GetSearchStatus; external 'CHESS';
function GetLastMove;     external 'CHESS';
function GetHintMove;     external 'CHESS';
function MoveToStr;       external 'CHESS';
function GetBoard;        external 'CHESS';
function GetPlayer;       external 'CHESS';
function GetCurrentMove;  external 'CHESS';
function GetMainLine;     external 'CHESS';
function GetValidMoves;   external 'CHESS';
function GetNodes;        external 'CHESS';

end.
