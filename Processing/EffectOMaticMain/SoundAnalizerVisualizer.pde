/**
 */

public class SoundAnalizerVisualizer
{
  private int x;
  private int y;
  private SoundAnalizerData data;
  
  public SoundAnalizerVisualizer(int x, int y)
  {
    this.x = x;
    this.y = y;
  }
  
  public void setValues(SoundAnalizerData data)
  {
    this.data = data;
  }
  
  private void draw()
  {
    stroke(0);
    fill(color(255));
    
    int baseX = x - ((data.getValues().length - 1) * 30 / 2);
    
    for(int i = 0; i < data.getValues().length; i++)
    {
      // show
      rect(i * 30 + baseX, y - data.getValues()[i] * 25, 20, data.getValues()[i] * 50);
    }
    
    if(!data.getBeat())
    {
      fill(color(0));
    }
    rect(x, y + 15, ( data.getValues().length - 1) * 30 + 20, 10);
  }
}
