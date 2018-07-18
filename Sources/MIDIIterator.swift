//
//  Iterators.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AVFoundation

//public class MIDIIterator: IteratorProtocol {
//    public typealias Timestamp = MIDITimestamp
//    public typealias Element = MIDINote
//
//    internal init(_ content: MIDITrack, timestamp: Timestamp? = nil) {
//        self.ref = MIDIIteratorCreate(ref : content.ref)
//        timestamp.map {
//            self.seek(to: $0)
//        }
//    }
//
//    deinit {
//        OSAssert(DisposeMusicEventIterator(ref))
//    }
//
//    public final var current: Element? {
//        get {
//            fatalError()
//        }
//        set {
//            fatalError()
//        }
////        return MIDIIteratorGetCurrent(ref: ref)
////        if let e : Element = MIDIIteratorGetCurrent(ref: _ref) {
////            if let r = _timerange, !r.contains(e.timestamp) {
////                return nil
////            }
////            return e
////        }
////        return nil
//    }
//
//    internal func remove() -> Element? {
//        defer {
//            OSAssert(MusicEventIteratorDeleteEvent(ref))
//        }
//        return current
//    }
//
//    public func next() -> Element? {
//        defer {
//            fwd()
//        }
//        return current
//    }
//
//    public final func seek(to timestamp: Timestamp) {
//        OSAssert(MusicEventIteratorSeek(ref, timestamp.beats))
//    }
//
//    @inline(__always)
//    fileprivate func fwd() {
//        OSAssert(MusicEventIteratorNextEvent(ref))
//    }
//
//    @inline(__always)
//    fileprivate func bwd() {
//        OSAssert(MusicEventIteratorPreviousEvent(ref))
//    }
//
//    private let ref: MusicEventIterator
//
//
////    private let _timerange: Range<Timestamp>?
//}

/// todo rename to cursor?
public class MIDIEventRawBufferIterator: IteratorProtocol {
    public typealias Timestamp = MIDITimestamp
    public typealias Element = MIDIEventRawBuffer

    internal init(_ content: MIDITrack) {
        self.ref = MIDIIteratorCreate(ref : content.ref)
    }

    internal init(ref: MusicTrack) {
        self.ref = MIDIIteratorCreate(ref : ref)
    }

    deinit {
        OSAssert(DisposeMusicEventIterator(ref))
    }

    final var current: Element? {
        get {
            return Element(ref: ref)
        }
        set {
            ///
            /// if we are updating,
            ///
            if let event = newValue {
                _ = event.data.baseAddress.map {
                    OSAssert(MusicEventIteratorSetEventInfo(ref, event.type.rawValue, $0))
                }
                if event.timestamp != current?.timestamp {
                    /// note that this moved the pointer to the next event
                    OSAssert(MusicEventIteratorSetEventTime(ref, MusicTimeStamp(event.timestamp.beats)))
                }
            }
            else {
                _ = remove()
            }
        }
    }

    final func remove() -> Element? {
        defer {
            OSAssert(MusicEventIteratorDeleteEvent(ref))
        }
        return current
    }

    public func next() -> Element? {
        defer {
            fwd()
        }
        return current
    }

    final func previous() -> Element? {
        defer { 
            bwd()
        }
        return current
    }

    final func seek(to timestamp: Timestamp) {
        OSAssert(MusicEventIteratorSeek(ref, timestamp.beats))
    }

    private var hasCurrent: Bool {
        var ret: DarwinBoolean = false
        OSAssert(MusicEventIteratorHasCurrentEvent(ref, &ret))
        return ret.boolValue
    }

    private var hasNext: Bool {
        var ret: DarwinBoolean = false
        OSAssert(MusicEventIteratorHasNextEvent(ref, &ret))
        return ret.boolValue
    }

    private var hasPrevious: Bool {
        var ret: DarwinBoolean = false
        OSAssert(MusicEventIteratorHasPreviousEvent(ref, &ret))
        return ret.boolValue
    }

    @inline(__always)
    fileprivate func fwd() {
        guard hasNext else { return }
        OSAssert(MusicEventIteratorNextEvent(ref))
    }

    @inline(__always)
    fileprivate func bwd() {
        guard hasPrevious else { return }
        OSAssert(MusicEventIteratorPreviousEvent(ref))
    }

    private let ref: MusicEventIterator
}

public class MIDIRangeIterator : MIDIEventRawBufferIterator {
    public let timerange : Range<Timestamp>

    internal init(_ content: MIDITrack, timerange: Range<Timestamp>) {
        self.timerange = timerange
        super.init(content)
        self.seek(to: timerange.lowerBound)
    }

    public override func next() -> Element? {
        return super.next().flatMap {
            guard self.timerange.contains($0.timestamp) else { return nil }
            return $0
        }
    }
}

//struct MIDIEventIterator<Event: EventType> {
//
//}

