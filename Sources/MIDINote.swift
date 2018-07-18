//
//  MIDINote.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import AVFoundation

extension MIDINoteMessage {
    @inline(__always)
    init(data: MIDIData) {
        self = data.data.baseAddress!.assumingMemoryBound(to: MIDINoteMessage.self).pointee
    }
}

extension MIDINoteMessage {
    public var isDrum: Bool {
        return channel == 9
    }
}

public struct MIDINote: Equatable, Hashable, CustomStringConvertible, Strideable {
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

    public func advanced(by n: Stride) -> MIDINote {
        return MIDINote(timestamp: timestamp.advanced(by: n), msg: msg)
    }

    public func distance(to other: MIDINote) -> Stride {
        return timestamp.distance(to: other.timestamp)
    }

    public static func ==(lhs: MIDINote, rhs: MIDINote) -> Bool {
        return lhs.timestamp == rhs.timestamp && lhs.msg == rhs.msg
    }

    public var hashValue: Int {
        return timestamp.hashValue ^ msg.hashValue
    }

    public var description: String {
        return "MIDINote(timestamp: \(timestamp), duration: \(msg))"
    }
}



extension String {
    @inline(__always)
    func getString(ptr: UnsafeRawBufferPointer) {
        fatalError()
        //getCString(&ptr.bindMemory(to: [CChar].self), maxLength: ptr.count, encoding: <#T##String.Encoding#>)
    }
}

//extension UnsafeMutablePointer where Pointee == MIDIMetaEvent {
//    init<T : MIDIMetaEventType>(type: T, string: String) {
//        let capacity = MemoryLayout<MIDIMetaEvent>.size + string.count
//        self = .allocate(capacity: capacity)
//        pointee.metaEventType = T.byte.rawValue
//        pointee.unused1 = 0
//        pointee.unused2 = 0
//        pointee.unused3 = 0
//        pointee.dataLength = UInt32(string.count)
//        string.getString(ptr: withUnsafeBytes(of: &pointee.data) { $0 })
//    }
//}
//
//extension UnsafeMutablePointer where Pointee == MIDIRawData {
//    init(string: String) {
//        self = .allocate(capacity: MemoryLayout<MIDIRawData>.size + string.count)
//
//        var copy = string
//        fatalError()
//        //self = withUnsafeMutableBytes(of: &copy) { $0 }
//    }
//}

//public struct MIDIDrumNote: Equatable, Hashable, CustomStringConvertible, Strideable {
//    public typealias Timestamp = MIDITimestamp
//    public typealias Stride = Timestamp.Stride
//
//    public let timestamp: Timestamp
//
//    internal let msg: MIDINoteMessage
//
//    internal init(data: MIDIData) {
//        self.timestamp = data.timestamp
//        self.msg = MIDINoteMessage(data: data)
//    }
//
//    internal init(timestamp: Timestamp, msg: MIDINoteMessage) {
//        self.timestamp = timestamp
//        self.msg = msg
//    }
//
//    public var drum: MIDIDrum {
//        return MIDIDrum(Int8(msg.note))
//    }
//
//    public func advanced(by n: Stride) -> MIDIDrumNote {
//        return MIDIDrumNote(timestamp: timestamp.advanced(by: n), msg: msg)
//    }
//
//    public func distance(to other: MIDIDrumNote) -> Stride {
//        return timestamp.distance(to: other.timestamp)
//    }
//
//    public static func ==(lhs: MIDIDrumNote, rhs: MIDIDrumNote) -> Bool {
//        return lhs.timestamp == rhs.timestamp && lhs.msg == rhs.msg
//    }
//
//    public var hashValue: Int {
//        return timestamp.hashValue ^ msg.hashValue
//    }
//
//    public var description: String {
//        return "MIDIDrumNote(timestamp: \(timestamp), duration: \(msg))"
//    }
//}

