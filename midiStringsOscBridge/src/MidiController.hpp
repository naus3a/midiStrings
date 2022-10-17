//
//  MidiController.hpp
//  midiStringsOscBridge
//
//  Created by enrico<naus3a>viola on 10/17/22.
//

#pragma once
#include "ofMain.h"
#include "ofxMidi.h"
#include "Note.hpp";

class MidiController{
public:
    MidiController();
    ~MidiController();
    void open(string name);
    void close();
    bool isActive();
    string getPortName();
    void emitNote(Note & n);
private:
    ofxMidiOut _midi;
    string _portName;
    bool _bActive;
};
