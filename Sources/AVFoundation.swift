//
//  AVFoundation.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AVFoundation

@inline(__always) internal
func OSAssert(_ err: OSStatus, function: String = #function, line: Int = #line) {
    assert(err == noErr, "Error (osstatus: \(err)) in \(function)@\(line)")
}

//
//@inline(__always) internal
//func MusicSequenceInsert(ref: MusicSequence, event: MIDIEvent) {
//    switch event {
//    case .extendedNote(let ts, var e): OSAssert(MusicTrackNewExtendedNoteEvent(ref, ts.beats, &e))
//    case .extendedTempo(let ts, let e): OSAssert(MusicTrackNewExtendedTempoEvent(ref, ts.beats, e.bpm))
//    case .user(let ts, var e): OSAssert(MusicTrackNewUserEvent(ref, ts.beats, &e))
//    case .meta(let ts, var e): OSAssert(MusicTrackNewMetaEvent(ref, ts.beats, &e))
//    case .note(let ts, var e): OSAssert(MusicTrackNewMIDINoteEvent(ref, ts.beats, &e))
//    case .channel(let ts, var e): OSAssert(MusicTrackNewMIDIChannelEvent(ref, ts.beats, &e))
//    case .rawData(let ts, var e): OSAssert(MusicTrackNewMIDIRawDataEvent(ref, ts.beats, &e))
//    case .parameter(let ts, var e): OSAssert(MusicTrackNewParameterEvent(ref, ts.beats, &e))
//    case .auPreset(let ts, var e): OSAssert(MusicTrackNewAUPresetEvent(ref, ts.beats, &e))
//    }
//}

@inline(__always) internal
func MusicSequenceBeatsToBarBeatTime(ref: MusicSequence, beats: MIDITimestamp, subdivisor: UInt32) -> CABarBeatTime {
    var t = CABarBeatTime()
    OSAssert(MusicSequenceBeatsToBarBeatTime(ref, beats.beats, subdivisor, &t))
    return t
}

@inline(__always) internal
func MusicSequenceBeatsToSeconds(ref: MusicSequence, beats: MusicTimeStamp) -> Float64 {
    var out: Float64 = 0
    OSAssert(MusicSequenceGetSecondsForBeats(ref, beats, &out))
    return out
}

//@inline(__always) internal
//func MusicSequenceSecondsToBeats(ref: MusicSequence, seconds: MusicTimeStamp) -> Float64 {
//    var out: MusicTimeStamp = 0
//    OSAssert(MusicSequenceGetBeatsForSeconds(ref, seconds, &out))
//    return out
//}

@inline(__always) internal
func MusicSequenceGetSequenceType(ref: MusicSequence) -> MusicSequenceType {
    var out: MusicSequenceType = .beats
    OSAssert(MusicSequenceGetSequenceType(ref, &out))
    return out
}

//@inline(__always) internal
//func MusicTrackGetSequence(_ track: MusicTrack) -> MusicSequence {
//    var out: MusicSequence? = nil
//    OSAssert(MusicTrackGetSequence(track, &out))
//    return out!
//}

///
/// Iterators
///

@inline(__always) internal
func MIDIIteratorCreate(ref: MusicTrack) -> MusicEventIterator {
    var r: MusicEventIterator? = nil
    OSAssert(NewMusicEventIterator(ref, &r))
    return r!
}

//extension Double: TimestampType {
//    public var beats: MusicTimeStamp {
//        return MusicTimeStamp(self)
//    }
//}

@inline(__always) internal
func MIDIIteratorHasCurrent(ref: MusicEventIterator) -> Bool {
    var ret: DarwinBoolean = false
    OSAssert(MusicEventIteratorHasCurrentEvent(ref, &ret))
    return ret.boolValue
}

extension UnsafeRawBufferPointer: Equatable {
    public static func ==(lhs: UnsafeRawBufferPointer, rhs: UnsafeRawBufferPointer) -> Bool {
        return lhs.count == rhs.count && lhs.elementsEqual(rhs)
    }
}

extension UnsafePointer {
    @inline(__always)
    fileprivate init(data: MIDIEventRawBuffer) {
        self = data.data.bindMemory(to: Pointee.self).baseAddress!
    }
}

extension Float64 {
    @inline(__always)
    fileprivate init(data: MIDIEventRawBuffer) {
        self = data.data.bindMemory(to: Float64.self).baseAddress!.pointee
    }
}


//@inline(__always) internal
//func MIDIIteratorGetCurrent(ref: MusicEventIterator) -> MIDIEvent? {
//
//    guard MIDIIteratorHasCurrent(ref: ref) else { return nil }
//
//    var timestamp: Float64 = 0
//    var type: MusicEventType = 0
//    var data: UnsafeRawPointer? = nil
//    var size: UInt32 = 0
//
//    OSAssert(MusicEventIteratorGetEventInfo(ref, &timestamp, &type, &data, &size))
//    let d = Data(bytes: data!, count: Int(size))
//
//    return MIDIEvent(timestamp: MIDITimestamp(beats: timestamp),
//                     type: MIDIEventType(rawValue: type),
//                     data: d)
//}

///
/// Tracks
///

@inline(__always) internal
func MIDITrackCreate(ref: MusicSequence) -> MusicTrack {
    var out: MusicTrack? = nil
    OSAssert(MusicSequenceNewTrack(ref, &out))
    return out!
}

@inline(__always) internal
func MIDITrackGetProperty<T>(ref: MusicTrack, prop: MIDITrackProp) -> T {
    var d = Data(capacity: MemoryLayout<T>.size)
    var size: UInt32 = 0
    d.withUnsafeMutableBytes {
        OSAssert(MusicTrackGetProperty(ref, prop.rawValue, $0, &size))
    }

    return d.decode()
}

@inline(__always) internal
func MIDITrackGetProperty(ref: MusicTrack, prop: UInt32) -> Bool {
    var out: DarwinBoolean = false
    var size: UInt32 = 0
    OSAssert(MusicTrackGetProperty(ref, prop, &out, &size))
    return out.boolValue
}

@inline(__always) internal
func MIDITrackSetProperty<T>(ref: MusicTrack, prop: MIDITrackProp, to value: T) {
    var cpy = value
    OSAssert(MusicTrackSetProperty(ref, prop.rawValue, &cpy, UInt32(MemoryLayout<T>.size)))
}

extension ExtendedNoteOnEvent: Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {
    public static func ==(lhs: ExtendedNoteOnEvent, rhs: ExtendedNoteOnEvent) -> Bool {
        return lhs.instrumentID == rhs.instrumentID &&
            lhs.groupID == rhs.groupID &&
            lhs.duration == rhs.duration
    }

    internal mutating func insert(to ref: MIDITrack, at timestamp: Double) {
        OSAssert(MusicTrackNewExtendedNoteEvent(ref.ref, timestamp, &self))
    }

    public var description: String {
        return "instrumentID: \(instrumentID), groupID: \(groupID), duration: \(duration)"
    }

    public var hashValue: Int {
        return instrumentID.hashValue
    }

    internal var type: MIDIEventType {
        return .extendedNote
    }
}

///
/// MARK: ExtendedTempoEvent
///

extension ExtendedTempoEvent: Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {
    public var hashValue: Int {
        return bpm.hashValue
    }

    public static func ==(lhs: ExtendedTempoEvent, rhs: ExtendedTempoEvent) -> Bool {
        return lhs.bpm == rhs.bpm
    }

    public var description: String {
        return "bpm: \(bpm)"
    }

    public mutating func insert(to ref: MIDITrack, at timestamp: Double) {
        OSAssert(MusicTrackNewExtendedTempoEvent(ref.ref, timestamp, bpm))
    }

    internal var type: MIDIEventType {
        return .extendedTempo
    }
}

///
/// MARK: MusicEventUserData
///

extension MusicEventUserData: Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {
    public var hashValue: Int {
        return length.hashValue
    }

    static public func ==(lhs: MusicEventUserData, rhs: MusicEventUserData) -> Bool {
        return lhs.length == rhs.length && lhs.data == rhs.data
    }

    public var description: String {
        return "data: \(data)"
    }

    internal mutating func insert(to ref: MIDITrack, at timestamp: Double) {
        OSAssert(MusicTrackNewUserEvent(ref.ref, timestamp, &self))
    }

    internal var type: MIDIEventType {
        return .user
    }
}

///
/// MARK: MIDIMetaEvent
///

//extension UnsafeMutablePointer where Pointee == MIDIMetaEvent {
//
//}

//
//extension UnsafeBufferPointer {
//    func copy() -> UnsafeBufferPointer<Pointee> {
//
//        return self
//    }
//}

extension UnsafeMutablePointer where Pointee: MIDITrackEvent {
    mutating func insert(to ref: MIDITrack, at timestamp: Double) {
        pointee.insert(to: ref, at: timestamp)
    }
}

extension UnsafeMutablePointer {
    @inline(__always)
    init(bytes: Int) {
        let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: bytes)
        self = ptr.withMemoryRebound(to: Pointee.self, capacity: 1) { $0 }
    }
}

extension UnsafePointer where Pointee == MIDIMetaEvent {
    init(metaEventType: UInt8, string: String) {
        let staticSize = MemoryLayout<MIDIMetaEvent>.size - MemoryLayout<UInt8>.size
        let dynamicSize = string.count
        let capacity = staticSize + dynamicSize

        let ptr = UnsafeMutablePointer<MIDIMetaEvent>(bytes: capacity)

        ptr.pointee.metaEventType = metaEventType
        ptr.pointee.unused1 = 0
        ptr.pointee.unused2 = 0
        ptr.pointee.unused3 = 0
        ptr.pointee.dataLength = UInt32(dynamicSize)
        _ = withUnsafeMutableBytes(of: &ptr.pointee.data) {
            memcpy($0.baseAddress!, string, dynamicSize)
        }
        self.init(ptr)
    }
}

extension UnsafePointer where Pointee == MusicEventUserData {
    init(string: String) {
        let staticSize = MemoryLayout<MusicEventUserData>.size - MemoryLayout<UInt8>.size
        let dynamicSize = string.count
        let capacity = staticSize + dynamicSize

        let ptr = UnsafeMutablePointer<MusicEventUserData>(bytes: capacity)

        ptr.pointee.length = UInt32(dynamicSize)
        _ = withUnsafeMutableBytes(of: &ptr.pointee.data) {
            memcpy($0.baseAddress!, string, dynamicSize)
        }
        self.init(ptr)
    }
}

extension UnsafePointer where Pointee == MIDIRawData {
    init(string: String) {
        let staticSize = MemoryLayout<MIDIRawData>.size - MemoryLayout<UInt8>.size
        let dynamicSize = string.count
        let capacity = staticSize + dynamicSize

        let ptr = UnsafeMutablePointer<MIDIRawData>(bytes: capacity)

        ptr.pointee.length = UInt32(dynamicSize)
        _ = withUnsafeMutableBytes(of: &ptr.pointee.data) {
            memcpy($0.baseAddress!, string, dynamicSize)
        }

        self.init(ptr)
    }
}


extension MIDIMetaEvent: Hashable, CustomStringConvertible, MIDITrackEvent {

    public enum Subtype: UInt8 {
        case sequenceNumber = 0x00,
        textEvent = 0x01, // text
        copyrightNotice = 0x02, // text
        trackSequenceName = 0x03, // text
        instrumentName  = 0x04, // per track, text
        lyricText = 0x05, // text
        markerText              = 0x06, // timed, text
        cuePoint                = 0x07, // timed, text
        MIDIChannelPrefix       = 0x20,
        endOfTrack              = 0x2F,
        tempoSetting            = 0x51, // timed
        SMPTEOffset             = 0x54, // timed
        timeSignature           = 0x58, // timed
        keySignature            = 0x59, // timed
        sequencerSpecificEvent  = 0x7F,
        invalid                    = 0x66
    }

    public var hashValue: Int {
        return metaEventType.hashValue
    }

    public static func ==(lhs: MIDIMetaEvent, rhs: MIDIMetaEvent) -> Bool {
        return lhs.metaEventType == rhs.metaEventType &&
            lhs.dataLength == rhs.dataLength &&
            lhs.data == rhs.data
    }

    public var description: String {
        return "metaEventType: \(metaEventType)"
    }

    internal mutating func insert(to ref: MIDITrack, at timestamp: Double) {
        OSAssert(MusicTrackNewMetaEvent(ref.ref, timestamp, &self))
    }

    internal var type: MIDIEventType {
        return .meta
    }
}

///
/// MARK: MIDINoteMessage
///
extension MIDINoteMessage: Hashable, CustomStringConvertible, MIDITrackEvent {

    init(note: UInt8, duration: Float32, velocity: UInt8 = 100) {
        self.init(channel: 0,
                  note: note,
                  velocity: velocity,
                  releaseVelocity: 0,
                  duration: duration)
    }

    public var description: String {
        return "note: \(note), duration: \(duration)"
    }

    public static func ==(lhs: MIDINoteMessage, rhs: MIDINoteMessage) -> Bool {
        return lhs.duration == rhs.duration &&
            lhs.note == rhs.note &&
            lhs.channel == rhs.channel &&
            lhs.velocity == rhs.velocity &&
            lhs.releaseVelocity == rhs.releaseVelocity
    }

    public var hashValue: Int {
        return note.hashValue
    }

    internal mutating func insert(to ref: MIDITrack, at timestamp: Double) {
        OSAssert(MusicTrackNewMIDINoteEvent(ref.ref, timestamp, &self))
    }

    internal var type: MIDIEventType {
        return .note
    }
}

///
/// MARK: MIDIChannelMessage
///

extension MIDIChannelMessage: Hashable, CustomStringConvertible, MIDITrackEvent {

    enum Subtype: UInt {
        case polyphonicKeyPressure        = 0xA0,
        controlChange                = 0xB0,
        programChange                = 0xC0,
        channelPressure                = 0xD0,
        pitchBendChange                = 0xE0
    }

    public static func ==(lhs: MIDIChannelMessage, rhs: MIDIChannelMessage) -> Bool {
        return lhs.status == rhs.status && lhs.data1 == rhs.data1 && lhs.data2 == rhs.data2
    }

    public var hashValue: Int {
        return status.hashValue
    }

    public var description: String {
        return "cc: \(status): [\(data1), \(data2)]"
    }

    internal mutating func insert(to ref: MIDITrack, at timestamp: Double) {
        OSAssert(MusicTrackNewMIDIChannelEvent(ref.ref, timestamp, &self))
    }

    internal var type: MIDIEventType {
        return .channel
    }
}

///
/// MARK: MIDIRawData
///

extension MIDIRawData: Hashable, CustomStringConvertible, MIDITrackEvent {
    public static func ==(lhs: MIDIRawData, rhs: MIDIRawData) -> Bool {
        return lhs.length == rhs.length && lhs.data == rhs.data
    }

    public var hashValue: Int {
        return length.hashValue
    }

    public var description: String {
        return "\(length) \(data)"
    }

    internal mutating func insert(to ref: MIDITrack, at timestamp: Double) {
        OSAssert(MusicTrackNewMIDIRawDataEvent(ref.ref, timestamp, &self))
    }

    internal var type: MIDIEventType {
        return .rawData
    }
}

///
/// MARK: ParameterEvent
///

extension ParameterEvent: Hashable, CustomStringConvertible, MIDITrackEvent {
    public static func ==(lhs: ParameterEvent, rhs: ParameterEvent) -> Bool {
        return lhs.parameterID == rhs.parameterID &&
            lhs.scope == rhs.scope &&
            lhs.element == rhs.element &&
            lhs.value == rhs.value
    }

    public var hashValue: Int {
        return parameterID.hashValue
    }

    public var description: String {
        return ""
    }

    internal mutating func insert(to ref: MIDITrack, at timestamp: Double) {
        OSAssert(MusicTrackNewParameterEvent(ref.ref, timestamp, &self))
    }

    internal var type: MIDIEventType {
        return .parameter
    }
}

///
/// MARK: AUPresetEvent
///

extension AUPresetEvent: Hashable, CustomStringConvertible, MIDITrackEvent {
    static public func ==(lhs: AUPresetEvent, rhs: AUPresetEvent) -> Bool {
        return lhs.scope == rhs.scope &&
            lhs.element == rhs.element &&
            lhs.preset.toOpaque() == rhs.preset.toOpaque()
    }

    public var hashValue: Int {
        return scope.hashValue
    }

    public var description: String {
        return ""
    }

    internal mutating func insert(to ref: MIDITrack, at timestamp: Double) {
        OSAssert(MusicTrackNewAUPresetEvent(ref.ref, timestamp, &self))
    }

    internal var type: MIDIEventType {
        return .auPreset
    }
}

extension ExtendedControlEvent: Hashable, CustomStringConvertible, MIDITrackEvent {
    static public func ==(lhs: ExtendedControlEvent, rhs: ExtendedControlEvent) -> Bool {
        //        return lhs.scope == rhs.scope && lhs.element == rhs.element
        //        return lhs.scope == rhs.scope &&
        //            lhs.element == rhs.element &&
        //            lhs.preset.toOpaque() == rhs.preset.toOpaque()
        fatalError()
    }

    public var hashValue: Int {
        //        return scope.hashValue
        fatalError()
    }

    public var description: String {
        return ""
    }

    internal mutating func insert(to ref: MIDITrack, at timestamp: Double) {
        fatalError()
        //        withCopy(of: self) {
        //            MusicTrackNewExtendedNoteEvent(ref.ref, timestamp, $0)
        //        }
    }

    internal var type: MIDIEventType {
        fatalError()
    }

}
