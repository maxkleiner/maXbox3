#define LED_AK1 11
#define LED_AK1_AUS digitalWrite(LED_AK1, LOW)
#define LED_AK1_EIN digitalWrite(LED_AK1, HIGH)
#define LED_AK1_DIR_OUT pinMode(LED_AK1, OUTPUT)

#define LED_AK2 12
#define LED_AK2_AUS digitalWrite(LED_AK2, LOW)
#define LED_AK2_EIN digitalWrite(LED_AK2, HIGH)
#define LED_AK2_DIR_OUT pinMode(LED_AK2, OUTPUT)

#define AK_KONTAKT A3
#define AK_KONTAKT_AKTIV (digitalRead(AK_KONTAKT) == LOW)
#define AK_PULLUP digitalWrite(AK_KONTAKT, HIGH)


void init_andreaskreuz(void)
{
  AK_PULLUP;
  LED_AK1_AUS;
  LED_AK1_DIR_OUT;
  LED_AK2_AUS;
  LED_AK2_DIR_OUT;
}


void andreaskreuz(void)
{ // Nachdem der Auslösekontakt betätigt wurde, sollen die beiden Andreaskreuz-Blinkleuchten jeweils 10-mal wechselseitig blinken.

  static unsigned char repeat = 0;                 // Variable für Wiederholzähler
  
  SM_ENTRY(0);

  // Zustand 0
  SM_DURATION(10);                                 // Auslösekontakt alle 10 ms prüfen
     LED_AK2_AUS;
     LED_AK1_AUS;
     SM_CONDITION(0, AK_KONTAKT_AKTIV);            // Auslösekontakt prüfen
        // Bedingung true => Code bis SM_END ausführen und zum nächsten Zustand wechseln (Angabe bei SM_CONDITION: 0 ms, d.h. im nächsten ms-Tick)
        repeat = 10-1;                             // Auslösekontakt aktiv => Wiederholungszähler setzen und zum nächsten Zustand wechseln
     SM_END;
     // Bedingung false => optionaler Code...      // Auslösekontakt inaktiv => der Zustand wird nach 10 ms (Angabe bei SM_DURATION) erneut ausgeführt
  SM_END;

  // Zustand 1
  SM_DURATION(500); // AK1: ein AK2: aus
     LED_AK2_AUS;
     LED_AK1_EIN;
  SM_END;
  
  // Zustand 2  
  SM_DURATION(500); // AK1: aus AK2: ein
     LED_AK1_AUS;
     LED_AK2_EIN;
     if(repeat)           // Wiederholzähler prüfen und ggf. dekrementieren
     {
        repeat--;
        SM_SET_STATE(1);  // Springe zu Zustand 1 (alternativ wäre auch SM_SET_STATE_RELATIVE(-1); möglich)
        if(AK_KONTAKT_AKTIV)
        {
           repeat = 10-1; // wenn Auslösekontakt noch aktiv, dann Wiederholzähler neu triggern
        }
     }
  SM_END;

  SM_EXIT;
}

