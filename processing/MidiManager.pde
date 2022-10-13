import themidibus.*;

class MidiString{
  private Note _note;
  private String _noteName = "";
  private boolean _noteTriggered = false;
  private MidiBus _midi;
  
  MidiString(){}
  
  MidiString(int chan, int freq, int vel, MidiBus midi){
    MakeNote(chan, freq, vel);
    LinkMidi(midi);
  }
  
  void MakeNote(int chan, int freq, int vel){
    _note = new Note(chan, freq, vel);
    _noteName = _note.name()+_note.octave();
  }
  
  void LinkMidi(MidiBus midi){
    _midi = midi;
  }
  
  String GetNoteName(){return _noteName;}
  
  void SetNoteTriggered(boolean b){
    println(b);
    if(b==_noteTriggered)return;
    _noteTriggered = b;
    if(_midi!=null){
      if(_noteTriggered){
        _midi.sendNoteOn(_note);
        println(_noteName+" ON");
      }else{
        _midi.sendNoteOff(_note);
        println(_noteName+" OFF");
      }
    }
  }
  
  boolean IsTriggered(){return _noteTriggered;}
}

class MidiManager{
  private PApplet _parent;
  private MidiBus _midi;
  private ArrayList<MidiString> _midiStrings = new ArrayList<MidiString>();
  
  MidiManager(PApplet parent){
    _parent = parent;
    MidiBus.list();
    _midi = new MidiBus(_parent, -1, "Bus 1");
    
    _midiStrings.add(new MidiString(1,1,127, _midi));
    _midiStrings.add(new MidiString(1,2,127,_midi));
  }
  
  MidiString GetMidiString(int mId){
    if(mId<0 || mId>=_midiStrings.size())return null;
    return _midiStrings.get(mId);
  }
  
  public void TestOn(){
    _midi.sendNoteOn(new Note(1,440,127));
  }
  
  public void TestOff(){
    _midi.sendNoteOff(new Note(1,440,127));
  }
}
