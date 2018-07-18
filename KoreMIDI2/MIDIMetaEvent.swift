//
//  MIDIMetaEvent.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 7/15/18.
//

import Foundation

/*
Note In the above description, note data refers to all MIDI events (Channel MIDI messages),
 whereas timing related events refers to the following Meta events: Marker, Cue Point, Tempo,
 SMPTE Offset, Time Signature, and Key Signature. Key Signature events are not strictly timing
 related, though they fall into this group. These Meta events are all detailed later.
 */

enum MIDITimingEvent {
    case marker, cuePoint, tempo, smpteOffset, timeSignature, keySignature
}


