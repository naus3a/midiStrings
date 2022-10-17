//
//  Note.cpp
//  midiStringsOscBridge
//
//  Created by enrico<naus3a>viola on 10/17/22.
//

#include "Note.hpp"

Note::Note(){}

Note::Note(int chan, int ptch, int vel, bool noteOn){
    set(chan, ptch, vel, noteOn);
}

void Note::set(int chan, int ptch, int vel, bool noteOn){
    channel = chan;
    pitch = ptch;
    velocity = vel;
    isOn = noteOn;
}
