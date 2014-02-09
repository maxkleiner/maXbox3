
void init_i2c_lauflicht(void)
{
   init_i2c();
}


void i2c_lauflicht(void)
{
  #define I2C_ADDR_PCF8574  0x20 // 0100000x (PCF8574)
  static unsigned char value = 0x01;
  
  SM_ENTRY(0);

  SM_DURATION(200);
     send_i2c(I2C_ADDR_PCF8574, ~value);
     value <<= 1;
     if(value == 0)
     {
        value = 0x01;
     }
  SM_END;
  
  SM_EXIT;
}

