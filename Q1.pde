/*=========================================================
MICHAEL UKWENYA 7802112
COMP3490 ASSIGNMENT 4
===========================================================*/


PImage bricks;
PImage walls;
PImage ceilling;
PImage exA,exB,exC,exD;

void setup(){
  
  size(800, 640, P3D);
  frustum(-1, 1, 1, -1, 1, 23);
  resetMatrix();
  textureMode(NORMAL);
  bricks = loadImage("Assets/floor2.jpg");
  walls = loadImage("Assets/walls2.jpg");
  ceilling = loadImage("Assets/ceilling.jpg");
  exA = loadImage("Assets/exA.jpg");
  exB = loadImage("Assets/exB.jpg");
  exC = loadImage("Assets/exC.jpg");
  exD = loadImage("Assets/exD.jpg");
  textureWrap(REPEAT);
  noStroke();
}

PVector[] exhibits = new PVector[16];
float currentX = 0.;
float currentZ = -4.5;
float movementX = 0;
float movementZ = 0;
float currentAngle = 0;
float newAngle = 0;
float angle = 0;
float exAngle = 0;
float frwd_bkwdZ = -4.5;
float frwd_bkwdX = 0;
float t = 0;
float tPrime = 0;
float ascend_descend = 0;
float levatate = -.2;
float levatateN = .2;
float floater = 0;
boolean freeLook = false;
boolean leftright = false;
float lookX = 0, lookY = 0, newLookX = 0, newLookY = 0, currentLookX = 0, currentLookY = 0;

void draw(){
 
  clear();
  
  if( freeLook ){
    currentLookX = lookX;
    currentLookY = lookY;
    newLookX = lookX;
    newLookY = lookY;
  }
  else{
    newLookX = 0;
    newLookY = 0;
  }
    
  rotateY(radians(angle));
  if(!leftright){
  rotateX(radians(lookY));
  }
  else{
  rotateZ(radians(lookY));
  }
  rotateY(radians(lookX));
  
  translate(movementX,ascend_descend,movementZ);
    
  drawFloor(); 
  drawWalls();
  drawCeilling();
  DrawExhibits();
  movementX = lerp(currentX, frwd_bkwdX, t);
  movementZ = lerp(currentZ, frwd_bkwdZ, t);
  angle = lerp(currentAngle, newAngle, t);
  floater = lerp(levatate, levatateN, tPrime);
  lookX = lerp(currentLookX, newLookX, tPrime);
  lookY = lerp(currentLookY, newLookY, tPrime);
  
  tPrime += .03;
  if( tPrime > 1){
    tPrime = 0;
     levatate = levatateN;
    levatateN = -levatateN;
    currentLookX = newLookX;
    currentLookY = newLookY;

  }
  
  t += 0.1;
  if( t > 1 ){
    t = 0;
    currentAngle = newAngle;
    currentX = frwd_bkwdX;
    currentZ = frwd_bkwdZ;

   }
  }

void mouseMoved(){
 if(freeLook){
   lookX = ((mouseX/800.)*2 - 1) * 90;
   lookY = (1 - (mouseY/640.)*2) * 90;
   if( newAngle/90%4 == 0 || newAngle/90%4 == 1 ){
     lookY = -lookY;
   }
 }
}

void exhibitA(){
  drawBox(.5,exA);  
}

void exhibitC(){
  drawPyramid(.5,exC);  
}

void exhibitB(){
  drawBox(.5,exB);  
}

void exhibitD(){
  drawPyramid(.5,exD);  
}

void DrawExhibits(){
  
  final float CHEK = 4;
  int counter = 0;
  beginShape(QUADS);
  
  for (float xf = -6; xf < 10; xf += CHEK) {
    for (float zf = -6; zf < 10; zf += CHEK) {
      
      pushMatrix();
      exhibits[counter] = new PVector(xf,-.2,zf);   
      pushMatrix();
      translate(xf,floater*pow(-1,counter),zf);
      rotateY(radians(exAngle+=.1));
      
      switch((int) exp(counter)%4){
        case 0:
        exhibitA();
        break;
        case 1:
        exhibitB();
        break;
        case 2:
        exhibitC();
        break;
        case 3:
        exhibitD();
        break;
      }
      
      popMatrix();
      translate(xf,-.8,zf);
      fill(100, 100, 100);
      box(.5,.4,.5);
      popMatrix();
      counter++; 
    }
  }
  endShape();
}

void drawFloor(){
  final float CHEK = 0.4;
  beginShape(QUADS);
  for (float xf = -10; xf < 10; xf += CHEK) {
    for (float zf = -10; zf < 10; zf += CHEK) {
      texture(bricks);
      vertex(xf, -1, zf,xf,zf);
      vertex(xf + CHEK, -1, zf, xf+CHEK, zf);
      vertex(xf + CHEK, -1, zf + CHEK, xf+CHEK, zf+CHEK);
      vertex(xf, -1, zf + CHEK, xf, zf+CHEK);
    }
  }
  endShape();
}

void drawWalls(){
  
  beginShape(QUAD);
  
  texture(walls);
  vertex(-10,-1,-10,-10,-1);
  vertex(-10,2,-10,-10,2);
  vertex(10,2,-10,10,2);
  vertex(10,-1,-10,10,-1);
  
  texture(walls);
  vertex(-10,-1,10,-10,-1);
  vertex(-10,2,10,-10,2);
  vertex(10,2,10,10,2);
  vertex(10,-1,10,10,-1);
  
  texture(walls);
  vertex(10,-1,-10,-10,-1);
  vertex(10,2,-10,-10,2);
  vertex(10,2,10,10,2);//
  vertex(10,-1,10,10,-1);
 
  texture(walls);
  vertex(-10,-1,-10,-10,-1);
  vertex(-10,2,-10,-10,2);
  vertex(-10,2,10,10,2);
  vertex(-10,-1,10,10,-2);
  endShape();
}

void drawCeilling(){
  beginShape();
  texture(ceilling);
  vertex(-10,2,-10,-10,-10);
  vertex(10,2,-10,10,-10);
  vertex(10,2,10,10,10);
  vertex(-10,2,10,-10,10);
  endShape();
}

boolean exhibitCheck(float x, float z){
  boolean result = true;
  for( int i=0; i<exhibits.length; i++){
    if( dist(x, z, exhibits[i].x, exhibits[i].z) < 1.5 ){
      result = false;
    }
  }
  return result;
}
          

void keyPressed(){
  switch(key){
    case 'w':
      
     if((currentAngle/90)%4 == 0){
       if(frwd_bkwdZ + .4 < 9 &&  exhibitCheck(frwd_bkwdX, frwd_bkwdZ + .4)){ 
        frwd_bkwdZ += .4;
       }
     }
     else if((currentAngle/90)%4 == 1){
      if(frwd_bkwdX - .4 > -9 && exhibitCheck(frwd_bkwdX - .4, frwd_bkwdZ)){
       frwd_bkwdX -= .4;
      }
     }
     else if((currentAngle/90)%4 == 2){
      if(frwd_bkwdZ - .4 > -9 && exhibitCheck(frwd_bkwdX, frwd_bkwdZ - .4)){
       frwd_bkwdZ -= .4;
      }
     }
     else if((currentAngle/90)%4 == 3){
      if(frwd_bkwdX + .4 < 9 &&  exhibitCheck(frwd_bkwdX + .4, frwd_bkwdZ )){
        frwd_bkwdX += .4;
       }
     }
     else if((currentAngle/90)%4 == -1){
     if(frwd_bkwdX + .4 < 9 && exhibitCheck(frwd_bkwdX + .4, frwd_bkwdZ )){
       frwd_bkwdX += .4;
       }
     }
     else if((currentAngle/90)%4 == -2){
       if(frwd_bkwdZ - .4 > -9 && exhibitCheck(frwd_bkwdX, frwd_bkwdZ - .4) ){
       frwd_bkwdZ -= .4;
       }
     }
     else if((currentAngle/90)%4 == -3){
      if(frwd_bkwdX - .4 > -9 && exhibitCheck(frwd_bkwdX - .4, frwd_bkwdZ) ){
       frwd_bkwdX -= .4;
      }
     }
     break;
    case 's':
    if((currentAngle/90)%4 == 0){
   if(frwd_bkwdZ - .4 > -9 && exhibitCheck(frwd_bkwdX, frwd_bkwdZ - .4)){
      frwd_bkwdZ -= .4;
   }
     }
     else if((currentAngle/90)%4 == 1){
      if(frwd_bkwdX + .4 < 9 &&  exhibitCheck(frwd_bkwdX + .4, frwd_bkwdZ)){
       
       frwd_bkwdX += .4;
      }
     }
     else if((currentAngle/90)%4 == 2){
      if(frwd_bkwdZ + .4 < 9 && exhibitCheck(frwd_bkwdX, frwd_bkwdZ + .4) ){
        
       frwd_bkwdZ += .4;
      }
     }
     else if((currentAngle/90)%4 == 3){
       if(frwd_bkwdX - .4 > -9 && exhibitCheck(frwd_bkwdX - .4, frwd_bkwdZ)){
         
       frwd_bkwdX -= .4;
       }
     }
      
     else if((currentAngle/90)%4 == -1){
      if(frwd_bkwdX - .4 > -9 &&  exhibitCheck(frwd_bkwdX - .4, frwd_bkwdZ )){
       
       frwd_bkwdX -= .4;
      }
     }
     else if((currentAngle/90)%4 == -2){
       if(frwd_bkwdZ + .4 < 9 && exhibitCheck(frwd_bkwdX, frwd_bkwdZ + .4)){
         
       frwd_bkwdZ += .4;
       }
     }
     else if((currentAngle/90)%4 == -3){
       if(frwd_bkwdX + .4 < 9 &&  exhibitCheck(frwd_bkwdX + .4, frwd_bkwdZ)){
        
       frwd_bkwdX += .4;
       }
     }
    break;
    case 'a':
    newAngle = currentAngle-90;
    if(newAngle/90%2 != 0 ){
      leftright = true;
      
    }
    else{
      leftright = false;
    }
    freeLook = false;
    break;
    case 'd':
     
    newAngle = currentAngle+90;
    if(newAngle/90%2 != 0 ){
      leftright = true;
    }
    else{
      leftright = false;
    }
    freeLook = false;
    break;
    case 'x':
    ascend_descend += .1;
    break;
    case 'z':
    ascend_descend -= .1;
    break;
    case 'f':
    freeLook = !freeLook;
    break;
  }
}  

 void drawBox(float size, PImage img){
 
  float middle = size/2.;
  beginShape(QUADS);
  
  texture(img);
  vertex(-middle, middle, -middle,-middle, middle);
  vertex(middle, middle, -middle, middle, middle);
  vertex(middle, -middle, -middle, middle, -middle);
  vertex(-middle, -middle, -middle, -middle, -middle);
  
  texture(img);
  vertex(-middle, middle, middle,-middle, middle);
  vertex(middle, middle, middle,middle,middle);
  vertex(middle, -middle, middle,middle,-middle);
  vertex(-middle, -middle, middle,-middle,-middle);
  
  texture(img);
  vertex(-middle, middle, -middle,-middle,-middle);
  vertex(middle, middle, -middle,middle,-middle);
  vertex(middle, middle, middle,middle,middle);
  vertex(-middle, middle, middle,-middle,middle);
  
  texture(img); 
  vertex(-middle, -middle, -middle,-middle,-middle);
  vertex(middle, -middle, -middle,middle,-middle);
  vertex(middle, -middle, middle,middle,middle);
  vertex(-middle, -middle, middle,-middle,middle);
  
  texture(img);
  vertex(-middle, middle, -middle,-middle,middle);
  vertex(-middle, middle, middle,middle,middle);
  vertex(-middle, -middle, middle,middle,-middle);
  vertex(-middle, -middle, -middle,-middle,-middle);
  
  texture(img);
  vertex(middle, middle, -middle,-middle,middle);
  vertex(middle, middle, middle,middle,middle);
  vertex(middle, -middle, middle,middle,-middle);
  vertex(middle, -middle, -middle,-middle,-middle);
  
  endShape();
}

void drawPyramid(float size, PImage img){
  pushMatrix();
  translate(0,.3,0);
  float middle = size/2;
  
  beginShape(TRIANGLE);
  texture(img);
  vertex(0,0,0,0,0);
  vertex(-middle, -size, middle,-middle, middle);
  vertex(middle, -size, middle, middle, middle);
  endShape();
  
  rotateY(radians(90));
  beginShape(TRIANGLE);
  texture(img);
  vertex(0,0,0,0,0);
  vertex(-middle, -size, middle,-middle, middle);
  vertex(middle, -size, middle, middle, middle);
  endShape();
  
  rotateY(radians(90));
  beginShape(TRIANGLE);
  texture(img);
  vertex(0,0,0,0,0);
  vertex(-middle, -size, middle,-middle, middle);
  vertex(middle, -size, middle, middle, middle);
  endShape();
  
  rotateY(radians(90));
  beginShape(TRIANGLE);
  texture(img);
  vertex(0,0,0,0,0);
  vertex(-middle, -size, middle,-middle, middle);
  vertex(middle, -size, middle, middle, middle);
  endShape();
  
  beginShape(QUAD);
  texture(img);
  vertex(-middle,-size, -middle, -middle, -middle);
  vertex(middle, -size, -middle,middle, -middle);
  vertex(middle, -size, middle, middle, middle);
  vertex(-middle, -size, middle, -middle, middle);
  endShape();
  
  popMatrix();
}
