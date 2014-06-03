/**
 * Effect-O-Matic 1.0
 */
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
      new EffectKitt(),
      new EffectNoise(),
      new EffectDrop(),
      new EffectHit(),
      new EffectBar(),
      new EffectSpectrum()
      },
      new EffectOff());

  // analizzatore del suono
  sound = new SoundAnalizer(this);
  
  // comando luci
  comm = new EffectOMaticCommander(this);
  comm.setValues(data);
  
  // visualizzatore
  soundVis = new SoundAnalizerVisualizer(int(width * boxX), int(height * 0.80));
  vis = new EffectOMaticVisualizer(int(width * boxX), int(height * 0.4), 30, 40, data.length);
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

