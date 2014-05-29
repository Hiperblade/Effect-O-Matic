/**
 */

import ddf.minim.analysis.*;
import ddf.minim.*;

public class SoundAnalizer
{
  private final int DEADLINE = 5000; // 5 secondi
  
  private Minim minim;
  private AudioInput in;
  private FFT fft;
  private BeatDetect beat;
  
  private float timeStamp = 0;
  private float maxAverage = 0;
  private float localMaxAverage = 0;
  
  private boolean visible = false;
  private int x;
  private int y;
  private int baseX;
  
  /**
   * Crea un analizzatore di suoni
   * 
   * @param fileSystemHandler
   * The Object that will be used for file operations.
   * When using Processing, simply pass <strong>this</strong> to SoundAnalizer's constructor.
   *
   * @param size
   * Number of value generated
   */
  public SoundAnalizer(PApplet fileSystemHandler, int size)
  {
    minim = new Minim(this);
    in = minim.getLineIn(Minim.STEREO, 512, 20000, 16);
    //in = minim.getLineIn(Minim.STEREO, 512, 44100, 16);
    fft = new FFT(in.bufferSize(), in.sampleRate());
    
    //fft.linAverages(size);
    //fft.logAverages(690, 1);
    fft.logAverages(11, 1);
    
    beat = new BeatDetect();
    
    setVisiblePosition(0, 0);
  }
  
  public float[] getValues()
  {
    float[] ret = new float[fft.avgSize()];
    
    fft.forward(in.mix);
    for(int i = 0; i < fft.avgSize(); i++)
    {
      float tmp = fft.getAvg(i);
      if(tmp > maxAverage)
      {
        maxAverage = tmp;
        localMaxAverage = tmp; 
        timeStamp = millis();
      }
      else if(tmp > localMaxAverage)
      {
        localMaxAverage = tmp;
      }
      
      if(maxAverage > 0)
      {
        ret[i] = tmp / maxAverage;
      }
      else
      {
        ret[i] = 0;
      }
    }
    
    //TODO
    
    // resetto il massimo
    if(millis() - timeStamp > DEADLINE)
    {
      maxAverage = localMaxAverage;
      localMaxAverage = 0; 
      timeStamp = millis();
    }
    
    beat.detect(in.mix);
    
    draw(ret);
    return ret;
  }
  
  public boolean getBeat()
  {
    //return beat.isKick();
    //return beat.isSnare();
    //return beat.isHat();
    //return beat.isRange();
    return beat.isOnset();
  }
  
  public void stop()
  {
    in.close();
    minim.stop();
  }
  
  public void setVisible(boolean value)
  {
    visible = value;
  }
  
  public void setVisiblePosition(int x, int y)
  {
    this.x = x;
    this.y = y;
    baseX = x - ((fft.avgSize() - 1) * 30 / 2);
  }
  
  private void draw(float[] ret)
  {
    if(visible)
    {
      stroke(0);
      fill(color(255));
      
      for(int i = 0; i < fft.avgSize(); i++)
      {
        // show
        rect(i * 30 + baseX, y - ret[i] * 25, 20, ret[i] * 50);
      }
      
      if(!getBeat())
      {
        fill(color(0));
      }
      rect(x, y + 15, (fft.avgSize() - 1) * 30 + 20, 10);
    }
  }
}
