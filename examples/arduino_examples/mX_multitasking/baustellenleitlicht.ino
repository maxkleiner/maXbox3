#define LED_BS1 0
#define LED_BS1_AUS digitalWrite(LED_BS1, LOW)
#define LED_BS1_EIN digitalWrite(LED_BS1, HIGH)
#define LED_BS1_DIR_OUT pinMode(LED_BS1, OUTPUT)

#define LED_BS2 1
#define LED_BS2_AUS digitalWrite(LED_BS2, LOW)
#define LED_BS2_EIN digitalWrite(LED_BS2, HIGH)
#define LED_BS2_DIR_OUT pinMode(LED_BS2, OUTPUT)

#define LED_BS3 2
#define LED_BS3_AUS digitalWrite(LED_BS3, LOW)
#define LED_BS3_EIN digitalWrite(LED_BS3, HIGH)
#define LED_BS3_DIR_OUT pinMode(LED_BS3, OUTPUT)

#define LED_BS4 3
#define LED_BS4_AUS digitalWrite(LED_BS4, LOW)
#define LED_BS4_EIN digitalWrite(LED_BS4, HIGH)
#define LED_BS4_DIR_OUT pinMode(LED_BS4, OUTPUT)

#define LED_BS5 4
#define LED_BS5_AUS digitalWrite(LED_BS5, LOW)
#define LED_BS5_EIN digitalWrite(LED_BS5, HIGH)
#define LED_BS5_DIR_OUT pinMode(LED_BS5, OUTPUT)

#define LED_BS6 5
#define LED_BS6_AUS digitalWrite(LED_BS6, LOW)
#define LED_BS6_EIN digitalWrite(LED_BS6, HIGH)
#define LED_BS6_DIR_OUT pinMode(LED_BS6, OUTPUT)

#define LED_BS7 6
#define LED_BS7_AUS digitalWrite(LED_BS7, LOW)
#define LED_BS7_EIN digitalWrite(LED_BS7, HIGH)
#define LED_BS7_DIR_OUT pinMode(LED_BS7, OUTPUT)

#define LED_BS8 7
#define LED_BS8_AUS digitalWrite(LED_BS8, LOW)
#define LED_BS8_EIN digitalWrite(LED_BS8, HIGH)
#define LED_BS8_DIR_OUT pinMode(LED_BS8, OUTPUT)


void init_baustellen_leitlicht(void)
{
  LED_BS1_AUS;
  LED_BS1_DIR_OUT;
  LED_BS2_AUS;
  LED_BS2_DIR_OUT;
  LED_BS3_AUS;
  LED_BS3_DIR_OUT;
  LED_BS4_AUS;
  LED_BS4_DIR_OUT;
  LED_BS5_AUS;
  LED_BS5_DIR_OUT;
  LED_BS6_AUS;
  LED_BS6_DIR_OUT;
  LED_BS7_AUS;
  LED_BS7_DIR_OUT;
  LED_BS8_AUS;
  LED_BS8_DIR_OUT;
}


void baustellen_leitlicht(void)
{
  SM_ENTRY(0);

  SM_DURATION(150);
     LED_BS1_EIN;
  SM_END;

  SM_DURATION(150);
     LED_BS2_EIN;
  SM_END;

  SM_DURATION(150);
     LED_BS3_EIN;
  SM_END;

  SM_DURATION(150);
     LED_BS4_EIN;
  SM_END;

  SM_DURATION(150);
     LED_BS5_EIN;
  SM_END;

  SM_DURATION(150);
     LED_BS6_EIN;
  SM_END;

  SM_DURATION(150);
     LED_BS7_EIN;
  SM_END;

  SM_DURATION(1000);
     LED_BS8_EIN;
  SM_END;

  SM_DURATION(150);
     LED_BS1_AUS;
     LED_BS2_AUS;
     LED_BS3_AUS;
     LED_BS4_AUS;
     LED_BS5_AUS;
     LED_BS6_AUS;
     LED_BS7_AUS;
     LED_BS8_AUS;
  SM_END;
  
  SM_EXIT;
}

