SensorManager sensorManager = new SensorManager();
SerialManager serialManager = new SerialManager(this, sensorManager);
UiView ui;

void setup(){
  size(300, 720);
  serialManager.AutoConnect();
  ui = new UiView(300,720, serialManager, sensorManager);
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
