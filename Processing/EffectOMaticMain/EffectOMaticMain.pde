/**
 *
 */

import java.util.Map;

int RANDOM_TIMER = 5000; // 5 secondi

SoundAnalizer sound;
SoundAnalizerVisualizer soundVis;

EffectOMaticVisualizer vis;
EffectOMaticCommander comm;
int[] data = new int[]{0, 0, 0, 0, 0};

RadioButtonGroup group1;
RadioButtonGroup group2;
RadioButtonGroup group3;

IEffectOMatic eom;
IEffectOMatic OFF = new EffectOff();
HashMap<String, IEffectOMatic> effectsMap;
private float timeStamp = 0;
IEffectOMatic[] effects;

PFont fontTitle;
PFont fontControlls;

int baseX;
int baseY = 10;
float boxX = 0.3;

void setup()
{
  size(640, 360);
  baseX = int(width * 0.66) - 30;
  
  ellipseMode(CENTER);
  rectMode(CENTER);

  fontTitle = createFont("Arial", 32, true);
  fontControlls = createFont("Arial", 16, true);
  
  // visualizzatore
  vis = new EffectOMaticVisualizer(int(width * boxX), int(height * 0.4), 30, 40, data.length);
  vis.setValues(data);

  comm = new EffectOMaticCommander(this);
  comm.setValues(data);

  effects = new IEffectOMatic[]{ new EffectKitt(), new EffectNoise(), new EffectBeat(), new EffectBar(), new EffectEqualizer(), new EffectEqualizerDecay() };  
  
  // controlli
  effectsMap = new HashMap<String, IEffectOMatic>();
  group1 = new RadioButtonGroup();
  group1.add(new RadioButton(OFF.getName(), OFF.getDescription(), baseX, baseY + 30));
  group1.add(new RadioButton("Single", "Solo selezionato", baseX + 30, baseY + 60));
  group1.add(new RadioButton("Random", "Casuale", baseX + 60, baseY + 90));
  group1.setValue(OFF.getName());
 
  eom = OFF;
 
  int verticalPosition = 140;
  group2 = new RadioButtonGroup(false);
  group3 = new RadioButtonGroup();
  for (int i = 0; i < effects.length; i++)
  {
    effectsMap.put(effects[i].getName(), effects[i]);
    group2.add(new RadioButton(effects[i].getName(), effects[i].getDescription(), baseX + 60, baseY + verticalPosition + (30 * i)));
    group3.add(new RadioButton(effects[i].getName(), "", baseX + 30, baseY + verticalPosition + (30 * i)));
  }
 
  sound = new SoundAnalizer(this);
  
  soundVis = new SoundAnalizerVisualizer(int(width * boxX), int(height * 0.80));
}

void draw()
{
  if(group1.getValue() == OFF.getName())
  {
    eom = OFF;
  }
  else if(group1.getValue() == "Single")
  {
    if(group3.getValue() != null)
    {
      eom = effectsMap.get(group3.getValue());
    }
    else
    {
      eom = OFF;
    }
  }
  else if(group1.getValue() == "Random")
  {
    if((millis() - timeStamp > RANDOM_TIMER) || (eom == null))
    {
      timeStamp = millis();
      if(group2.getValues().size() > 0)
      {
        eom = effectsMap.get(group2.getValues().get(int(random(group2.getValues().size()))));
      }
      else
      {
        eom = effects[int(random(effects.length))];
      }
    }
  }
  
  background(color(50));
  stroke(0);
  textFont(fontControlls);
  
  sound.next();
  soundVis.setValues(sound.getData());
  data = eom.process(sound.getData());
  comm.setValues(data);
  vis.setValues(data);
  
  group1.draw();
  group2.draw();
  group3.draw();
  soundVis.draw();
  vis.draw();
  
  stroke(250);
  fill(color(250));

  rect(baseX, baseY + 82 + 90, 3, 76 + 180);
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
  
  textAlign(CENTER);
  textFont(fontTitle);
  text("Effect-O-Matic 1.0", int(width * boxX), int(height * 0.15)); 
}

void stop()
{
  sound.stop();
  super.stop();
}

void debugGroup(RadioButtonGroup group)
{
  ArrayList<String> a = group.getValues();
  print("{ ");
  for (int i = 0; i < a.size(); i++)
  {
    print(a.get(i) + " ");
  }
  println("}");
}

void mousePressed() {
  group1.mousePressed();
  group2.mousePressed();
  group3.mousePressed();
}

