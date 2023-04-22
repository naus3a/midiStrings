import themidibus.*;
import oscP5.*;
import netP5.*;

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
  
  int GetMidiChannel(){return _note.channel;}
  
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
  private OscP5 _osc;
  private NetAddress _netOut;
  private ArrayList<MidiString> _midiStrings = new ArrayList<MidiString>();
  private boolean _bMidiActive = true;
  private boolean _bOscActive = true;
  
  private final String _midiOutDevice = "Bus 1";
  private final int _oscPortOut = 12345;
  private final int _oscPortIn = 12344;
  
  MidiManager(PApplet parent){
    _parent = parent;
    MidiBus.list();
    _midi = new MidiBus(_parent, -1, _midiOutDevice);
    
    /*_midiStrings.add(new MidiString(12,0,127, this));
    _midiStrings.add(new MidiString(13,0,127, this));
    _midiStrings.add(new MidiString(14,0,127, this));
    _midiStrings.add(new MidiString(15,0,127, this));
    _midiStrings.add(new MidiString(16,0,127, this));*/
    
    _osc = new OscP5(_parent, _oscPortIn);
    _netOut = new NetAddress("172.20.10.7", _oscPortOut);//("255.255.255.255", _oscPortOut);
  }
  
  void MakeMidiStrings(int numStrings, boolean incrementChannel=false, boolean incrementNote=true, int startChannel=1, int startNote=0){
    int c = startChannel;
    int n = startNote;
    for(int i=0;i<numStrings;i++){
      _midiStrings.add(new MidiString(c, n, 127, this));
      if(incrementChannel)c++;
      if(incrementNote)n++;
    }
  }
  
  MidiString GetMidiString(int mId){
    if(mId<0 || mId>=_midiStrings.size())return null;
    return _midiStrings.get(mId);
  }
  
  boolean IsMidiActive(){return _bMidiActive;}
  boolean IsOscActive(){return _bOscActive;}
  
  void SetMidiActive(boolean b){_bMidiActive=b;}
  void ToggleMidiActive(){SetMidiActive(!IsMidiActive());}
  void SetOscActive(boolean b){_bOscActive=b;}
  void ToggleOscActive(){SetOscActive(!IsOscActive());}
  
  boolean SendNoteOn(Note n){
    boolean bMidi = SendMidiNoteOn(n);
    boolean bOsc = SendOscNote(n, true);
    return (bMidi||bOsc);
  }
  
  boolean SendNoteOff(Note n){
    boolean bMidi = SendMidiNoteOff(n);
    boolean bOsc = SendOscNote(n, false);
    return (bMidi||bOsc);
  }
  
  boolean SendMidiNoteOn(Note n){
    if(!IsMidiActive())return false;
    _midi.sendNoteOn(n);
    return true;
  }
  
  boolean SendMidiNoteOff(Note n){
    if(!IsMidiActive())return false;
    _midi.sendNoteOff(n);
    return true;
  }
  
  boolean SendOsc(OscMessage msg){
    if(!IsOscActive())return false;
    _osc.send(msg, _netOut);
    return true;
  }
  
  boolean SendOscNote(Note n, boolean noteOn){
    if(!IsOscActive())return false;
    return SendOsc(makeOscNoteMessage(n, noteOn));
  }
  
  private OscMessage makeOscMessage(String addr){
    OscMessage msg = new OscMessage(addr);
    return msg;
  }
  
  private OscMessage makeOscNoteMessage(Note n, boolean noteOn){
    String addr = "/NoteOn";
    if(!noteOn)addr = "/NoteOff";
    OscMessage msg = makeOscMessage(addr);
    msg.add(n.channel);
    msg.add(n.pitch);
    msg.add(n.velocity);
    return msg;
  }
  
  void TestNoteOn(){
    SendNoteOn(new Note(1,440,127));
  }
  
  void TestNoteOff(){
    SendNoteOff(new Note(1,440,127));
  }
}
