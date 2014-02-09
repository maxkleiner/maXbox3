//FormFileTimer_Object_UML;  VISUAL FILE   loc's=75
//tutorial on http://www.softwareschule.ch/download/maxbox_starter2.pdf
//this is the form file for 59_timerobject_starter2_uml_main.txt 
//CLX (Delphi and C++ Builder) based on Qt

const EDITBASE = 170; 
      BTNLINE = 400;
 
var  okBtn, closeBtn: TButton;
     timelbl: TLabel;

//-------------------------------form begin---------------------//
function loadTimerForm: TForm;
var 
  frm: TForm;
  myimage: TImage;
begin
  frm:= TForm.create(self);
  result:= frm;
  timeLbl:= TLabel.create(frm);
  closeBtn:= TButton.create(frm);
  okBtn:= TButton.create(frm);
  myimage:= TImage.Create(frm);
  try
    with frm do begin
      caption:= '*************ETCS RockClock**************';  
      height:= 500;
      width:= 580;
      color:= clpurple;
      Position:= poScreenCenter;
      show;
    end;
    with timeLbl do begin
      parent:= frm;
      setbounds(55,EDITBASE + 60,180,20);
      font.size:= 90;
      font.name:= 'Times New Roman';
      font.color:= clred;
      caption:= 'TIMER:';
    end;  
    with okBtn do begin
      parent:= frm;
      caption:= 'Stop Clock';
      setbounds(210,BTNLINE,145,40);
      font.size:= 18;
      //onclick:= @startStopClick;
      show
    end;
    with closeBtn do begin
      parent:= frm;
      caption:= 'CloseX';
      setbounds(390,BTNLINE,145,40);
      font.size:= 18;
      //onclick:= @closeClick;
      show
    end;   
    with myimage do begin
      Parent:= frm;
      AutoSize:= false;
      try
        picture.bitmap.loadfromFile('..\maxbox3\examples\citymax.bmp')
      except
        showmessage('bitmap citymax.bmp not found')
      end  
      //picture.bitmap.height:= 30+ 30*i;
      center:= tacenter;
      width:= 260;
      height:= 200;
    end;    
  except
    frm.Free;
    result:= NIL;
    Exit
  end  
end;
//--------------------------form end--------------------------//

{//Purpose
Use the Timer component to trigger an event, either one time or repeatedly, after a measured interval. Write the code that you want to occur at the specified time inside the timer component's OnTimer event. 
//Tasks
To specify the amount of elapsed time before the timer event is triggered, use the Interval property. 
To discontinue a timed event, set the timer component's Enabled property to False. TTimer encapsulates the Windows API timer functions.

Unit
ExtCtrls

{Pascal Casing convention capitalizes the first character of each word (including acronyms over two letters in length) as in the following examples.
PropertyDescriptor
HtmlTag
PascalCase

Camel Casing convention capitalizes the first character of each word except the first word, as in the following examples.
propertyDescriptor
ioStream
htmlTag
camelCase}