import ddf.minim.analysis.*;
import ddf.minim.*;

/**
 * Analizzatore di suoni (usa il segnale di LineIn)
 *
 * uso:
 *
 * soundAnalizer.next();
 * SoundAnalizerData data = soundAnalizer.getData();
 */
public class SoundAnalizer
{
  private final float LOW_THRESHOLD = 0.4; // soglia minima anti rumore di fondo
  private final int DEADLINE = 5000; // 5 secondi
  
  private Minim minim;
  private AudioInput in;
  private FFT fft;
  private BeatDetect beat;
  
  private float timeStamp = 0;
  private float maxAverage = 0;
  private float localMaxAverage = 0;
  private SoundAnalizerData data;
  
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
  public SoundAnalizer(PApplet fileSystemHandler)
  {
    minim = new Minim(fileSystemHandler);
    //in = minim.getLineIn(Minim.STEREO, 512, 20000, 16);
    in = minim.getLineIn(Minim.STEREO, 512, 44100, 16);
    fft = new FFT(in.bufferSize(), in.sampleRate());
    
    //fft.logAverages(600, 1);
    //fft.logAverages(690, 1);
    fft.logAverages(11, 1);
    
    beat = new BeatDetect();
  }
  
  /**
   * Elabora un nuovo campione
   */
  public void next()
  {
    float[] ret = new float[fft.avgSize()];
    
    fft.forward(in.mix);
    for(int i = 0; i < fft.avgSize(); i++)
    {
      float tmp = fft.getAvg(i);
      if(tmp < LOW_THRESHOLD)
      {
        tmp = 0;
      }
      
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
    
    // resetto il massimo
    if(millis() - timeStamp > DEADLINE)
    {
      maxAverage = localMaxAverage;
      localMaxAverage = 0; 
      timeStamp = millis();
    }
    
    beat.detect(in.mix);
    boolean beatVal = false;
    //beatVal = beat.isKick();
    //beatVal = beat.isSnare();
    //beatVal = beat.isHat();
    //beatVal = beat.isRange();
    beatVal = beat.isOnset();
    
    data = new SoundAnalizerData(ret, beatVal);
  }

  /**
   * Restituisce i dati relativi al campione corrente
   */
  public SoundAnalizerData getData()
  {
    return data;
  }
  
  public void stop()
  {
    in.close();
    minim.stop();
  }
}

/**
 * Contiene i dati elaborati dall'analizer
 */
public class SoundAnalizerData
{
  private float[] values;
  private boolean beat;
  
  public SoundAnalizerData(float[] values, boolean beat)
  {
    this.values = values;
    this.beat = beat;
  }
  
  public float[] getValues()
  {
    return values;
  }
  
  public boolean getBeat()
  {
    return beat;
  }
}
