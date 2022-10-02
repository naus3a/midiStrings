//TODO: this is just placeholder code

class MidiString{
  private String _noteName = "C0";
  private boolean _noteTriggered = false;
  
  MidiString(){}
  MidiString(String noteName){
    SetNote(noteName);
  }
  
  void SetNote(String noteName){
    _noteName = noteName;
  }
  
  String GetNoteName(){return _noteName;}
  
  void SetNoteTriggered(boolean b){
    if(b==_noteTriggered)return;
    _noteTriggered = b;
  }
}

class MidiManager{
  private ArrayList<MidiString> _midiStrings = new ArrayList<MidiString>();
  
  MidiManager(){
    _midiStrings.add(new MidiString("C0"));
    _midiStrings.add(new MidiString("D0"));
  }
  
  MidiString GetMidiString(int mId){
    if(mId<0 || mId>=_midiStrings.size())return null;
    return _midiStrings.get(mId);
  }
}
