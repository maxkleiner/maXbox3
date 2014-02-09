void Fountain(){
  digitalWrite (Tower[5], HIGH);
  
  digitalWrite (LowerLayer, HIGH);
  delay(400);
  digitalWrite (LowerLayer, LOW);
  
  digitalWrite (MiddleLayer, HIGH);
  delay(400);
  digitalWrite (MiddleLayer, LOW);
  
  digitalWrite (UpperLayer, HIGH);
  delay(400);
  
  digitalWrite (Tower[1], HIGH);
  digitalWrite (Tower[2], HIGH);
  digitalWrite (Tower[3], HIGH);
  digitalWrite (Tower[4], HIGH);
  digitalWrite (Tower[6], HIGH);
  digitalWrite (Tower[7], HIGH);
  digitalWrite (Tower[8], HIGH);
  digitalWrite (Tower[9], HIGH);
  delay(400);
  digitalWrite (Tower[1], HIGH);
  digitalWrite (Tower[2], HIGH);
  digitalWrite (Tower[3], HIGH);
  digitalWrite (Tower[4], HIGH);
  digitalWrite (Tower[6], HIGH);
  digitalWrite (Tower[7], HIGH);
  digitalWrite (Tower[8], HIGH);
  digitalWrite (Tower[9], HIGH);
  delay(400);
  
  digitalWrite (UpperLayer, LOW);
  digitalWrite (Tower[5], LOW);
  delay(400);
  digitalWrite (MiddleLayer, HIGH);
  delay(400);
  digitalWrite (MiddleLayer, LOW);
  delay(400);
  digitalWrite (LowerLayer, HIGH);
  delay(400);
  digitalWrite (LowerLayer, LOW);
  
  digitalWrite (Tower[1], LOW);
  digitalWrite (Tower[2], LOW);
  digitalWrite (Tower[3], LOW);
  digitalWrite (Tower[4], LOW);
  digitalWrite (Tower[6], LOW);
  digitalWrite (Tower[7], LOW);
  digitalWrite (Tower[8], LOW);
  digitalWrite (Tower[9], LOW);
  
  delay(500);

}
