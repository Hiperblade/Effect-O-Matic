/**
 */

public interface IEffectOMatic
{
  String getName();
  String getDescription();
  int[] process(SoundAnalizerData data);
}

public abstract class EffectBeatDecay implements IEffectOMatic
{
  protected int[] values = new int[] {0, 0, 0, 0, 0};
  
  protected abstract int getPattern(int index);
  
  protected abstract float getDecay(int index);
  
  public int[] process(SoundAnalizerData data)
  {
    if(data.getBeat())
    {
      for(int i = 0; i < 5; i++)
      {
        values[i] = getPattern(i);
      }
    }
    else
    {
      for(int i = 0; i < 5; i++)
      {
        values[i] = int(values[i] * getDecay(i));
      }
    }
    return values;
  }
}

public abstract class EffectBaseStep implements IEffectOMatic
{
  private final int STEP = 15;
  private int iteration = 0;
 
  protected int[] values = new int[]{0, 0, 0, 0, 0};
  
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
}

// ------------------------------------------------------------------------------

public class EffectOff implements IEffectOMatic
{
  public String getName() { return "Off"; }
  
  public String getDescription() { return "Spento"; }
  
  public int[] process(SoundAnalizerData data)
  {
    return new int[] {0, 0, 0, 0, 0};
  }
}

public class EffectKitt extends EffectBaseStep
{
  private final int[] VALUE = new int[]{255, 200, 100, 50, 0};
  private int position = -1;
  private boolean forward = true;
 
  public String getName() { return "Kitt"; }
  
  public String getDescription() { return "Kitt (SuperCar)"; }
  
  public int[] process(SoundAnalizerData data)
  {
    if(!isStep())
    {
      return values;
    }
    
    if(forward)
    {
      position = (position + 1) % 5;
      
      for(int i = position; i > 0; i--)
      {
        values[i] = values[i - 1];
      }
      values[0] = VALUE[position];
      for(int i = position + 1; i < 4; i++)
      {
        values[i] = values[i + 1];
      }
      if(position < 4)
      {
        values[4] = 0;
      }
    }
    else
    {
      position = (position - 1) % 5;
      
      for(int i = position; i < 4; i++)
      {
        values[i] = values[i + 1];
      }
      values[4] = VALUE[4 - position];
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
    else if (position == 4)
    {
      forward = false;
    }

    return values;
  }
}

public class EffectNoise extends EffectBaseStep
{
  public String getName() { return "Noise"; }
  
  public String getDescription() { return "Disturbo"; }
  
  public int[] process(SoundAnalizerData data)
  {
    if(!isStep())
    {
      return values;
    }
    
    values = new int[]{ int(random(255)), int(random(255)), int(random(255)), int(random(255)), int(random(255)) };
    return values;
  }
}

public class EffectDrop extends EffectBeatDecay
{
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
        newDrop = int(random(5));
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

public class EffectBeat extends EffectBeatDecay
{
  private final int[] VALUE = new int[]{120, 180, 255, 180, 120};
  
  public String getName() { return "Beat"; }
  
  public String getDescription() { return "Colpo"; }
  
  protected int getPattern(int index)
  {
    return VALUE[index];
  }
  
  protected float getDecay(int index)
  {
    return 0.95;
  }
}

public class EffectBar extends EffectBeatDecay
{
  private final float DECAY = 0.7;
  
  public String getName() { return "Bar"; }
  
  public String getDescription() { return "Barra"; }
  
  protected int getPattern(int index)
  {
    return 255;
  }
  
  protected float getDecay(int index)
  {
    if((values[index] > 0) && (index == 4 || values[index + 1] == 0))
    {
      return DECAY;
    }
    return 1;
  }
}

public class EffectEqualizer implements IEffectOMatic
{
  public String getName() { return "Equalizer"; }
  
  public String getDescription() { return "Equalizzatore"; }
  
  public int[] process(SoundAnalizerData data)
  {   
    int[] ret = new int[5];
    for(int i = 0; i < 5; i++)
    {
      ret[i] = int(data.getValues()[i] * 255);
    }
    return ret;
  }
}

/*
public class EffectEqualizerDecay extends EffectBeatDecay
{
  public String getName() { return "EqualizerDecay"; }
  
  public String getDescription() { return "Equ. Echo"; }
  
  private SoundAnalizerData incomingData;
  
  public int[] process(SoundAnalizerData data)
  {
    if(data.getBeat())
    {
      incomingData = data;
    }
    
    return super.process(data);
  }
  
  protected int getPattern(int index)
  {
    return int(incomingData.getValues()[index] * 255);
  }
  
  protected float getDecay(int index)
  {
    return 0.99;
  }
}
*/
