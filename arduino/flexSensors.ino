const int numSensors = 2;
const int flexPins[numSensors] = {A0, A1};
int flexValues[numSensors];

///
/// sensors
///

void updateSensors(){
  for(int i=0;i<numSensors;i++){
    updateSensor(i);
  }
}

void updateSensor(int sId){
  flexValues[sId] = analogRead(flexPins[sId]);
  printSensorValue(sId);
}

void printSensorValue(int sId){
  Serial.print(sId);
  Serial.print(":");
  Serial.println(flexValues[sId]);
}

///
/// Arduino
///

void setup() {
  Serial.begin(9600);  
}

void loop() {
  updateSensors();
}
