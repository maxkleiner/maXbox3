program weltcont;    (* H.Bossel: Modellbildung und Simulation 910503 *)
uses crt,graph;
var
   volk,last,kons,tun,volkRate,lastRate,konsRate,tunRate,C,dt,t:real;
   antwort: string;
   weiter: boolean;
   graphDriver,graphMode: integer;
   sx,sy,xnull,ynull: integer;
   xscale,yscale: real;
begin
   weiter := true;
   while (weiter) do
   begin
      clrscr;
      writeln ('DYNAMIK EINES KONTINUIERLICHEN MINI-WELTMODELLS');
      writeln;
      writeln ('Eingriffsparameter C (1.1)');
      readln (C);
      graphDriver := detect;
      initGraph (graphDriver, graphMode, '');
      sx := (getMaxX+1) div 100;
      sy := (getMaxY+1) div 100;
      xnull := round(0*sx);
      ynull := round(50*sy);
      line (xnull+round(100*sx),ynull,xnull,ynull);
      moveTo(xnull,ynull);
      xscale := 1;
      yscale := 5;
      t := 0;
      dt := 0.02;
      volk := 1;
      last := 1;
      kons := 1;
      while t<100 do
      begin
         t := t+dt;
         lineTo (round(t*xscale*sx), round(ynull-last*yscale));
         volkRate := (-0.1-0.1*C)*last+0.3*kons;
         lastRate := +1*volk+1*kons;
         konsRate := (1.1-C)*last;
         volk := volk+volkRate*dt;
         last := last+lastRate*dt;
         kons := kons+konsRate*dt;
      end;
      readln;
      closeGraph;
      writeln ('noch mal? (j/n)');
      readln (antwort);
      if (antwort='n') or (antwort='N') then
         weiter := false;
   end;
end.