/**
 */

import processing.serial.*;
 
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
      port = new Serial(fileSystemHandler, Serial.list()[0], speed);
    }
    else
    {
      port = new Serial(fileSystemHandler, comPort, speed);
    }
  }
  
  public void setValues(int[] values)
  {
    byte[] bytes = new byte[values.length];
    for(int i = 0; i < values.length; i++)
    {
      bytes[i] = (byte)values[i];
    }
    port.write(bytes);
  }
}
