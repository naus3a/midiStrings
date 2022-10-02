class UiView{
  private int _width = 300;
  private int _height = 720;
  private int _sensorH = 40;
  private int _sensorIdX = 20;
  private int _sensorRawValueX = 100;
  private int _sensorStartValueX = 140;
  private int _sensorDeltaValueX = 180;
  private Rectangle rSerial;
  private Rectangle rSensors;
  private Rectangle rCalibrate;
  private SerialManager _serial;
  private SensorManager _sensors;
  private boolean bOverBoard = false;
  private boolean bOverCalibrate = false;
  
  UiView(int w, int h, SerialManager sm, SensorManager ssm){
    _width = w;
    _height = h;
    _serial = sm;
    _sensors = ssm;
    
    rSerial= new Rectangle(0,0, _width, 40);
    rSensors = new Rectangle(0, rSerial.GetMaxY(), _width, _height-rSerial.GetMaxY());
    rCalibrate = new Rectangle(_sensorStartValueX-10, rSensors.y, 40, _sensorH);
  }
  
  void Draw(){
    drawSerialStatus();
    drawSensors();
  }
  
  void drawSerialStatus(){
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
  
  void drawSensors(){
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
  
  void drawSensorsHeader(){
    fill(100);
    rect(0, rSensors.y, _width, _sensorH);
    float textY = _sensorH+20;
    fill(255);
    text("raw", _sensorRawValueX, textY);
    text("start", _sensorStartValueX, textY);
    text("delta", _sensorDeltaValueX, textY);
  }
  
  void drawSensorGrid(){
    noFill();
    stroke(150);
    float x = _sensorRawValueX-20;
    line(x, rSensors.y, x, rSensors.GetMaxY());
    x = _sensorStartValueX-10;
    line(x, rSensors.y, x, rSensors.GetMaxY());
    x = _sensorDeltaValueX-10;
    line(x, rSensors.y, x, rSensors.GetMaxY());
  }
  
  void drawSensor(int sId){
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
      text(sd.GetDeltaValue(), _sensorDeltaValueX, textY);
    }
  }
  
  void OnMousePressed(int mx, int my){
    if(rSerial.IsInside(mx,my)){
      _serial.AutoConnect();
    }else if(rCalibrate.IsInside(mx,my)){
      _sensors.Calibrate();
    }
  }
  
  void OnMouseMoved(int mx, int my){
    bOverBoard = rSerial.IsInside(mx,my);
    bOverCalibrate = rCalibrate.IsInside(mx,my);
  }
  
  int GetWidth(){return _width;}
  int GetHeight(){return _height;}
}
