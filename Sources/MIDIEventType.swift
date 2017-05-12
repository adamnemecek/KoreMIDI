//
//  MIDIEventType.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AudioToolbox.MusicPlayer
import Foundation


/// this struct is basically a better MIDIPacket
extension MIDIPacket  {

    typealias Timestamp = MIDITimeStamp
    var count : Int {
        return Int(length)
    }

    var status : MIDIStatus {
        fatalError()
    }
}


//typealias Temp = MIDIEvent2<ExtendedNoteOnEvent>


public enum MIDIEventType : RawRepresentable, CustomStringConvertible {

    // ExtendedControlEvent
    case extendedNote, extendedTempo, user, meta, note, channel, rawData, parameter, auPreset

    public init(rawValue: MusicEventType) {
        switch rawValue {
        case kMusicEventType_ExtendedNote: self = .extendedNote
        case kMusicEventType_ExtendedTempo: self = .extendedTempo
        case kMusicEventType_User: self = .user
        case kMusicEventType_Meta: self = .meta
        case kMusicEventType_MIDINoteMessage: self = .note
        case kMusicEventType_MIDIChannelMessage: self = .channel
        case kMusicEventType_MIDIRawData: self = .rawData
        case kMusicEventType_Parameter: self = .parameter
        case kMusicEventType_AUPreset: self = .auPreset
        default: fatalError()
        }
    }

    public var description : String {
        switch self {
        case .extendedNote: return ".extendedNote"
        case .extendedTempo: return ".extendedTempo"
        case .user: return ".user"
        case .meta: return ".meta"
        case .note: return ".note"
        case .channel: return ".channel"
        case .rawData: return ".rawData"
        case .parameter: return ".parameter"
        case .auPreset: return ".auPreset"
        }
    }

    init<T: TimestampType>(event: MIDIEvent<T>) {
        switch event {
        case .extendedNote: self = .extendedNote
        case .extendedTempo: self = .extendedTempo
        case .user: self = .user
        case .meta: self = .meta
        case .note: self = .note
        case .channel: self = .channel
        case .rawData: self = .rawData
        case .parameter: self = .parameter
        case .auPreset: self = .auPreset
        }
    }

    public var rawValue : MusicEventType {
        switch self {
        case .extendedNote: return kMusicEventType_ExtendedNote
        case .extendedTempo: return kMusicEventType_ExtendedTempo
        case .user: return kMusicEventType_User
        case .meta: return kMusicEventType_Meta
        case .note: return kMusicEventType_MIDINoteMessage
        case .channel: return kMusicEventType_MIDIChannelMessage
        case .rawData: return kMusicEventType_MIDIRawData
        case .parameter: return kMusicEventType_Parameter
        case .auPreset: return kMusicEventType_AUPreset
        }
    }
}
