{ ******************************************************************* }
{ Turbo Pascal Version 4.0 -> 7.0 Utility Functions and Procedures    }
{ ------------------------------------------------------------------- }
{ Copyright 1988, 1995 Roger E. Donais        <rdonais@southeast.net> }
{ ------------------------------------------------------------------- }

UNIT UTIL;
{ ------------------------------------------------------------------- }
{-O+,D+,L+,S-} { Uses IDE or Command Line settings  ...red }
{-N+,E+}
(* ----------------------------------------------------------------- *)
(* External functions use the declaration "{constant} String" to     *)
(* indicate that the parameter is not copied to the stack and is not *)
(* alterd by the function or procedure,  Other strings that are not  *)
(* altered are defined as a const String which is incompatible with  *)
(* older versions of TP/BP. I suggest that you comment the {const}   *)
(* keyword so that you can retore the headers should you upgrade to  *)
(* a newer compiler.  You can then choose to have them passed by     *)
(* calue (which is what I did) or make them VAR parameters. Headers  *)
(* are not redefined in the implementation so you only have to       *)
(* modify the declaration in the interface.                   ...red *)
(* ----------------------------------------------------------------- *)

(*--- comment-out for version 4.0 --->*)
{$IFDEF VER70}
   {$X+}           { Unit uses extended syntax }
   {$DEFINE X}     { enable extended systax }
   {$DEFINE STRINGS}
   {$DEFINE C}     { enable const parameter declarations }
{$ENDIF}

{$IFDEF VER60}
   {$X+}           { Unit uses extended syntax }
   {$DEFINE X}     { enable extended systax }
{$ENDIF}
(*<----- end version 4.0 comment -----*)

{$IFDEF VER40}
  {$DEFINE GETENV} { <--<< define if GetEnv is not part of DOS Unit }
{$ENDIF}

{ ******************************************************************* }
INTERFACE


USES {$IFDEF WINDOWS} WINDOS
     {$ELSE }DOS
     {$ENDIF}
     {$IFDEF VER60}, OBJECTS {$ENDIF}     { pChar }
     {$IFDEF STRINGS}, STRINGS {$ENDIF}
     ;

{$IFOPT N- } TYPE REAL  = SYSTEM.REAL; {$ENDIF}
{$IFOPT N+ } TYPE REAL  = DOUBLE;      {$ENDIF}
{$IFNDEF X } TYPE PChar = ^Char;       {$ENDIF}

VAR    Okay: Boolean; { status of string to binary/Double conversions }

CONST  MAX_STASH = $FFF1;            { Maximum allowable memory block }
       MAXWORD   = $FFFF;            { Maximum value for word value   }

TYPE   tpByte       = ^Byte;
       tpWord       = ^Word;
       tpInteger    = ^Integer;
       tpLongint    = ^Longint;
       tpPointer    = ^Pointer;

       tpByteSet    = ^tByteSet;
       tByteSet     = Set of Byte;

       tpPtrArray   = ^tPtrArray;
       tPtrArray    = Array[1..8190] of Pointer;

       tpLongArray  = ^tLongArray;
       tLongArray   = Array[1..8190] of Longint;

       tpByteArray  = ^tByteArray;
       tByteArray   = Array[1..65521] Of Byte;

       tpCharArray  = ^tCharArray;
       tCharArray   = Array[1..65521] Of Char;

       tpWordArray  = ^tWordArray;
       tWordArray   = Array[1..32761] Of Word;

       tpOfsArray   = ^tOfsArray;
       tOfsArray    = Array[1..16381] of Longint;

       tpTextBuffer = ^tTextBuffer;
       tTextBuffer  = Array[0..MAX_STASH] of Char;

       tpByteBuffer = ^tByteBuffer;
       tByteBuffer  = Array[0..MAX_STASH] of Byte;

       tpWordBuffer = ^tWordBuffer;
       tWordBuffer  = Array[0..32760] of Word;

       tpIntBuffer  = ^tIntBuffer;
       tIntBuffer   = Array[0..32760] of Integer;

       tpLongBuffer = ^tLongBuffer;
       tLongBuffer  = Array[0..8190] of Longint;

       tpPtrBuffer = ^tPtrBuffer;
       tPtrBuffer  = Array[0..8190] of Pointer;
       {$IFDEF WINDOWS}
       Registers = tRegisters;
       TextRec   = tTextRec;
       FileRec   = tFileRec;
       {$ENDIF}

CONST  Numeric: Set of Char = ['0'..'9'];
       Alpha  : Set of Char = ['A'..'Z', 'a'..'z'];
       AlphaN : Set of Char = ['0'..'9', 'A'..'Z', 'a'..'z'];

{$IFNDEF DPMI}
    CONST Seg0040 = $40;
{$ENDIF}

PROCEDURE DisableInterrupts; INLINE($FA);
PROCEDURE EnableInterrupts;  INLINE($FB);

{ =================================================================== }
{                           W A R N I N G                             }
{ ------------------------------------------------------------------- }
{ The Push... family of procedures DO NOT remove the parameters from  }
{ the stack.  They swap the VAR parameter with NewValue, leaving both }
{ the VAR parameter address and old value on the stack.  The POP...   }
{ series of procedures blindly assume that the stack structure was    }
{ left by it's corresponding Push... procedure.  This means ---       }
{ (1) After a Push the stack is somewhat lower than what the compiler }
{     assumes it to be. (has not yet been the cause of any problems)  }
{ (2) Pop's must be performed in the reverse order that they were     }
{     pushed (as would be done in assembly language)                  }
{ (3) Failure to Pop a value may cause the program to crash if the    }
{     compiler opt'd to 'POP' the previous 'BP' before reloading the  }
{     the 'SP' (often done when a procedure has no local parameters)  }
{ =================================================================== }

PROCEDURE PushChar(VAR Parameter: Char; NewValue: Char);
PROCEDURE PopChar;
{ ================================================================== }
{ PUSH Saves current char parameter value and installs the value     }
{ POP  Restores previously push'd char parameter value               }
{ ================================================================== }

PROCEDURE PushByte(VAR Parameter: Byte; NewValue: Byte);
PROCEDURE PopByte;
{ ================================================================== }
{ PUSH Saves current byte parameter value and installs the value     }
{ POP  Restores previously push'd byte parameter value               }
{ ================================================================== }

PROCEDURE PushFlag(VAR Parameter: Boolean; NewValue: Boolean);
PROCEDURE PopFlag;
{ ================================================================== }
{ PUSH Saves current boolean parameter value and installs new value  }
{ POP  Restores previously push'd boolean parameter value            }
{ ================================================================== }

PROCEDURE PushWord(VAR Parameter: Word; NewValue: Word);
PROCEDURE PopWord;
{ ================================================================== }
{ PUSH Saves current word parameter value and installs new value     }
{ POP  Restores previously push'd word parameter value               }
{ ================================================================== }

PROCEDURE PushInteger(VAR Parameter: Integer; NewValue: Integer);
PROCEDURE PopInteger;
{ ================================================================== }
{ PUSH Saves current integer parameter value and installs new value  }
{ POP  Restores previously push'd integer parameter value            }
{ ================================================================== }

PROCEDURE PushLong(VAR Parameter: Longint; NewValue: Longint);
PROCEDURE PopLong;
{ ================================================================== }
{ PUSH Saves current integer parameter value and installs new value  }
{ POP  Restores previously push'd integer parameter value            }
{ ================================================================== }

PROCEDURE PushPtr(VAR Parameter: Pointer; NewValue: Pointer);
PROCEDURE PopPtr;
{ ================================================================== }
{ PUSH Saves current integer parameter value and installs new value  }
{ POP  Restores previously push'd integer parameter value            }
{ ================================================================== }

FUNCTION Hex(i: Word): String;
{ ================================================================== }
{ Converts a binary word to a 4-Digit ascii hex string               }
{ ================================================================== }

FUNCTION Bin(i: Word): String;
{ ================================================================== }
{ Converts a binary byte to an 8-Digit ascii binary string           }
{ ================================================================== }

FUNCTION SetupString(s: String): String;
{ ================================================================== }
{ Returns s with all embedded "\3DIGIT's" converted to a character   }
{                                                                    }
{ EXAMPLE:     SetupString('\065\\066\0\0671')                       }
{ will return  A\B\0C1       ^^^  ^^^   ^^^                          }
{ ================================================================== }

FUNCTION UpperCase({constant} S: String): String;
{ ================================================================== }
{ Converts all characters in an ASCII-7 string to upper case.        }
{ Character values greater than 127 are unaffected.                  }
{                                                                    }
{ See also LowerCase, CodeCase, WordCase, and LineCase.              }
{ ================================================================== }

FUNCTION LowerCase({constant} S: String): String;
{ ================================================================== }
{ Converts all characters in an ASCII-7 string to lower case.        }
{ Character values greater than 127 are unaffected.                  }
{                                                                    }
{ See also UpperCase, CodeCase, WordCase, and LineCase               }
{ ================================================================== }

FUNCTION CodeCase({$IFDEF C}const {$ENDIF} s: String): String;
{ ===================================================================}
{ Converts the first and all characters in an ASCII-7 string that    }
{ follow a non-alphabetic character to upper case, and converts all  }
{ other charaacters to lower case. Character values greater than 127 }
{ are unaffected.                                                    }
{                                                                    }
{ See also UpperCase, LowerCase, CodeCase, WordCase, and LineCase    }
{ ===================================================================}

FUNCTION WordCase({$IFDEF C}const {$ENDIF} S: String): String;
{ ================================================================== }
{ Returns "S" with characters following a space uppercased           }
{ Converts the first and all characters in an ASCII-7 string         }
{ following a non-alphanumeric character upper case and all other    }
{ characters to lower case.  Character values greater than 127 are   }
{ unaffected.                                                        }
{                                                                    }
{ See also UpperCase, LowerCase, CodeCase, and LineCase.             }
{ ================================================================== }

FUNCTION LineCase({$IFDEF C}const {$ENDIF} S: String): String;
{ ================================================================== }
{ Converts the first non-space character in an ASCII-7 string to     }
{ upper case and all other character to lower case. Character values }
{ greater than 127 are unaffected.                                   }
{                                                                    }
{ See also UpperCase, LowerCase, CodeCase, and WordCase.             }
{ ================================================================== }

FUNCTION StringOf(C: Char; Count: Integer): String;
{ ================================================================== }
{ Returns a string containing "count" characters of "c"              }
{ <Returns null string if count is less than 1 or greater than 255>  }
{ ================================================================== }

FUNCTION Spaces(Count: Integer): String;
{ ================================================================== }
{ Returns a string containing "count" number of spaces               }
{ <Returns null string if count is less than 1 or greater than 255>  }
{ This is the same as StringOf(' ', Count);                          }
{ ================================================================== }

FUNCTION IsBlank(C: Char): Boolean;
{ ================================================================== }
{ Returns TRUE if C is a Space (ascii 20), Tab (ascii 9), Form-Feed  }
{ (ascii 12), Carriage-Return (ascii 13), or Line-Feed (ascii 10).   }
{ ================================================================== }

FUNCTION Ascii(Number: LongInt; Width: Integer): String;
{ ================================================================== }
{ Converts a long integer to an ascii decimal string. The resulting  }
{ string will be right justified in a field of width spaces, or in   }
{ as many characters required to display the number if the specified }
{ width is too small.                                                }
{                                                                    }
{ See also Binary and standard system procedures Str and Val.        }
{                                                                    }
{ EXAMPLE        s := Ascii(i, 0);                                   }
{                                                                    }
{                Will return a string containing the minimum         }
{                number of characters to display i.                  }
{ ================================================================== }

FUNCTION Binary({$IFDEF C}const {$ENDIF} S: String): LongInt;
{ ================================================================== }
{ Converts an ascii decimal string to an signed long integer         }
{ Strips Leading and trailing spaces and all embedded commas         }
{ and changes lowercase Ls to 1s and uppercase Os to 0s              }
{ ------------------------------------------------------------------ }
{ If successful, Returns the converted value with Okay set TRUE      }
{ Else Returns 0 with Okay set FALSE                                 }
{                                                                    }
{ See also Ascii, Str2Real, and standard functions Str and Val.      }
{ ================================================================== }

FUNCTION Zfill({constant} S: String): String;
{ ================================================================== }
{ Returns "S" with all characters less than or equal to a space      }
{ replaced with ascii zero's  ('0')                                  }
{                                                                    }
{EXAMPLE:  VAR Day, Month, Year: Integer;                            }
{                                                                    }
{          Day := 1;                                                 }
{          Month := 1;                                               }
{          Year := 1980;                                             }
{          Writeln( Zfill(Ascii(Month,2)                             }
{                 + '/' + Ascii(Day,2)                               }
{                 + '/' + Ascii(Year,4)                              }
{          ));                                                       }
{                                                                    }
{               Will write the string "01/01/1980"                   }
{ ================================================================== }

FUNCTION Roman(No: Word): String;
{ =================================================================== }
{ Returns lowercase roman numeral for values I to MMMCMXCIX [1..3999] }
{ Returns Ascii(No,1) if value is greater than 3999, or aborts with   }
{ runtime error 201 if unit was compiled with range checking on (R+)  }
{ =================================================================== }

FUNCTION OrdNum(No: Word): String;
{ =================================================================== }
{ Returns lowercase ordinal for values 1st, 2nd, 3rd, etc             }
{ =================================================================== }

FUNCTION Ordinal(No: Integer): String;
{ =================================================================== }
{ Returns lowercase ordinal for values "first" to "ninety-ninth"      }
{ Returns OrnNum() (0th, 100th, 101st, etc) for out-of-range values.  }
{ =================================================================== }

FUNCTION Number(No: Word): String;
{ =================================================================== }
{ Returns lowercase number for values 0..MAX_WORD, as "zero", "one",  }
{ two, ..., "sixty-five thousand five hundred sixty five.             }
{ =================================================================== }

FUNCTION Min(i,j: LongInt): Longint;
{ =================================================================== }
{ Returns the smaller of two long integers                            }
{ =================================================================== }

FUNCTION Max(i,j: LongInt): Longint;
{ =================================================================== }
{ Returns the larger of two long integers                             }
{ =================================================================== }

FUNCTION iMin(i,j: Integer): Integer;
{ =================================================================== }
{ Returns the smaller of two integers                                 }
{ =================================================================== }

FUNCTION iMax(i,j: Integer): Integer;
{ =================================================================== }
{ Returns the larger of two integers                                  }
{ =================================================================== }

FUNCTION LongFormat(Value: Longint; Width: Byte): String;
FUNCTION RealFormat(Value: Real; Width, Precision: Byte): String;
{ =================================================================== }
{ Converts a Double to an ascii string with the specified decimal     }
{ fraction and embedded commas.  If the resulting string is less than }
{ the specified width, pads left with spaces else uses Rest() to      }
{ truncates to width                                                  }
{ =================================================================== }

FUNCTION Comma({$IFDEF C}const {$ENDIF} Number: String): String;
{ =================================================================== }
{ Returns number with embedded commas                                 }
{ =================================================================== }

FUNCTION Real2Str(Value: Real; Precision: Byte): String;
{ =================================================================== }
{ Converts a real to an ascii string with the specified decimal       }
{ fraction                                                            }
{ ------------------------------------------------------------------- }
{ NOTE: to convert a 64-Bit IEEE Double w/o ipx87 support, use        }
{       s := FLOATS.Float2Str(VAR Number: Float; Precision: Integer); }
{ =================================================================== }

FUNCTION Str2Str({$IFDEF C}const {$ENDIF} Source: String; Precision: Integer): String;
{ =================================================================== }
{ Strips Leading and trailing spaces and all embedded commas, then    }
{ Converts the ascii string to a real, then converts the real to an   }
{ ascii string with the specified decimal fraction right justified    }
{ to width (does NOT insert commas in the reformatted string!)        }
{ ------------------------------------------------------------------- }
{ If successful, Returns the converted value with Okay set TRUE       }
{ Else Returns 0.0 with Okay set FALSE                                }
{ The value of Okay reflects the result of the Str2Real conversion.   }
{ =================================================================== }

FUNCTION  Str2Real({$IFDEF C}const {$ENDIF} Source: String): Real;
{ =================================================================== }
{ Converts an ascii string to real                                    }
{ Strips Leading and trailing spaces and all embedded commas          }
{ ------------------------------------------------------------------- }
{ If successful, Returns the converted value with Okay set TRUE       }
{ Else Returns 0.0 with Okay set FALSE                                }
{ ------------------------------------------------------------------- }
{ NOTE: to convert 64-Bit IEEE Double w/o ipx87 support, use          }
{       FLOATS.Str2Float(VAR Number: Float; VAR S: String);           }
{ =================================================================== }

FUNCTION DistFormat(Dist : Real): String;
{ =================================================================== }
{ Convert Double feet to an ascii string in the form 'miles:feet'     }
{ =================================================================== }

FUNCTION TimeFormat(Time: Real): String;
{ =================================================================== }
{ Convert Double seconds to ascii string in the form 'hh:mm:ss'       }
{ =================================================================== }

FUNCTION Str2Time({$IFDEF C}const {$ENDIF} Source: String): Real;
{ =================================================================== }
{ Converts an ascii string to number of seconds                       }
{ ------------------------------------------------------------------- }
{ If successful, Returns the converted value with Okay set TRUE       }
{ Else Returns 0 with Okay set FALSE                                  }
{ ------------------------------------------------------------------- }
{ If Source contains no colons then format is assumed to be seconds   }
{ If Source contains one colon then format is assumed to be 'hh:mm'   }
{ Else format is assumed to be 'hh:mm:ss                              }
{ Any field may contain a contain decimal component   (1.5:22.3:44:6) }
{ =================================================================== }

FUNCTION Str2Dist({$IFDEF C}const {$ENDIF} Source: String): Real;
{ =================================================================== }
{ Converts an ascii string to number of feet                          }
{ Strips Leading and trailing spaces and all embedded commas          }
{ ------------------------------------------------------------------- }
{ If successful, Returns converted value with Okay set TRUE           }
{ Else Return 0 with Okay set FALSE                                   }
{ ------------------------------------------------------------------- }
{ If Source contains no colons then format is assumed to be feet      }
{ Else format is assumed to be 'miles:feet'                           }
{ Both miles and feet may contain a decimal component   e.g. 1.5:6.3  }
{ =================================================================== }

FUNCTION Power(Number, Exponent:  Real):  Real;
{ =================================================================== }
{ Return Number raised to the power of exponent                       }
{ Usually returns Exponent * ln(Abs(Number)), however,                }
{ If Number is 0, returns 1 if Exponent is 0, otherwise returns 0     }
{ =================================================================== }

FUNCTION Maximum(i,j: Real): Real;
{ =================================================================== }
{ Returns the larger of two reals                                     }
{ =================================================================== }

FUNCTION Minimum(i,j: Real): Real;
{ =================================================================== }
{ Returns the smaller of two reals                                    }
{ =================================================================== }

FUNCTION Boundary(i, j: Longint): Longint;
{ =================================================================== }
{ simply returns int(i div j) * j                                     }
{ =================================================================== }

FUNCTION Limit(Low, Number, High: LongInt): Longint;
{ =================================================================== }
{ Returns the Low <= Number <= High (Does *NOT* validate LOW <= HIGH) }
{ =================================================================== }

FUNCTION iLimit(LowBound, Number, HighBound: Integer): Integer;
{ =================================================================== }
{ Returns the Low <= Number <= High (Does *NOT* validate LOW <= HIGH) }
{ =================================================================== }

FUNCTION AbsMin(i, j: Longint): Longint;
{ =================================================================== }
{ Returns the ABS(longint) that is closer to zero                     }
{ =================================================================== }

FUNCTION iSign(i: Integer): Integer;
FUNCTION SignOf(Number: LongInt): Integer;
{ =================================================================== }
{ Returns -1, 0, +1 for number less than, equal, or greater than zero }
{ =================================================================== }

PROCEDURE Compress(VAR S{: String});
{ =================================================================== }
{ Removes all characters less than or equal to a space from "s"       }
{ =================================================================== }

FUNCTION Trimmed({constant} S: String; Flags: Byte): String;
{ =================================================================== }
{ Returns "s" w/ trimmed according to flags:                          }
{ Left       $80 remove all leading characters .le. space             }
{ Compress   $60 remove all characters .le. space                     }
{ Control    $40 change all characters .lt. space to a space          }
{ Extraneous $20 change control to space & remove extraneous spaces   }
{ Right      $10 remove all trailing characters .le. space            }
{ =================================================================== }

FUNCTION Ctrim({constant} S: String): String;
{ =================================================================== }
{ CONTOL: Returns "s" w/ all charatcers < space changed to space      }
{ =================================================================== }

FUNCTION Strim({constant} S: String): String;
{ =================================================================== }
{ STRIP: Returns "s" w/ all charatcers <= space removed               }
{ =================================================================== }

FUNCTION Trim({constant} s: String): String;
{ =================================================================== }
{ Returns "s" with all leading and trailing charatcers that are       }
{ less than or equal to a space removed                               }
{ =================================================================== }

FUNCTION Ltrim({constant} s: String): String;
{ =================================================================== }
{ LEFT: Returns "s" with all leading charatcers that are less than or }
{ edto a space removed                                               }
{ =================================================================== }

FUNCTION Rtrim({constant} s: String): String;
{ =================================================================== }
{ RIGHT: Returns "s" with all trailing charatcers that are less than  }
{ or equal to a space removed                                         }
{ =================================================================== }

FUNCTION Ftrim({constant} s: String): String;
{ =================================================================== }
{ FULL: Returns "s" with all leading and trailing charatcers that are }
{ less than or equal to a space removed, all characters less than     }
{ a space converted to a space, and all duplicate spaces removed.     }
{ =================================================================== }

FUNCTION Atrim({$IFDEF C}const {$ENDIF} S: String): String;
{ =================================================================== }
{ ALPHA: Returns "s" w/ all non alpha-numeric charatcers removed      }
{ =================================================================== }

Function Htrim(C: Char; {$IFDEF C}const {$ENDIF} s: String): String;
{ =================================================================== }
{ HEAD: Returns "s" w/ all Leading occurrences of 'c' removed         }
{ NOTE: Does *NOT* remove nul (#0) from the end of the string         }
{       but will remove characters infront of trailing nul.           }
{ =================================================================== }

Function Ttrim(C: Char; s: String): String;
{ =================================================================== }
{ TAIL: Returns "s" w/ all TAIL occurrences of 'c' removed            }
{ NOTE: Does *NOT* remove nul (#0) from the end of the string         }
{       but will remove characters infront of trailing nul.           }
{ =================================================================== }

Function Etrim(C: Char; s: String): String;
{ =================================================================== }
{ END: Returns "s" w/ all HEAD and TAIL occurrences of 'c' removed    }
{ NOTE: Does *NOT* remove nul (#0) from the end of the string         }
{       but will remove characters infront of trailing nul.           }
{ =================================================================== }

Function RwTag(FieldNo: Integer): String;
{ =================================================================== }
{ Returns Romware field tag in the form '<001>'                       }
{ Returns NULL String if FieldNo is ZERO (0)                          }
{ =================================================================== }

FUNCTION IsNumber({$IFDEF C}const {$ENDIF} s: String): Boolean;
{ =================================================================== }
{ Returns TRUE if s is a valid numeric value                          }
{ =================================================================== }

FUNCTION IsInteger({constant} s: String): Boolean;
{ =================================================================== }
{ Returns TRUE if string contains only chatacters '0'..'9'            }
{ =================================================================== }

FUNCTION HasNumber({constant} s: String): Boolean;
{ =================================================================== }
{ Returns TRUE if string "s" contains any characters '0'..'9'         }
{ ------------------------------------------------------------------- }

FUNCTION StrOf(VAR S; Len: Integer): String;
{ =================================================================== }
{ Returns a string starting at "s" for "len" characters               }
{ <Returns null string if "len" is less than 1 or greater than 255>   }
{ =================================================================== }

FUNCTION TrimStrOf(VAR S; Len: Integer): String;
{ =================================================================== }
{ Returns the trimmed string starting at "s" for "len" characters     }
{ <Returns null string if "len" is less than 1 or greater than 255>   }
{ =================================================================== }

FUNCTION Lset({constant} s: String; Width: Integer): String;
{ =================================================================== }
{ Returns "S" left justified or truncated to "width"                  }
{ <Returns null string if width is less than 1 or greater than 255>   }
{ =================================================================== }

FUNCTION Rset({$IFDEF C}const {$ENDIF} s: String; Width: Integer): String;
{ =================================================================== }
{ Returns "S" right justified or truncated to "width"                 }
{ <Returns null string if width is less than 1 or greater than 255>   }
{ =================================================================== }

FUNCTION Center({$IFDEF C}const {$ENDIF} S: String; Width: Integer): String;
{ =================================================================== }
{ Returns S centered within a string of width (or Lset if s > width)  }
{ =================================================================== }

FUNCTION Scomp({constant} String1, String2: String): Integer;
{ =================================================================== }
{ Returns a signed integer value of -1, 0, or +1 based upon the       }
{ numberic weight of string1 - string2.                               }
{                                                                     }
{             Ä1        If String1 is smaller than string2            }
{              0        If String1 is equal to string2                }
{             +1        If String1 is greater than string2            }
{                                                                     }
{ The following code fragment uses Scomp to implement a binary search }
{ strategy that minimizes the number of string comparisons required.  }
{ The knowledge obtained by the string comparison can be used as a    }
{ a case selector.                                                    }
{ =================================================================== }

FUNCTION MemComp(VAR Mem1, Mem2; Size: Word): Integer;
{ =================================================================== }
{ Returns a signed integer value of  -1, 0, +1 based upon the numeric }
{ weight of Mem1 less Mem2 (e.g. Mem1 - Mem2)  (Mem = array of byte)  }
{ =================================================================== }

FUNCTION Apos({constant} SubString, MainString: String): Integer;
{ =================================================================== }
{ Returns the position of the first occurrence of "SubString" in      }
{ "MainString", or length of MainString plus 1 if it does not occur   }
{                                                                     }
{ EXAMPLE TempFile := Copy(FileName,1,Pred(Apos('.',Fname)) + '.BAK'; }
{                                                                     }
{ Will drop an existing file extention from FileName and append       }
{ '.BAK' to TempFile.  The resulting value of TempFile will be the    }
{ same value, regardless if the value of FileName contains a file     }
{ extension or not.                                                   }
{                                                                     }
{ See also Lpos and Npos                                              }
{ =================================================================== }

FUNCTION Lpos({$IFDEF C}const {$ENDIF} SubString,MainString: String): Integer;
{ =================================================================== }
{ Returns the position of the last occurrence of "SubString"          }
{ within "MainString", or zero if "SubString" does not occur          }
{ See also Apos and Npos                                              }
{ =================================================================== }

FUNCTION Npos({constant} SubString,MainString: String; Occurrence: Integer): Integer;
{ =================================================================== }
{ Returns 0 when occurrence is less than 1, otherwise Returns 1 when  }
{ substring is null,  otherwise Returns the position of the N-th      }
{ occurrence of "SubString" in "MainString", or string length plus +1 }
{ if the N-th occurrence is not found.                                }
{ See also Apos and Lpos                                              }
{ =================================================================== }

FUNCTION Count({constant} SubString, MainString: String): Integer;
{ =================================================================== }
{ Returns a count of the number of occurrences of "SubString" within  }
{ "MainString", or 0 when SubString or MainString is null.            }
{ =================================================================== }

FUNCTION Dcount({constant} SubString, MainString: String): Integer;
{ =================================================================== }
{ Returns the number of fields bounded by SubString.  Dcount always   }
{ assumes a phantom SubString delimiter beyond the end of MainString. }
{ Therefore the result is always one greater than the number of times }
{ that SubString occurs within MainString, or 0 if MainStr is null.   }
{ =================================================================== }

FUNCTION Field({$IFDEF C}const {$ENDIF} MainString, Delimiter: String; Occurrence: Integer): String;
{ =================================================================== }
{ Returns a sub-string delimited by the specified occurrence of a     }
{ delimiter sub-string.  Note that Field(S,i) produces the same       }
{ result as FIelds(S,i-1,1).                                          }
{                                                                     }
{ EXAMPLE:  s := '5:2:3487';                                          }
{                                                                     }
{           Identifier   := Field(s,':',1);                           }
{           Registration := Field(s,':',2);                           }
{           Sequence     := Field(s,':',3);                           }
{                                                                     }
{ will set  Identifier to '5'                                         }
{           Registration to '2'                                       }
{      and  Sequence to '3487'                                        }
{                                                                     }
{See also Fields, BeforeFirst, BeforeLast, AfterFirst, AfterLast      }
{ =================================================================== }

FUNCTION Fields({$IFDEF C}const {$ENDIF} MainString,Delimiter: String; Skip,Number: Integer): String;
{ =================================================================== }
{ Returns a sub-string containing the specified number of fields      }
{ bounded by the delimiter sub-string sequence after skipping the     }
{ specified number of fields.  Note that Fields(S,i-1,1) produces the }
{ same result as Field(s,i).                                          }
{                                                                     }
{ EXAMPLE:   s := '0:NARA*RG-153.146*150-16B';                        }
{                                                                     }
{            institution := Fields(s,'*',0,1);                        }
{            collection := Field(s,'*',0,2);                          }
{            folder := Field(s,'*',2,3);                              }
{                                                                     }
{     will   set institution to '0:NARA'                              }
{            collection to '0:NARA*RG-153.146'                        }
{     and    folder to '150-16B'                                      }
{                                                                     }
{ See also Field, BeforeFirst, BeforeLast, AfterFirst, AfterLast      }
{ =================================================================== }

FUNCTION Change({$IFDEF C}const {$ENDIF} OldTxt,NewTxt: String; MainStr: String): String;
{ =================================================================== }
{ Returns "MainStr" with all occuranses of "OldTxt" replaced with     }
{ "NewTxt".  If NewTxt is null, then MainStr is returned with all     }
{ occurrences of OldTxt deleted.                                      }
{ =================================================================== }

FUNCTION BeforeFirst({$IFDEF C}const {$ENDIF} SubStr,MainStr: String): String;
{ =================================================================== }
{ Returns the portion of "MainStr" to the left of the first occurrence}
{ of "SubSTr", or all of "MainStr" if "SubStr" does not occur         }
{ A null SubString matches both ends of MainString.  Therefore,       }
{ BeforeFirst('', S) will return a null string.                       }
{ See also Field, Fields, BeforeFirst, BeforeLast, AfterFirst         }
{                                                                     }
{ EXAMPLE:       VAR s,t: String;                                     }
{                                                                     }
{                s := 'AAA/BBB/CCC/DDD'                               }
{                t := BeforeFirst(s,'/');                             }
{                                                                     }
{         Would set t to "AAA"                                        }
{ =================================================================== }

FUNCTION BeforeLast({constant} SubStr,MainStr: String): String;
{ =================================================================== }
{ Returns the portion of "MainStr" to the left of the last occurrence }
{ of "SubStr", or all of "MainStr" if "SubStr" does not occur         }
{ A null SubString matches both ends of MainString.  Therefore,       }
{ BeforeLast('', S) will return NainStr.                              }
{ See also Field, Fields, BeforeFirst, AfterFirst, Afterlast          }
{                                                                     }
{ EXAMPLE:       VAR s,t: String;                                     }
{                                                                     }
{                s := 'AAA/BBB/CCC/DDD'                               }
{                t := BeforeLast(s,'/');                              }
{                                                                     }
{         Would set t to "AAA/BBB/CCC"                                }
{ =================================================================== }

FUNCTION AfterFirst({$IFDEF C}const {$ENDIF} SubStr,MainStr: String): String;
{ =================================================================== }
{ Returns the portion of "MainStr" to the right of the first          }
{ occurrence of "SubStr", or a NULL string if "SubStr" does not occur.}
{ A null SubString matches both ends of MainString.  Therefore,       }
{ AfterFirst('', S) will return mainStr string.                       }
{ See also Field, Fields, BeforeFirst, BeforeLast, AfterLast.         }
{                                                                     }
{ EXAMPLE:       VAR s,t: String;                                     }
{                                                                     }
{                s := 'AAA/BBB/CCC/DDD'                               }
{                t := AfterFirst(s,'/');                              }
{                                                                     }
{         Would set t to "BBB/CCC/DDD"                                }
{ =================================================================== }

FUNCTION AfterLast({$IFDEF C}const {$ENDIF} SubStr, MainStr: String): String;
{ =================================================================== }
{ Returns the portion of "MainStr" to the right of the last           }
{ occurrence of "SubStr", or a NULL string if "SubStr" does not occur }
{ A null SubString matches both ends of MainString.  Therefore,       }
{ AfterLast('', S) will return a null string.                         }
{ See also Field, Fields, BeforeFirst, BeforeLast, AfterFirst         }
{                                                                     }
{ EXAMPLE:       VAR s,t: String;                                     }
{                                                                     }
{                s := 'AAA/BBB/CCC/DDD'                               }
{                t := AfterLast(s,'/');                               }
{                                                                     }
{         Would set t to "DDD"                                        }
{ =================================================================== }

FUNCTION Strip({$IFDEF C}const {$ENDIF} SubString: String; MainString: String): String;
{ =================================================================== }
{ Returns MainString with all occurrences of SubString removed        }
{ =================================================================== }

FUNCTION StripAny({$IFDEF C}const {$ENDIF} SubString: String; MainString: String): String;
{ =================================================================== }
{ Returns MainString with all occurrences of any of the characters in }
{ SubStr removed                                                      }
{ =================================================================== }

FUNCTION StrLPas(P: pChar; MaxLen: Integer): String;
{ =================================================================== }
{ Returns Asciiz string of maximum "len" characters                   }
{ <Returns null string if "len" is less than 1 or greater than 255>   }
{ =================================================================== }

{$IFNDEF STRINGS}
{ =================================================================== }
{ Following C-String functions were renamed to map to version 7.0     }
{ and are provided for compatibility with Turbo 4.0 through 6.0       }
{ =================================================================== }

function  StrEnd(Str: PChar): pChar;
{ =================================================================== }
{ Return pointer to nul byte                                          }
{ =================================================================== }

FUNCTION  StrLen(Str: pChar): Word;
{ =================================================================== }
{ Return length of a C-String                                         }
{ =================================================================== }

FUNCTION  StrPas(p: pChar): String;
{ =================================================================== }
{ Convert C-String to Pascal String and return Pascal string          }
{ =================================================================== }

PROCEDURE StrPCopy(Target: pChar; {$IFDEF C}const {$ENDIF} Source: String);
{ =================================================================== }
{ Convert Pascal string to C-String and return pointer to C-String    }
{ =================================================================== }

FUNCTION StrPECopy(Target: pChar; {$IFDEF C}const {$ENDIF} Source: String): pChar;
{ =================================================================== }
{ Convert Pascal string to C-String and return pointer to nul EOL     }
{ =================================================================== }
{$ENDIF}

PROCEDURE WrapLines(VAR a,b: String; len: Integer);
{ =================================================================== }
{ Join two lines then separate them according to the specified length }
{ ------------------------------------------------------------------- }
{ It is the caller's responsibility to insure that neither part of    }
{ the resulting wrap exceeds 255 characters, or data will be lost!    }
{ =================================================================== }

{$IFDEF GETENV}
FUNCTION DosVersion: Integer;
{ =================================================================== }
{ Returns DosVersion Hi:Minor, Lo:Major                               }
{ =================================================================== }

FUNCTION GetEnv({$IFDEF C}const {$ENDIF} S: String): String;
{ =================================================================== }
{ Returns the evnironment value for environment parameter "s"         }
{ ------------------------------------------------------------------- }
{ If s is a #0 (NUL CHAR!) returns the program's path\name (DOS 3.x), }
{ or a null string (less than DOS 3.0)                                }
{ Same as ParamStr(0) which returns program's path/name...            }
{ =================================================================== }
{$ENDIF}

PROCEDURE Reverse(VAR Parameter; Size: Integer);
{ =================================================================== }
{ Reverses the byte sequence of a variable                            }
{                                                                     }
{ EXAMPLE: Reverse(i,Sizeof(i));     Will change an Intel low-to-high }
{                                    integer sequence to Motorola     }
{                                    high-to-low sequence.            }
{                                                                     }
{          Reverse(s[1],Ord(s[0]));  Will reverse the characters of   }
{                                    string "s".                      }
{ =================================================================== }

PROCEDURE Exchange(VAR Var1,Var2; Size: Integer);
{ =================================================================== }
{ Exchanges the specified number of bytes of two variables            }
{ =================================================================== }

function IdxAt({constant} S: String; Idx: Byte): Integer;
{ ------------------------------------------------------------------- }
{ implements an Ord(s[i]) for use with const strings like S = 'zxy'   }
{ returns integer value of character at S[Idx] (NO RANGE CHECKING!)   }
{ See also CharAt and LChar                                           }
{ ------------------------------------------------------------------- }

FUNCTION CharAt({constant} S: String; Idx: Integer): Char;
{ ------------------------------------------------------------------- }
{ Returns character at s[Idx], or #0 if idx is < 1 or > length(s)     }
{ See also IdxAt and LChar                                            }
{ ------------------------------------------------------------------- }

FUNCTION LChar({constant} s: String): Char;
{ ------------------------------------------------------------------- }
{ Returns last character. e.g. s[Ord(s[i])]  (Null string returns #0) }
{ See also IdxAt and CharAt                                           }
{ ------------------------------------------------------------------- }

FUNCTION SwapWords(DoubleWord: LongInt): LongInt;
{ =================================================================== }
{ Exchange HI and LO words                                            }
{ =================================================================== }
INLINE ($5A /$58) { Pop DX, Pop AX } ;

function MakeLong(HiWord, LoWord: Word): LongInt;
{ ------------------------------------------------------------------- }
{ takes hi and lo words and makes a longint                           }
{ ------------------------------------------------------------------- }
Inline(
   $58     { pop ax ; pop low  word into AX }
  /$5A     { pop dx ; pop high word into DX }
);

function LoWord(DoubleWord: LongInt) : Word;
{ ------------------------------------------------------------------- }
{ returns the low word of a double word                               }
{ Use LongRec(DoubleWord).Lo for smaller code                         }
{ ------------------------------------------------------------------- }
Inline(
  $58/    { pop ax ; pop low  word into AX                       }
  $5A     { pop dx ; pop high word into DX  -- discarded/ignored }
);

function HiWord(DoublwWord: LongInt) : Word;
{ ------------------------------------------------------------------- }
{ returns high word of a double word                                  }
{ Use LongRec(DoubleWord).HI for smaller code                         }
{ ------------------------------------------------------------------- }
Inline(
       $5A     { pop dx ; pop low  word into DX  -- discarded/ignored }
      /$58     { pop ax ; pop high word into AX }
 );

Procedure IncPtr(VAR Pointer; Amount: Integer);
{ ------------------------------------------------------------------- }
{ Increments pointer by amount of signed integer (wraps on 64k)       }
{ See also AddPtr, FarPtr, and Normalize                              }
{ ------------------------------------------------------------------- }
INLINE(
       $58                  { pop AX         }
      /$5B                  { pop BX         }
      /$07                  { pop ES         }
      /$26 /$01 /$07        { add ES:[BX],AX }
 );

Function AddPtr(p: Pointer; Amount: Integer): Pointer;
{ ------------------------------------------------------------------- }
{ Increments pointer by amount of signed integer (wraps on 64k)       }
{ Same as:   Ptr(Seg(p^), Ofs(p^)+Amount)                             }
{ See also IncPtr, FarPtr, and Normalize                              }
{ ------------------------------------------------------------------- }
INLINE(
       $58                  { pop AX        }
      /$5A                  { pop DX        }
      /$03 /$C2             { add AX,DX     }
      /$5A                  { pop DX        }
 );


{$IFNDEF DPMI}
PROCEDURE Normalize(VAR p: Pointer);
FUNCTION  FarPtr(p: Pointer): Pointer;
{ ------------------------------------------------------------------- }
{ Normalizes SEG:OFS of a pointer so that offset is between 0 and 15  }
{ See also IncPtr, and AddPtr                                         }
{ ------------------------------------------------------------------- }
{$ENDIF}

FUNCTION PreviousCopy: Boolean;
{ =================================================================== }
{ no longer works with BP 7.0 ...                                     }
{ Follows the DOS memory control blocks comparing start of each       }
{ program with that of the current program and returns TRUE if a      }
{ match occurs for a memory resident task other than this one.        }
{ ------------------------------------------------------------------- }
{ This method was chosen so that copies of the program could be       }
{ identified, regardless of their disk location or current name.      }
{ =================================================================== }

FUNCTION Twiddle: Boolean;
{ =================================================================== }
{ Return TRUE and twirl a baton if more than 2 clock tics have passed }
{ since last call, otherwise return FALSE                             }
{ =================================================================== }

IMPLEMENTATION
{ ******************************************************************* }
{$IFOPT F+} {$DEFINE FAR}   {$ELSE} {$UNDEF FAR}   {$ENDIF}
{$IFOPT I+} {$DEFINE IOCHK} {$ELSE} {$UNDEF IOCHK} {$ENDIF}

{$I UTIL01.PAS }

BEGIN
    Timer := Ptr(Seg0040, $6C);
END.
