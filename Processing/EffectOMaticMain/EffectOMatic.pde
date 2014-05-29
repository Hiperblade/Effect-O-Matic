/**
 */

public interface IEffectOMatic
{
  String getName();
  String getDescription();
  int[] process(float[] data, boolean beat);
}

public abstract class EffectBeatDecay implements IEffectOMatic
{
  protected int[] values = new int[] {0, 0, 0, 0, 0};
  
  protected abstract int getPattern(int index);
  
  protected abstract float getDecay(int index);
  
  public int[] process(float[] data, boolean beat)
  {
    if(beat)
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
  String getName() { return "Off"; }
  
  String getDescription() { return "Spento"; }
  
  public int[] process(float[] data, boolean beat)
  {
    return new int[] {0, 0, 0, 0, 0};
  }
}

public class EffectKitt extends EffectBaseStep
{
  private final int[] VALUE = new int[]{255, 200, 100, 50, 0};
  private int position = -1;
  private boolean forward = true;
 
  String getName() { return "Kitt"; }
  
  String getDescription() { return "Kitt (SuperCar)"; }
  
  public int[] process(float[] data, boolean beat)
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
  String getName() { return "Noise"; }
  
  String getDescription() { return "Disturbo"; }
  
  public int[] process(float[] data, boolean beat)
  {
    if(!isStep())
    {
      return values;
    }
    
    values = new int[]{ int(random(255)), int(random(255)), int(random(255)), int(random(255)), int(random(255)) };
    return values;
  }
}

public class EffectBeat extends EffectBeatDecay
{
  private final int[] VALUE = new int[]{120, 180, 255, 180, 120};
  
  String getName() { return "Beat"; }
  
  String getDescription() { return "Colpo"; }
  
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
  
  String getName() { return "Bar"; }
  
  String getDescription() { return "Barra"; }
  
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
  String getName() { return "Equalizer"; }
  
  String getDescription() { return "Equalizzatore"; }
  
  public int[] process(float[] data, boolean beat)
  {   
    int[] ret = new int[5];
    for(int i = 0; i < 5; i++)
    {
      ret[i] = int(data[i] * 255);
    }
    return ret;
  }
}

public class EffectEqualizerDecay extends EffectBeatDecay
{
  String getName() { return "EqualizerDecay"; }
  
  String getDescription() { return "Equ. Echo"; }
  
  private float[] incomingData;
  
  public int[] process(float[] data, boolean beat)
  {
    if(beat)
    {
      incomingData = data;
    }
    
    return super.process(data, beat);
  }
  
  protected int getPattern(int index)
  {
    return int(incomingData[index] * 255);
  }
  
  protected float getDecay(int index)
  {
    return 0.99;
  }
}
