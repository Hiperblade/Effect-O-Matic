/**
 */

public class EffectOMaticControlPanel
{
  private static final int RANDOM_TIMER_DEFAULT = 60000; // 60 secondi
  private int randomTime;
  private float timeStamp = 0;
  
  private HashMap<String, IEffectOMatic> effectsMap;
  private IEffectOMatic[] effects;
  private IEffectOMatic offEffect;
  private IEffectOMatic currentEffect;

  private int baseX;
  private int baseY;
  private PFont fontControlls;
  private RadioButtonGroup group1;
  private RadioButtonGroup group2;
  private RadioButtonGroup group3;
  
  public EffectOMaticControlPanel(int x, int y, IEffectOMatic[] effects, IEffectOMatic offEffect)
  {
    this(x, y, effects, offEffect, RANDOM_TIMER_DEFAULT);
  }
  
  public EffectOMaticControlPanel(int x, int y, IEffectOMatic[] effects, IEffectOMatic offEffect, int randomTime)
  {
    this.randomTime = randomTime;
    this.effects = effects;
    this.offEffect = offEffect;
    currentEffect = offEffect;
    
    fontControlls = createFont("Arial", 16, true);
    baseX = x;
    baseY = y;
    
    group1 = new RadioButtonGroup();
    group1.add(new RadioButton(offEffect.getName(), offEffect.getDescription(), baseX, baseY + 30));
    group1.add(new RadioButton("Single", "Solo selezionato", baseX + 30, baseY + 60));
    group1.add(new RadioButton("Random", "Casuale", baseX + 60, baseY + 90));
    group1.setValue(offEffect.getName());
   
    group2 = new RadioButtonGroup(false);
    group3 = new RadioButtonGroup();
    
    int verticalPosition = 140;
    effectsMap = new HashMap<String, IEffectOMatic>();
    for (int i = 0; i < effects.length; i++)
    {
      effectsMap.put(effects[i].getName(), effects[i]);
      group2.add(new RadioButton(effects[i].getName(), effects[i].getDescription(), baseX + 60, baseY + verticalPosition + (30 * i)));
      group3.add(new RadioButton(effects[i].getName(), "", baseX + 30, baseY + verticalPosition + (30 * i)));
    }
  }
  
  /**
    * Restituisce l'effetto corrente
    */
  public IEffectOMatic getCurrentEffect()
  {
    if(group1.getValue() == offEffect.getName())
    {
      currentEffect = offEffect;
    }
    else if(group1.getValue() == "Single")
    {
      if(group3.getValue() != null)
      {
        currentEffect = effectsMap.get(group3.getValue());
      }
      else
      {
        currentEffect = offEffect;
      }
    }
    else if(group1.getValue() == "Random")
    {
      if((millis() - timeStamp > randomTime) || (currentEffect == null))
      {
        timeStamp = millis();
        if(group2.getValues().size() > 0)
        {
          currentEffect = effectsMap.get(group2.getValues().get(int(random(group2.getValues().size()))));
        }
        else
        {
          currentEffect = effects[int(random(effects.length))];
        }
      }
    }
    return currentEffect;
  }
  
  public void draw()
  {
    textFont(fontControlls);
        
    group1.draw();
    group2.draw();
    group3.draw();
    
    stroke(250);
    fill(color(250));
    rectMode(CENTER);
      
    rect(baseX, baseY + 82 + int(30 * effects.length / 2), 3, 76 + (30 * effects.length));
    //rect(baseX, baseY + 82 + 90, 3, 76 + 180);
    /*
    rect(baseX, baseY + 82, 3, 76);
    beginShape();
    vertex(baseX - 5, baseY + 120);
    vertex(baseX + 4, baseY + 120);
    vertex(baseX, baseY + 125);
    endShape(CLOSE);
    // */
    
    rect(baseX + 30, baseY + 97, 3, 46);
    beginShape();
    vertex(baseX + 30 - 5, baseY + 120);
    vertex(baseX + 30 + 4, baseY + 120);
    vertex(baseX + 30, baseY + 125);
    endShape(CLOSE);
    
    rect(baseX + 60, baseY + 112, 3, 16);
    beginShape();
    vertex(baseX + 60 - 5, baseY + 120);
    vertex(baseX + 60 + 4, baseY + 120);
    vertex(baseX + 60, baseY + 125);
    endShape(CLOSE);
  }
  
  void mousePressed() {
    group1.mousePressed();
    group2.mousePressed();
    group3.mousePressed();
  }
}
