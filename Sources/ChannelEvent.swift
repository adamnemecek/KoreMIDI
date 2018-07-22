//
//  ChannelEvent.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 2/1/18.
//

import Foundation

enum ChannelEvent2 {
    case Aftertouch(channel: UInt8, key: UInt8, pressure: UInt8)
    case ControlChange(channel: UInt8, controller: UInt8, value: UInt8)
    case ProgramChange(channel: UInt8, programNumber: UInt8)
    case ChannelPressure(channel: UInt8, pressure: UInt8)
    case PitchBend(channel: UInt8, pitch: UInt16)
}

//protocol CCEvent: Comparable {
//    associatedtype Timestamp: Strideable
//    var timestamp: Timestamp { get }
//
//}
//
//extension CCEvent {
//    static func <(lhs: Self, rhs: Self) -> Bool {
//        return lhs.timestamp < rhs.timestamp
//    }
//}

//struct AfterTouch: CCEvent {
//    let timestamp: MIDITimestamp
//    let note: MIDIPitch
//    let pressure: Int8
//}

//struct ProgramChange: CCEvent {
//    let timestamp: MIDITimestamp
//}

