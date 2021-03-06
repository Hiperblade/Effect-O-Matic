/**
 * Visualizzatore grafico dei dati elaborati da un effetto (IEffectOMatic)
 */
public class EffectOMaticVisualizer
{
  private int x;
  private int y;
  private int width;
  private int height;
  private int number;
  private int[] values;
  
  /**
   * Costruttore:
   * x e y = posizione
   * width e height = dimensione
   * number = numero di valori visualizzati
   */
  public EffectOMaticVisualizer(int x, int y, int width, int height, int number)
  {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.number = number;
    values = new int[number];
  }
  
  /**
   * Imposta i valori da visualizzare
   */
  public void setValues(int[] values)
  {
    this.values = values;
  }
  
  /**
   * Imposta i valori da visualizzare e li visualizza
   */
  public void draw(int[] values)
  {
    setValues(values);
    draw();
  }
  
  /**
   * Visualizzara i valori correnti
   */
  public void draw()
  {
    stroke(0);
    int step = width + width / 2;
    int startX = x - ((number - 1) * step / 2);
  
    fill(color(0));
    rect(x, y, ((number - 1) * step) + width + 40, height + 40);  
    for (int i = 0; i < number; i++)
    {
      fill(color(values[i]));
      rect(startX + (i * step), y, width, height);
    }
  }
}
