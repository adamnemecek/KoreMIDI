//
//  Event.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 5/12/17.
//
//

import AudioToolbox.MusicPlayer
import Foundation


/// this struct is basically a better MIDIPacket
struct Event<Timestamp : Strideable, Data> : Comparable, Strideable {

    typealias Stride = Timestamp.Stride

    let timestamp: Timestamp
    let data : Foundation.Data

    /// called from the CoreMIDI.ReadMIDI callback
    init(timestamp: Timestamp, data: Foundation.Data) {
        self.timestamp = timestamp
        self.data = data
    }

    static func ==(lhs: Event, rhs: Event) -> Bool {
        return lhs.timestamp == rhs.timestamp && lhs.data == rhs.data
    }

    static func <(lhs: Event, rhs: Event) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }

    func advanced(by n: Stride) -> Event<Timestamp, Data> {
        return Event(timestamp: timestamp.advanced(by: n), data: data)
    }

    func distance(to other: Event) -> Stride {
        return timestamp.distance(to: other.timestamp)
    }
}

extension MIDIEventConvertible {
    @inline(__always)
    init(event: Event<MIDIPacket.Timestamp, Self>) {
        self = event.data.decode()
    }
}

extension Event where Data : MIDIEventConvertible {
    @inline(__always)
    internal init(timestamp: Timestamp, ptr: UnsafeMutablePointer<MIDIPacket>) {
        self.timestamp = timestamp
        self.data = withUnsafeBytes(of: &ptr.pointee.data) {
            Foundation.Data(bytes: $0.baseAddress!, count: ptr.pointee.count)
        }
    }
}
