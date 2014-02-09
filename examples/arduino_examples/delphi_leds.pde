/*
 * Delphi LEDs Control
 * -----------------
 * Turns on and off 5 light emitting diodes(LED) connected to digital  
 * pins 2 thru 6. The LEDs will be controlled using check boxes on Delphi
 * that sends serial data to Arduino Board.
 *
 * IMPORTANT!!: Don't forget to download the Delphi PC Example that controls the leds connected to arduino board.
 *
 * Created April 02 2009
 * copyleft 2009 Roberto Ramirez <beta@thepenguincult.com>
 * Full Source code at http://www.thepenguincult.com/proyectos/arduino-delphi-control/
 * 
 */

int val = 0;       // variable to store the data from the serial port
int ledPin1 = 2;   // LED connected to digital pin 2
int ledPin2 = 3;   // LED connected to digital pin 3
int ledPin3 = 4;   // LED connected to digital pin 4
int ledPin4 = 5;   // LED connected to digital pin 5
int ledPin5 = 6;   // LED connected to digital pin 6

void setup() {

  pinMode(ledPin1,OUTPUT);    // declare the LED's pin as output
  pinMode(ledPin2,OUTPUT);    // declare the LED's pin as output
  pinMode(ledPin3,OUTPUT);    // declare the LED's pin as output
  pinMode(ledPin4,OUTPUT);    // declare the LED's pin as output
  pinMode(ledPin5,OUTPUT);    // declare the LED's pin as output


  
  Serial.begin(9600);        // connect to the serial port
}

void loop () {
  val = Serial.read();      // read the serial port

  
  if (val !=-1){

    if (val=='1'){
      digitalWrite(ledPin1,HIGH);
    }
    
    else if (val=='A'){
      digitalWrite(ledPin1,LOW);
      }
    
    if (val=='2'){
      digitalWrite(ledPin2,HIGH);
    }

    else if (val=='B'){
      digitalWrite(ledPin2,LOW);
      }

    if (val=='3'){
      digitalWrite(ledPin3,HIGH);
    }

    else if (val=='C'){
      digitalWrite(ledPin3,LOW);
      }

    if (val=='4'){
      digitalWrite(ledPin4,HIGH);
    }

    else if (val=='D'){
      digitalWrite(ledPin4,LOW);
      }

    if (val=='5'){
      digitalWrite(ledPin5,HIGH);
    }

    else if (val=='E'){
      digitalWrite(ledPin5,LOW);
      }
   
    //Serial.println();
  }
}
