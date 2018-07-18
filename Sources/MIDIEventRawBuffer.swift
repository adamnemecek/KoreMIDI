//
//  MIDIEventRawBuffer.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 7/18/18.
//

public struct MIDIEventRawBuffer : EventType, CustomStringConvertible {
    public let timestamp: MIDITimestamp
    public let type: MIDIEventType
    public let data: UnsafeRawBufferPointer

    @inline(__always)
    internal init?(ref: MusicEventIterator) {
        guard MIDIIteratorHasCurrent(ref: ref) else { return nil }

        var timestamp: Float64 = 0
        var type: MusicEventType = 0
        var data: UnsafeRawPointer? = nil
        var size: UInt32 = 0

        OSAssert(MusicEventIteratorGetEventInfo(ref, &timestamp, &type, &data, &size))

        self.timestamp = MIDITimestamp(beats: timestamp)
        self.type = MIDIEventType(rawValue: type)
        self.data = UnsafeRawBufferPointer(start: data!, count: Int(size))
    }

    //    init(meta: )

    ///
    /// this is for serializing user created meta events
    ///
    init(timestamp: MIDITimestamp, type: MIDIEventType, data: UnsafeRawBufferPointer) {
        self.timestamp = timestamp
        self.type = type
        self.data = data
    }

    public var description: String {
        return "\(timestamp)\(type)"
    }

    public static func ==(lhs: MIDIEventRawBuffer, rhs: MIDIEventRawBuffer) -> Bool {
        return lhs.timestamp == rhs.timestamp &&
            lhs.type == rhs.type &&
            lhs.data == rhs.data
    }

    public static func <(lhs: MIDIEventRawBuffer, rhs: MIDIEventRawBuffer) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }

    public func insert(to track: MIDITrack, at timestamp: AVMusicTimeStamp) {
        switch type {
        case .note:
            OSAssert(MusicTrackNewMIDINoteEvent(track.ref, timestamp, .init(data: self)))
        case .channel:
            OSAssert(MusicTrackNewMIDIChannelEvent(track.ref, timestamp, .init(data: self)))
        case .rawData:
            OSAssert(MusicTrackNewMIDIRawDataEvent(track.ref, timestamp, .init(data: self)))
        case .extendedNote:
            OSAssert(MusicTrackNewExtendedNoteEvent(track.ref, timestamp, .init(data: self)))
        case .parameter:
            OSAssert(MusicTrackNewParameterEvent(track.ref, timestamp, .init(data: self)))
        case .user:
            OSAssert(MusicTrackNewUserEvent(track.ref, timestamp, .init(data: self)))
        case .extendedTempo:
            OSAssert(MusicTrackNewExtendedTempoEvent(track.ref, timestamp, .init(data: self)))
        case .meta:
            OSAssert(MusicTrackNewMetaEvent(track.ref, timestamp, .init(data: self)))
        case .auPreset:
            OSAssert(MusicTrackNewAUPresetEvent(track.ref, timestamp, .init(data: self)))
        }
    }
}
