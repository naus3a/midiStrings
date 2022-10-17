//
//  OscController.cpp
//  midiStringsOscBridge
//
//  Created by enrico<naus3a>viola on 10/17/22.
//

#include "OscController.hpp"

OscController::OscController(){
    _bActive = false;
    _bListeners = false;
    
    _msgAddresses.push_back("/NoteOn");
    _msgAddresses.push_back("/NoteOff");
    
    addListeners();
}

OscController::~OscController(){
    close();
    removeListeners();
}

void OscController::close(){
    if(!_bActive)return;
    _osc.stop();
    _bActive = false;
}

void OscController::open(int inPort){
    close();
    _inPort = inPort;
    _osc.setup(_inPort);
    _bActive = true;
}

void OscController::addListeners(){
    if(_bListeners)return;
    ofAddListener(ofEvents().update, this, &OscController::update);
    _bListeners = true;
}

void OscController::removeListeners(){
    if(!_bListeners)return;
    ofRemoveListener(ofEvents().update, this, &OscController::update);
    _bListeners = false;
}

bool OscController::isActive(){return _bActive;}

int OscController::getListeningPort(){return _inPort;}

int OscController::getNumMessageTypes(){
    return (int)OscController::MessageType::NONE;
}

void OscController::update(ofEventArgs & e){
    if(!isActive())return;
    while(_osc.hasWaitingMessages()){
        ofxOscMessage msg;
        _osc.getNextMessage(msg);
        OscController::MessageType mt = getMessageType(msg);
        switch (mt) {
            case OscController::MessageType::NOTE_ON:
                emitNoteEventFromMsg(msg, true);
                break;
            case OscController::MessageType::NOTE_OFF:
                emitNoteEventFromMsg(msg, false);
                break;
            case OscController::MessageType::NONE:
            default:
                break;
        }
    }
}

void OscController::emitNoteEventFromMsg(ofxOscMessage &msg, bool noteOn){
    Note n;
    n.channel = msg.getArgAsInt(0);
    n.pitch = msg.getArgAsInt(1);
    n.velocity = msg.getArgAsInt(2);
    n.isOn = noteOn;
    eventNote.notify(this, n);
}

OscController::MessageType OscController::getMessageType(ofxOscMessage &msg){
    string addr = msg.getAddress();
    for(int i=0;i<getNumMessageTypes();i++){
        if(addr==_msgAddresses[i]){
            return (OscController::MessageType)i;
        }
    }
    return OscController::MessageType::NONE;
}
