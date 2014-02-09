program word_formulator;

uses crt;
const maxnr=18;
       cola: array[0..maxnr] of string = ('integrated','total',
      'systemized','parallel','responsive','synchronized','optional',
      'compatible','balanced','regulated','tabulated','coordinated',
      'segmented','multiplex','operative','limited','participant',
      'ascendant','priority');
       colb: array[0..maxnr] of string = ('management','organizational',
      'monitored','reciprocal','logistical','incremental','transitional',
      'third-generation','policy','categorial','conversion','alterational',
      'aggregational','operational','convexity','cognition','mode','platform',
      'supplemental');
       colc: array[0..maxnr] of string = ('options','flexibility',
      'capability','mobility','concept','projection','time-phase','hardware',
      'contingency','analysis','rectification','construct','variation','matrix',
      'expectation','examination','stratification','catalyzation',
      'progression');

var a,b,c:string;
       go: char;
       silvia, carlo: string;

procedure shake(var ya,yb,yc: string);
begin;
     ya:=(cola[random(maxnr)]);
     yb:=(colb[random(maxnr)]);
     yc:=(colc[random(maxnr)]);
end;

procedure partner(var silvia,carlo: string);
begin
gotoxy(4,10);
write('   your name please: ');
readln(silvia);
gotoxy(4,12);
write('your partner`s name: ');
readln(carlo);

end;


begin
clrscr;
writeln;
  writeln(' MAGIC///                          ');
  writeln('///LOGIC products                 _______________ ');
  writeln('                       presents   W O R D THEATRE ');
  writeln;
  writeln('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');

partner(silvia,carlo);
repeat
randomize;
clrscr;
shake(a,b,c);
gotoxy(20,2);writeln('      **************************      ');
gotoxy(20,3);writeln('********* WORDS MAKE THE MAN *********');
writeln;
writeln;
writeln(' To get ahead, just talk about things no one understands - even you!');
writeln;
delay(4000);
writeln(' ',Carlo,': What`cha doing?');
delay(2000);
writeln(' ',Silvia,': Working on a ' ,a,' ',b,' ',c,' test.');
delay(4500);
writeln(' ',Carlo,': What`s that?');
shake(a,b,c);
delay(3000);
writeln(' ',Silvia,': Well, basically it`s a kind of ' ,a,' ',b,' ',c);
shake(a,b,c);
writeln('         using ' ,a,' ',b,' ',c,' coupled with ') ;shake(a,b,c);
writeln('         ' ,a,' ',b,' ',c,'.');
delay(11000);
writeln(' ',Carlo,': How`s it going?');
shake(a,b,c);
delay(3000);
writeln(' ',Silvia,': WelI, seem to be having a little trouble with');
writeln('         ' ,a,' ',b,' ',c,'.');
delay(6500);
writeln(' ',Carlo,': I see. How long before you work the bugs out?');
delay(4000);
writeln(' ',Silvia,': Probably about a month.');
delay(2500);
writeln(' ',Carlo,': Hey, that`s great. Keep me posted.');
delay(4000);
writeln;writeln;
writeln('                         quoi qu`il en soit, encore une fois ?   ');
writeln('                         Press any key to continue or Q to Quit');
writeln('                         רררררררררררררררררררררררררררררררררררררררררררררר');
gotoxy (65,23); go:=readkey;
until go in ['n','N','q','Q']
end.