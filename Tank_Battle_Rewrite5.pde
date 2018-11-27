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
      String inData = controller1.readStringUntil('\n');//first send the data as String
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
      String inData2 = controller2.readStringUntil('\n');//first send the data as String
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
  text(10-score2, 200, 240);
  image(heart, 1150, 240, heart.width/14, heart.height/14);
  textSize(35);
  fill(10);
  text(10-score1, 1250, 240);
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