class Block
{
  int id;
  PImage img = new PImage();
  Block()
  {
    
  }
  
  void NewId(int id)
  {
    this.id = id;
    if(id <= 0)
      return;
    this.img = blockImages.get((id-1)*50, 0, 50, 50);
  }
  
  void DrawBlock(int x, int y)
  {
    if(id <= 0 || (lowDetail && id >= 10 && id != 22))
      return;
    tint(levelColor);
    image(img, x*50, y*50);
  }
}
