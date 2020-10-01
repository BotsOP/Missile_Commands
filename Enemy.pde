class Enemy {
  float enemyX;
  float enemyXSetup;
  float enemyY;
  int targetX;
  float movementX;
  float movementY;
  boolean setup;
  boolean shouldDelete;
  boolean setupDelete;
  int enemySpeed;
  boolean foundTurret;
  int chanceToAimForTurret = 50;
  
  void EnemySetup() {
    if(!setup) {
      enemyX = (int)random(2,79) * 10;
      enemyXSetup = enemyX;
      
      FindTarget();
      
      enemySpeed = (int)random(350,450);
      movementX = (targetX - enemyXSetup) / enemySpeed;
      movementY = (700 - enemyY) / enemySpeed;

      setup = true;
    }
  }
  
  void FindTarget() {
    int randomInt = (int)random(1,101);
      if(randomInt <= chanceToAimForTurret) {
        while(!foundTurret) {
          int whichTurretToAimFor = (int)random(0,4);
          if(whichTurretToAimFor == 0 && !isTurretDead[0]) {
            targetX = 50;
            foundTurret = true;
          }
          else if(whichTurretToAimFor == 1 && !isTurretDead[1]) {
            targetX = 283;
            foundTurret = true;
          }
          else if(whichTurretToAimFor == 2 && !isTurretDead[2]) {
            targetX = 516;
            foundTurret = true;
          }
          else if(whichTurretToAimFor == 3 && !isTurretDead[3]) {
            targetX = 749;
            foundTurret = true;
          }
          else if(isTurretDead[0] && isTurretDead[1] && isTurretDead[2] && isTurretDead[3]) {
            targetX = (int)random(2,79) * 10;
            foundTurret = true;
          }
        }
      }
      else {
        targetX = (int)random(2,79) * 10;
      } 
  }
  
  
  
  void MoveToTarget() {
     if(!shouldDelete) {
       enemyX = enemyX + movementX;
       enemyY = enemyY + movementY;
       fill(235, 168, 61);
       ellipse(enemyX,enemyY,5,5); 
       stroke(235, 168, 61);
       line(enemyXSetup, 0, enemyX,enemyY);
       stroke(0,0,0);
       fill(255,255,255);
     }
     
     HitGround();
     HitTurret();
     HitBuilding();
     HitByBomb();
  }
  
  void HitTurret() {
    for(int i = 0; i < 4;i++) {
       if(dist(enemyX,enemyY,50 + 233 * i,710) < 15 && !isTurretDead[i]) {
         isTurretDead[i] = true;
         DeactivateBomb();
         fireRate += 250;
       }
     }
  }
  
  void HitGround() {
    if(enemyY > 710) {
        shouldDelete = true;
        if(!setupDelete) {
          playerHealth -= 10;
          setupDelete = true;
        }
     }
  }
  
  void HitBuilding() {
    if(enemyX > 80 && enemyX < 110 && enemyY > 700 && !isBuildingDead[0]) {
       isBuildingDead[0] = true;
       DeactivateBomb();
     }
     if(enemyX > 130 && enemyX < 160 && enemyY > 695 && !isBuildingDead[1]) {
       isBuildingDead[1] = true;
       DeactivateBomb();
     }
     if(enemyX > 170 && enemyX < 200 && enemyY > 700 && !isBuildingDead[2]) {
       isBuildingDead[2] = true;
       DeactivateBomb();
     }
     if(enemyX > 220 && enemyX < 250 && enemyY > 685 && !isBuildingDead[3]) {
       isBuildingDead[3] = true;
       DeactivateBomb();
     }
     if(enemyX > 313 && enemyX < 343 && enemyY > 700 && !isBuildingDead[4]) {
       isBuildingDead[4] = true;
       DeactivateBomb();
     }
     if(enemyX > 363 && enemyX < 393 && enemyY > 695 && !isBuildingDead[5]) {
       isBuildingDead[5] = true;
       DeactivateBomb();
     }
     if(enemyX > 403 && enemyX < 433 && enemyY > 700 && !isBuildingDead[6]) {
       isBuildingDead[6] = true;
       DeactivateBomb();
     }
     if(enemyX > 453 && enemyX < 483 && enemyY > 685 && !isBuildingDead[7]) {
       isBuildingDead[7] = true;
       DeactivateBomb();
     }
     if(enemyX > 546 && enemyX < 576 && enemyY > 700 && !isBuildingDead[8]) {
       isBuildingDead[8] = true;
       DeactivateBomb();
     }
     if(enemyX > 596 && enemyX < 626 && enemyY > 695 && !isBuildingDead[9]) {
       isBuildingDead[9] = true;
       DeactivateBomb();
     }
     if(enemyX > 636 && enemyX < 666 && enemyY > 700 && !isBuildingDead[10]) {
       isBuildingDead[10] = true;
       DeactivateBomb();
     }
     if(enemyX > 686 && enemyX < 726 && enemyY > 685 && !isBuildingDead[11]) {
       isBuildingDead[11] = true;
       DeactivateBomb();
     }
  }
  
  void HitByBomb() {
    for(PlayerBomb playerBomb : playerBombs) {
       if(dist(enemyX, enemyY, playerBomb.GetTargetPosX(), playerBomb.GetTargetPosY()) < 25 && !setupDelete) {
         score += 10;
         DeactivateBomb();
         setupDelete = true;
       }
     }
  }
  
  void DeactivateBomb() {
    shouldDelete = true;
    movementX = 0;
    movementY = 0;
    enemyY = 0;
  }
}
