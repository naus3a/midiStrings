class SensorData{
  int sensorId = -1;
  int sensorValue = -1;
  int startValue = -1;
  int threshold = 20;
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
  
  boolean IsTriggered(){
    return (_lastDelta>threshold);
  }
}

class SensorManager{
  private MidiManager _midi;
  private ArrayList<SensorData> _values = new ArrayList<SensorData>();
  
  SensorManager(MidiManager midi){
    _midi = midi;
  }
  
  
  int GetNumSensors(){ return _values.size();}
  
  SensorData GetSensorData(int sId){
    if(sId<0 || sId>=_values.size()){
      return null;
    }
    return _values.get(sId);
  }
  
  void Update(SensorData sd){
    if(sd==null)return;
    boolean oldTriggered = false;
    boolean bNew = expandSensorsIfNeeded(sd);
    if(bNew){
      _values.get(sd.sensorId).InitValue(sd.sensorValue);
    }else{
      oldTriggered = _values.get(sd.sensorId).IsTriggered();
      _values.get(sd.sensorId).UpdateValue(sd.sensorValue);
    }
    boolean newTriggered = _values.get(sd.sensorId).IsTriggered();
    
    if(oldTriggered!=newTriggered){
      MidiString ms = _midi.GetMidiString(sd.sensorId);
      if(ms!=null){
        ms.SetNoteTriggered(_values.get(sd.sensorId).IsTriggered());
      }
    }
  }
  
  void UpdateWatchDog(){
    for(int i=0;i<_midi.GetNumMidiStrings();i++){
      MidiString ms = _midi.GetMidiString(i);
      if(ms.IsTriggered()){
        if(!_values.get(i).IsTriggered()){
          ms.SetNoteTriggered(false);
        }
      }
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
