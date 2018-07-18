//
//  MIDITrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 1/30/18.
//

import Foundation
import AudioToolbox


//enum ChanEvent {
//    case controlChange(MIDIChannelMessage)
//
//    case programChange(MIDIChannelMessage)
//
//    case pitchBend(MIDIChannelMessage)
//
//    case channelPressure(MIDIChannelMessage)
//
//    case aftertouch(MIDIChannelMessage)
//}


public enum ChannelEvent : Comparable, Strideable, Hashable, CustomStringConvertible {
    public typealias Timestamp = MIDITimestamp
    public typealias Stride = Timestamp.Stride

    case note(Timestamp, MIDINoteMessage)
    case channel(Timestamp, MIDIChannelMessage)

    public func distance(to other: ChannelEvent) -> Stride {
        return timestamp.distance(to: other.timestamp)
    }

    public func advanced(by n: Stride) -> ChannelEvent {
        fatalError()
    }

    public var description: String {
        switch self {
        case let .note(ts, e): return "\(type)(timestamp: \(ts), \(e))"
        case let .channel(ts, e): return "\(type)(timestamp: \(ts), \(e))"
        }
    }

    public var timestamp : Timestamp {
        switch self {
        case let .note(ts, _): return ts
        case let .channel(ts, _): return ts
        }
    }

    internal var type: MIDIEventType {
        switch self {
        case .note: return .note
        case .channel: return .channel
        }
    }

//    func insert(to track: MIDITrack) {
//        switch self {
//        case let .note(ts, e): e.insert(to: track, at: ts.beats)
//        case let .channel(ts, e): e.insert(to: track, at: ts.beats)
//        }
//    }
}
