

void init_steuerung(void)
{  // Initialisierung der Tasks, z.B. Portpins als Ausgang konfigurieren.

  init_ampel();
  init_andreaskreuz();
  init_blitz();
  init_baustellen_leitlicht();
  init_i2c_lauflicht();
}


void steuerung(void)
{  // Zyklischer Aufruf der einzelnen Tasks jede Millisekunde, gesteuert per Timerinterrupt.
   // Die hier aufgerufenen Funktionen sollten eine möglichst kurze Laufzeit haben, um das Timing nicht zu blockieren.
   // In der Praxis normalerweise kein Problem, da meist nur einige Portpins umgeschaltet werden müssen.
   
  ampel();
  andreaskreuz();
  blitz();
  baustellen_leitlicht();
  i2c_lauflicht();
}


void setup()
{
  init_steuerung();  // Initialisierung der einzelnen Tasks
  
  init_system();  // Diesen Aufruf nicht entfernen, da er für die Initialisierung der Steuerung unbedingt benötigt wird.
                  // Er sollte ganz am Ende der setup-Funktion stehen.
}


void loop()
{  // Hauptschleife, wird hier nicht benutzt, kann für nicht zeitkritische Dinge verwendet werden.

}

