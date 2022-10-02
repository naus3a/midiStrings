class SensorData{
  int sensorId = -1;
  int sensorValue = -1;
  int startValue = -1;
  private int _lastDelta = 0;
  
  SensorData(){}
  
  SensorData(int sId, int sVal){
    sensorId = sId;
    InitValue(sVal);
  }
  
  void InitValue(int val){
    sensorValue = val;
    SetStartValueToCurValue();
    _lastDelta = 0;
  }
  
  void SetStartValueToCurValue(){
    startValue = sensorValue;
  }
  
  void UpdateValue(int val){
    sensorValue = val;
    UpdateDeltaValue();
  }
  
  void UpdateDeltaValue(){
    _lastDelta =  abs(startValue-sensorValue);
  }
  
  int GetLastDeltaValue(){return _lastDelta;}
}

class SensorManager{
  private ArrayList<SensorData> _values = new ArrayList<SensorData>();
  
  SensorManager(){}
  
  
  int GetNumSensors(){ return _values.size();}
  
  SensorData GetSensorData(int sId){
    if(sId<0 || sId>=_values.size()){
      return null;
    }
    return _values.get(sId);
  }
  
  void Update(SensorData sd){
    if(sd==null)return;
    boolean bNew = expandSensorsIfNeeded(sd);
    if(bNew){
      _values.get(sd.sensorId).InitValue(sd.sensorValue);
    }else{
      _values.get(sd.sensorId).UpdateValue(sd.sensorValue);
    }
  }
  
  void Calibrate(){
    for(int i=0;i<_values.size();i++){
      _values.get(i).SetStartValueToCurValue();
    }
  }
  
  private boolean expandSensorsIfNeeded(SensorData sd){
    if(_values.size()>sd.sensorId)return false;
    while(_values.size()<=sd.sensorId){
      _values.add(new SensorData(_values.size(),0));
    }
    return true;
  }
}
