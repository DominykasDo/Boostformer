class Player
{
  boolean disabled;
  PVector playerPos = new PVector();
  PVector velocity = new PVector();
  boolean onGround;
  int onGroundTimer;
  
  Player()
  {
    ResetPlayer();
  }
  
  void DrawPlayer()
  {
    Movement();
    Boost();
    
    PlayerAnimation();
  }
  
  float walkFrame;
  int animationDirection;
  void PlayerAnimation()
  {
    if(boostTint > 0)
      boostTint -= 15;
    tint(255-boostTint);
    
    if(onGround)
    {
      if(velocity.x != 0)
          walkFrame = (walkFrame+abs(velocity.x)/15)%4;
      
      if(velocity.x > 0)
        animationDirection = 0;
      else if(velocity.x < 0)
        animationDirection = 1;
      
      if(velocity.x != 0)
        image(playerImages.get(50*int(walkFrame), 50*animationDirection, 50, 50), playerPos.x, playerPos.y-4);
      else
        image(playerImages.get(150, 50*animationDirection, 50, 50), playerPos.x, playerPos.y-4);
    }
    else
    {
      if(velocity.x > 0)
        animationDirection = 0;
      else if(velocity.x < 0)
        animationDirection = 1;
      
      if(velocity.y >= 0)
        image(playerImages.get(250, 50*animationDirection, 50, 50), playerPos.x, playerPos.y-4);
      else
        image(playerImages.get(200, 50*animationDirection, 50, 50), playerPos.x, playerPos.y-4);
    }
  }
  
  PVector Movement()
  {
    if(!disabled)
    {
      XMovement();
      YMovement();
      
      playerPos.x += velocity.x;
      XCollision();
      playerPos.y += velocity.y;
      YCollision();
    }
    
    return new PVector(playerPos.x, playerPos.y);
  }
  
  void XMovement()
  {
    int xMov = int(keys['d']) - int(keys['a']);
    float tempVelocityY = velocity.y;
    velocity = new PVector(velocity.x + xMov * 0.15, 0).limit(max(abs(velocity.x), 2.5));
    velocity.y += tempVelocityY;
    if(xMov == 0)
      velocity.x *= 0.9;
    if(abs(velocity.x) < 0.01)
      velocity.x = 0;
  }
  
  void YMovement()
  {
    velocity.y += 0.08;
    if(onGround && keys[' '])
    {
      onGround = false;
      velocity.y = -3.5;
    }
    else if(onGround)
    {
      --onGroundTimer;
      if(onGroundTimer <= 0)
        onGround = false;
    }
  }
  
  void XCollision()
  {
    if(playerPos.x > 4950 || playerPos.x < 0)
      ResetPlayer();
    
    if(CheckForCollision())
    {
      playerPos.x -= velocity.x;
      velocity.x = 0;
    }
  }
  
  void YCollision()
  {
    if(playerPos.y > 1450 || playerPos.y < 0)
      ResetPlayer();
    
    if(CheckForCollision())
    {
      if(velocity.y >= 0)
      {
        onGround = true;
        onGroundTimer = 5;
        boostAvailable = true;
      }
      playerPos.y -= velocity.y;
      velocity.y = 0;
    }
  }
  
  boolean CheckForCollision()
  {
    int xCoord = int(playerPos.x / 50);
    int yCoord = int(playerPos.y / 50);
    int playerSize = 36;
    if((blocks[xCoord][yCoord].id >= 1 && blocks[xCoord][yCoord].id <= 9
    && RectInRect(int(playerPos.x), int(playerPos.y), playerSize, playerSize, xCoord*50, yCoord*50, 50, 50))
    || (blocks[xCoord+1][yCoord].id >= 1 && blocks[xCoord+1][yCoord].id <= 9
    && RectInRect(int(playerPos.x), int(playerPos.y), playerSize, playerSize, (xCoord+1)*50, yCoord*50, 50, 50))
    || (blocks[xCoord][yCoord+1].id >= 1 && blocks[xCoord][yCoord+1].id <= 9
    && RectInRect(int(playerPos.x), int(playerPos.y), playerSize, playerSize, xCoord*50, (yCoord+1)*50, 50, 50))
    || (blocks[xCoord+1][yCoord+1].id >= 1 && blocks[xCoord+1][yCoord+1].id <= 9
    && RectInRect(int(playerPos.x), int(playerPos.y), playerSize, playerSize, (xCoord+1)*50, (yCoord+1)*50, 50, 50)))
      return true;
    else if((blocks[xCoord][yCoord].id == 22
    && RectInRect(int(playerPos.x), int(playerPos.y), playerSize, playerSize, xCoord*50, yCoord*50, 50, 50))
    || (blocks[xCoord+1][yCoord].id == 22
    && RectInRect(int(playerPos.x), int(playerPos.y), playerSize, playerSize, (xCoord+1)*50, yCoord*50, 50, 50))
    || (blocks[xCoord][yCoord+1].id == 22
    && RectInRect(int(playerPos.x), int(playerPos.y), playerSize, playerSize, xCoord*50, (yCoord+1)*50, 50, 50))
    || (blocks[xCoord+1][yCoord+1].id == 22
    && RectInRect(int(playerPos.x), int(playerPos.y), playerSize, playerSize, (xCoord+1)*50, (yCoord+1)*50, 50, 50)))
      ResetPlayer();
    return false;
  }
  
  boolean boostAvailable;
  int boostTint;
  void Boost()
  {
    if(boostAvailable && mousePressed && mouseButton == LEFT)
    {
      boostAvailable = false;
      boostTint = 255;
      
      float magnitude = new PVector(mouseX - width/2, mouseY - height/2).mag();
      velocity = new PVector((mouseX - width/2)/magnitude*4, (mouseY - height/2)/magnitude*4);
    }
  }
  
  void ResetPlayer()
  {
    playerPos = new PVector(800, 800);
    velocity = new PVector(0, 0);
    disabled = false;
  }
}
