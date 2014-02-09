#define LED_BLITZ 13
#define LED_BLITZ_AUS digitalWrite(LED_BLITZ, LOW)
#define LED_BLITZ_EIN digitalWrite(LED_BLITZ, HIGH)
#define LED_BLITZ_DIR_OUT pinMode(LED_BLITZ, OUTPUT)


void init_blitz(void)
{
  LED_BLITZ_AUS;
  LED_BLITZ_DIR_OUT;
}



void blitz(void)
{
  SM_ENTRY(0);
  
  SM_DURATION(100);
     LED_BLITZ_EIN;
  SM_END;
  
  SM_DURATION(900);
     LED_BLITZ_AUS;
  SM_END;

  SM_EXIT;
}

