MidiManager midiManager = new MidiManager(this);
SensorManager sensorManager = new SensorManager(midiManager);
SerialManager serialManager = new SerialManager(this, sensorManager);
UiView ui;

void setup(){
  size(300, 600);
  
  midiManager.MakeMidiStrings(5, false, true, 1, 0);
  
  serialManager.AutoConnect();
  ui = new UiView(width,height, serialManager, sensorManager, midiManager);
}

void draw(){
  serialManager.Update();
  ui.Draw();
}

void mousePressed(){
  ui.OnMousePressed(mouseX, mouseY);
}

void mouseReleased(){
  ui.OnMouseReleased();
}

void mouseMoved(){
  ui.OnMouseMoved(mouseX, mouseY);
}
