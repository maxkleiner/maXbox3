unit U_SoundGen2;
{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }TFreqObj.Create(newf,newp,newa,shape)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MPlayer, StdCtrls, ComCtrls, Menus, CheckLst, ExtCtrls, shellAPI;

type

  TfreqObj=class(TObject)
     ftemp,f,P,a,shape:INTEGER;
     StringRep:String;
     constructor Create(newf, newP, newA, newshape:integer);
     procedure makestringrep;
  end;

  TVolumeLevel = 0..127 ;
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    IntroSheet: TTabSheet;
    SoundSheet: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    VolLbl: TLabel;
    FreqLbl: TLabel;
    Label1: TLabel;
    CompLbl: TLabel;
    Label5: TLabel;
    PlayBtn: TButton;
    StopBtn: TButton;
    VolBar: TTrackBar;
    ListBox1: TCheckListBox;
    ListBox2: TListBox;
    Freqbar: TTrackBar;
    RateRgrp: TRadioGroup;
    StatusBar1: TStatusBar;
    VolEdit: TEdit;
    FreqEdit: TEdit;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PopupMenu2: TPopupMenu;
    N2: TMenuItem;
    Startnewsound1: TMenuItem;
    Loadsound1: TMenuItem;
    Savesound1: TMenuItem;
    Savesoundas1: TMenuItem;
    Deletesoundfile1: TMenuItem;
    ImageSheet: TTabSheet;
    Image1: TImage;
    StaticText1: TStaticText;
    Applyfreqscalingtodefinition1: TMenuItem;
    Memo1: TMemo;
    Label4: TLabel;
    Label6: TLabel;
    Edit1: TEdit;
    Unitsgrp: TRadioGroup;
    Duration: TUpDown;
    Label7: TLabel;
    TabSheet1: TTabSheet;
    Edit2: TEdit;
    Label8: TLabel;
    UpDown1: TUpDown;
    Button1: TButton;
    Button2: TButton;
    PinkNoiseBtn: TCheckBox;
    procedure PlayBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure VolBarChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure LoadsoundClick(Sender: TObject);
    procedure SavesoundClick(Sender: TObject);
    procedure SavesoundasClick(Sender: TObject);
    procedure StartnewsoundClick(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FreqbarChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Removesoundfromlist1Click(Sender: TObject);
    procedure ListBox2ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Deletesoundfile1Click(Sender: TObject);
    procedure RateRgrpClick(Sender: TObject);
    procedure VolEditChange(Sender: TObject);
    procedure FreqEditChange(Sender: TObject);
    procedure FreqEditKeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBox1ClickCheck(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure ImageSheetEnter(Sender: TObject);
    procedure Applyfreqscalingtodefinition1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MS: array[0..1] of tmemorystream;
    StreamInUse:integer;
    datacount:integer;
    soundname, soundfilename :string;
    soundfilelist:TStringList;  {list of sound file names}
    modified:boolean; {Has this sound been changed since last save?}
    playing:boolean;  {Is sound currently playing?}
    checkclicked:boolean;  {Clicking the checkbox also counts as a click, which
                             we don't want - this switch allows checkbox clicks
                            to be ignored as clicks}
    imagedata:array of byte;
    procedure MakeComplexSound(n:integer; freqlist:TStrings;
                           Duration{mSec}: Integer; Volume: TVolumeLevel);
    procedure MsPlaySound;
    procedure MakeObject;
    procedure EditObject;
    procedure DeleteObject(n:integer);
    procedure AddObjectToList(newf,newp,newa,news:integer);
    procedure savesound;
    procedure savenewsound;
    procedure LoadSound(name:string);
    procedure Clearlist;
    procedure Getfilenames(path,mask:string;list:TStringlist);
    function  checkmodified:boolean;
    procedure checkplaying;
  end;

var
  Form1: TForm1;
  SampleRate: Integer = 11025; // 8000, 11025, 22050, or 44100

implementation
{$R *.DFM}

uses math, MMSystem,U_SetFreq;

function makesoundname(name:string):string;
 var n:integer;
     s:string;
 begin
    s:=extractfilename(name);
    n:=pos('.',s);
    if n>0 then delete(s,n,length(s)-n+1);
    result:=s;
 end;

var shapenames:array[0..3] of string=('Sine','Square','Sawtooth','Triangle');
  defaultname:string='DEFAULT.SND';

{************ TFreqObj.Create *********}
Constructor TFreqObj.Create;

begin
  inherited create;
  f:=newf;
  ftemp:=f;
  p:=newp;
  a:=newA;
  shape:=newSHAPE;
  makestringrep;
end;

procedure TFreqObj.makestringrep;
begin
  stringrep:=format('%5d (F:%4d, P:%4d, A:%4d  %S)',[ftemp,f,p,a,SHAPENAMES[SHAPE]]);
end;


const
  Mono: Word = $0001;
  
  RiffId: string = 'RIFF';
  WaveId: string = 'WAVE';
  FmtId: string = 'fmt ';
  DataId: string = 'data';


{********************* MakeComplexSound **************}
procedure TForm1.MakeComplexSound(N:integer {stream # to use};
                           freqlist:TStrings;
                           Duration{mSec}: Integer;
                           Volume: TVolumeLevel);
  {writes complex tone defined by a list to memory stream N }
var
  WaveFormatEx: TWaveFormatEx;
  i,j, TempInt, RiffCount: integer;
  SoundValue: integer;
  Byteval:byte;
  minfreq, maxval:integer;
  w,ph, amp: double; // w= omega = ( 2 * pi * frequency) {= radians per second}
  freqerror:boolean;
  sampdiv2:integer; {half of sampling rate}
  msg:string;
  ptspercycle,x:extended;
begin
  with WaveFormatEx do
  begin
    wFormatTag := WAVE_FORMAT_PCM;
    nChannels := Mono;
    nSamplesPerSec := SampleRate;
    wBitsPerSample := $0008;
    nBlockAlign := (nChannels * wBitsPerSample) div 8;
    nAvgBytesPerSec := nSamplesPerSec * nBlockAlign;
    cbSize := 0;
  end;
  MS[n] := TMemoryStream.Create;
  with MS[n] do
  begin
    {Calculate length of sound data and of file data}
    DataCount := (Duration * SampleRate) div 1000; {record "duration" ms at "samplrate" samps/sec}
    RiffCount := Length(WaveId) + Length(FmtId) + SizeOf(DWORD) +
    SizeOf(TWaveFormatEx) + Length(DataId) + SizeOf(DWORD) + DataCount; // file data
    {write out the wave header}
    Write(RiffId[1], 4); // 'RIFF'
    Write(RiffCount, SizeOf(DWORD)); // file data size
    Write(WaveId[1], Length(WaveId)); // 'WAVE'
    Write(FmtId[1], Length(FmtId)); // 'fmt '
    TempInt := SizeOf(TWaveFormatEx);
    Write(TempInt, SizeOf(DWORD)); // TWaveFormat data size
    Write(WaveFormatEx, SizeOf(TWaveFormatEx)); // WaveFormatEx record
    Write(DataId[1], Length(DataId)); // 'data'
    Write(DataCount, SizeOf(DWORD)); // sound data size
    {calculate and write out the tone signal} // now the data values

    {calculate a few cycles of the lowest frequency to find an appropriate
     scaling value for the signal}
    minfreq:=TFreqObj(freqlist.objects[0]).ftemp;
    maxval:=0;
    freqerror:=false;
    sampdiv2:=samplerate div 2;
    for i := 0 to trunc(2/minfreq*samplerate) do
    begin
      soundvalue:=0;
      for j:=0 to freqlist.count-1 do
      if TFreqObj(freqlist.objects[j])<>nil then
      with TFreqObj(freqlist.objects[j]) do
      begin
        if ftemp>sampdiv2 then freqerror:=true;
        w := 2 * Pi * Ftemp; // omega
        ph:=p/pi;
        SoundValue := soundvalue+ trunc(Volume * a/1000* sin(ph+i * w / SampleRate)); // wt = w * i / SampleRate
      end;
      If soundvalue>maxval
      then maxval:=soundvalue;
    end;
    if freqerror then
    begin
      msg:='Some frequency components ignored (too high to display';
      beep;
    end
    else msg:='';
    statusbar1.panels[1].text:=msg;
    {now we can generate the waveform}
    for i := 0 to DataCount - 1 do
    begin
      soundvalue:=127;
      for j:=0 to freqlist.count-1 do  {last entry is "add new freq" - ignore}
      if TFreqObj(freqlist.objects[j])<>nil then
      with TFreqObj(freqlist.objects[j]) do
      begin
        if ftemp< sampdiv2 then
        begin
          ptspercycle:=samplerate/Ftemp;
          if j=0 then setlength(imagedata,min(datacount,trunc(5*ptspercycle)));
          x:=frac(i/ptspercycle+p/360); {where are we in the cycle}
          amp:=a/1000 ;  {amplitude}
          if pinknoisebtn.checked then amp:=amp+100*a*(1-random)/(f*1000) ;  {add pink noise}
          CASE SHAPE OF
            0: {Sine}
            begin
              w := 2 * Pi * Ftemp; {omega}
              ph:=p/pi;  {phase}
              SoundValue := soundvalue+ trunc(Volume * amp* sin(ph+i * w / SampleRate)
                     ); // wt = w * i / SampleRate
            end;
            1: {Square}
            begin
              if x<0.5
              then SoundValue := soundvalue -trunc(Volume * amp)
              else SoundValue := soundvalue +trunc(Volume * amp);
            end;
            2: {Sawtooth}
            begin
              SoundValue := soundvalue + trunc(Volume * amp*(2*x-1));
            end;
            3: {Triangle}
            begin
              if x<0.5
              then SoundValue := soundvalue +trunc(Volume * amp*(4*x-1))
              else SoundValue := soundvalue +trunc(Volume * amp*(3-4*x));
            end;
          end; {case}

        end;
      end;
      if maxval>127 then byteval:=soundvalue*127 div maxval
      else byteval:=soundvalue;
      Write(Byteval, SizeOf(Byte));

      {write a few cycles for debugging}
      If i<=high(imagedata) then imagedata[i]:=byteval;
    end;
  end;

end;

{********** msPlaySound ********}
 procedure TForm1.msPlaySound;
 var options:integer;
 begin
   options:=SND_MEMORY or SND_ASYNC;
   if duration.position=0 then  options:=options or SND_LOOP;
   PlaySound(MS[streaminuse].Memory, 0, options);
 end;



{*************** PlayBtnClick **********}
procedure TForm1.PlayBtnClick(Sender: TObject);
var
  nextstream:integer;
  freqlist:TStringlist;
  i:integer;
  dur:integer;
begin
  freqlist:=TStringlist.create;
  with listbox1 do
  if items.count>0 then
  begin
    for i:=0 to items.count-1 do if checked[i] {copy only the checked frequencies}
    then freqlist.addobject(items[i],items.objects[i]);
    nextstream:=(streaminuse+1) mod 2;
    if freqlist.count>0 then
    begin
      dur:=duration.position;
      if unitsgrp.itemindex=1 then dur:=dur*1000;
      if dur=0 then dur:=1000;  {continuous, generate 1 second's worth}
      MakeComplexSound(nextstream, freqlist, dur{1000}, Volbar.position);
      stopbtnclick(sender);
      playing:=true;
      streaminuse:=nextstream;
      MsPlaySound;
    end
    else stopbtnclick(sender);
    freqlist.free;
  end;
end;

{*************** StopBtnClick **************}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  PlaySound(nil,0,SND_Purge);
  if assigned (ms[streaminuse]) then freeandnil(Ms[streaminuse]);
  playing:=false;
end;



{************** FormCreate ******}
procedure TForm1.FormCreate(Sender: TObject);
begin
  streaminuse:=1;
  pagecontrol1.activepage:=IntroSheet;
end;

{************* ListBox1Click *********}
procedure TForm1.ListBox1Click(Sender: TObject);
begin
  if not checkclicked then editobject;
  checkclicked:=false;
end;

{**************** MakeObject *********}
procedure TForm1.MakeObject;
begin
  with ElementDlg do
  begin
    caption:='Define new frequency';
    setElement(440,0,500,0);
    if showmodal=MrOK then
    with listbox1 do AddObjectToList(freqedt.value,PhaseEdt.value,AmpEdt.value,wavegrp.itemindex);
  end;
  checkplaying;
end;

procedure TForm1.CheckPlaying;
{Simulate play button just to force waveform to be drawn, even if we stop it
 immediately}
begin
  if playing then playbtnclick(self)
  else
  begin
    playbtnclick(self);
    stopbtnclick(self);
  end;  
end;


{**************** AddObjectToList *************}
procedure TForm1.AddObjectToList(newf,newp,newa,news:integer);
{Create a new TFreqObj and add it to Listbox1}
var
  ff:TFreqObj;
begin
  with listbox1, elementdlg do
  begin
     ff:=TFreqObj.create(newf,newp,newa,news);
     items.addobject(ff.stringrep,ff);
     itemindex:=items.count-1;
     checked[itemindex]:=true;
     modified:=true;
   end;
end;

{************** EditObject *********}
procedure TForm1.EditObject;
begin
  with listbox1, items do
  with TFreqObj(objects[itemindex]), elementdlg  do
  begin
    setElement(f,p,a,shape);
    caption:='Change frequency component';
    if showmodal=MrOK then
    with listbox1 do
    begin
      f:=freqedt.value;
      p:=PhaseEdt.value;
      a:=AmpEdt.value;
      Shape:=wavegrp.itemindex;
      makestringrep;
      strings[itemindex]:=stringrep;
    end;
  end;
  modified:=true;
  checkplaying;

end;

{*************** DeleteObject *********}
procedure TForm1.DeleteObject(n:integer);
{delete frequency list item n}
begin
  with listbox1, items do
  If n<count-1 then
  begin
    TFreqObj(objects[n]).free;
    objects[n]:=nil;
    delete(n);
  end;
  modified:=true;
  checkplaying;
end;

{************** SaveSound **********}
Procedure TForm1.savesound;
var
  ff:textfile;
  i:integer;
begin
  assignfile(ff,soundfilename);
  rewrite(ff);
  writeln(ff,'D',' ',duration.position,' ',unitsgrp.itemindex);
  for i:=0 to listbox1.items.count-1 do
  with listbox1, TFreqObj(items.objects[i]) do writeln(ff,
          integer(checked[i]),' ', f,' ',p,' ',a,' ',shape,' ',stringrep);
  closefile(ff);
  modified:=false;
end;


{************** LoadSound ********}
Procedure TForm1.Loadsound(name:string);
var
  ff:textfile;
  t:TFreqobj;
  chk:integer;
  d:char;
  dur,units:integer;
begin
  if checkmodified then
  begin
    soundfilename:=name;
    if name='' then {newsound} Savenewsound;

    assignfile(ff,soundfilename);
    reset(ff);
    read(ff,d);
    if d='D' then
    begin
      readln(ff,dur, units);
      duration.position:=dur;
      unitsgrp.itemindex:=units;
    end
    else reset(ff);  {old version w/o duration, just reset file to start}
    soundname:=makesoundname(soundfilename);
    statusbar1.Panels[0].text:='Current sound: '+soundname+' ('+soundfilename+')';
    listbox1.clear;
    while not eof(ff) do
    with listbox1 do
    begin
      t:=tfreqobj.create(0,0,0,0);
      with t do readln(ff,chk, f,p,a,shape,stringrep);
      t.ftemp:=t.f;
      items.AddObject(t.stringrep,t);
      checked[items.count-1]:=chk<>0
    end;
    closefile(ff);
    modified:=false;
    if listbox1.items.count=0 then AddObjectToList(440,0,500,0); {no entry, make one}
    freqbar.position:=TFreqobj(listbox1.items.objects[0]).f;
    volbar.position:=64;
    volbarchange(self);
    complbl.caption:='Components for '+soundname;
  end;
end;


{**************** DeletefreqClick **********}
function TForm1.checkmodified:boolean;
{check if current freq set has been modified,
   return true if not modified or user did not say "Cancel"}
var  r:integer;
begin
  r:=mrno;
  if modified then
  begin
    r:=messagedlg('Save current sound first?',
                              mtConfirmation,[mbyes,mbno,mbcancel],0);
    if r=mryes then
    begin
      savesoundclick(self);
      r:=mrno;
    end;
  end;
  result:= r=mrno;
end;

{***** Clearlist ********}
procedure Tform1.clearlist;
{Empty the frequency list, deleting TFreq objects as we go}
begin
  while listbox1.items.count>1 do deleteobject(0);
  modified:=false;
end;

{************ ListBox2Click *************}
procedure TForm1.ListBox2Click(Sender: TObject);
{select a sound}
begin
  loadsound(soundfilelist[listbox2.itemindex]);
  checkplaying;
end;

{***************** GetFileNames **************}
procedure TForm1.Getfilenames(path,mask:string;list:TStringlist);
var
  SearchRec: TSearchRec;
begin
  list.Clear;
  chdir(path);
  if FindFirst(mask, faAnyFile, SearchRec) = 0 then
  repeat
    list.Add(SearchRec.Name);
  until FindNext(SearchRec) <> 0;
end;

{*************** FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
var i:integer;
    {f:textfile;
    line:string;
    }
begin
  if not assigned(soundfilelist) then  soundfilelist:=Tstringlist.create
  else soundfilelist.clear;
  listbox2.clear;
  getfilenames(extractfilepath(application.exename),'*.snd', soundfilelist);
  for i:=0 to soundfilelist.count-1 do
  begin
    listbox2.items.add(makesoundname(soundfilelist[i]));
  end;
  if listbox2.items.count>0 then
  begin
    listbox2.itemindex:=0;
    loadsound(soundfilelist[0]);
  end;
end;

{**************** FreqBarChange ***********}
procedure TForm1.FreqbarChange(Sender: TObject);
{Reascale the current sound based on new 1st frequency}
var
  scale:extended;
  i:integer;
begin
  if freqbar.position>0 then
  begin
    with listbox1,items do
    if count>=1 then
    begin
      scale:=freqbar.position/TFreqobj(objects[0]).f;
      freqedit.text:=inttostr(freqbar.position);
      for i:=0 to count-1 do
      if objects[i]<>nil then
      with TFreqObj(objects[i]) do
      begin
        ftemp:=round(f*scale);
        makestringrep;
        items[i]:=stringrep;
      end;
    end;
    checkplaying;
  end;
end;

{***************** FormCloseQuery ***********}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{ Give user a chance to save last changed sound before exiting}
begin
  if checkmodified then canclose:=true
  else canclose:=false;
end;

{*******************}
{Popup menu actions }
{*******************}

{*********** ApplyfreqScalingToDefinition **********}
procedure TForm1.Applyfreqscalingtodefinition1Click(Sender: TObject);
{Make current frequency scaling a permanent part of sound definition}
var
 i:integer;
begin
  with listbox1,items do
  if count>=1 then
  begin
    for i:=0 to count-1 do
    if objects[i]<>nil then
    with TFreqObj(objects[i]) do
    if f<>ftemp then
    begin
      f:=ftemp;
      makestringrep;
      items[i]:=stringrep;
      modified:=true;
    end;
  end;
end;


{************* RemovesoundfromList *************}
procedure TForm1.Removesoundfromlist1Click(Sender: TObject);
var n:integer;
begin
  if checkmodified then
  with listbox2 do
  if items.count>1 then
  begin
    n:=itemindex;
    items.delete(N);
    soundfilelist.delete(N);
    if N>items.count-1 then itemindex:=items.count-1 else itemindex:=N;
    loadsound(soundfilelist[itemindex]
    );
  end;
end;

{********* ListBox2ContextPopup ************}
procedure TForm1.ListBox2ContextPopup(Sender: TObject; MousePos: TPoint;
{User right clicked - select entry on before the popup menu is displayed}
  var Handled: Boolean);
var n:integer;
begin
  with listbox2 do
  begin
    n:=itemindex;
    itemindex:=mousepos.y div  itemheight;
    if itemindex<>n then loadsound(soundfilelist[itemindex]); {don't reload if we didn't move}
  end;
end;

{**************** DeleteSound *********}
procedure TForm1.Deletesoundfile1Click(Sender: TObject);
{Delete a sound file}
var filename:string;
begin
  filename:=soundfilename;

  if fileexists(filename) and (messagedlg('Delete '+filename+'?',mtconfirmation,
                  [mbyes,mbno],0)=mryes) then
  begin
    removesoundfromlist1Click(sender);
    deletefile(filename);
  end;
end;

{***************** StartNewSoundClick ********}
procedure TForm1.StartnewsoundClick(Sender: TObject);
begin
  if checkmodified then
  begin
    clearlist;
    soundname:='New Sound';
    soundfilename:='';
    listbox2.items.add(soundname);
    soundfilelist.add('');
    loadsound('');
  end;
end;

{************** LoadSoundClick ***********}
procedure TForm1.LoadsoundClick(Sender: TObject);

begin
  if (checkmodified) and opendialog1.execute then
  begin
    {load new list data here}
    loadsound(opendialog1.filename);
  end;
end;

{************* SaveSoundClick *********}
procedure TForm1.SavesoundClick(Sender: TObject);
begin
  If uppercase(soundfilename)=defaultname then
  begin
    showmessage('Initial default sound not replaced, clcik to save with another name');
    savenewsound;
  end
  else savesound;
end;

{******************* SaveSoundAsClick ***********}
procedure TForm1.SavesoundasClick(Sender: TObject);
var i:integer;
    s:string;
begin
  if savedialog1.execute then
  with listbox2 do
  begin
    soundfilename:=savedialog1.filename;
    soundname:=makesoundname(soundfilename);
    s:=uppercase(soundname);
    for i:=0 to items.count-1 do
    begin
      if s=uppercase(items[i]) then
      begin
        items.delete(i);
        soundfilelist.Delete(i);
        break;
      end
    end;
    Items.add(soundname);
    soundfilelist.add(soundfilename);
    itemindex:=items.count-1;
    savesound;
    statusbar1.Panels[0].text:='Current sound: '+soundname+' ('+soundfilename+')';
  end;
end;

{******************* SaveNewSound ***********}
procedure TForm1.SaveNewsound;
begin
  if savedialog1.execute then
  with listbox2 do
  begin
    {soundname:=Inputbox('Save as','Enter sound name',soundname);}
    soundfilename:=savedialog1.filename;
    soundname:=makesoundname(soundfilename);
    items[itemindex]:=soundname;
    soundfilelist[itemindex]:=soundfilename;
    savesound;
  end;
end;

{*********** End Popup menu actions **********}


{*************** RateRgrpClick **************}
var samprates:array[0..3] of integer=(8000,11025,22050,44100);

procedure TForm1.RateRgrpClick(Sender: TObject);
{Set new sampling rate based on user click}
begin
  samplerate:=samprates[rateRgrp.itemindex];
  checkplaying;
end;

{************* VolBarChange *************}
procedure TForm1.VolBarChange(Sender: TObject);
begin
  volEdit.text:=inttostr(Volbar.position);
  checkplaying;
end;

{***************** VolEditChange ***********}
procedure TForm1.VolEditChange(Sender: TObject);
{User manually changed master Volume edit box value}
var n:integer;
begin
  n:=volbar.position;
  volbar.position:=strtointdef(VolEdit.text,n);
  if n<>volbar.position then volbarchange(sender);
end;

{************** FreEditChange *************}
procedure TForm1.FreqEditChange(Sender: TObject);
{User manually changed master Frequency edit box value}
var n:integer;
begin
  n:=freqbar.position;
  freqbar.position:=strtointdef(freqedit.text,n);
  if n<>freqbar.position then FreqBarchange(sender);
end;

{************** FreqEditKeyPress *********}
procedure TForm1.FreqEditKeyPress(Sender: TObject; var Key: Char);
{Enter a revised frequency value}
begin
  if key=#13 then Freqeditchange(sender);
end;

{*************** ListBoxKeyUp ****************}
procedure TForm1.ListBox1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{Check for user press of Enter, Insert, or Delete}
begin
  case key of
    vk_return: EditObject;
    vk_Insert: MakeObject;
    Vk_Delete: deleteObject(listbox1.itemindex);
  end;
end;

{************ ListBoxClickCheck ************}
procedure TForm1.ListBox1ClickCheck(Sender: TObject);
{User clicked a check box to enable or disable a freq component}
begin
  {Set a switch so that Onclick can ignore this as a mod request click}
  checkclicked:=true;
  modified:=true;
  checkplaying;
end;


{***************** StaticText1Click ****************}
procedure TForm1.StaticText1Click(Sender: TObject);
begin
    ShellExecute(Handle, 'open', 'http://delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

{**************** ImageSheetEnter ***********}
procedure TForm1.ImageSheetEnter(Sender: TObject);
{draw the current sound image when imagesheet is entered}
var  pointstoplot,i,x,xincr:integer;
begin
  if length(imagedata)>0 then
  With image1 do
  begin
    canvas.fillrect(clientrect);
    pointstoplot:=length(imagedata);

    xincr:=image1.width div pointstoplot;
    if xincr=0 then  {too much data, truncate plot}
    begin
      pointstoplot:=image1.width;
      xincr:=1;
    end;
    x:=0;  i:=0;
    canvas.pen.width:=3;
    canvas.moveto(x,height-imagedata[0]);
    while i<pointstoplot-1 do
    begin
      inc(i);
      inc(x,xincr);
      canvas.lineto(x,height-imagedata[i]);
    end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if savedialog1.execute then
  begin
    ms[streaminuse].savetofile(savedialog1.filename);
  end;  
end;

end.
