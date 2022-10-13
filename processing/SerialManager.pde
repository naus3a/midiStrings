import processing.serial.*;

class SerialManager{
  private PApplet _parent;
  private SensorManager _sensors;
  private Serial _serial;
  private String _portName = "";
  private boolean _bConnected;
  private final int _bytesPerMsg = 5;
  
  SerialManager(PApplet parent, SensorManager sensors){
    _parent = parent;
    _sensors = sensors;
    _bConnected = false;
  }
  
  ///
  /// connection
  ///
  
  boolean IsConnected(){
    return _bConnected;
  }
  
  void AutoConnect(){
    println("Trying to autoconnect; available ports: ");
    String[] ports = GetAvailablePorts();
    for(int i=0;i<ports.length;i++){
      println("\t"+ports[i]);
    }
    int idx = getGoodPortIndex(ports);
    if(idx<0){
      println("Autoconnect failed.");
      return;
    }
    Connect(ports[idx]);
  }
  
  void Connect(String portName){
    if(IsConnected()){
      if(portName==_portName){
        return;
      }
    }
    Disconnect();
    _serial = new Serial(_parent, portName, 9600);
    _bConnected = true;
    _portName = portName;
    println("Serial connected to "+_portName);
  }
  
  void Disconnect(){
    if(!IsConnected())return;
    _serial.stop();
    _serial = null;
    _bConnected = false;
    _portName = "";
    println("Serial disconnected.");
  }
  
  String[] GetAvailablePorts(){
    return Serial.list();
  }
  
  String GetPortName(){return _portName;}
  
  private int getGoodPortIndex(String[] ports){
    if(ports==null)return -1;
    if(ports.length<1)return -1;
    for(int i=0;i<ports.length;i++){
      if(ports[i].contains("COM") || ports[i].contains("tty.usbmodem")){
        return i;
      }
    }
    return -1;
  }
  
  ///
  /// read
  ///
  
  void Update(){
    //serial protocol is:
    //(int)sensorId:(int)value
    // so we're expecting:
    // 2bytes+1byte+2bytes
    String msg = "";
    if(_serial==null)return;
    while(_serial.available()>0){
      char c = (char)_serial.read();
      if(c=='\n'){
        SensorData sd = stringToSensorData(msg);
        _sensors.Update(sd);
        msg = "";
      }else{
        msg += c;
      }
    }
  }
  
  private SensorData stringToSensorData(String s){
    if(s.length()>4){
      if(s.charAt(1)==':'){
        String sId = s.substring(0,1);
        String sVal = s.substring(2, s.length()-1);
        int iId = -1;
        int iVal = -1;
        try{
          iId = Integer.parseInt(sId);
        }catch(NumberFormatException ex){
          ex.printStackTrace();
          return null;
        }
        try{
          iVal = Integer.parseInt(sVal);
        }catch(NumberFormatException ex){
          ex.printStackTrace();
          return null;
        }
        return new SensorData(iId, iVal);
      }
    }
    return null;
  }
}
