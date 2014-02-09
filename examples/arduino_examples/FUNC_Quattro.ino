void Quattro(){
  //--------One Cube-------- 
  digitalWrite (Tower[1], HIGH);
  digitalWrite (Tower[2], HIGH);
  digitalWrite (Tower[4], HIGH);
  digitalWrite (Tower[5], HIGH);
  
  digitalWrite (LowerLayer, HIGH);
  digitalWrite (MiddleLayer, HIGH);
  delay(500);

//------------------------
 
  digitalWrite (Tower[1], LOW);
  digitalWrite (Tower[2], LOW);
  digitalWrite (Tower[4], LOW);
  digitalWrite (Tower[5], LOW);
  
  digitalWrite (LowerLayer, LOW);
  digitalWrite (MiddleLayer, LOW);
  delay(500);
  
//------------------------

  digitalWrite (Tower[5], HIGH);
  digitalWrite (Tower[6], HIGH);
  digitalWrite (Tower[8], HIGH);
  digitalWrite (Tower[9], HIGH);
  
  digitalWrite (LowerLayer, HIGH);
  digitalWrite (MiddleLayer, HIGH);
  delay(500);
  
//------------------------

  digitalWrite (Tower[5], LOW);
  digitalWrite (Tower[6], LOW);
  digitalWrite (Tower[8], LOW);
  digitalWrite (Tower[9], LOW);
  
  digitalWrite (LowerLayer, LOW);
  digitalWrite (MiddleLayer, LOW);
  delay(500);
  
//------------------------

  digitalWrite (Tower[4], HIGH);
  digitalWrite (Tower[5], HIGH);
  digitalWrite (Tower[7], HIGH);
  digitalWrite (Tower[8], HIGH);
  
  digitalWrite (MiddleLayer, HIGH);
  digitalWrite (UpperLayer, HIGH);
  delay(500);
  
//------------------------

  digitalWrite (Tower[4], LOW);
  digitalWrite (Tower[5], LOW);
  digitalWrite (Tower[7], LOW);
  digitalWrite (Tower[8], LOW);
  
  digitalWrite (MiddleLayer, LOW);
  digitalWrite (UpperLayer, LOW);
  delay(500);
  
//------------------------

  digitalWrite (Tower[2], HIGH);
  digitalWrite (Tower[3], HIGH);
  digitalWrite (Tower[5], HIGH);
  digitalWrite (Tower[6], HIGH);
  
  digitalWrite (MiddleLayer, HIGH);
  digitalWrite (UpperLayer, HIGH);
  delay(500);
  
//------------------------

  digitalWrite (Tower[2], LOW);
  digitalWrite (Tower[3], LOW);
  digitalWrite (Tower[5], LOW);
  digitalWrite (Tower[6], LOW);
  
  digitalWrite (MiddleLayer, LOW);
  digitalWrite (UpperLayer, LOW);
  delay(500);
  
//------------------------
}
