int gameState;
int levelSelected;
Level currentLevel = null;
color levelColor;
boolean[] keys = new boolean[128];
boolean mouseActive;

void setup()
{
  size(800, 600);
  surface.setTitle("Boostformer");
  textAlign(CENTER);
  frameRate(60);
}

void draw()
{
  switch(gameState)
  {
    case(0):
      Menu();
      break;
    case(1):
      LevelSelect();
      break;
    case(2):
      InLevel();
      break;
    case(3):
      InEditor();
      break;
    default:
      println("Bug1");
      exit();
      break;
  }
}

void Menu()
{
  background(150, 150, 200);
  textSize(110);
  fill(0);
  stroke(50);
  strokeWeight(4);
  text("Boostformer", width/2, 200);
  textSize(107);
  fill(240);
  text("Boostformer", width/2, 200);
  textSize(36);
  fill(#5AD6EA);
  rect(width/2 - 65, height/2 + 50, 130, 50);
  fill(0, 0, 0, 80);
  text("Play", width/2, height/2 + 85);
  fill(#FF505C);
  rect(width/2 - 50, height/2 + 150, 100, 50);
  fill(0, 0, 0, 80);
  text("Quit", width/2, height/2 + 185);
  if(MouseInRect(width/2 - 65, height/2 + 50, 130, 50) && CheckMouseLeft())
    gameState = 1;
  if(MouseInRect(width/2 - 50, height/2 + 150, 100, 50) && CheckMouseLeft())
    exit();
}

void LevelSelect()
{
  background(150, 200, 150);
  fill(0, 0, 0, 80);
  textSize(78);
  text("Select level", width/2, 100);
  stroke(100, 180, 100);
  strokeWeight(10);
  fill(150, 255, 150);
  rect(150, 175, 100, 100);
  stroke(180, 180, 100);
  fill(255, 255, 150);
  rect(width/2 - 50, 175, 100, 100);
  stroke(180, 150, 100);
  fill(255, 200, 150);
  rect(width - 250, 175, 100, 100);
  stroke(180, 100, 100);
  fill(255, 150, 150);
  rect(150, 375, 100, 100);
  stroke(150);
  fill(255);
  rect(width/2 - 50, 375, 100, 100);
  rect(width - 250, 375, 100, 100);
  fill(0, 0, 0, 80);
  text("1", 200, 250);
  text("2", 400, 250);
  text("3", 600, 250);
  text("4", 200, 450);
  text("C", 400, 450);
  text("E", 600, 450);
  
  fill(#CB6EE8);
  textSize(40);
  text("Back", 45, 35);
  
  if(MouseInRect(0, 0, 90, 40) && CheckMouseLeft())
    gameState = 0;
  else if(MouseInRect(150, 175, 100, 100) && CheckMouseLeft())
  {
    levelSelected = 1;
    gameState = 2;
  }
  else if(MouseInRect(width/2 - 50, 175, 100, 100) && CheckMouseLeft())
  {
    levelSelected = 2;
    gameState = 2;
  }
  else if(MouseInRect(width - 250, 175, 100, 100) && CheckMouseLeft())
  {
    levelSelected = 3;
    gameState = 2;
  }
  else if(MouseInRect(150, 375, 100, 100) && CheckMouseLeft())
  {
    levelSelected = 4;
    gameState = 2;
  }
  else if(MouseInRect(width/2 - 50, 375, 100, 100) && CheckMouseLeft())
  {
    levelSelected = 5;
    gameState = 3;
  }
  else if(MouseInRect(width - 250, 375, 100, 100) && CheckMouseLeft())
  {
    levelSelected = 5;
    gameState = 2;
  }
}

void InLevel()
{
  if(currentLevel == null)
    currentLevel = new Level(levelSelected, false);
  currentLevel.DrawLevel();
  
  if(MouseInRect(0, height - 35, 60, 35) && CheckMouseLeft())
  {
    currentLevel = null;
    gameState = 1;
  }
}

void InEditor()
{
  if(currentLevel == null)
    currentLevel = new Level(levelSelected, true);
  currentLevel.DrawLevel();
  
  if(MouseInRect(0, height - 35, 150, 35) && CheckMouseLeft())
  {
    SaveCreator();
    currentLevel = null;
    gameState = 1;
  }
  if(MouseInRect(width - 185, height - 35, 185, 35) && CheckMouseLeft())
  {
    currentLevel = null;
    gameState = 1;
  }
}

void LoadNewLevel(int levelId)
{
  currentLevel = null;
  levelSelected = levelId;
}

void SaveCreator()
{
  JSONArray saveArray = new JSONArray();
  
  int amountOfBlocks = 0;
  for(int j = 0; j < worldSizeY; ++j)
    for(int i = 0; i < worldSizeX; ++i)
    {
      if(blocks[i][j].id > 0)
      {
        JSONObject saveObject = new JSONObject();
        
        saveObject.setInt("x", i);
        saveObject.setInt("y", j);
        saveObject.setInt("id", blocks[i][j].id);
        
        saveArray.setJSONObject(amountOfBlocks, saveObject);
        ++amountOfBlocks;
      }
    }
    
    saveJSONArray(saveArray, "data\\World5.json");
}

boolean MouseInRect(int x, int y, int xSize, int ySize)
{
  if(mouseX - x < xSize && mouseX - x > 0 && mouseY - y < ySize && mouseY - y > 0)
    return true;
  return false;
}

boolean RectInRect(int x1, int y1, int x1Size, int y1Size, int x2, int y2, int x2Size, int y2Size)
{
  if(abs(x2-x1) < x1Size/2 + x2Size/2 && abs(y2-y1) < y1Size/2 + y2Size/2)
    return true;
  return false;
}

void keyPressed()
{
  if(key < 128)
    keys[key] = true;
}

void keyReleased()
{
  if(key < 128)
    keys[key] = false;
}

boolean CheckMouseLeft()
{
  if(!mouseActive && mousePressed && mouseButton == LEFT)
  {
    mouseActive = true;
    return true;
  }
  return false;
}

boolean CheckMouseRight()
{
  if(!mouseActive && mousePressed && mouseButton == RIGHT)
  {
    mouseActive = true;
    return true;
  }
  return false;
}

void mouseReleased()
{
  if(!mousePressed)
    mouseActive = false;
}
