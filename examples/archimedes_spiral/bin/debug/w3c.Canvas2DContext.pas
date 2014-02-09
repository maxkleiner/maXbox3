{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Creative IT. All rights reserved.                              }
{ Licensed to Optimale Systemer AS.                                            }
{                                                                              }
{ For the latest version of this spec, see                                     }
{ http://www.w3.org/TR/2dcontext/                                              }
{                                                                              }
{ **************************************************************************** }

unit w3c.Canvas2DContext;

{------------------------------------------------------------------------------}
{ Author:    Eric Grange                                                       }
{ Updated:   2012.05.11 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

interface

uses w3c.dom, w3c.canvas, w3c.typedarray;

type
   JHTMLImageElement = class external (Element);
   JHTMLVideoElement = class external (Element);

   JCanvasGradient = class external 'CanvasGradient'
      // opaque object
      procedure addColorStop(offset : Float; color : String);
   end;

   CanvasPattern = class external 'CanvasPattern'
      // opaque object
   end;

   TextMetrics = class external 'TextMetrics'
      width : Float; // Read Only
   end;

   ImageData = class external 'ImageData'
      width : Integer; // Read Only
      height : Integer; // Read Only
      data : Uint8ClampedArray; // Read Only
   end;

   CanvasRenderingContext2D = class external 'CanvasRenderingContext2D'

      // back-reference to the canvas
      canvas : HTMLCanvasElement; // Read Only

      // state
      procedure save(); // push state on state stack
      procedure restore(); // pop state stack and restore state

      // compositing
      globalAlpha : Float; // (default 1.0)
      globalCompositeOperation : String; // (default source-over)

      // colors and styles (see also the CanvasLineStyles interface)
      strokeStyle : Variant; // (default black)
      fillStyle : Variant; // (default black)
      function  createLinearGradient(x0 : Float; y0 : Float; x1 : Float; y1 : Float) : CanvasGradient;
      function  createRadialGradient(x0 : Float; y0 : Float; r0 : Float; x1 : Float; y1 : Float; r1 : Float) : CanvasGradient;
      function  createPattern(image : ElementElement; repetition : String) : CanvasPattern;

      // shadows
      shadowOffsetX : Float; // (default 0)
      shadowOffsetY : Float; // (default 0)
      shadowBlur : Float; // (default 0)
      shadowColor : String; // (default transparent black)
      procedure clearShadow; // webkit-specific

      // rects
      procedure clearRect(x : Float; y : Float; w : Float; h : Float);
      procedure fillRect(x : Float; y : Float; w : Float; h : Float);
      procedure strokeRect(x : Float; y : Float; w : Float; h : Float);

      // current default path API (see also CanvasPathMethods)
      procedure beginPath();
      procedure fill();
      procedure stroke();
      procedure drawSystemFocusRing(element : ElementElement);
      function  drawCustomFocusRing(element : ElementElement) : Boolean;
      procedure scrollPathIntoView();
      procedure clip();
      procedure resetClip();
      function  isPointInPath(x : Float; y : Float) : Boolean;

      // text (see also the CanvasText interface)
      procedure fillText(text : String; x : Float; y : Float); overload;
      procedure fillText(text : String; x : Float; y : Float; maxWidth : Float); overload;
      procedure strokeText(text : String; x : Float; y : Float); overload;
      procedure strokeText(text : String; x : Float; y : Float; maxWidth : Float); overload;
      function  measureText(text : String) : TextMetrics;

      // drawing images
      procedure drawImage(image : ElementElement; dx, dy : Float); overload;
      procedure drawImage(image : ElementElement; dx, dy, dw, dh : Float); overload;
      procedure drawImage(image : ElementElement; sx, sy, sw, sh, dx, dy, dw, dh : Float); overload;

      // pixel manipulation
      function  createImageData(sw : Float; sh : Float) : ImageData; overload;
      function  createImageData(imagedata : ImageDataImageData) : ImageData; overload;
      function  getImageData(sx : Float; sy : Float; sw : Float; sh : Float) : ImageData;
      procedure putImageData(imagedata : ImageDataImageData; dx : Float; dy : Float); overload;
      procedure putImageData(imagedata : ImageDataImageData; dx : Float; dy : Float; dirtyX : Float; dirtyY : Float; dirtyWidth : Float; dirtyHeight : Float); overload;

      // transformations (default transform is the identity matrix)
      procedure scale(x : Float; y : Float);
      procedure rotate(angle : Float);
      procedure translate(x : Float; y : Float);
      procedure transform(a : Float; b : Float; c : Float; d : Float; e : Float; f : Float);
      procedure setTransform(a : Float; b : Float; c : Float; d : Float; e : Float; f : Float);

      // shared path API methods
      procedure closePath();
      procedure moveTo(x : Float; y : Float);
      procedure lineTo(x : Float; y : Float);
      procedure quadraticCurveTo(cpx : Float; cpy : Float; x : Float; y : Float);
      procedure bezierCurveTo(cp1x : Float; cp1y : Float; cp2x : Float; cp2y : Float; x : Float; y : Float);
      procedure arcTo(x1 : Float; y1 : Float; x2 : Float; y2 : Float; radius : Float);
      procedure rect(x : Float; y : Float; w : Float; h : Float);
      procedure arc(x : Float; y : Float; radius : Float; startAngle : Float; endAngle : Float; anticlockwise : Boolean);

      // line caps/joins
      lineWidth : Float; // (default 1)
      lineCap : String; // "butt", "round", "square" (default "butt")
      lineJoin : String; // "round", "bevel", "miter" (default "miter")
      lineDashOffset : Float; // (default 0.0)
      miterLimit : Float; // (default 10)

      // text
      font : String; // (default 10px sans-serif)
      textAlign : String; // "start", "end", "left", "right", "center" (default: "start")
      textBaseline : String; // "top", "hanging", "middle", "alphabetic", "ideographic", "bottom" (default: "alphabetic")
   end;

