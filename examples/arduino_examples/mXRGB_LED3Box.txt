//Third Edition RGB LED BOX ***************************************
//Binary sketch size: 1944 bytes (of a 32256 byte maximum)
//Sketch uses 3,162 bytes (9%) of program storage space. Maximum is 32,256 bytes.
//Global variables use 195 bytes (9%) of dynamic memory, leaving 1,853 bytes for local variables. Maximum is 2,048 bytes.
//Build options changed, rebuilding all

/*
  Blink Switch LEDMAX___WebofThings3
  Turns on an RGB LED on for one second, then off for one second, repeatedly.
  Switch on Analog and Digital Write
 
  This example code of maXbox is in the public domain.
  Script: 443_webserver_arduino_rgb_light4.txt
 */
 
  int ledPin11 = 11;   //RED
  int ledPin12 = 12;
  int ledPin13 = 13;
  int ledPin6Spec = 6;
  
  int counter =0;
  int change = 1;
  int val = 0;       // variable to store the data from serial port
  bool analog = false;
  int sensorValue = 0;        // value read from the pot
  int outputValue = 0;        // value output to the PWM (analog out)
   

void setup() {                
  // initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards:
 
 Serial.begin(9600);  
  //pinMode(ledPin1, OUTPUT);     
  pinMode(ledPin11, OUTPUT);     
  pinMode(ledPin12, OUTPUT);     
  pinMode(ledPin13, OUTPUT);     
  pinMode(ledPin6Spec, OUTPUT);     
}

int changeCounter() {
  if (counter ==255)
       change=-1;
  if (counter ==0)
       change= 1;
  counter = counter + change;
return counter;
}
       
void ledmax(){
  digitalWrite(ledPin11, HIGH);   // set the LED on
  delay(500);              // wait for a second
  digitalWrite(ledPin11, LOW);    // set the LED off
  delay(500);              // wait for a second
  digitalWrite(ledPin11, HIGH);   // set the LED on
  delay(500);              // wait for a second
  digitalWrite(ledPin11, LOW);    // set the LED off
  delay(500);              // wait for a second
 }

void loop() {
  //digitalWrite(ledPin1, HIGH);   // set the LED on
  //delay(4000);              // wait for a second
  //digitalWrite(ledPin1, LOW);    // set the LED off
  //delay(1000);              // wait for a second

val = Serial.read();      // read the serial port
 if (val==255) analog=true; 
 if (val==254) {
     analog=false; 
     analogWrite(ledPin11, 0);
     }
  if (val !=-1){
    if (analog) {
    //outputValue = map(sensorValue, 0, 1023, 0, 255); //prepare poti
     outputValue = map(val, 1, 252, 0, 255); //prepare test
     analogWrite(ledPin11, outputValue);
      //analogWrite(ledPin11, val);
      //Serial.write(outputValue);
      Serial.write(val);
      // wait 2 milliseconds before the next loop for the 
      //analog-to-digital converter to settle after the last reading:
      delay(2);
      }
   if (not analog) {  
    if (val=='1'){
      digitalWrite(ledPin11,HIGH);
    }
    else if (val=='A'){
      digitalWrite(ledPin11,LOW);
      }
    if (val=='2'){
      digitalWrite(ledPin12,HIGH);
    }
    else if (val=='B'){
      digitalWrite(ledPin12,LOW);
      }
    if (val=='3'){
      digitalWrite(ledPin13,HIGH);
    }
    else if (val=='C'){
      digitalWrite(ledPin13,LOW);
      }
    if (val=='4'){
      digitalWrite(ledPin6Spec,HIGH);
    }
    else if (val=='D'){
      digitalWrite(ledPin6Spec,LOW);
      }
     Serial.write(val);

   }
   //Serial.write('X');
   //Serial.write(val);
  }
  //counter = changeCounter();
  //analogWrite(ledPin2, counter);
  //delay(10);
  //ledmax();
  // digitalWrite(13, HIGH);    // set the LED off
  //delay(100);              // wait for a second
 //digitalWrite(13, LOW);    // set the LED off
  //delay(100);              // wait for a second
  // digitalWrite(13, LOW);    // set the LED off
  //delay(1000);              // wait for a second
}

//all colors test routine in Rainbow loop on client site!

