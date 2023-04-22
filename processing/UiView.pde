class UiView{
  private float noiseR;
  private float noiseCtrY;
  private float noiseStart;
  private float noiseStop;
  private float noiseRange;
  private int _width = 300;
  private int _height = 720;
  private int _sensorH = 40;
  private int _sensorIdX = 20;
  private int _sensorRawValueX = 100;
  private int _sensorStartValueX = 140;
  private int _sensorDeltaValueX = 180;
  private int _midiNoteX = 220;
  private int _midiChanX = 260;
  private int _noteClicked = -1;
  private Rectangle rSerial;
  private Rectangle rSensors;
  private Rectangle rCalibrate;
  private Rectangle rFooter;
  private Rectangle rMidiActive;
  private Rectangle rOscActive;
  private Rectangle rNoise;
  private SerialManager _serial;
  private SensorManager _sensors;
  private MidiManager _midi;
  private boolean bOverBoard = false;
  private boolean bOverCalibrate = false;
  
  UiView(int w, int h, SerialManager sm, SensorManager ssm, MidiManager mm){
    _width = w;
    _height = h;
    _serial = sm;
    _sensors = ssm;
    _midi = mm;
    
    rSerial= new Rectangle(0,0, _width, 40);
    rSensors = new Rectangle(0, rSerial.GetMaxY(), _width, _height-rSerial.GetMaxY());
    rCalibrate = new Rectangle(_sensorStartValueX-10, rSensors.y, 40, _sensorH);
    rFooter = new Rectangle(0, _height-40, _width, 40);
    rMidiActive = new Rectangle(rFooter.x, rFooter.y, 80, rFooter.height);
    rOscActive = new Rectangle(rMidiActive.GetMaxX(), rFooter.y, 80, rFooter.height);
    rNoise = new Rectangle(rOscActive.GetMaxX(), rFooter.y, rFooter.width-rOscActive.width-rMidiActive.width, rFooter.height);
    
    noiseR = rNoise.height/2;
    noiseCtrY = rNoise.y+rNoise.height/2;
    noiseStart = rNoise.x + noiseR;
    noiseStop = rNoise.GetMaxX()-noiseR;
    noiseRange = noiseStop-noiseStart;
  }
  
  void Draw(){
    drawSerialStatus();
    drawSensors();
    drawFooter();
    drawNoise(_midi.GetNoiseParam());
  }
  
  private void drawSerialStatus(){
    noStroke();
    fill(0);
    rSerial.Draw();
    if(_serial.IsConnected()){
      fill(0,255,0);
      text("Sensor Board: "+_serial.GetPortName(), 20,20);
    }else{
      fill(255,0,0);
      text("Sensor Board: not connected", 20,20);
    }
    if(bOverBoard){
      fill(255,255,255,50);
      rSerial.Draw();
    }
  }
  
  private void drawFooter(){
    noStroke();
    fill(0);
    rFooter.Draw();
    if(_midi.IsMidiActive()){
      fill(0,255,0, 50);
    }else{
      fill(255,0,0,50);
    }
    rMidiActive.Draw();
    fill(255);
    text("MIDI", rMidiActive.x+20, rMidiActive.y+20);
    if(_midi.IsOscActive()){
      fill(0,255,0, 50);
    }else{
      fill(255,0,0,50);
    }
    rOscActive.Draw();
    fill(255);
    text("OSC", rOscActive.x+20, rOscActive.y+20);
  }
  
  private void drawSensors(){
    drawSensorsHeader();
    for(int i=0;i<_sensors.GetNumSensors();i++){
      drawSensor(i);
    }
    drawSensorGrid();
    if(bOverCalibrate){
      fill(255,255,255,50);
      rCalibrate.Draw();
    }
  }
  
  private void drawSensorsHeader(){
    fill(100);
    rect(0, rSensors.y, _width, _sensorH);
    float textY = _sensorH+20;
    fill(255);
    text("raw", _sensorRawValueX, textY);
    text("start", _sensorStartValueX, textY);
    text("delta", _sensorDeltaValueX, textY);
    text("note", _midiNoteX, textY);
    text("chan", _midiChanX, textY);
  }
  
  private void drawSensorGrid(){
    noFill();
    stroke(150);
    float x = _sensorRawValueX-20;
    line(x, rSensors.y, x, rSensors.GetMaxY());
    x = _sensorStartValueX-10;
    line(x, rSensors.y, x, rSensors.GetMaxY());
    x = _sensorDeltaValueX-10;
    line(x, rSensors.y, x, rSensors.GetMaxY());
    x = _midiNoteX-10;
    line(x, rSensors.y, x, rSensors.GetMaxY());
    x = _midiChanX-10;
    line(x, rSensors.y, x, rSensors.GetMaxY());
  }
  
  private void drawSensor(int sId){
    noStroke();
    if(sId%2==0){
      fill(50);
    }else{
      fill(100);
    }
    float y = rSensors.y+((sId+1)*_sensorH);
    rect(0,y, _width, _sensorH);
    fill(255);
    float textY = y+20;
    text("string "+sId, _sensorIdX, textY);
    SensorData sd = _sensors.GetSensorData(sId);
    if(sd!=null){
      text(sd.sensorValue, _sensorRawValueX, textY);
      text(sd.startValue, _sensorStartValueX, textY);
      text(sd.GetLastDeltaValue(), _sensorDeltaValueX, textY);
      MidiString ms = _midi.GetMidiString(sId);
      if(ms!=null){
        text(ms.GetNoteName(), _midiNoteX, textY);
        text(ms.GetMidiChannel(), _midiChanX, textY);
        if(ms.IsTriggered()){
          fill(0,255,0, 100);
          rect(_midiNoteX-10, y, 40, _sensorH);
          noFill();
        }
      }
      if(sd.IsTriggered()){
        fill(0,255,0, 100);
        rect(_sensorDeltaValueX-10, y, 40, _sensorH);
      }
    }
  }
  
  void drawNoise(float pct){
    float x = map(pct, 0,1, noiseStart, noiseStop);
    push();
    noFill();
    stroke(255);
    rect(rNoise.x, rNoise.y, rNoise.width, rNoise.height);
    noStroke();
    fill(255,255,255,50);
    rect(rNoise.x, rNoise.y, map(_midi.GetNoiseSpeed(), _midi.GetMinNoiseSpeed(), _midi.GetMaxNoiseSpeed(), 0, rNoise.width) ,rNoise.height);
    fill(255,255,255,100);
    ellipse(x,noiseCtrY, noiseR,noiseR);
    pop();
  }
  
  private Rectangle GetNoteRectangle(int sId){
    Rectangle r = new Rectangle();
    r.x = _midiNoteX;
    r.y = rSensors.y+((sId+1)*_sensorH);
    r.width = 40;
    r.height = _sensorH;
    return r;
  }
  
  void OnNotesPressed(int mx, int my){
    _noteClicked = -1;
    for(int i=0;i<_sensors.GetNumSensors();i++){
      if(OnNotePressed(i, mx, my))return;
    }
  }
  
  boolean OnNotePressed(int sId, int mx, int my){
    Rectangle r = GetNoteRectangle(sId);
    if(r.IsInside(mx,my)){
      MidiString ms = _midi.GetMidiString(sId);
      if(ms!=null){
        ms.SetNoteTriggered(true);
        _noteClicked = sId;
      }
      return true;
    }else{
      return false;
    }
  }
  
  void OnMousePressed(int mx, int my){
    if(rSerial.IsInside(mx,my)){
      _serial.AutoConnect();
    }else if(rCalibrate.IsInside(mx,my)){
      _sensors.Calibrate();
    }else if(rMidiActive.IsInside(mx,my)){
      _midi.ToggleMidiActive();
    }else if(rOscActive.IsInside(mx,my)){
      _midi.ToggleOscActive();
    }else if(rNoise.IsInside(mx,my)){
      float nv = map(mx, rNoise.x, rNoise.GetMaxX(), _midi.GetMinNoiseSpeed(), _midi.GetMaxNoiseSpeed());
      _midi.SetNoiseSpeed(nv);
    }else{
      OnNotesPressed(mx, my);
    }
  }
  
  void OnMouseReleased(){
    if(_noteClicked>=0){
      MidiString ms = _midi.GetMidiString(_noteClicked);
      if(ms!=null){
        ms.SetNoteTriggered(false);
      }
      _noteClicked = -1;
    }
  }
  
  void OnMouseMoved(int mx, int my){
    bOverBoard = rSerial.IsInside(mx,my);
    bOverCalibrate = rCalibrate.IsInside(mx,my);
  }
  
  void KeyPressed(char k){
    if(k=='n'){
      _midi.ToggleNoiseParam();
    }
  }
  
  
  int GetWidth(){return _width;}
  int GetHeight(){return _height;}
}
