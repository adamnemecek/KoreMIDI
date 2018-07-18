//
//  MIDINote1.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 7/15/18.
//

import AVFoundation

public struct MIDINote1: Equatable, Hashable, CustomStringConvertible, Strideable {


    public typealias Timestamp = MIDITimestamp
    public typealias Stride = Timestamp.Stride

    public let timestamp: Timestamp

    internal let msg: MIDINoteMessage

    internal init(timestamp: Timestamp, msg: MIDINoteMessage) {
        self.timestamp = timestamp
        self.msg = msg
    }

    public var pitch: MIDIPitch {
        return MIDIPitch(Int8(msg.note))
    }

    public var duration: Timestamp {
        return Timestamp(float: msg.duration)
    }

    public var isDrum: Bool {
        return msg.isDrum
    }

    internal init(data: MIDIData) {
        self.timestamp = data.timestamp
        self.msg = MIDINoteMessage(data: data)
    }

    public var endstamp: Timestamp {
        return timestamp + duration
    }

    public var timerange: Range<Timestamp> {
        return timestamp..<endstamp
    }

    public func advanced(by n: Stride) -> MIDINote1 {
        return MIDINote1(timestamp: timestamp.advanced(by: n), msg: msg)
    }

    public func distance(to other: MIDINote1) -> Stride {
        return timestamp.distance(to: other.timestamp)
    }

    public static func ==(lhs: MIDINote1, rhs: MIDINote1) -> Bool {
        return lhs.timestamp == rhs.timestamp && lhs.msg == rhs.msg
    }

    public var hashValue: Int {
        return timestamp.hashValue ^ msg.hashValue
    }

    public var description: String {
        return "MIDINote(timestamp: \(timestamp), duration: \(msg))"
    }
}

