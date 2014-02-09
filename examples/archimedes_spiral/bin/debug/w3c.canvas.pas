{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Creative IT. All rights reserved.                              }
{ Licensed to Optimale Systemer AS.                                            }
{                                                                              }
{ For the latest version of this spec, see                                     }
{ http://www.khronos.org/registry/xxxxxxxxxx/specs/latest/                     }
{                                                                              }
{ **************************************************************************** }

unit w3c.Canvas;

{------------------------------------------------------------------------------}
{ Author:    Eric Grange                                                       }
{ Updated:   2012.05.10 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

interface

uses w3c.DOM;

type
   HTMLCanvasElement = class external 'HTMLCanvasElement' (Element)
      width : Integer;
      height : Integer;

      function toDataURL(aType : String) : String;

      function getContext(contextId : String) : Variant;
   end;

