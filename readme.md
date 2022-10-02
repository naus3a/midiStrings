# midiStrings
This is a simple prototype allowing you to get `MIDI` out of the manipulation of strings, ropes, etc. It's not the most elegant, efficient, or musical way: it's the most quick and dirty and cheap way tho. And that makes a difference sometimes.

## Why
This was put together to facilitate a musical performance where an ensemble of musicians is sonifying the bodies of people performing body suspension.
If you don't know what body suspension is: it's practice where people hangs from hooks pierced through their skin. If you're an art kind of person you're probably familiar with Stelarc performances; if you're into body modification, you're probably aware of the body suspension scene; if you're into anthropology, you probably know this practice kept popping up in different cultures and times since the beginning of time.

## The hardware
The hardware part is very simple:
* string manipulation is tracked using flex sensors (like these: https://www.sparkfun.com/products/10264 )
* sensor resistance is processed by some kind of arduino compatible board and the result is sent over serial

The circuit is fairly easy:
![The circuit](./flexSensorCirctuit.svg)

When you have your circuit ready, just upload the `.ino` file in the `arduino` folder to your board.

## The software
The software is a simple `Processing` sketch, meaning it runs everywhere and can be easily modified on the fly.
The source code is in the `processing` folder.