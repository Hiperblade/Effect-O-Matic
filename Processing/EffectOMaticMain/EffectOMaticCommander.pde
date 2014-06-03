import processing.serial.*;

/**
 * Componente di interfacciamento con la seriale (collegamento con arduino)
 */
public class EffectOMaticCommander
{
  private Serial port;
  
  public EffectOMaticCommander(PApplet fileSystemHandler)
  {
    this(fileSystemHandler, null, 9600);
  }
  
  public EffectOMaticCommander(PApplet fileSystemHandler, String comPort)
  {
    this(fileSystemHandler, comPort, 9600);
  }
  
  public EffectOMaticCommander(PApplet fileSystemHandler, int speed)
  {
    this(fileSystemHandler, null, speed);
  }
  
  public EffectOMaticCommander(PApplet fileSystemHandler, String comPort, int speed)
  {
    if(comPort == null)
    {
      for(int i = 0; i < Serial.list().length; i++)
      {
        try
        {
          port = new Serial(fileSystemHandler, Serial.list()[i], speed);
          break;
        }
        catch(Exception e)
        {
        }
      }
    }
    else
    {
      port = new Serial(fileSystemHandler, comPort, speed);
    }
  }
  
  /**
   * Invia i valori alla porta seriale
   */
  public void setValues(int[] values)
  {
    byte[] bytes = new byte[values.length];
    for(int i = 0; i < values.length; i++)
    {
      bytes[i] = (byte)values[i];
    }
    
    if(port != null)
    {
      port.write(bytes);
    }
  }
}
