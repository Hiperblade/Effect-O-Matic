/**
 * Effect-O-Matic 1.0
 */
final int LENGTH = 5;
//final int LENGTH = 10;

SoundAnalizer sound;
EffectOMaticControlPanel controlPanel;
EffectOMaticCommander comm;
SoundAnalizerVisualizer soundVis;
EffectOMaticVisualizer vis;

int[] data = new int[]{0, 0, 0, 0, 0};

PFont fontTitle;
float boxX = 0.3;

void setup()
{
  size(640, 360);

  fontTitle = createFont("Arial", 32, true);

  // pulsantiera
  controlPanel = new EffectOMaticControlPanel(
    int(width * 0.66) - 30, 10,
    new IEffectOMatic[]{
      new EffectKitt(LENGTH),
      new EffectNoise(LENGTH),
      new EffectDrop(LENGTH),
      new EffectHit(LENGTH),
      new EffectBar(LENGTH),
      new EffectSpectrum(LENGTH)
      },
      new EffectOff(LENGTH));

  // analizzatore del suono
  sound = new SoundAnalizer(this);
  
  // comando luci
  comm = new EffectOMaticCommander(this);
  comm.setValues(data);
  
  // visualizzatore
  soundVis = new SoundAnalizerVisualizer(int(width * boxX), int(height * 0.80));
  if(LENGTH <= 6)
  {
    vis = new EffectOMaticVisualizer(int(width * boxX), int(height * 0.4), 30, 40, LENGTH);
  }
  else
  {
    vis = new EffectOMaticVisualizer(int(width * boxX), int(height * 0.4), 20, 40, LENGTH);
  }
  vis.setValues(data);
}

void draw()
{
  // campionamento
  sound.next();
  
  // elaborazione effetto
  IEffectOMatic currentEffect = controlPanel.getCurrentEffect();
  data = currentEffect.process(sound.getData());
  
  // trasmissione effetto ad arduino
  comm.setValues(data);
  
  // visualizzazione
  background(color(50));
  
  // visualizzazione titolo
  stroke(250);
  fill(color(250));
  textAlign(CENTER);
  textFont(fontTitle);
  text("Effect-O-Matic 1.0", int(width * boxX), int(height * 0.15)); 
  
  // visualizzazione effetto
  vis.draw(data);
  
  // visualizzazione campionamento
  soundVis.draw(sound.getData());
  
  // visualizzazione pulsanti
  controlPanel.draw();
}

void stop()
{
  sound.stop();
  super.stop();
}

/**
 * Gestione mouse
 */
void mousePressed() {
  controlPanel.mousePressed();
}

