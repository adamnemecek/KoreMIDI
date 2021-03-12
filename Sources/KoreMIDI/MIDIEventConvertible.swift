//
//  MIDIEventType
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/8/17.
//
//

import AVFoundation

//public protocol MIDIEventConvertible {
//
//}

/*
 If this flag is set the resultant Sequence will contain a tempo track, 1 track for each MIDI Channel that is found in the SMF, 1 track for SysEx or MetaEvents -
 */

internal protocol MIDITrackEvent { //}: MIDIEventConvertible {
    mutating func insert(to ref: MIDITrack, at timestamp: Double)
    var type: MIDIEventType { get }
}


