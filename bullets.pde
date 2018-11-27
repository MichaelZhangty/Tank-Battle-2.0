class Bullets {

  int x, y; // where the bullets come out
  int d;// the diameter of the bullet  
  int  tankOwner;//whose bullets are they
  color Color;// the color of the bullet
  //boolean explosion;
  //int xExplosion, yExplosion;
  int counter;//counter for hit margin
  int counter2;//counter for hit another tank
  boolean test = false;//testHit
  float r;//for anctangent
  float radianX, radianY;


  Bullets(int _x, int _y, int _tankOwner, color _Color, float _radianX, float _radianY) {
    x = _x;
    y = _y;
    d = 6;
    tankOwner = _tankOwner;
    Color = _Color;
    counter = 10;
    counter2 = 10;
    radianX = _radianX;
    radianY = _radianY;
  }

  void drawBullets () {
    stroke(150);
    strokeWeight(1);
    fill(Color);
    ellipse(0, 0, d, d);
  }

  void moveBullets () {
    pushMatrix();
    translate(x, y);
    imageMode(CENTER);
    if (radianX>0 && radianY>0) {
      r = atan(radianX/radianY);
      if (x>=1030 || y<=90) {
        counter--;
        if (counter>=0) {
          image(explosion, 0, 0, 20, 20);
        } else {
          counter = -1;
        }
      } else {
        drawBullets();
        x+=sin(r)*bSpeed;
        y-=cos(r)*bSpeed;
      }
    } else if (radianX>0 && radianY<0) {
      r = atan(radianX/-radianY);

      if (x>=1030 ||y>=750) {
        counter--;
        if (counter >=0) {
          image(explosion, 0, 0, 20, 20);
        } else {
          counter = -1;
        }
      } else {
        drawBullets();
        x+=sin(r)*bSpeed;
        y+=cos(r)*bSpeed;
      }
    } else if (radianX<0 && radianY<0) {
      r = atan(-radianX/-radianY);

      if (x<=370 ||y>=750) {
        counter--;
        if (counter >=0) {
          image(explosion, 0, 0, 20, 20);
        } else {
          counter = -1;
        }
      } else {
        drawBullets();
        x-=sin(r)*bSpeed;
        y+=cos(r)*bSpeed;
      }
    } else if (radianX<0 && radianY>0) {
      r = atan(-radianX/radianY);

      if (x<=370 ||y<=90) {
        counter--;
        if (counter >=0) {
          image(explosion, 0, 0, 20, 20);
        } else {
          counter = -1;
        }
      } else {
        drawBullets();
        x-=sin(r)*bSpeed;
        y-=cos(r)*bSpeed;
      }
    }
    popMatrix();
  }

  void testHit() {
    if (tankOwner == 1) {//if it's bullet from tank1
      if (x>=body2.x-25 && x<=body2.x+25 && y>=body2.y-25 && y<=body2.y+25) {//hit the tank2
        test = true;
        counter2 --;
        if (counter2>=0 && test == true) {
          if (counter2==1) {        
            score1 = score1+1;
          }
          image(explosion, body2.x, body2.y, 50, 50);//show explosion for 10 milliseconds
          body2.j=0;
          turret2.j = 5;//body2.y += 0;
        } else if (counter2 <0) {
          body2.x = 700;//reset tank body position
          body2.y = 710;//reset tank body position
          turret2.x = 700;//reset tank turret position
          turret2.y = 710;//reset tank turret position
          counter2 = -1;
          test = false;
          x = 1050;//so that the bullets will disappear
          counter = -1;
        }
      }
    } else if (tankOwner == 2) {// if it's bullet from tank2
      if (x>=body1.x-25 && x<=body1.x+25 && y>=body1.y-25 && y<=body1.y+25) {//hit the tank2
        test = true;
        counter2 --;
        if (counter2>=0 && test == true) {
          if (counter2==1) {        
            score2 = score2+1;
          }
          image(explosion, body1.x, body1.y, 50, 50);//show explosion for 10 milliseconds
          body1.j=0;
          turret1.j = 5;//body2.y += 0;
        } else if (counter2 <0) {
          body1.x = 700;//reset tank body position
          body1.y = 130;//reset tank body position
          turret1.x = 700;//reset tank turret position
          turret1.y = 130;//reset tank turret position
          counter2 = -1;
          test = false;
          x = 1050;//so that the bullets will disappear
          counter = -1;
        }
      }
    }
  }
}