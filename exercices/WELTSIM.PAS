program weltsim;    (* H.Bossel: Modellbildung und Simulation 910512 *)
uses crt,graph,scrcopy;
var
   volk,last,kons,tun,volkRate,lastRate,konsRate,tunRate,f,g,dt,t:real;
   qual,abbau,a,b,c,d,e,final: real;
   antwort,volkstr,laststr,konsstr,fstr,gstr,finstr: string;
   weiter,drucken,PrinterOK: boolean;
   graphDriver,graphMode: integer;
   sx,sy,xnull,ynull: integer;
   xscale,yscale: real;
begin
   weiter := true;
   while (weiter) do
   begin
      clrscr;
      writeln ('DYNAMIK EINES NICHTLINEAREN MINI-WELTMODELLS');
      writeln;
      writeln ('Eingriffsparameter g (1)');
      readln (g);
      writeln ('Eingriffsparameter f (0.1)');
      readln (f);
      writeln ('Zeitraum [Jahre] (200)');
      readln (final);
      graphDriver := detect;
      initGraph (graphDriver, graphMode, '');
      sx := (getMaxX+1) div 100;
      sy := (getMaxY+1) div 100;
      xnull := round(0*sx);              {Nullpunkt}
      ynull := round(90*sy);
      line (xnull+round(100*sx),ynull,xnull,ynull);
      moveTo(xnull,ynull);
      xscale := 100/final;               {Skalierung}
      yscale := 20;
      t := 0;                            {Parameter}
      a := 0.1;  b := 0.03;  c := 0.05;  d := 0.01;  e := 0.02;
      dt := 0.2;
      volk := 1;                         {Anfangswerte}
      last := 1;
      kons := 1;
      while t<final do                   {Zeitschleife-Beginn}
      begin
         t := t+dt;
         lineTo (round(t*xscale*sx), round(ynull-last*yscale));
         circle (round(t*xscale*sx), round(ynull-volk*yscale),1);
         circle (round(t*xscale*sx), round(ynull-kons*yscale),3);
         moveTo (round(t*xscale*sx), round(ynull-last*yscale));
         qual := 1/last;
         volkRate := b*volk*g*qual*kons - d*volk*last;
         if qual>=1 then                 {Zustandsgleichungen (Raten)}
            abbau := a*last else
            abbau := a*last*qual;
         lastRate := e*kons*volk - abbau;
         konsRate := c*kons*last*(1-(kons*last*f));
         volk := volk+volkRate*dt;       {numerische Integration}
         last := last+lastRate*dt;
         kons := kons+konsRate*dt;
         if (volk+last+kons)>1000 then t:=final;
      end;
      str(volk:6:3,volkstr); str(last:6:3,laststr); str(kons:6:3,konsstr);
      str(g:3:2,gstr); str(f:3:2,fstr); str(final:5:0,finstr);
      OutTextXY (xnull, ynull+10,'volk = '+volkstr+',  last = '+laststr+',  kons = '+konsstr);
      OutTextXY (xnull, ynull+20,'g = '+gstr+',  f = '+fstr+',  Zeitraum = '+finstr);
      if drucken=true then graf24(40,3,3,PrinterOK);
      readln;
      closeGraph;
      writeln ('noch mal? (j/n)');
      readln (antwort);
      if (antwort='n') or (antwort='N') then
         weiter := false;
      writeln ('drucken? (j/n)');
      readln (antwort);
      if (antwort='n') or (antwort='N') then
         drucken := false
         else drucken := true;
   end;
end.