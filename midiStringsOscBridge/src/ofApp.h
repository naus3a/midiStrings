#pragma once

#include "ofMain.h"
#include "MidiController.hpp"
#include "OscController.hpp"

class ofApp : public ofBaseApp{
public:
    void setup();
		
    OscController osc;
    MidiController midi;
    string portName;
    int inPort;
};
