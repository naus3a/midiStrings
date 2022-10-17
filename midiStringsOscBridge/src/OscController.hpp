//
//  OscController.hpp
//  midiStringsOscBridge
//
//  Created by enrico<naus3a>viola on 10/17/22.
//

#pragma once
#include "ofMain.h"
#include "ofxOsc.h"
#include "Note.hpp"

class OscController{
public:
    OscController();
    ~OscController();
    void open(int inPort);
    void close();
    bool isActive();
    int getListeningPort();
    int getNumMessageTypes();
    
    enum MessageType{
        NOTE_ON,
        NOTE_OFF,
        NONE
    };
    
    ofEvent<Note> eventNote;
private:
    void addListeners();
    void removeListeners();
    void update(ofEventArgs & e);
    MessageType getMessageType(ofxOscMessage & msg);
    void emitNoteEventFromMsg(ofxOscMessage & msg, bool noteOn);
    
    ofxOscReceiver _osc;
    vector<string> _msgAddresses;
    int _inPort;
    bool _bActive;
    bool _bListeners;
};
