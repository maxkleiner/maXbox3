#include <Wire.h>

void init_i2c(void)
{
  Wire.begin(); // join i2c bus (address optional for master)
}


void send_i2c(unsigned char address, unsigned char value)
{
  Wire.beginTransmission(address); // transmit to device address
  Wire.write(value);               // sends one byte  
  Wire.endTransmission();          // stop transmitting
}


