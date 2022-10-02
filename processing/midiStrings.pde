MidiManager midiManager = new MidiManager();
SensorManager sensorManager = new SensorManager(midiManager);
SerialManager serialManager = new SerialManager(this, sensorManager);
UiView ui;

void setup(){
  size(300, 300);
  serialManager.AutoConnect();
  ui = new UiView(300,720, serialManager, sensorManager, midiManager);
}

void draw(){
  serialManager.Update();
  ui.Draw();
}

void mousePressed(){
  ui.OnMousePressed(mouseX, mouseY);
}

void mouseMoved(){
  ui.OnMouseMoved(mouseX, mouseY);
}
