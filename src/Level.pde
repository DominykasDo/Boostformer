final int worldSizeX = 100;
final int worldSizeY = 30;
Block[][] blocks = new Block[worldSizeX][worldSizeY];
PImage blockImages;
PImage playerImages;
boolean lowDetail;

class Level
{
  Player player;
  Ending ending;
  PVector playerPos = new PVector();
  PVector cameraPos = new PVector();
  boolean levelEditor;
  
  Level(int levelSelected, boolean levelEditor)
  {
    LevelColor();
    
    if(blockImages == null)
      blockImages = loadImage("data\\Blocks.png");
    if(playerImages == null)
      playerImages = loadImage("data\\Player.png");
    
    LoadBlocks(levelSelected);
    
    this.levelEditor = levelEditor;
    if(!levelEditor)
      player = new Player();
    ending = new Ending();
    cameraPos = new PVector(-514, -614);
  }
  
  void DrawLevel()
  {
    if(IsPlayerOnEnding())
    {
      ending.ended = true;
      player.disabled = true;
    }
    if(keys['r'])
      RestartLevel();
    
    background(red(levelColor)+10, green(levelColor)+10, blue(levelColor)+10);
    if(!levelEditor)
    {
      CameraPlayerPositioning();
      ending.DrawEnding();
      for(int i = 0; i < worldSizeX; ++i)
        for(int j = 0; j < worldSizeY; ++j)
          blocks[i][j].DrawBlock(i, j);
      playerPos = player.Movement();
      player.DrawPlayer();
      ending.DrawEndScreen(cameraPos);
      ExitControlsWhenPlaying();
      LowDetailMode();
    }
    else
    {
      CameraEditorPositioning();
      PlaceBlocks();
      ending.DrawEnding();
      for(int i = 0; i < worldSizeX; ++i)
        for(int j = 0; j < worldSizeY; ++j)
          blocks[i][j].DrawBlock(i, j);
      DrawPlayerGhost();
      SelectableBlocks();
      ExitControlsWhenCreator();
    }
  }
  
  void LoadBlocks(int levelSelected)
  {
    for(int i = 0; i < worldSizeX; ++i)
      for(int j = 0; j < worldSizeY; ++j)
        blocks[i][j] = new Block();
    
    JSONArray blocksFromJSON = new JSONArray();
    if((blocksFromJSON = loadJSONArray("World"+levelSelected+".json")) != null)
      for(int i = 0; i < blocksFromJSON.size(); ++i)
      {
        JSONObject oneBlockFromJSON = blocksFromJSON.getJSONObject(i);
        blocks[oneBlockFromJSON.getInt("x")][oneBlockFromJSON.getInt("y")].NewId(oneBlockFromJSON.getInt("id"));
      }
  }
  
  void CameraPlayerPositioning()
  {
    cameraPos.x = lerp(cameraPos.x, -playerPos.x + width/2 - 25, 0.1);
    cameraPos.y = lerp(cameraPos.y, -playerPos.y + height/2 - 25, 0.1);
    translate(cameraPos.x, cameraPos.y);
  }
  
  void CameraEditorPositioning()
  {
    int xMov = int(keys['d']) - int(keys['a']);
    int yMov = int(keys['w']) - int(keys['s']);
    
    cameraPos.x -= xMov*12;
    cameraPos.y += yMov*12;
    translate(cameraPos.x, cameraPos.y);
  }
  
  int selectedBlock = 1;
  void PlaceBlocks()
  {
    if(!mouseActive && mousePressed && mouseY < width * 0.5)
      if(mouseButton == LEFT)
        blocks[constrain(int((mouseX-cameraPos.x)/50), 1, worldSizeX-2)]
        [constrain(int((mouseY-cameraPos.y)/50), 1, worldSizeY-2)].NewId(selectedBlock);
      else if(mouseButton == RIGHT)
        blocks[constrain(int((mouseX-cameraPos.x)/50), 1, worldSizeX-2)]
        [constrain(int((mouseY-cameraPos.y)/50), 1, worldSizeY-2)].NewId(0);
  }
  
  void SelectableBlocks()
  {
    fill(0, 0, 0, 40);
    rect(0 - cameraPos.x, height - 200 - cameraPos.y, width, 200);
    
    tint(red(levelColor), green(levelColor), blue(levelColor), 220);
    for(int i = 0; i < 22; ++i)
    {
      image(blockImages.get(i*50, 0, 50, 50), i%13*60 + 15 - cameraPos.x, i/13*60 + height*0.7 - cameraPos.y);
      if(MouseInRect(int(i%13*60 + 15), int(i/13*60 + height*0.7), 50, 50) && CheckMouseLeft())
        selectedBlock = i+1;
    }
  }
  
  void ExitControlsWhenPlaying()
  {
    fill(225);
    textSize(32);
    text("Exit", -cameraPos.x + 30.4, -cameraPos.y + height - 10);
  }
  
  void ExitControlsWhenCreator()
  {
    fill(225);
    textSize(32);
    text("Exit (Save)", -cameraPos.x + 73.2, -cameraPos.y + height - 10);
    text("Exit (No save)", width - cameraPos.x - 94.4, -cameraPos.y + height - 10);
  }
  
  void RestartLevel()
  {
    player.ResetPlayer();
    ending.ResetEnding();
  }
  
  void LevelColor()
  {
    switch(levelSelected)
    {
      case(1):
        levelColor = #69ED5D;
        break;
      case(2):
        levelColor = #F0EB63;
        break;
      case(3):
        levelColor = #F0B163;
        break;
      case(4):
        levelColor = #F06366;
        break;
      case(5):
        levelColor = color(random(145)+100, random(145)+100, random(145)+100);
        break;
    }
  }
  
  boolean IsPlayerOnEnding()
  {
    if(RectInRect(int(playerPos.x), int(playerPos.y), 50, 50, 4200, 700, 50, 50))
      return true;
    return false;
  }
  
  void DrawPlayerGhost()
  {
    tint(200, 200, 200, 100);
    image(playerImages.get(150, 0, 50, 50), 800, 803);
  }
  
  void LowDetailMode()
  {
    if(keys['p'])
      lowDetail = true;
    else if(keys['P'])
      lowDetail = false;
  }
}
