//
//  MIDITrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AVFoundation


//@convention(c) func SequenceCallback(ref: UnsafeMutableRawPointer?,
//                                    seq: MusicSequence,
//                                    track: MusicTrack,
//                                    timestamp: MusicTimeStamp,
//                                    userdata: UnsafePointer<MusicEventUserData>,
//                                    timestamp2: MusicTimeStamp,
//                                    timestamp3: Musi  cTimeStamp) {
//
//}

public class MIDITrack : Sequence, Equatable, Comparable, Hashable, CustomStringConvertible {

    public typealias Timestamp = MIDITimestamp
    public typealias Element = MIDINote

    /// this needs to be a strong reference because sequence need to be around as long as track is around
    private final let sequence: MIDISequence
    internal final let ref : MusicTrack
//    let instrument: InstrumentName

    public static func ===(lhs: MIDITrack, rhs: MIDITrack) -> Bool {
        return lhs.ref == rhs.ref
    }

    public static func ==(lhs: MIDITrack, rhs: MIDITrack) -> Bool {
        return lhs === rhs || lhs.elementsEqual(rhs)
    }

    public static func <(lhs: MIDITrack, rhs: MIDITrack) -> Bool {
        return lhs.ref.hashValue < rhs.ref.hashValue
    }

    public init(sequence: MIDISequence) {
        self.sequence = sequence
        self.ref = MIDITrackCreate(ref: sequence.ref)
//        self.instrument = InstrumentName(ref: self.ref)
    }

    internal init(sequence: MIDISequence, no: Int) {
        self.sequence = sequence
        self.ref = MusicSequenceGetTrack(ref: sequence.ref, at: no)
//        self.instrument = InstrumentName(ref: self.ref)
    }

    public final var timerange: Range<Timestamp> {
        return start..<end
    }

    public final var description: String {
        var opts: [String] = []
        if soloed {
            opts.append("soloed")
        }

        if muted {
            opts.append("muted")
        }

        return "MIDITrack(in:\(timerange), \(map { $0 }))"
    }

    public final subscript(timerange timerange: Range<Timestamp>) -> MIDIRangeIterator {
        fatalError()
    }

    public final var start: Timestamp {
        get {
            return Timestamp(beats: _offsetTime)
        }
        set {

            _offsetTime = newValue.beats
        }
    }

    public final var end: Timestamp {
        get {
            return start.advanced(by: duration)
        }
        set {
            duration = _offsetTime + newValue.beats
        }
    }

    public final func makeIterator() -> AnyIterator<Element> { // MIDIIterator {
        let i = MIDIDataIterator(self)

        return AnyIterator {
            while let n = i.next() {
                if n.type == .note {
                    return Element(data: n)
                }
            }
            return nil
        }
    }

    public final var hashValue: Int {
        return ref.hashValue
    }

    public final var loopInfo : MusicTrackLoopInfo {
        get {
            return self[.loopInfo]
        }
        set {
            self[.loopInfo] = newValue
        }
    }

    public final var muted : Bool {
        get {
            let ret : DarwinBoolean = self[.muted]
            return ret.boolValue
        }
        set {
            self[.muted] = DarwinBoolean(newValue)
        }
    }

    public final var soloed : Bool {
        get {
            let ret : DarwinBoolean = self[.soloed]
            return ret.boolValue
        }
        set {
            self[.soloed] = DarwinBoolean(newValue)
        }
    }

    public final var automatedParameters : UInt32 {
        get {
            return self[.automatedParams]
        }
        set {
            self[.automatedParams] = newValue
        }
    }

    public final var timeResolution : Int16 {
        get {
            return self[.resolution]
        }
        set {
            self[.resolution] = newValue
        }
    }

    private subscript <T>(_ prop: MIDITrackProp) -> T {
        get {
            return MIDITrackGetProperty(ref: ref, prop: prop)
        }
        set {
            MIDITrackSetProperty(ref: ref, prop: prop, to: newValue)
        }
    }

    private var _offsetTime : MusicTimeStamp {
        get {
            return self[.offsetTime]
        }
        set {
            self[.offsetTime] = newValue
        }
    }

    public final var duration : Timestamp.Stride {
        get {

            return self[.length]
        }
        set {
            self[.length] = newValue
        }
    }

    func flatMap(timerange: Range<Timestamp>,
                 transform: (Element) -> Element?) {
        var i = MIDIRangeIterator(self, timerange: timerange)

        var add: [Element] = []

        while let current = i.next() {
            if let mapped = transform(current) {
                if current.timestamp != mapped.timestamp {
                    // change
                    _ = i.remove()
                }
                else {

                }

//                add.append(transform(n))
            }
            else {
                // remove current from iterator
                
            }
        }
        
    }

    final func insert(_ element: Element) {
        fatalError()
//        MusicSequenceInsert(ref: ref, event: element)
    }

    func move(_ timerange: Range<Timestamp>, to timestamp: Timestamp) {
        OSAssert(MusicTrackMoveEvents(ref,
                                      timerange.lowerBound.beats,
                                      timerange.upperBound.beats,
                                      timestamp.beats))
    }

    func remove<S : SetAlgebra & TimeSeries>(elements: S) where S.Element == Element {
//        var i = MIDIIterator(self, timestamp: elements.startTime)

        fatalError()
    }

    func load(from other: MIDITrack) {
        clearAll()
        copyInsert(from: other, in: other.timerange, at: other.start)
    }

    convenience init(copy: MIDITrack) {
        self.init(sequence: copy.sequence)
        load(from: copy)
    }

    func clear(_ timerange: Range<Timestamp>) {
        OSAssert(MusicTrackClear(ref,
                                 timerange.lowerBound.beats,
                                 timerange.upperBound.beats))
    }

//    var channelEvents:

    func clearAll() {
        clear(timerange)
    }

    func cut(_ timerange: Range<Timestamp>) {
        OSAssert(MusicTrackCut(ref,
                               timerange.lowerBound.beats,
                               timerange.upperBound.beats))
    }

    func copyInsert(from other: MIDITrack,
                    in timerange: Range<Timestamp>? = nil,
                    at timestamp: Timestamp? = nil) {
        let tr = timerange ?? other.timerange
        OSAssert(MusicTrackCopyInsert(other.ref,
                                      tr.lowerBound.beats,
                                      tr.upperBound.beats,
                                      ref,
                                      timestamp?.beats ?? 0))
    }

    func merge(with other: MIDITrack,
               in timerange: Range<Timestamp>? = nil,
               at timestamp: Timestamp? = nil) {
        let tr = timerange ?? other.timerange
        OSAssert(MusicTrackMerge(other.ref,
                                 tr.lowerBound.beats,
                                 tr.upperBound.beats,
                                 ref,
                                 (timestamp ?? 0).beats))
    }

    func remove<S : Sequence>(_ elements: S) where S.Iterator.Element == Element {
        guard let range = (elements.lazy.map { $0.timestamp }.range()) else { return }
        let s = Set(elements)
        fatalError()
        //            remove(range) {
        //                s.contains($0)
        //            }
    }

    func remove(_ timerange: Range<Timestamp>,
                predicate: (Element) -> Bool) {

        let i = MIDIRangeIterator(self, timerange: timerange)

        while let n = i.next() {
//            if predicate(n) {
//                _ = i.remove()
//            }
        }
    }

    fileprivate init(tempo sequence: MIDISequence) {
        self.sequence = sequence
        self.ref = MusicSequenceGetTempoTrack(ref: sequence.ref)
    }
}

public class MIDITempoTrack : MIDITrack {
    override init(sequence: MIDISequence) {
        super.init(tempo : sequence)
    }
}

@inline(__always) fileprivate
func MusicSequenceGetTrack(ref: MusicSequence, at index: Int) -> MusicTrack {
    var r : MusicTrack? = nil
    OSAssert(MusicSequenceGetIndTrack(ref, UInt32(index), &r))
    return r!
}






