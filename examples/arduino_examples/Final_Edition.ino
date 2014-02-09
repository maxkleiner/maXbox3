/*
 (Tower1)  (Tower2)  (Tower3)    (UpperLayer)
 
 (Tower4)  (Tower5)  (Tower6)    (MiddleLayer)
 
 (Tower7)  (Tower8)  (Tower9)    (LowerLayer)
 
 Turm 1 bis 9 von oben gesehen. Ebene 1 bis 3 von unten startend.
 
 Programmiert von Philipp Bretscher
 */


// 9 Anoden der LEDs
int Tower[] = {
  0, 2, 3, 4, 5, 6, 7, 8, 9, 10};

// 3 Kathodenebenen
int Layer[] = {
  0, 11, 12, 13};

int LowerLayer = 11;                                       //Dient der Namensgebung für einfacheres Programmieren
int MiddleLayer = 12;
int UpperLayer = 13;

  int a;                                                  //a wird als Schleifenvariable verwendet
  int b;                                                  //b wird als Schleifenvariable verwendet
  int c;                                                  //c wird als Schleifenvariable verwendet
  int d;                                                  //d wird als Schleifenvariable verwendet
  int e;                                                  //e wird als Schleifenvariable verwendet
  int f;                                                  //f wird als Schleifenvariable verwendet
  int g;                                                  //g wird als Schleifenvariable verwendet







void setup(){
  Serial.begin(9600);                                      //Serielle Konsole aktivieren





  for (int LEDTower = 0; LEDTower <= 9; LEDTower++) {      //Alle Anoden auf OUTPUT  
    pinMode(Tower[LEDTower], OUTPUT);    
  }

  for (int LEDLayer = 0; LEDLayer <= 3; LEDLayer++) {      //Alle Kathoden auf OUTPUT
    pinMode(Layer[LEDLayer], OUTPUT);   
  }
}





void loop(){

  char data = Serial.read();          //Data besteht also aus acht Bit (Buchstabe, Zeichen, Zahl)




  if (data == 'A') {                  //Führt die Funktion Lauflicht 2 mal aus bei serieller Eingabe 'A'
    for (int a = 0; a < 2; a++){
      Lauflicht();
    }
  }

  else {

    if (data == 'B'){                //Führt die Funktion Lauflicht_1_2 2 mal aus bei serieller Eingabe 'B'
      for (int b = 0; b < 4; b++) {
        Lauflicht_1_2();
      }
    }
  }



  if (data == 'C') {                //Führt die Funktion Quattro 2 mal aus bei serieller Eingabe 'C'
    for (int c = 0; c < 3; c++) {
      Quattro();
    }
  }


  else {
    if (data == 'D') {              //Führt die Funktion Fountain 2 mal aus bei serieller Eingabe 'D'
      for (int d = 0; d < 3; d++) {
        Fountain();
      }
    }
  }



  if (data == 'E') {                //Führt die Funktion Wall 2 mal aus bei serieller Eingabe 'E'
    for (int e = 0; e < 4; e++) {
      Wall();
    }
  }


  else {
    if (data == 'F') {              //Führt die Funktion Wiper 2 mal aus bei serieller Eingabe 'F'
      for (int f = 0; f < 3; f++) {
        Wiper();
      }
    }
  }
}
























