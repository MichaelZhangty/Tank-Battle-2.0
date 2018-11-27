class Turret {

  int x;
  int y;
  color R;
  color G;
  color B;
  int intialDirection;
  int direction1, direction2, direction3, direction4;// up, down, left, right
  int j; //to remember the location of the tank
  float radianX, radianY;//the location of the joystick
  float r;//the arctangent calculated by "radianX/radianY"
  int tankOwner;//which tank it is
  int bulletFire = 0;
  int missileFire = 0;
  int number;

  Turret(int _x, int _y, color _R, color _G, color _B, int _intialDirection, int _tankOwner,int _number) {
    x = _x;
    y = _y;
    R = _R;
    G = _G;
    B = _B;
    intialDirection = _intialDirection;
    tankOwner = _tankOwner;
    number = _number;
  }

  void drawTurret() { //basic image of turret
    rectMode(CENTER);
    stroke(255);
    strokeWeight(1);
    fill(R, G, B);
    rect(0, 0-15, 6, 30);//the turret tube
    ellipse(0, 0, 30, 30);
  }

  void moveTurret() {// combine all teh functions about turret
    //move the turret by pushbuttons 
    //rotate the turret by joystick
    //fire by pressing Z and C
    if (j == 1||j==0) {
      pushMatrix();
      translate(x, y);
      rotateTurret();
      popMatrix();
      if (direction1 == 1) {
        y-=tSpeed;
        if (y-25<=90) {
          y = 90+25;
        }
      }
      // move the tank up by y
    } else if (j == 2||j==0) {
      pushMatrix();
      translate(x, y);
      rotateTurret();
      popMatrix();
      if (direction2 ==1) {
        y+=tSpeed;
        if ( y+25>=750) {
          y = 750-25;
        }
      }
    } else if (j ==3||j==0) {
      pushMatrix();
      translate(x, y);
      rotateTurret();
      popMatrix(); 
      if (direction3 ==1) {
        x-=tSpeed;
        if (x-25<=370) {
          x = 370+25;
        }
      }
    } else if (j == 4||j==0) {
      pushMatrix();
      translate(x, y);
      rotateTurret();
      popMatrix(); 
      if (direction4 ==1) {
        x+=tSpeed;
        if (x+25>=1030) {
          x = 1030-25;
        }
      }
    }
  }

  void rotateTurret() {//rotate according to the value of joystick
    if (radianX>0 && radianY>0) {
      r = atan(radianX/radianY);
      rotate(r);
    } else if (radianX>0 && radianY <0) {
      r = atan(radianX/(-radianY));
      rotate(PI-r);
    } else if (radianX<0 && radianY<0) {
      r = atan((-radianX)/(-radianY));
      rotate(PI+r);
    } else if (radianX<0 && radianY>0) {
      r = atan((-radianX)/radianY);
      rotate(2*PI-r);
    }
    drawTurret();
  }
} 