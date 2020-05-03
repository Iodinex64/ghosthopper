//Sets the floor height, which is where the player will stand and jump on.
int groundLevel = height + 250;

//Sets the players playerX position, playerY position, jump height and gravity.
float playerX;
float playerY;
float playerW = 50;
float playerH = 50;
float jumpForce;
float horMoveForce;
float gravityForce = 0.981;

//Sets up the variables which relate to the pseudo-animation for the jump.
int playerDetail;
int playerDetail1;

//Sets the speed at which the screen "scrolls".
float scrollSpeed;

//Sets the first obstacle's parameters.
float obstacleX;
float obstacleY = (groundLevel - 50);
float obstacleW = 20;
float obstacleH = 100;

//Sets the second obstacle's parameters (identical to the first one. Two identical obstacles are used in this game to add challenge).
float obstacleX1;
float obstacleY1 = (groundLevel - 50);
float obstacleW1 = 20;
float obstacleH1 = 100;

//Sets the parameters related to the infinitely scrolling parallax hills background.
float hillX;
float hillX1;

//Sets the parameters related to the infinitely scrolling grass object.
float groundDetailX;
float grassX;

//Sets which level of scrolling speed (and therefore difficulty) the player is on.
int lvl;
//Stores whether or not the player has collided with an obstacle.
boolean isHit;

//Bringing in the star object to create the starry sky
Star sp;

//Primitive Array used to get player inputs.
boolean[] inputs = new boolean[4];
private int A = 0;
private int D = 1;
private int G = 2;
private int R = 3;

//Sets up the sketch size window, stroke rule, hides the cursor and focuses the window.
void setup() {
  noCursor();
  size(800, 500);
  noStroke();
  focused = true;
  sp = new Star();
  playerX = 100;
  playerY = groundLevel;
  jumpForce = 0;
  horMoveForce = 1.5;
  obstacleX = 0;
  obstacleX1 = 0;
  hillX = 200;
  hillX1 = 150;
  grassX = 0;
  groundDetailX = 0;
  frameCount = 0;
  isHit = false;
}
//This is the code that handles the score, level and scrolling speed of the game.
//Every 50 points, the scrolling speed is increased by -1 until it reaches a hard cap of -13.
//I discovered that if I was to raise the speed above this, the game becomes impossible to play.
void score() {
  textSize(16);
  fill(#6dc2ca);
  text("SCORE: "+(frameCount/15), 10, 25);
  text("Level "+lvl, 10, 50);

  if (!isHit) {
    if (frameCount/15 >= 500) {
      scrollSpeed = -13;
      lvl = 10;
    } else if (frameCount/15 >= 450) {
      scrollSpeed = -13;
      lvl = 9;
    } else if (frameCount/15 >= 400) {
      scrollSpeed = -13;
      lvl = 8;
    } else if (frameCount/15 >= 350) {
      scrollSpeed = -12;
      lvl = 7;
    } else if (frameCount/15 >= 300) {
      scrollSpeed = -11;
      lvl = 6;
    } else if (frameCount/15 >= 250) {
      scrollSpeed = -10;
      lvl = 5;
    } else if (frameCount/15 >= 200) {
      scrollSpeed = -9;
      lvl = 4;
    } else if (frameCount/15 >= 150) {
      scrollSpeed = -8;
      lvl = 3;
    } else if (frameCount/15 >= 100) {
      scrollSpeed = -7;
      lvl = 2;
    } else if (frameCount/15 >= 50) {
      scrollSpeed = -6;
      lvl = 1;
    } else if (frameCount/15 >= 0) {
      scrollSpeed = -5;
      lvl = 0;
    }
  }
}

//This code draws a crescent moon in the top right of the game window.
//This approach is directly inspired by real lunar occlusion.
void moon() {
  fill(#dad45e);
  ellipse((width/1.75 + 225), height/5, 120, 120);
  fill(#442434);
  ellipse((width/1.75 + 255), ((height/5)-10), 120, 120);
}

/* This code draws the scrolling background hills using "for" loops.
 This code also contains an "infinite scrolling" solution, where the
 amount of hills don't change, but at a precise time (which changes depending
 on the current scrolling speed) the hills reset back to where they began, giving
 the illusion of infinite scrolling. This effect is also used in grass() and groundDetail().
 */
void hills() {
  for (int i = 0; i < 4; i++) {
    fill(#413131);
    ellipse((hillX+(400*i)), (groundLevel+50), 400, 400);
  }
  for (int j = 0; j < 5; j++) {
    fill(#3e3b2e);
    ellipse((hillX1+(250*j)), (groundLevel+65), 250, 250);
  }
  if (hillX <= -200) {
    hillX = 200;
  }
  hillX += scrollSpeed/4;
  if (hillX1 <= -125) {
    hillX1 = 125;
  }
  hillX1 += scrollSpeed/2;
}

//This code draws the grass pattern, which appears to scroll indefinitely.
void grass() {
  fill(#365b26);
  for (int i = 0; i < 60; i++) {
    arc(grassX+(25*i), groundLevel+50, 30, 30, 0, PI);
  }
}

//Draws the first obstacle and allows it to keep re-appearing on-screen behind the second obstacle at consistently random times.
void obstacle() {
  noStroke();
  fill(#757161);
  rect(obstacleX, obstacleY, obstacleW, obstacleH, 12, 12, 0, 0);
  if (obstacleX < -20) {
    obstacleX = obstacleX1 + random(300, 500);
  }
  obstacleX += scrollSpeed;
}

//Draws the second obstacle and allows it to keep re-appearing on-screen after going off-screen on the left side of the window.
void obstacle1() {
  fill(#757161);
  noStroke();
  rect(obstacleX1, obstacleY1, obstacleW1, obstacleH1, 12, 12, 0, 0);
  if (obstacleX1 < -20) {
    obstacleX1 = 801 + random(600);
  }
  obstacleX1 += scrollSpeed;
}

//Draws the infinitely scrolling ground details, since I had to shoe-horn in a nested "for" loop somehow...
void groundDetail() {
  for (int i=0; i < 3; i++)
  {
    for (int j=0; j < 78; j++)
    { 
      if ((i + j + 1) % 2 == 0)
        fill(0, 0, 0, 0);
      else
        fill(#6d542c);
      rect(groundDetailX+(j*40), 430+(i*40), 15, 15, 18);
    }
  }
  groundDetailX += scrollSpeed;
  if (groundDetailX <= (-80*(5+lvl))) {
    groundDetailX = 0;
  }
}

/* Sets the order in which each function will be called, so as to prevent
 issues where the visual elements could overlap. Also here is the code which:
 - Sets the background colour.
 - Draws the player character.
 - Lets the player jump (to avoid obstacles).
 - Controls the collission detection and game-over state.
 - Controls the speed of the grass scrolling (this is a bug fix).
 */

void draw() {
  background(#442434);
  //Drawing the stars by talking to the class
  sp.colour(218, 212, 94);
  sp.position(100, 75, 5);
  sp.display();
  sp.position(400, 175, 5);
  sp.display();
  sp.position(275, 225, 5);
  sp.display();
  sp.position(450, 60, 5);
  sp.display();
  sp.position(650, 225, 5);
  sp.display();
  sp.position(200, 80, 5);
  sp.display();
  sp.position(90, 200, 5);
  sp.display();
  sp.position(600, 150, 5);
  sp.display();
  hills();
  moon();
  fill(#7b4631);
  rect(-1, groundLevel+50, 801, 100);
  groundDetail();
  grass();
  if (grassX <= (-25*(5+lvl))) {
    grassX = 0;
  }
  grassX += scrollSpeed;

  //This is hardcode for landscape and player that doesn't change.
  fill(#636052);
  fill(#deeed6);
  rect(playerX, playerY, 50, 50, 12, 12, (playerDetail)+(playerDetail1), playerDetail);
  rect(playerX, playerY-10, 20, 50, 18);
  rect(playerX+30, playerY-10, 20, 50, 18);
  fill(#140c1c);
  rect(playerX+40, playerY+10, 8, 15, 20);
  rect(playerX+25, playerY+10, 8, 15, 20);
  fill(#dad45e);
  rect(playerX+44, playerY+15, 4, 5, 20);
  rect(playerX+29, playerY+15, 4, 5, 20);
  obstacle1();
  obstacle();
  playerY -= jumpForce;
  jumpForce -= gravityForce;

  // test for collision between player and obstacles
  if ((playerX + playerW /2) >= (obstacleX-10 - obstacleW /2) && (playerX-playerW /2 <= (obstacleX-10)+obstacleW /2) && (playerY + playerH /2 >= obstacleY+33-obstacleH/2) && (playerY - playerH /2 <= obstacleY+obstacleH /2)) {
    frameCount--;
    scrollSpeed = 0;
    jumpForce = 0;
    horMoveForce = 0;
    textSize(60);
    fill(#d04648);
    textAlign(CENTER);
    text("Game Over!", width/2, height/2-160);
    textSize(24);
    text("You made it to level "+lvl+".", width/2, height/2-120);
    textSize(20);
    text("Press 'R' to restart!", width/2, height/2-85);
    textAlign(LEFT);
    isHit = true;
  }
  if ((playerX + playerW /2) >= (obstacleX1-10 - obstacleW1 /2) && (playerX-playerW /2 <= (obstacleX1-10)+obstacleW1 /2) && (playerY + playerH/2 >= obstacleY1+33-obstacleH1 /2) && (playerY - playerH /2 <= obstacleY1+obstacleH1 /2)) {
    frameCount--;
    scrollSpeed = 0;
    jumpForce = 0;
    horMoveForce = 0;
    textSize(60);
    fill(#d04648);
    textAlign(CENTER);
    text("Game Over!", width/2, height/2-160);
    textSize(24);
    text("You made it to level "+lvl+"/10.", width/2, height/2-120);
    textSize(20);
    text("Press 'R' to restart!", width/2, height/2-85);
    textAlign(LEFT);
    isHit = true;
  }

  //Controls the pseudo-animation of jumping and running for the player by changing edge roundedness values
  if (playerY < groundLevel) {
    playerDetail = 20;
    playerDetail1 = 0;
  } else {
    playerDetail = 0; 
    playerDetail1 = 8;
  }

  //Establishes what happens when an input is given.
  if (inputs[D]) {
    playerX += horMoveForce;
  } 
  if (inputs[A]) {
    playerX -= horMoveForce;
  } 
  if ((inputs[G]) && (playerY >= groundLevel) && (isHit == false)) {
    jumpForce = 18.5;
  } 
  if (inputs[R]) {
    setup();
  } 

  if (playerY >= groundLevel) {
    playerY = groundLevel;
  }
  if (jumpForce < -19) {
    jumpForce = 0;
  }
  if (playerX <=0) {
    playerX = 0;
  }
  if ((playerX + playerW) > width) {
    playerX = width - playerW;
  }
  score();
}

//Case (Number), the number is the ASCII code of the key pressed. This is the shortest and
//sweetest way of detecting player input since keypresses are read by the compiler as simple
//numbers
void keyPressed() {
  int mybutton = key;
  switch (mybutton) {
  case 100: 
    inputs[D] = true;
    break;
  case 97: 
    inputs[A] = true;
    break;
  case 103:
    inputs[G] = true;
    break;
  case 114:
    inputs[R] = true;
    break;
  }
}

void keyReleased() {
  int mybutton = key;
  switch (mybutton) {
  case 100: 
    inputs[D] = false;
    break;
  case 97: 
    inputs[A] = false;
    break;
  case 103:
    inputs[G] = false;
    break;
  case 114:
    inputs[R] = false;
    break;
  }
}
