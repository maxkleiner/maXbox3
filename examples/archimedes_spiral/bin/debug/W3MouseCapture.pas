{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Eric Grange, Creative IT. All rights reserved.                 }
{ Licensed to Optimale Systemer AS.                                            }
{                                                                              }
{ **************************************************************************** }

// Adds support for mouse capture
// Uses browser support when available, and a full-screen transparent div otherwise

unit W3MouseCapture;

interface

uses
   w3c.DOM,
   W3System, W3Components, W3Application;

type

  TW3CustomControl = partial class (TW3MovableControl)
    private
      FMouseCaptured : Integer;

      class var vCaptureControl : TW3CustomControl;
      class var vCaptureInitialized : Boolean;
      class procedure InitializeCapture;

    public
      procedure SetCapture;
      procedure ReleaseCapture;
      property MouseCaptured : Boolean read (vCaptureControl=Self);

  end;

implementation

class procedure TW3CustomControl.InitializeCapture;
begin
   var doc$1 := BrowserAPI.GetDocument;
   doc$1.addEventListener('mousedown',
      lambda (evt : MouseEventMouseEvent)
         if vCaptureControl<>nil then begin
            vCaptureControl.CBMouseDown(evt);
            evt.stopImmediatePropagation;
         end;
      end, True);
   doc$1.addEventListener('mousemove',
      lambda (evt$1 : MouseEventMouseEvent)
         if vCaptureControl<>nil then begin
            vCaptureControl.CBMouseMove(evt$1);
            evt$1.stopImmediatePropagation;
         end;
      end, True);
   doc$1.addEventListener('mouseup',
      lambda (evt$2 : MouseEventMouseEvent)
         if vCaptureControl<>nil then begin
            vCaptureControl.CBMouseUp(evt$2);
            evt$2.stopImmediatePropagation;
         end;
         vCaptureControl:=nil;
      end, True);
   doc$1.addEventListener('mouseover',
      lambda (evt$3 : MouseEventMouseEvent)
         if vCaptureControl<>nil then begin
            vCaptureControl.CBMouseEnter(evt$3);
            evt$3.stopImmediatePropagation;
         end;
      end, True);
   doc$1.addEventListener('mouseout',
      lambda (evt$4 : MouseEventMouseEvent)
         if vCaptureControl<>nil then begin
            vCaptureControl.CBMouseExit(evt$4);
            evt$4.stopImmediatePropagation;
         end;
      end, True);
   doc$1.addEventListener('mousewheel',
      lambda (evt$5 : MouseWheelEventMouseWheelEvent)
         if vCaptureControl<>nil then begin
            vCaptureControl.CBMouseWheel(evt$5);
            evt$5.stopImmediatePropagation;
         end;
      end, True);
   doc$1.addEventListener('onclick',
      lambda (evt$6 : EventEvent)
         if vCaptureControl<>nil then begin
            vCaptureControl.CBClick(evt$6);
            evt$6.stopImmediatePropagation();
         end;
      end, True);
   doc$1.addEventListener('ondblclick',
      lambda (evt$7 : EventEvent)
         if vCaptureControl<>nil then begin
            vCaptureControl.CBDblClick(evt$7);
            evt$7.stopImmediatePropagation();
         end;
      end, True);

   vCaptureInitialized:=True;
end;

procedure TW3CustomControl.SetCapture;
begin
   if FMouseCaptured = 0 then begin
      if (Handle.setCapture) then
         Handle.setCapture(true)
      else if not vCaptureInitialized then
         InitializeCapture;
      vCaptureControl := Self;
   end;
   Inc(FMouseCaptured);
end;

procedure TW3CustomControl.ReleaseCapture;
begin
   Dec(FMouseCaptured);
   if FMouseCaptured=0 then begin
      if (Handle.releaseCapture) then
         Handle.releaseCapture();
      vCaptureControl := nil;
   end else if FMouseCaptured<0 then
      FMouseCaptured:=0;
end;

