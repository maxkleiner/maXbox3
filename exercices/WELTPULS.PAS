program weltpuls;    (* H.Bossel: Modellbildung und Simulation 910503 *)
uses crt,graph;
var
   volk,last,kons,tun,volkNeu,lastNeu,konsNeu,tunNeu,C,t:real;
   antwort: string;
   weiter: boolean;
   graphDriver,graphMode: integer;
   sx,sy,xnull,ynull,xscale,yscale: integer;
begin
   weiter := true;
   while (weiter) do
   begin
      clrscr;
      writeln ('PULSDYNAMIK EINES MINI-WELTMODELLS');
      writeln;
      writeln ('Eingriffsparameter C (0.4)');
      readln (C);
      graphDriver := detect;
      initGraph (graphDriver, graphMode, 'tur/bgi');
      sx := (getMaxX+1) div 100;
      sy := (getMaxY+1) div 100;
      xnull := round(0*sx);
      ynull := round(50*sy);
      line (xnull+round(100*sx),ynull,xnull,ynull);
      moveTo(xnull,ynull);
      xscale := 1;
      yscale := 100;
      t := 0;
      volk := 0;
      last := 1;  (* Anfangspuls hier*)
      kons := 0;
      tun  := 0;
      while t<101 do
      begin
         line (round(t*xscale*sx),ynull,round(t*xscale*sx),
         round(ynull-last*yscale));
         t := t+1;
         volkNeu := -0.1*last+0.3*kons-0.1*tun;
         lastNeu := 1*volk+1*kons;
         konsNeu := 1.1*last-1*tun;
         tunNeu  := C*last;
         volk := volkNeu;
         last := lastNeu;
         kons := konsNeu;
         tun  := tunNeu;
      end;
      readln;
      closeGraph;
      writeln ('noch mal? (j/n)');
      readln (antwort);
      if (antwort='n') or (antwort='N') then
         weiter := false;
      end;
end.