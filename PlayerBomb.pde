class PlayerBomb {
  PVector bombPos;
  PVector targetPos;
  float targetY;
  float targetX;
  PVector bombVel = new PVector(0,0);
  boolean setup;
  boolean underway = true;
  boolean shouldDraw = true;
  int lastTime;
  int bombSpeed = 10;
  int explodeDuration = 2000;
  
  PlayerBomb(PVector bombPos, PVector targetPos) {
    this.bombPos = bombPos;
    this.targetPos = targetPos;
  }
  
  void BombSetup() {
    if(!setup) {
      targetY = targetPos.y;
      targetX = targetPos.x;
      bombVel = targetPos.sub(bombPos);
      bombVel.normalize();
      bombVel.mult(bombSpeed);
      lastTime = millis();

      setup = true;
    }
     
    MoveToTarget();
  }
  
  void MoveToTarget() {
    fill(230, 57, 9);
    if(shouldDraw) {
      if(underway) {
        bombPos.add(bombVel);
        ellipse(bombPos.x,bombPos.y,5,5); 
      }
      if(bombPos.y < targetY) {
        underway = false;
        ellipse(targetX,targetY,35,35);
        //println(targetX + "   " + targetY);
      }
    }
    if(!underway && millis() - lastTime > explodeDuration) {
      shouldDraw = false;
      targetX = 1000;
      targetY = 1000;
    }
  }
  
  float GetTargetPosX() {
    if(!underway)
      return targetX;
    else
      return 1000;
  }
  
  float GetTargetPosY() {
    if(!underway)
      return targetY;
    else
      return 1000;
  }
}
