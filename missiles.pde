class Missiles {

  int x, y; // where the bullets come out
  int d;// the diameter of the bullet  
  int  tankOwner;//whose bullets are they
  color Color;// the color of the bullet
  //boolean explosion;
  //int xExplosion, yExplosion;
  int counter;//counter for hit margin
  int counter2;//counter for hit another tank
  boolean test = false;//testHit
  float r, R;//for anctangent
  float radianX, radianY;
  int direction1, direction2, direction3, direction4;// up, down, left, right
  int j; //to remember the location of the missile


  Missiles(int _x, int _y, int _tankOwner, float _radianX, float _radianY) {
    x = _x;
    y = _y;
    d = 6;
    tankOwner = _tankOwner;
    counter = 10;
    counter2 = 10;
    radianX = _radianX;
    radianY = _radianY;
  }

  void drawMissiles () {
    imageMode(CENTER);
    image(missile, 0, 0, 30, 30);
  }

  void moveMissiles () {
    pushMatrix();
    translate(x, y);
    imageMode(CENTER);
    if (x>1030 || x <370 || y<90 || y>750) {// out the battlefield - hit the bounder
      counter--;
      if (counter>=0) {
        image(explosion, 0, 0, 20, 20);
      } else {
        counter = -1;
      }
    } else {//in the battlefield
      rotateAndMoveMissiles();
    }
    popMatrix();
  }

  void rotateAndMoveMissiles() {
    if (tankOwner ==1) {
      if (turret1.radianX>=0 && turret1.radianY>=0) {
        R = atan(turret1.radianX/turret1.radianY);
        rotate(R);
        drawMissiles();
        x += sin(R)*bSpeed;
        y -= cos(R)*bSpeed;
      } else if (turret1.radianX>=0 && turret1.radianY <=0) {
        R = atan(turret1.radianX/(-turret1.radianY));
        rotate(PI-R);
        drawMissiles();
        x += sin(R)*bSpeed;
        y += cos(R)*bSpeed;
      } else if (turret1.radianX<=0 && turret1.radianY<=0) {
        R = atan((-turret1.radianX)/(-turret1.radianY));
        rotate(PI+R);
        drawMissiles();
        x -= sin(R)*bSpeed;
        y += cos(R)*bSpeed;
      } else if (turret1.radianX<=0 && turret1.radianY>=0) {
        R = atan((-turret1.radianX)/turret1.radianY);
        rotate(2*PI-R);
        drawMissiles();
        x -= sin(R)*bSpeed;
        y -= cos(R)*bSpeed;
      }
    } else if (tankOwner ==2) {
      if (turret2.radianX>=0 && turret2.radianY>=0) {
        R = atan(turret2.radianX/turret2.radianY);
        rotate(R);
        drawMissiles();
        x += sin(R)*bSpeed;
        y -= cos(R)*bSpeed;
      } else if (turret2.radianX>=0 && turret2.radianY <=0) {
        R = atan(turret2.radianX/(-turret2.radianY));
        rotate(PI-R);
        drawMissiles();
        x += sin(R)*bSpeed;
        y += cos(R)*bSpeed;
      } else if (turret2.radianX<=0 && turret2.radianY<=0) {
        R = atan((-turret2.radianX)/(-turret2.radianY));
        rotate(PI+R);
        drawMissiles();
        x -= sin(R)*bSpeed;
        y += cos(R)*bSpeed;
      } else if (turret2.radianX<=0 && turret2.radianY>=0) {
        R = atan((-turret2.radianX)/turret2.radianY);
        rotate(2*PI-R);
        drawMissiles();
        x -= sin(R)*bSpeed;
        y -= cos(R)*bSpeed;
      }
    }
  }

  void testHit() {
    if (tankOwner == 1) {//if it's bullet from tank1
      if (x>=body2.x-30 && x<=body2.x+30 && y>=body2.y-30 && y<=body2.y+30) {//hit the tank2
        test = true;
        missileJudge = false;
        counter2 --;
        if (counter2>=0 && test == true) {
          if (counter2==1){        
          score1 = score1+1;
          }
          image(explosion2, body2.x, body2.y, 50, 50);//show explosion for 10 milliseconds
          body2.j=0;
          turret2.j = 5;//body2.y += 0;
        } else if (counter2 <0) {
          body2.x = 700;//reset tank body position
          body2.y = 710;//reset tank body position
          turret2.x = 700;//reset tank turret position
          turret2.y = 710;//reset tank turret position
          counter2 = -1;
          test = false;
          x = 1450;//so that the missiles will disappear
          counter = -1;
        }
      }
    } else if (tankOwner == 2) {// if it's bullet from tank2
      if (x>=body1.x-30 && x<=body1.x+30 && y>=body1.y-30 && y<=body1.y+30) {//hit the tank2
        test = true;
        missileJudge2 = false;
        counter2 --;
        if (counter2>=0 && test == true) {
          if (counter2==1) {
            score2 = score2+1;
          }
          image(explosion2, body1.x, body1.y, 50, 50);//show explosion for 10 milliseconds
          body1.j=0;
          turret1.j = 5;//body2.y += 0;
        } else if (counter2 <0) {
          body1.x = 700;//reset tank body position
          body1.y = 130;//reset tank body position
          turret1.x = 700;//reset tank turret position
          turret1.y = 130;//reset tank turret position
          counter2 = -1;
          test = false;
          x = 1450;//so that the missiles will disappear
          counter = -1;
        }
      }
    }
  }
}