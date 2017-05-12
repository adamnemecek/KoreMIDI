//
//  MIDIEventConvertible.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/8/17.
//
//

import Foundation
import AudioToolbox.MusicPlayer


protocol CoreMIDIEventType {

}

extension ExtendedNoteOnEvent : Comparable, Hashable, CustomStringConvertible, CoreMIDIEventType {
    public static func ==(lhs: ExtendedNoteOnEvent, rhs: ExtendedNoteOnEvent) -> Bool {
        return lhs.instrumentID == rhs.instrumentID &&
            lhs.groupID == rhs.groupID &&
            lhs.duration == rhs.duration
    }

    public static func <(lhs: ExtendedNoteOnEvent, rhs: ExtendedNoteOnEvent) -> Bool {
        return lhs.groupID < rhs.groupID && lhs.instrumentID < rhs.instrumentID
    }
    public var description: String {
        return ""
    }

    public var hashValue: Int {
        return groupID.hashValue
    }
}

///
/// MARK: ExtendedTempoEvent
///

extension ExtendedTempoEvent : Comparable, Hashable, CustomStringConvertible, CoreMIDIEventType {
    public var hashValue: Int {
        return bpm.hashValue
    }

    public static func ==(lhs: ExtendedTempoEvent, rhs: ExtendedTempoEvent) -> Bool {
        return lhs.bpm == rhs.bpm
    }

    public static func <(lhs: ExtendedTempoEvent, rhs: ExtendedTempoEvent) -> Bool {
        return lhs.bpm < rhs.bpm
    }

    public var description: String {
        return ""
    }
}


///
/// MARK: MusicEventUserData
///

extension MusicEventUserData : Comparable, Hashable, CustomStringConvertible, CoreMIDIEventType, VLQ {

    //    init(data: Data) {
    //
    //    }

    public var hashValue: Int {
        return length.hashValue
    }

    static public func ==(lhs: MusicEventUserData, rhs: MusicEventUserData) -> Bool {
        return lhs.length == rhs.length && lhs.data == rhs.data
    }

    static public func <(lhs: MusicEventUserData, rhs: MusicEventUserData) -> Bool {
        return lhs.length < rhs.length
    }

    public var description: String {
        return ""
    }
}

///
/// MARK: MIDIMetaEvent
///

extension MIDIMetaEvent : Comparable, Hashable, CustomStringConvertible, CoreMIDIEventType, VLQ {
    var length : UInt32 {
        return dataLength
    }

    public var hashValue: Int {
        return metaEventType.hashValue
    }

    public static func ==(lhs: MIDIMetaEvent, rhs: MIDIMetaEvent) -> Bool {
        return lhs.metaEventType == rhs.metaEventType &&
            lhs.dataLength == rhs.dataLength &&
            lhs.data == rhs.data
    }

    public static func <(lhs: MIDIMetaEvent, rhs: MIDIMetaEvent) -> Bool {
        return lhs.metaEventType < rhs.metaEventType
    }

    public var description: String {
        return ""
    }
}

//extension MIDINoteMessage : MIDIEventConvertible  {}
///
/// MARK: MIDINoteMessage
///
extension MIDINoteMessage : Comparable, Hashable, CustomStringConvertible, CoreMIDIEventType {

    init(note: UInt8, duration: Float32) {
        self.init(channel: 0, note: note, velocity: 100, releaseVelocity: 0, duration: duration)
    }

    public var description : String {
        return "note: \(note), duration: \(duration)"
    }

    public static func ==(lhs: MIDINoteMessage, rhs: MIDINoteMessage) -> Bool {
        return lhs.duration == rhs.duration &&
            lhs.note == rhs.note &&
            lhs.channel == rhs.channel &&
            lhs.velocity == rhs.velocity &&
            lhs.releaseVelocity == rhs.releaseVelocity
    }

    public static func <(lhs: MIDINoteMessage, rhs: MIDINoteMessage) -> Bool {
        return lhs.note < rhs.note
    }

    public var hashValue: Int {
        return channel.hashValue ^ note.hashValue
    }
}

///
/// MARK: MIDIChannelMessage
///

extension MIDIChannelMessage : Comparable, Hashable, CustomStringConvertible, CoreMIDIEventType {
    public static func ==(lhs: MIDIChannelMessage, rhs: MIDIChannelMessage) -> Bool {
        return lhs.status == rhs.status && lhs.data1 == rhs.data1 && lhs.data2 == rhs.data2
    }

    public static func <(lhs: MIDIChannelMessage, rhs: MIDIChannelMessage) -> Bool {
        return lhs.status < rhs.status
    }
    public var hashValue: Int {
        return status.hashValue
    }

    public var description: String {
        return "cc: \(status): [\(data1), \(data2)]"
    }
}

///
/// MARK: MIDIRawData
///

extension MIDIRawData : Comparable, Hashable, CustomStringConvertible, CoreMIDIEventType, VLQ {
    public static func ==(lhs: MIDIRawData, rhs: MIDIRawData) -> Bool {
        return lhs.length == rhs.length && lhs.data == rhs.data
    }

    public static func <(lhs: MIDIRawData, rhs: MIDIRawData) -> Bool {
        return lhs.length < rhs.length
    }
    public var hashValue: Int {
        return length.hashValue
    }

    public var description: String {
        return ""
    }
}

///
/// MARK: ParameterEvent
///

extension ParameterEvent : Comparable, Hashable, CustomStringConvertible, CoreMIDIEventType {
    public static func ==(lhs: ParameterEvent, rhs: ParameterEvent) -> Bool {
        return lhs.parameterID == rhs.parameterID &&
            lhs.scope == rhs.scope &&
            lhs.element == rhs.element &&
            lhs.value == rhs.value
    }

    public static func <(lhs: ParameterEvent, rhs: ParameterEvent) -> Bool {
        return lhs.scope < rhs.scope && lhs.parameterID < rhs.parameterID
    }
    public var hashValue: Int {
        return scope.hashValue
    }

    public var description: String {
        return ""
    }
}

///
/// MARK: AUPresetEvent
///

extension AUPresetEvent : Comparable, Hashable, CustomStringConvertible, CoreMIDIEventType {
    static public func ==(lhs: AUPresetEvent, rhs: AUPresetEvent) -> Bool {
        return lhs.scope == rhs.scope &&
            lhs.element == rhs.element &&
            lhs.preset.toOpaque() == rhs.preset.toOpaque()
    }

    static public func <(lhs: AUPresetEvent, rhs: AUPresetEvent) -> Bool {
        return lhs.scope < rhs.scope
    }
    public var hashValue: Int {
        return scope.hashValue
    }

    public var description: String {
        return ""
    }
}

extension ExtendedControlEvent : Comparable, Hashable, CustomStringConvertible, CoreMIDIEventType {
    static public func ==(lhs: ExtendedControlEvent, rhs: ExtendedControlEvent) -> Bool {
        //        return lhs.scope == rhs.scope &&
        //            lhs.element == rhs.element &&
        //            lhs.preset.toOpaque() == rhs.preset.toOpaque()
        fatalError()
    }

    static public func <(lhs: ExtendedControlEvent, rhs: ExtendedControlEvent) -> Bool {
        //        return lhs.scope < rhs.scope
        fatalError()
    }
    public var hashValue: Int {
        //        return scope.hashValue
        fatalError()
    }
    
    public var description: String {
        return ""
    }
}

