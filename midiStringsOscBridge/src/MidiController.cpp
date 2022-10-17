//
//  MidiController.cpp
//  midiStringsOscBridge
//
//  Created by enrico<naus3a>viola on 10/17/22.
//

#include "MidiController.hpp"

MidiController::MidiController(){
    _bActive = false;
}

MidiController::~MidiController(){
    close();
}

void MidiController::close(){
    if(!_bActive)return;
    _midi.closePort();
    _bActive = false;
}

void MidiController::open(string name){
    close();
    _portName = name;
    _midi.openVirtualPort(name);
    _bActive = true;
}

bool MidiController::isActive(){return _bActive;}

string MidiController::getPortName(){return _portName;}

void MidiController::emitNote(Note & n){
    if(!isActive())return;
    if(n.isOn){
        _midi.sendNoteOn(n.channel, n.pitch, n.velocity);
    }else{
        _midi.sendNoteOff(n.channel, n.pitch, n.velocity);
    }
}
