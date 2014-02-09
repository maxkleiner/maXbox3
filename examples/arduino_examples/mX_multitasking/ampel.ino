#define LED_A1_ROT 10
#define LED_A1_ROT_AUS digitalWrite(LED_A1_ROT, LOW)
#define LED_A1_ROT_EIN digitalWrite(LED_A1_ROT, HIGH)
#define LED_A1_ROT_DIR_OUT pinMode(LED_A1_ROT, OUTPUT)

#define LED_A1_GELB 9
#define LED_A1_GELB_AUS digitalWrite(LED_A1_GELB, LOW)
#define LED_A1_GELB_EIN digitalWrite(LED_A1_GELB, HIGH)
#define LED_A1_GELB_DIR_OUT pinMode(LED_A1_GELB, OUTPUT)

#define LED_A1_GRUEN 8
#define LED_A1_GRUEN_AUS digitalWrite(LED_A1_GRUEN, LOW)
#define LED_A1_GRUEN_EIN digitalWrite(LED_A1_GRUEN, HIGH)
#define LED_A1_GRUEN_DIR_OUT pinMode(LED_A1_GRUEN, OUTPUT)

#define LED_A2_ROT A0
#define LED_A2_ROT_AUS digitalWrite(LED_A2_ROT, LOW)
#define LED_A2_ROT_EIN digitalWrite(LED_A2_ROT, HIGH)
#define LED_A2_ROT_DIR_OUT pinMode(LED_A2_ROT, OUTPUT)

#define LED_A2_GELB A1
#define LED_A2_GELB_AUS digitalWrite(LED_A2_GELB, LOW)
#define LED_A2_GELB_EIN digitalWrite(LED_A2_GELB, HIGH)
#define LED_A2_GELB_DIR_OUT pinMode(LED_A2_GELB, OUTPUT)

#define LED_A2_GRUEN A2
#define LED_A2_GRUEN_AUS digitalWrite(LED_A2_GRUEN, LOW)
#define LED_A2_GRUEN_EIN digitalWrite(LED_A2_GRUEN, HIGH)
#define LED_A2_GRUEN_DIR_OUT pinMode(LED_A2_GRUEN, OUTPUT)


void init_ampel(void)
{
  LED_A1_ROT_EIN;
  LED_A1_ROT_DIR_OUT;
  LED_A1_GELB_AUS;
  LED_A1_GELB_DIR_OUT;
  LED_A1_GRUEN_AUS;
  LED_A1_GRUEN_DIR_OUT;
  LED_A2_ROT_EIN;
  LED_A2_ROT_DIR_OUT;
  LED_A2_GELB_AUS;
  LED_A2_GELB_DIR_OUT;
  LED_A2_GRUEN_AUS;
  LED_A2_GRUEN_DIR_OUT;
}



void ampel(void)
{
  SM_ENTRY(0);
  
  SM_DURATION(3000); // A1: rot A2: rot
     LED_A2_GELB_AUS;
     LED_A2_ROT_EIN;
  SM_END;
  
  SM_DURATION(1000); // A1: rot/gelb A2: rot
     LED_A1_GELB_EIN;
  SM_END;

  SM_DURATION(5000); // A1: grün A2: rot
     LED_A1_ROT_AUS;
     LED_A1_GELB_AUS;
     LED_A1_GRUEN_EIN;
  SM_END;

  SM_DURATION(1000); // A1: gelb A2: rot
     LED_A1_GRUEN_AUS;
     LED_A1_GELB_EIN;
  SM_END;

  SM_DURATION(3000); // A1: rot A2: rot
     LED_A1_GELB_AUS;
     LED_A1_ROT_EIN;
  SM_END;

  SM_DURATION(1000); // A1: rot A2: rot/gelb
     LED_A2_GELB_EIN;
  SM_END;

  SM_DURATION(5000); // A1: rot A2: grün
     LED_A2_ROT_AUS;
     LED_A2_GELB_AUS;
     LED_A2_GRUEN_EIN;
  SM_END;

  SM_DURATION(1000); // A1: rot A2: gelb
     LED_A2_GRUEN_AUS;
     LED_A2_GELB_EIN;
  SM_END;

  SM_EXIT;
}

