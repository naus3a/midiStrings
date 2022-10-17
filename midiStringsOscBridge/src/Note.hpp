//
//  Note.hpp
//  midiStringsOscBridge
//
//  Created by enrico<naus3a>viola on 10/17/22.
//

#pragma once

class Note{
public:
    Note();
    Note(int chan, int ptch, int vel, bool noteOn);
    void set(int chan, int ptch, int vel, bool noteOn);
    
    int channel;
    int pitch;
    int velocity;
    bool isOn;
};
