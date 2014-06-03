/**
 * Visualizzatore grafico dei dati generati dal SoundAnalizer
 *
 * uso:
 *
 * soundAnalizerVisualizer.setValues(data);
 * soundAnalizerVisualizer.draw();
 *
 * oppure:
 *
 * soundAnalizerVisualizer.draw(data);
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
  
  /**
   * Imposta i valori da visualizzare
   */
  public void setValues(SoundAnalizerData data)
  {
    this.data = data;
  }
  
  /**
   * Imposta i valori da visualizzare e li visualizza
   */
  public void draw(SoundAnalizerData data)
  {
    setValues(data);
    draw();
  }
  
  /**
   * Visualizzara i valori correnti
   */
  public void draw()
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
