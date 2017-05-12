//
//  DataEvent.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 5/12/17.
//
//

import AudioToolbox.MusicPlayer
import Foundation

protocol EventType {

}

/// this struct is basically a better MIDIPacket
/// passed around
struct DataEvent<Timestamp : Strideable, Data: Equatable> : Comparable, Strideable {

    typealias Stride = Timestamp.Stride

    let timestamp: Timestamp
    let data : Data

    /// called from the CoreMIDI.ReadMIDI callback
    init(timestamp: Timestamp, data: Data) {
        self.timestamp = timestamp
        self.data = data
    }

    static func ==(lhs: DataEvent, rhs: DataEvent) -> Bool {
        return lhs.timestamp == rhs.timestamp && lhs.data == rhs.data
    }

    static func <(lhs: DataEvent, rhs: DataEvent) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }

    func advanced(by n: Stride) -> DataEvent<Timestamp, Data> {
        return DataEvent(timestamp: timestamp.advanced(by: n), data: data)
    }

    func distance(to other: DataEvent) -> Stride {
        return timestamp.distance(to: other.timestamp)
    }
}


enum CoreMIDIEvent : Equatable, Hashable, CustomStringConvertible {
    case extendedNote(ExtendedNoteOnEvent)
    case extendedTempo(ExtendedTempoEvent)
    case user(MusicEventUserData)
    case meta(MIDIMetaEvent)
    case note(MIDINoteMessage)
    case channel(MIDIChannelMessage)
    case rawData(MIDIRawData)
    case parameter(ParameterEvent)
    case auPreset(AUPresetEvent)

    static func ==(lhs: CoreMIDIEvent, rhs: CoreMIDIEvent) -> Bool {
        fatalError()
    }

    var description: String {
        fatalError()
    }

    var hashValue: Int {
        fatalError()
    }
}

