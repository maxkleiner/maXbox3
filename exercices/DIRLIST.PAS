program Dynstr1;   {dynstr1.pas}

{Heapdemo}

uses winCrt, windos, strings;

{---------------------------------------------------------}
{   Prozeduren die keine Methoden sind                    }
{---------------------------------------------------------}


procedure findfile(mypath : pchar);

var
  dir: array[0..fsdirectory] of char;
  fname: array[0..fsfilename] of char;
  fext : array[0..fsextension] of char;
  datetime: tdatetime;
  searchrec: tsearchrec;
  begin
    findfirst(mypath, faanyfile, searchrec);

    while (doserror = 0) do begin

      if (searchrec.name[0] <> '.') or
      ((searchrec.name[0] <> '.') and
      (searchrec.name[1] <> '.')) then begin
        filesplit(mypath,dir,fname, fext);

        if (searchrec.attr and fadirectory) > 0 then begin
          strcat(dir, searchrec.name);
          write('DIR:');
         writeln(searchrec.name);
          strcat(dir,'\*.*');
          findfile(dir);

        end;
        write('  ');
        writeln(searchrec.name);

      end;

     findnext(searchrec);

    end;

  end;


  begin
    autotracking:=true;
    screensize.x :=80;
    screensize.y:=500;
    findfile('c:\*.*');
 end.