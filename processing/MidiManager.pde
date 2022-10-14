import themidibus.*;

class MidiString{
  private Note _note;
  private String _noteName = "";
  private boolean _noteTriggered = false;
  private MidiManager _midi;
  int _lastNoteStateChange = 0;
  int _minNoteStateChangeTime = 100;
  
  MidiString(){}
  
  MidiString(int chan, int freq, int vel, MidiManager midi){
    MakeNote(chan, freq, vel);
    LinkMidi(midi);
  }
  
  void MakeNote(int chan, int freq, int vel){
    _note = new Note(chan, freq, vel);
    _noteName = _note.name()+_note.octave();
    _lastNoteStateChange = millis();
  }
  
  void LinkMidi(MidiManager midi){
    _midi = midi;
  }
  
  String GetNoteName(){return _noteName;}
  
  void SetNoteTriggered(boolean b){
    if(b==_noteTriggered)return;
    if(!DidEnoughTimePassSinceLastNoteStateChange())return;
    _noteTriggered = b;
    if(_midi!=null){
      if(_noteTriggered){
        if(_midi.SendNoteOn(_note)){
          println(_noteName+" ON");
          _lastNoteStateChange = millis();
        }
      }else{
        if(_midi.SendNoteOff(_note)){
          println(_noteName+" OFF");
          _lastNoteStateChange = millis();
        }
      }
    }
  }
  
  private boolean DidEnoughTimePassSinceLastNoteStateChange(){
    return(millis()-_lastNoteStateChange)>_minNoteStateChangeTime;
  }
  
  boolean IsTriggered(){return _noteTriggered;}
}

class MidiManager{
  private PApplet _parent;
  private MidiBus _midi;
  private ArrayList<MidiString> _midiStrings = new ArrayList<MidiString>();
  private boolean _bMidiActive = true;
  
  MidiManager(PApplet parent){
    _parent = parent;
    MidiBus.list();
    _midi = new MidiBus(_parent, -1, "Bus 1");
    
    _midiStrings.add(new MidiString(1,1,127, this));
    _midiStrings.add(new MidiString(1,2,127, this));
  }
  
  MidiString GetMidiString(int mId){
    if(mId<0 || mId>=_midiStrings.size())return null;
    return _midiStrings.get(mId);
  }
  
  boolean IsMidiActive(){return _bMidiActive;}
  
  void SetMidiActive(boolean b){_bMidiActive=b;}
  void ToggleMidiActive(){SetMidiActive(!IsMidiActive());}
  
  boolean SendNoteOn(Note n){
    if(!IsMidiActive())return false;
    _midi.sendNoteOn(n);
    return true;
  }
  
  boolean SendNoteOff(Note n){
    if(!IsMidiActive())return false;
    _midi.sendNoteOff(n);
    return true;
  }
  
  void TestNoteOn(){
    SendNoteOn(new Note(1,440,127));
  }
  
  void TestNoteOff(){
    SendNoteOff(new Note(1,440,127));
  }
}
