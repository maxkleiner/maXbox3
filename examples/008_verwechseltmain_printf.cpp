#include <stdio.h>

typedef unsigned char byte;


byte a,b,t;


void Swap(byte *a, byte *b)
{
  byte t;
  
  printf("2: a,b,t= %d %d %d\n",*a,*b,t);
  t = *a;
  *a = *b;
  *b = t;
  printf("3: a,b,t= %d %d %d\n",*a,*b,t);
}


int main( int argc,  char **argv)
{
  a = 10;
  b = 20;
  t = 30;
  printf("1: a,b,t= %d %d %d\n",a,b,t);
  Swap(&b,&a);
  printf("4: a,b,t= %d %d %d\n",a,b,t);
}



/*
//designed for teaching and analyzing methods
//runs under Win and Linux (CLX) 
//the prog shows glob and local vars with call by reference 
//***********************************************************

program xVerwechselt;

var a,b,t: byte;

procedure Swap(var a,b: byte);
var t: byte;

begin
  writeln('2: a,b,t= '+inttostr(a)+' '+inttostr(b)+' '+inttostr(t));
  t:= a;
  a:= b;
  b:= t;
  writeln('3: a,b,t= '+inttostr(a)+' '+inttostr(b)+' '+inttostr(t));
end;


begin //main
  a:= 10;
  b:= 20;
  t:= 30;
  writeln('1: a,b,t= '+inttostr(a)+' '+inttostr(b)+' '+inttostr(t));
  Swap(b,a);
  writeln('4: a,b,t= '+inttostr(a)+' '+inttostr(b)+' '+inttostr(t));
end.


//memo1 is script editor
//memo2 is output space

//max@kleiner.com 
*/