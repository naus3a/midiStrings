#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    portName = "midiStrings";
    inPort = 12345;
    midi.open(portName);
    osc.open(inPort);
    ofAddListener(osc.eventNote, &midi, &MidiController::emitNote);
}

