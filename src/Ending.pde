class Ending
{
  boolean ended;
  PImage[] sprites = new PImage[2];
  
  Ending()
  {
    sprites[0] = loadImage("data\\Misc.png").get(0, 0, 80, 80);
    sprites[1] = loadImage("data\\Misc.png").get(80, 0, 80, 80);
  }
  
  color drawColor;
  void DrawEnding()
  {
    if(!boolean(frameCount % 20))
      drawColor = color(random(156) + 100, random(156) + 100, random(156) + 100);
    noStroke();
    fill(drawColor);
    rect(4200, 700, 50, 50);
  }
  
  PVector endScreenPos = new PVector();
  void DrawEndScreen(PVector cameraPos)
  {
    if(ended)
    {
      endScreenPos.x = int(width/2 - cameraPos.x);
      endScreenPos.y = int(height/2 - cameraPos.y);
      stroke(0);
      strokeWeight(10);
      fill(255);
      rect(endScreenPos.x - 200, endScreenPos.y - 150, 400, 300);
      fill(0);
      textSize(72);
      text("Complete!", endScreenPos.x, endScreenPos.y-50);
      tint(255);
      
      image(sprites[0], endScreenPos.x-140, endScreenPos.y+15);
      image(sprites[1], endScreenPos.x+65, endScreenPos.y+15);
      
      if(MouseInRect(width/2-140, height/2+15, 80, 80) && CheckMouseLeft())
      {
        currentLevel = null;
        gameState = 1;
      }
      if(MouseInRect(width/2+70, height/2+15, 80, 80) && CheckMouseLeft())
      {
        currentLevel = null;
        LoadNewLevel(levelSelected % 5 + 1);
      }
    }
  }
  
  void ResetEnding()
  {
    ended = false;
  }
}
