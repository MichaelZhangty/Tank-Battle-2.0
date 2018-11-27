class Body {

  int x;
  int y;
  color R;
  color G;
  color B;
  int intialDirection;
  int direction1, direction2, direction3, direction4; // up, down, left, right
  int j; //to remember the direction of the tank
  int tankOwner;

  Body (int _x, int _y, color _R, color _G, color _B, int _intialDirection, int _tankOwner) {
    x = _x;
    y = _y;
    R = _R;
    G = _G;
    B = _B;
    intialDirection = _intialDirection;
    tankOwner = _tankOwner;
  }

  void drawBody() { //basic image of body
    rectMode(CENTER);
    fill(R, G, B);
    stroke(255);
    strokeWeight(1);
    rect(0, 0, 30, 30);
    rect(0-19, 0, 8, 50);
    rect(0+19, 0, 8, 50);
    for (int r=0-25; r<=0+25; r+=5 ) {
      line(0+15, r, 0+23, r);
      line(0-15, r, 0-23, r);
    }
  }
  void moveBody() {
    if (j == 1) {
      pushMatrix();
      translate(x, y); // translate to x and y
      drawBody(); // draw the tank at YAxis
      popMatrix();
      if (direction1==1) {
        y-=tSpeed;
        if (y-25<=90) {
          y = 90+25;
        }
      }
      // move the tank up by y
    } else if (j == 2) {
      pushMatrix();
      translate(x, y); // translate to x and y
      drawBody(); // draw the tank at YAxis
      popMatrix();
      if (direction2==1) {
        y+=tSpeed;
        if ( y+25>=750) {
          y = 750-25;
        }
      }
    } else if (j == 3) {
      pushMatrix();
      translate(x, y); // translate to x and y
      rotate(radians(90));// rotate 90
      drawBody(); // draw the tank looking at XAxis
      popMatrix();
      if (direction3==1) {
        x-=tSpeed;
        if (x-25<=370) {
          x = 370+25;
        }
      }
    } else if (j == 4) {
      pushMatrix();
      translate(x, y); // translate to x and y
      rotate(radians(90));// rotate 90
      drawBody(); // draw the tank looking at XAxis
      popMatrix();
      if (direction4==1) {
        x+=tSpeed;
        if (x+25>=1030) {
          x = 1030-25;
        }
      }
    }
  }
}