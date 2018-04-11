//
//  MIDITrumTrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/3/18.
//

import Foundation




//class MIDIDrumTrack : Sequence, Equatable, CustomStringConvertible {
//    public typealias Element = MIDIDrumEvent
//    public typealias Timestamp = Element.Timestamp
//
//    private final let sequence: MIDISequence
//    internal final let ref : MusicTrack
//
//    init(sequence: MIDISequence) {
//        self.sequence = sequence
//    }
//
//
//    public func makeIterator() -> AnyIterator<Element> {
//        fatalError()
//    }
//
//
//    public static func ==(lhs: MIDIDrumTrack, rhs: MIDIDrumTrack) -> Bool {
//        return lhs === rhs || lhs.elementsEqual(rhs)
//    }
//
//
//    public final var timerange: Range<Timestamp> {
//        return start..<end
//    }
//
//    public final var description: String {
//        var opts: [String] = []
//        if soloed {
//            opts.append("soloed")
//        }
//
//        if muted {
//            opts.append("muted")
//        }
//
//        return "MIDITrack(in:\(timerange), \(map { $0 }))"
//    }
//
//    public final subscript(timerange timerange: Range<Timestamp>) -> MIDIRangeIterator {
//        fatalError()
//    }
//
//    public final var start: Timestamp {
//        get {
//            return Timestamp(beats: _offsetTime)
//        }
//        set {
//
//            _offsetTime = newValue.beats
//        }
//    }
//
//    public final var end: Timestamp {
//        get {
//            return start.advanced(by: duration)
//        }
//        set {
//            duration = _offsetTime + newValue.beats
//        }
//    }
//
//
//}



