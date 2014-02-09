void Wall(){
  digitalWrite (LowerLayer, HIGH);
  digitalWrite (MiddleLayer, HIGH);
  digitalWrite (UpperLayer, HIGH);

  digitalWrite (Tower[1], HIGH);
  digitalWrite (Tower[4], HIGH);
  digitalWrite (Tower[7], HIGH);
  delay(200);

  digitalWrite (Tower[2], HIGH);
  digitalWrite (Tower[5], HIGH);
  digitalWrite (Tower[8], HIGH);
  delay (70);

  digitalWrite (Tower[1], LOW);
  digitalWrite (Tower[4], LOW);
  digitalWrite (Tower[7], LOW);
  delay (200);

  digitalWrite (Tower[3], HIGH);
  digitalWrite (Tower[6], HIGH);
  digitalWrite (Tower[9], HIGH);
  delay(70);

  digitalWrite (Tower[2], LOW);
  digitalWrite (Tower[5], LOW);
  digitalWrite (Tower[8], LOW);
  delay (200);

  digitalWrite (Tower[2], HIGH);
  digitalWrite (Tower[5], HIGH);
  digitalWrite (Tower[8], HIGH);
  delay(70);

  digitalWrite (Tower[3], LOW);
  digitalWrite (Tower[6], LOW);
  digitalWrite (Tower[9], LOW);
  delay (200);

  digitalWrite (Tower[1], HIGH);
  digitalWrite (Tower[4], HIGH);
  digitalWrite (Tower[7], HIGH);
  delay(70);

  digitalWrite (Tower[2], LOW);
  digitalWrite (Tower[5], LOW);
  digitalWrite (Tower[8], LOW);
  digitalWrite (Tower[1], LOW);
  digitalWrite (Tower[4], LOW);
  digitalWrite (Tower[7], LOW);
  digitalWrite (LowerLayer, LOW);
  digitalWrite (MiddleLayer, LOW);
  digitalWrite (UpperLayer, LOW);
}



