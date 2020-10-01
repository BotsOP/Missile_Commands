int downSpeed;
PVector playerPos = new PVector(80,80);
boolean [] keys = new boolean[1000000];
boolean [] isTurretDead = new boolean[4];
boolean [] isBuildingDead = new boolean[12];
int lastTime;
int lastTimeShot;
int whichBaseTurret = 1;
int amountOfEnemies = 10;
int enemyRespawinTime = 2000;
PVector baseTurretPos = new PVector(50,695);
int playerHealth = 100;
int score;

float playerSpeed = 2;
float playerAccelerate = 0.1;
boolean shouldAccelerate;
boolean pickedTurret;
boolean gameOver;
boolean gameOverSetup;

int fireRate = 500;

Enemy enemy;
ArrayList<Enemy> enemies = new ArrayList<Enemy>();

PlayerBomb playerBomb;
ArrayList<PlayerBomb> playerBombs = new ArrayList<PlayerBomb>();

int amountStars = 100;
int[] starsX = new int[amountStars];
int[] starsY = new int[amountStars];


void setup() {
  size(800, 800);
  lastTime = millis();
  lastTimeShot = millis();
  //enemy = new Enemy();
  //enemies.add(enemy);
  
  frameRate(50);
  for(int i = 0; i < amountStars; i++) {
    starsX[i] = (int)random(10,790);
    starsY[i] = (int)random(5,690);
  }
}

void draw() {
  background(0);
  
  if(!gameOver) {
    BaseTurrets();
    DrawBackground();
    SpawnRandomEnemies();
    MovePlayer();
    Shoot();
    DisplayPlayerStats();
    
    gameOverSetup = false;
  }
  else
    GameOverScreen();
}

void GameOverScreen() {
  textSize(32);
  textAlign(CENTER);
  text("GAME OVER", width/2, height/2 - 100);
  text("FINAL SCORE: " + score, width/2, height/2 - 50);
  text("PRESS ANY BUTTON TO RETRY", width/2, height/2);
  
  for(int i = 0; i < keys.length; i++) {
    if(keys[i]) {
      
      if(!gameOverSetup) {
        playerHealth = 100;
        score = 0;
        for(int j = 0; j < isTurretDead.length; j++) {
          isTurretDead[j] = false;
        }
        for(int j = 0; j < isBuildingDead.length; j++) {
          isBuildingDead[j] = false;
        }
        for(Enemy enemy : enemies) {
          enemy.DeactivateBomb();
        }
        gameOverSetup = true;
    }
    gameOver = false;

    }
  }
}

void BaseTurrets() {
  fill(12, 50, 120);
  if(!isTurretDead[0]) {
     ellipse(50, 710,30,30);
     stroke(194, 35, 23, 255);
     line(50,695,playerPos.x,playerPos.y + 10);
     stroke(0,0,0);
  }
  if(!isTurretDead[1]) {
     ellipse(283, 710,30,30);
     stroke(194, 35, 23, 255);
     line(283,695,playerPos.x,playerPos.y + 10);
     stroke(0,0,0);
  }
  if(!isTurretDead[2]) {
     ellipse(516, 710,30,30);
     stroke(194, 35, 23, 255);
     line(516,695,playerPos.x,playerPos.y + 10);
     stroke(0,0,0);
  }
  if(!isTurretDead[3]) {
     ellipse(749, 710,30,30);
     stroke(194, 35, 23, 255);
     line(749,695,playerPos.x,playerPos.y + 10);
     stroke(0,0,0);
  }
  
  stroke(0,0,0,255);
  fill(134, 143, 11,255);
  rect(0,710,800,800);
  fill(255,255,255,255);
}

void SpawnRandomEnemies() {
  //Controls all the enemies on the screen
  for(Enemy enemy : enemies) {
     enemy.EnemySetup();
     enemy.MoveToTarget();
  }
  //println(enemies.size());
  
  //Spawns and removes enemies
  if(millis() - lastTime > 2000) {
    Enemy enemy = new Enemy();
    enemies.add(enemy);
    lastTime = millis();

    //Deletes enemies if they are over the limit
    if(enemies.size() > amountOfEnemies) {
      enemies.remove(0);
    }
  }
}

void MovePlayer() {
  //Controls the movement of the crosshair
  if(keys['d'] == true)
    playerPos.x += playerSpeed;
  if(keys['a'] == true)
    playerPos.x -= playerSpeed;
  if(keys['s'] == true)
    playerPos.y += playerSpeed;
  if(keys['w'] == true)
    playerPos.y -= playerSpeed;
  
  //Accelerates the player if they keep holding down the keys
  if(keys['w'] == true || keys['s'] == true || keys['a'] == true || keys['d'] == true)
    shouldAccelerate = true;
  else
    shouldAccelerate = false;
    
  if(shouldAccelerate && playerSpeed < 8) {
     playerSpeed += playerAccelerate;
  }
  if(!shouldAccelerate && playerSpeed > 2)
     playerSpeed -= playerAccelerate * 2;
     
  drawCrosshair(playerPos);
  
  //Keeps the crosshair on the screen
  if(playerPos.x < 0)
    playerPos.x = 0;
  if(playerPos.x > 800)
    playerPos.x = 800;
  if(playerPos.y < 0)
    playerPos.y = 0;
  if(playerPos.y > 695)
    playerPos.y = 690;
}

void Shoot() {
  //println(millis() + "     " + lastTimeShot);
  if(keys['k'] == true && millis() - lastTimeShot > fireRate) {
    if(whichBaseTurret == 1) {
      if(!isTurretDead[0])
        baseTurretPos.set(50,695);
      else
        whichBaseTurret++;
    }
    if(whichBaseTurret == 2) {
      if(!isTurretDead[1])
        baseTurretPos.set(283,695);
      else
        whichBaseTurret++;
    }
    if(whichBaseTurret == 3) {
     if(!isTurretDead[2])
        baseTurretPos.set(516,695);
      else
        whichBaseTurret++;
    }
    if(whichBaseTurret == 4) {
      if(!isTurretDead[3])
        baseTurretPos.set(749,695);
      else
        whichBaseTurret++;
    }

    if(whichBaseTurret >= 4)
      whichBaseTurret = 0;
    whichBaseTurret++;
    
    if(!gameOver) {
      playerBomb = new PlayerBomb(new PVector(baseTurretPos.x,baseTurretPos.y), new PVector(playerPos.x, playerPos.y));
      playerBombs.add(playerBomb);
    }
    
    lastTimeShot = millis();
  }
  
  for(PlayerBomb playerBomb : playerBombs) {
    playerBomb.BombSetup(); 
  }
  
  if(playerBombs.size() > 4) {
    playerBombs.remove(0);
  }
}

void DisplayPlayerStats() {
  fill(232, 69, 9);
  textSize(32);
  textAlign(CENTER);
  text("HP: " + playerHealth, 80, 40);
  text("SCORE: " + score, 670, 40);
  
  if(playerHealth == 0)
    gameOver = true;
  if(isTurretDead[0] && isTurretDead[1] && isTurretDead[2] && isTurretDead[3])
    gameOver = true;
}

void drawCrosshair(PVector playerPos) {
  fill(255,255,255);
  rect(0 + playerPos.x - 27.5,25 + playerPos.y - 27.5,20,5);
  rect(25 + playerPos.x - 27.5,0 + playerPos.y - 27.5,5,20);
  rect(25 + playerPos.x - 27.5,35 + playerPos.y - 27.5,5,20);
  rect(35 + playerPos.x - 27.5,25 + playerPos.y - 27.5,20,5);
}

void DrawBackground() {
  fill(255,255,255);
  for(int i = 0; i < amountStars; i++) {
     ellipse(starsX[i],starsY[i],5,5);
  }
  
  if(!isBuildingDead[0]) {
    fill(94, 92, 85);
    rect(80,700,30,30);
    fill(157, 225, 227);
    rect(85,705,5,5);
    rect(85,715,5,5);
    rect(95,705,5,5);
    rect(95,715,5,5);
  }
  if(!isBuildingDead[1]) {
    fill(94, 92, 85);
    rect(130,695,30,40);
    fill(157, 225, 227);
    rect(135,700,5,5);
    rect(135,710,5,5);
    rect(135,720,5,5);
    rect(145,700,5,5);
    rect(145,710,5,5);
    rect(145,720,5,5);
  }
  if(!isBuildingDead[2]) {
    fill(94, 92, 85);
    rect(170,700,30,30);
    fill(157, 225, 227);
    rect(175,705,5,5);
    rect(175,715,5,5);
    rect(185,705,5,5);
    rect(185,715,5,5);
  }
  if(!isBuildingDead[3]) {
    fill(94, 92, 85);
    rect(220,685,30,50);
    fill(157, 225, 227);
    rect(225,690,5,5);
    rect(225,700,5,5);
    rect(225,710,5,5);
    rect(225,720,5,5);
    rect(235,690,5,5);
    rect(235,700,5,5);
    rect(235,710,5,5);
    rect(235,720,5,5);
  }
  if(!isBuildingDead[4]) {
    fill(94, 92, 85);
    rect(80 + 233,700,30,30);
    fill(157, 225, 227);
    rect(85 + 233,705,5,5);
    rect(85 + 233,715,5,5);
    rect(95 + 233,705,5,5);
    rect(95 + 233,715,5,5);
  }
  if(!isBuildingDead[5]) {
    fill(94, 92, 85);
    rect(130 + 233,695,30,40);
    fill(157, 225, 227);
    rect(135 + 233,700,5,5);
    rect(135 + 233,710,5,5);
    rect(135 + 233,720,5,5);
    rect(145 + 233,700,5,5);
    rect(145 + 233,710,5,5);
    rect(145 + 233,720,5,5);
  }
  if(!isBuildingDead[6]) {
    fill(94, 92, 85);
    rect(170 + 233,700,30,30);
    fill(157, 225, 227);
    rect(175 + 233,705,5,5);
    rect(175 + 233,715,5,5);
    rect(185 + 233,705,5,5);
    rect(185 + 233,715,5,5);
  }
  if(!isBuildingDead[7]) {
    fill(94, 92, 85);
    rect(220 + 233,685,30,50);
    fill(157, 225, 227);
    rect(225 + 233,690,5,5);
    rect(225 + 233,700,5,5);
    rect(225 + 233,710,5,5);
    rect(225 + 233,720,5,5);
    rect(235 + 233,690,5,5);
    rect(235 + 233,700,5,5);
    rect(235 + 233,710,5,5);
    rect(235 + 233,720,5,5);
  }
  if(!isBuildingDead[8]) {
    fill(94, 92, 85);
    rect(80 + 466,700,30,30);
    fill(157, 225, 227);
    rect(85 + 466,705,5,5);
    rect(85 + 466,715,5,5);
    rect(95 + 466,705,5,5);
    rect(95 + 466,715,5,5);
  }
  if(!isBuildingDead[9]) {
    fill(94, 92, 85);
    rect(130 + 466,695,30,40);
    fill(157, 225, 227);
    rect(135 + 466,700,5,5);
    rect(135 + 466,710,5,5);
    rect(135 + 466,720,5,5);
    rect(145 + 466,700,5,5);
    rect(145 + 466,710,5,5);
    rect(145 + 466,720,5,5);
  }
  if(!isBuildingDead[10]) {
    fill(94, 92, 85);
    rect(170 + 466,700,30,30);
    fill(157, 225, 227);
    rect(175 + 466,705,5,5);
    rect(175 + 466,715,5,5);
    rect(185 + 466,705,5,5);
    rect(185 + 466,715,5,5);
  }
  if(!isBuildingDead[11]) {
    fill(94, 92, 85);
    rect(220 + 466,685,30,50);
    fill(157, 225, 227);
    rect(225 + 466,690,5,5);
    rect(225 + 466,700,5,5);
    rect(225 + 466,710,5,5);
    rect(225 + 466,720,5,5);
    rect(235 + 466,690,5,5);
    rect(235 + 466,700,5,5);
    rect(235 + 466,710,5,5);
    rect(235 + 466,720,5,5);
  }
}

void keyPressed()
{
  keys[key] = true;
}

void keyReleased()
{
  keys[key] = false;
}
