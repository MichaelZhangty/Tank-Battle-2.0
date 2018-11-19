PImage title, startButton, againButton, explosion, explosion2, missile, heart;
PImage backgroundImage, bulletCount, missileCount, scoreCount, player1, player2, time;
PImage player1Win, player2Win, bothWin;
boolean startJudge = false;//whether i press the start button
boolean endJudge = false;//whether somebody wins
boolean againJudge = false;//whether i press the again button
boolean missileJudge = false;
boolean missileJudge2 = false;
int yAxis;//for initial direction of the body&turret
int tSpeed = 2;//tank speed
float bSpeed = 2.5;//bullet speed
int[] vals;//data from controller1
int[] vals2;//data from controller1
int score1, score2;//score of player1 and player2
int startGame;
int timer;
int minutes;
int seconds;
Body body1, body2;
Turret turret1, turret2;
int counter1 = 0, counter2 = 0, counter3 =0, counter4 =0;
boolean startMusic=false, bodyMusic=false;

ArrayList<Bullets> bullets;
ArrayList<Bullets> bullets2;
ArrayList<Missiles> missiles;
ArrayList<Missiles> missiles2;

import processing.serial.*;
Serial controller1;
Serial controller2;

import processing.sound.*;
SoundFile background;
SoundFile start;
SoundFile bumb;

void setup() {
  size(1400, 840);
  title = loadImage("TANKBATTLE.png");
  startButton = loadImage("STARTBUTTON.png");
  againButton = loadImage("AGAINBUTTON.png");
  explosion = loadImage("explosion.png");
  explosion2 = loadImage("explosion2.png");
  missile = loadImage("missile.png");
  backgroundImage = loadImage("Background.png");
  bulletCount = loadImage("bulletCount.png");
  missileCount = loadImage("missileCount.png");
  scoreCount = loadImage("ScoreCount.png");
  player1 = loadImage("player1.png");
  player2 = loadImage("player2.png");
  heart = loadImage("heart.png");
  time = loadImage("time.png");
  player1Win = loadImage("player1lose.png");
  player2Win = loadImage("player1win.png");
  bothWin = loadImage("youBothWin.png");
  startJudge = false;// means "start" button isn't pressed
  body1 = new Body(700, 130, 229, 186, 9, yAxis, 1);
  body2 = new Body(700, 710, 216, 212, 197, yAxis, 2);
  turret1 = new Turret(700, 130, 229, 186, 9, yAxis, 1, 1);
  turret2 = new Turret(700, 710, 216, 212, 197, yAxis, 2, 1);
  bullets = new ArrayList<Bullets>(1);
  bullets2 = new ArrayList<Bullets>(2);
  missiles = new ArrayList<Missiles>(1);
  missiles2 = new ArrayList<Missiles>(2);
  printArray(Serial.list());
  String portName = Serial.list()[2];
  controller1 = new Serial(this, portName, 19200);
  String portName2 = Serial.list()[1];
  controller2 = new Serial(this, portName2, 9600);
  background = new SoundFile(this, "body.mp3");
  start = new SoundFile(this, "Start.mp3");
  bumb = new SoundFile(this, "bumb.mp3");
}

void draw() {
  background(255);
  if (startJudge == false) {// means "start" button isn't pressed
    if (endJudge == false) {
      startInterface();
      startGame = millis();
      if (startMusic==false) {
        start.play();
        startMusic = true;
      }
    } else if (endJudge == true) {
      endInterface();
    }
  } else if (startJudge == true && endJudge == false) {// means "start" button is pressed
    timer = millis()-startGame;
    timer = timer/1000;
    minutes = timer/60;
    seconds = timer%60;
    print("minutes ");
    print (minutes);
    print("seconds ");
    print (seconds);
    println();
    battleField();
    gameInterface();
    start.stop();
    if (bodyMusic == false) {
      background.play();
      bodyMusic = true;
    }
    if (body1.j == 0) {//before any pushbutton is pressed for tank1
      pushMatrix();
      translate(body1.x, body1.y);
      body1.drawBody();//to draw the body of tank
      popMatrix();      
      turret1.moveTurret();//so that turret can still rotate
    } else {
      body1.moveBody();// to move the body of the tank
      turret1.moveTurret();
    }

    if (body2.j == 0) {//before any pushbutton is pressed for tank2
      pushMatrix();
      translate(body2.x, body2.y);
      body2.drawBody();//to draw the body of tank
      popMatrix();      
      turret2.moveTurret();//so that turret can still rotate
    } else {
      body2.moveBody();// to move the body of the tank
      turret2.moveTurret();
    }
    //get bullets
    for (int i = bullets.size()-1; i >= 0; i--) {
      Bullets b = bullets.get(i);
      b.moveBullets();
      b.testHit();
    }

    for (int q = bullets2.size()-1; q >= 0; q--) {
      Bullets b = bullets2.get(q);
      b.moveBullets();
      b.testHit();
    }
    //get missiles
    for (int k = missiles.size()-1; k >= 0; k--) {
      Missiles m = missiles.get(k);
      m.moveMissiles();
      m.testHit();
    }

    for (int z = missiles2.size()-1; z >= 0; z--) {
      Missiles m = missiles2.get(z);
      m.moveMissiles();
      m.testHit();
    }

    if (controller1.available()>0) {//there's data from controller 1
      String inData = controller1.readStringUntil('n');//first send the data as String
      if (inData != null) {
        inData=trim(inData);//clear up all the blank spaces between datas
        int[] vals = int(split(inData, ','));//split the data into 9 parts
        //println(vals);//print them separately
        // the vals have to be higher than 8...
        if (vals.length>8) {
          body1.direction1 = vals[0];
          body1.direction2 = vals[1];
          body1.direction3 = vals[2];
          body1.direction4 = vals[3];
          turret1.direction1 = vals[0];
          turret1.direction2 = vals[1];
          turret1.direction3 = vals[2];
          turret1.direction4 = vals[3];
          body1.j = vals[4];
          turret1.j = vals[4];
          turret1.radianX = map(vals[5], 30, 240, -1, 1);//map the joystick x location
          turret1.radianY = map(vals[6], 30, 230, -1, 1);//map the joystick y location
          turret1.bulletFire = vals[7];
          turret1.missileFire = vals[8];
        }
      }
    }

    if (controller2.available()>0) {//there's data from controller 2
      String inData2 = controller2.readStringUntil('n');//first send the data as String
      if (inData2 != null) {
        inData2=trim(inData2);//clear up all the blank spaces between datas
        int[] vals2 = int(split(inData2, ','));//split the data into 9 parts
        //println(vals2);//print them separately
        // the vals have to be higher than 8...
        if (vals2.length>8) {
          body2.direction1 = vals2[0];
          body2.direction2 = vals2[1];
          body2.direction3 = vals2[2];
          body2.direction4 = vals2[3];
          turret2.direction1 = vals2[0];
          turret2.direction2 = vals2[1];
          turret2.direction3 = vals2[2];
          turret2.direction4 = vals2[3];
          body2.j = vals2[4];
          turret2.j = vals2[4];
          turret2.radianX = map(vals2[5], 30, 240, -1, 1);//map the joystick x location
          turret2.radianY = map(vals2[6], 30, 230, -1, 1);//map the joystick y location
          turret2.bulletFire = vals2[7];
          turret2.missileFire = vals2[8];
        }
      }
    }
    fire();
    endInterface();
  }
  println(turret1.number, missileJudge, turret2.number, missileJudge2);//to check the number
}

//all the functions

void battleField() {
  //battlefield
  fill(255); //color of background
  rectMode(CENTER);
  rect(width/2, height/2, 700, 700);
  fill(#B4B1B1);//color of margin
  stroke(255);
  strokeWeight(1);
  //margin of battle field
  for (int r1 = 10+350; r1<=700+350; r1+=20) {
    rect(r1, 10+70, 20, 20);
  }
  for (int r2 = 30+70; r2<=700+70; r2+=20) {
    rect(10+350, r2, 20, 20);
  }
  for (int r3 = 10+350; r3<=700+350; r3+=20) {
    rect(r3, 690+70, 20, 20);
  }
  for (int r4 = 30+70; r4<=700+70; r4+=20) {
    rect(690+350, r4, 20, 20);
  }
  //the tank reset position
  fill(#E05F5F);// color of reset spot
  noStroke();
  ellipse(700, 130, 20, 20);
  ellipse(700, 710, 20, 20);
}

void startInterface() {
  imageMode(CENTER);
  image(backgroundImage, width/2, height/2, width, height);
  image(title, 700, 240, 1600, 900);
  image(startButton, 660, 720, startButton.width/6, startButton.height/6);
}

void gameInterface() {
  imageMode(CENTER);
  image(player1, 175, 100, player1.width/2, player1.height/2);
  image(player2, 1400-175, 100, player2.width/2, player2.height/2);
  image(heart, 100, 240, heart.width/14, heart.height/14);
  textSize(35);
  fill(10);
  text(5-score2, 200, 240);
  image(heart, 1150, 240, heart.width/14, heart.height/14);
  textSize(35);
  fill(10);
  text(5-score1, 1250, 240);
  image(bulletCount, 120, 380, bulletCount.width/2, bulletCount.height/2);
  textSize(35);
  fill(10); 
  text("Infinite", 230, 380);
  image(bulletCount, 1170, 380, bulletCount.width/2, bulletCount.height/2);
  textSize(35);
  fill(10); 
  text("Infinite", 1280, 380);
  image(missileCount, 120, 500, missileCount.width/2, missileCount.height/2);
  textSize(35);
  fill(10); 
  text(turret1.number, 230, 500);
  image(missileCount, 1170, 500, missileCount.width/2, missileCount.height/2);
  textSize(35);
  fill(10); 
  text(turret2.number, 1280, 500);
  image(scoreCount, width/2-80, 815, scoreCount.width/2, scoreCount.height/2);
  //scoreCount
  textSize(35);
  fill(10); 
  text(score1, width/2, 815);
  text(":", width/2+43, 815);
  text(score2, width/2+80, 815);
  image(time, width/2-80, 45, time.width/2, time.height/2);
  text(minutes, width/2, 45);
  text(":", width/2+43, 45);
  text(seconds, width/2+80, 45);
}

void endInterface() {
  imageMode(CENTER);
  if (timer <= 300000) {//if within the timer 5 minutes
    if (score1 >= 10) {
      endJudge = true;
      startJudge = false;
      image(player1Win, width/2, height/2, width, height);
      image(againButton, 660, 720, againButton.width/6, againButton.height/6);
    } else if (score2 >= 10) {
      endJudge = true;
      startJudge = false;
      image(player2Win, width/2, height/2, width, height);
      image(againButton, 660, 720, againButton.width/6, againButton.height/6);
    }
  } else {//out of time
    if (score1 >score2) {
      endJudge = true;
      startJudge = false;
      image(player1Win, width/2, height/2, width, height);
      image(againButton, 660, 720, againButton.width/6, againButton.height/6);
    } else if (score1<score2) {
      endJudge = true;
      startJudge = false;
      image(player2Win, width/2, height/2, width, height);
      image(againButton, 660, 720, againButton.width/6, againButton.height/6);
    } else if (score1 == score2) {
      image(bothWin, width/2, height/2, width, height);
      endJudge = true;
      startJudge = false;
    }
  }
}



void fire() {
  //fire bullets
  if (turret1.bulletFire ==1) {
    counter1 --;
    if (counter1 <= 0) {
      bullets.add(new Bullets(turret1.x, turret1.y, 1, 0, turret1.radianX, turret1.radianY));
      counter1 = 20;
    }
  } else {
    counter1 = 0;
  }

  if (turret2.bulletFire ==1) {
    counter2 --;
    if (counter2 <= 0) {
      bullets2.add(new Bullets(turret2.x, turret2.y, 2, 255, turret2.radianX, turret2.radianY));
      counter2 = 20;
    }
  } else {
    counter2 = 0;
  }

  //fire missiles
  if (turret1.missileFire ==1 && turret1.number >=1 && missileJudge == false) {
    missileJudge = true;
    turret1.number = turret1.number -1;
    missiles.add(new Missiles(turret1.x, turret1.y, 1, turret1.radianX, turret1.radianY));
  }

  if (turret2.missileFire ==1 && turret2.number >=1 && missileJudge2 == false) {
    missileJudge2 = true;
    turret2.number = turret2.number -1;
    missiles2.add(new Missiles(turret2.x, turret2.y, 2, turret2.radianX, turret2.radianY));
  }
}

void resetData() {
  body1.x = body2.x = turret1.x = turret2.x= 700;
  body1.y = turret1.y = 130;
  body2.y = turret2.y = 710;
  counter1 = 0; 
  counter2 = 0; 
  counter3 =0; 
  counter4 =0;
  startJudge = false;//whether i press the start button
  endJudge = false;//whether somebody wins
  againJudge = false;//whether i press the again button
  missileJudge = false;
  missileJudge2 = false;
  timer = 0;
  turret1.number = 1;
  turret2.number = 1;
  for (int i = bullets.size()-1; i>=0; i--) {
    bullets.remove(i);
  }
  for (int i = bullets2.size()-1; i>=0; i--) {
    bullets2.remove(i);
  }
  for (int i = missiles.size()-1; i>=0; i--) {
    missiles.remove(i);
  }
  for (int i = missiles2.size()-1; i>=0; i--) {
    missiles2.remove(i);
  }
}

void mouseClicked () {
  if (startJudge == false) {
    if (endJudge == false) {
      if (mouseX>=470 && mouseX<=849 && mouseY>=627 && mouseY<=815) {
        startJudge = true;
      }
    } else if (endJudge ==true) {
      if (mouseX>=470 && mouseX<=849 && mouseY>=627 && mouseY<=815) {
        endJudge = false;
        score1 =0;
        score2 =0;
        startMusic = false;
        bodyMusic = false;
        background.stop();
        resetData();
      }
    }
  }
}

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
