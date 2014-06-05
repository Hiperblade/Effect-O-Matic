/**
 * Interfaccia di base degli effetti 
 */
public interface IEffectOMatic
{
  String getName();
  String getDescription();
  int[] process(SoundAnalizerData data);
}

// -----------------------------------------------------------------------

/**
 * Classe base per gli effetti che utilizzano il Beat e la dissolvenza
 */
public abstract class EffectBeatDecay implements IEffectOMatic
{
  protected int length;
  protected int[] values;// = new int[] {0, 0, 0, 0, 0};
  
  public EffectBeatDecay(int length)
  {
    this.length = length;
    values = new int[length];
  }
  
  protected abstract int getPattern(int index);
  
  protected abstract float getDecay(int index);
  
  public int[] process(SoundAnalizerData data)
  {
    if(data.getBeat())
    {
      for(int i = 0; i < length; i++)
      {
        values[i] = getPattern(i);
      }
    }
    else
    {
      for(int i = 0; i < length; i++)
      {
        values[i] = int(values[i] * getDecay(i));
      }
    }
    return values;
  }
}

/**
 * Classe base per gli effetti temporizzati
 */
public abstract class EffectBaseStep implements IEffectOMatic
{
  private final int STEP = 15;
  private int iteration = 0;
 
  protected int length; 
  protected int[] values;
 
  public EffectBaseStep(int length)
  {
    this.length = length;
    values = new int[length];
  }
  
  protected boolean isStep()
  {
    iteration++;
    if(iteration == STEP)
    {
      iteration = 0;
      return true;
    }
    return false;
  }
  
  public int[] process(SoundAnalizerData data)
  {
    if(!isStep())
    {
      return values;
    }
    
    values = internalProcess(data);
    return values;
  }
  
  protected abstract int[] internalProcess(SoundAnalizerData data);
}

// -----------------------------------------------------------------------

/**
 * Effetto spento
 */
public class EffectOff implements IEffectOMatic
{
  protected int length; 
  protected int[] values;
 
  public EffectOff(int length)
  {
    this.length = length;
    values = new int[length];
  }
  
  public String getName() { return "Off"; }
  
  public String getDescription() { return "Spento"; }
  
  public int[] process(SoundAnalizerData data)
  {
    return values;
  }
}

/**
 * Effetto automatico (Kitt)
 */
public class EffectKitt extends EffectBaseStep
{ 
  private final int[] VALUE = new int[]{255, 200, 100, 50, 0};
  private int position = -1;
  private boolean forward = true;
 
  public EffectKitt(int length)
  {
    super(length);
  }
 
  public String getName() { return "Kitt"; }
  
  public String getDescription() { return "Kitt (SuperCar)"; }
  
  protected int[] internalProcess(SoundAnalizerData data)
  {
    if(forward)
    {
      position = (position + 1) % length;
      
      for(int i = position; i > 0; i--)
      {
        values[i] = values[i - 1];
      }
      if(position < VALUE.length)
      {
        values[0] = VALUE[position];
      }
      else
      {
        values[0] = 0;
      }
      for(int i = position + 1; i < (length - 1); i++)
      {
        values[i] = values[i + 1];
      }
      if(position < (length - 1))
      {
        values[(length - 1)] = 0;
      }
    }
    else
    {
      position = (position - 1) % length;
      
      for(int i = position; i < (length - 1); i++)
      {
        values[i] = values[i + 1];
      }
      
      if((length - 1) - position < VALUE.length)
      {
        values[(length - 1)] = VALUE[(length - 1) - position];
      }
      else
      {
        values[(length - 1)] = 0;
      }
      
      for(int i = position - 1; i > 0; i--)
      {
        values[i] = values[i - 1];
      }
      if(position > 0)
      {
        values[0] = 0;
      }
    }
    
    if(position == 0)
    {
      forward = true;
    }
    else if (position == (length - 1))
    {
      forward = false;
    }

    return values;
  }
}

/**
 * Effetto automatico (Disturbo)
 */
public class EffectNoise extends EffectBaseStep
{
  public EffectNoise(int length)
  {
    super(length);
  }
  
  public String getName() { return "Noise"; }
  
  public String getDescription() { return "Disturbo"; }
  
  protected int[] internalProcess(SoundAnalizerData data)
  {
    int[] ret = new int[length];
    for(int i = 0; i < length; i++)
    {
      ret[i] = int(random(255));
    }
    return ret;
  }
}

/**
 * Effetto beat (Goccia di pioggia) 
 */
public class EffectDrop extends EffectBeatDecay
{
  public EffectDrop(int length)
  {
    super(length);
  }
  
  public String getName() { return "Drop"; }
  
  public String getDescription() { return "Goccia"; }

  private int currentDrop;
  
  protected int getPattern(int index)
  {
    if(index == 0)
    {
      int newDrop = currentDrop;
      while(newDrop == currentDrop)
      {
        newDrop = int(random(length));
      }
      currentDrop = newDrop;
    }
    
    if(index == currentDrop)
    {
      return 255;
    }
    return values[index];
  }
  
  protected float getDecay(int index)
  {
    return 0.95;
  }
}

/**
 * Effetto beat (Colpo)
 */
public class EffectHit extends EffectBeatDecay
{
  public EffectHit(int length)
  {
    super(length);
  }

  private final int[] VALUE = new int[]{255, 180, 120, 75, 40, 20, 0};
  
  public String getName() { return "Hit"; }
  
  public String getDescription() { return "Colpo"; }
  
  protected int getPattern(int index)
  {
    int valueIndex = index - int(length / 2);
    //correzione in caso di lunghezza pari
    if(length % 2 == 0)
    {
      if(valueIndex < 0)
      {
        valueIndex = valueIndex + 1;
      }
    }
    // valore assoluto
    valueIndex = abs(valueIndex);
    // gestione indici superiori
    if(valueIndex >= VALUE.length)
    {
      valueIndex = VALUE.length - 1;
    }
    return VALUE[valueIndex];
  }
  
  protected float getDecay(int index)
  {
    return 0.95;
  }
}

/**
 * Effetto beat (Barra)
 */
public class EffectBar extends EffectBeatDecay
{
  public EffectBar(int length)
  {
    super(length);
  }
  
  private final float DECAY = 0.7;
  
  public String getName() { return "Bar"; }
  
  public String getDescription() { return "Barra"; }
  
  protected int getPattern(int index)
  {
    return 255;
  }
  
  protected float getDecay(int index)
  {
    if((values[index] > 0) && (index == (length - 1) || values[index + 1] == 0))
    {
      return DECAY;
    }
    return 1;
  }
}

/**
 * Effetto frequenze (Spettro)
 */
public class EffectSpectrum implements IEffectOMatic
{
  protected int length; 

  public EffectSpectrum(int length)
  {
    this.length = length;
  }
  
  public String getName() { return "Spectrum"; }
  
  public String getDescription() { return "Spettro"; }
  
  public int[] process(SoundAnalizerData data)
  {   
    int[] ret = new int[length];
    for(int i = 0; i < length; i++)
    {
      ret[i] = int(data.getValues()[i] * 255);
    }
    return ret;
  }
}
