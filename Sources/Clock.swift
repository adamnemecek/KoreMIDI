//
//  main.swift
//  CAClock
//
//  Created by Adam Nemecek on 5/4/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AVFoundation

public final class Clock: Equatable {

    public enum Status { case stopped, running }

    //    public struct Timestamp : Comparable, Strideable, CustomStringConvertible, Hashable {
    //        public typealias Stride = CAClockSeconds.Stride
    //
    //        fileprivate let parent: Clock
    //        private let time : CAClockTime
    //
    //        public var seconds: CAClockSeconds {
    //            fatalError()
    //        }
    //
    //        internal init(parent: Clock, time: CAClockTime) {
    //            self.parent = parent
    //            self.time = time
    //        }
    //
    //        public var hashValue : Int {
    //            return seconds.hashValue
    //        }
    //
    //        public func distance(to other: Timestamp) -> Stride {
    ////            return time.distance(to: other.time)
    //            fatalError()
    //        }
    //
    //        public var description: String {
    //            return "\(seconds) seconds"
    //        }
    //
    //        public func advanced(by n: Stride) -> Timestamp {
    ////            return Timestamp(parent: parent, seconds: seconds.advanced(by: n))
    //            fatalError()
    //        }
    //
    //        public static func ==(lhs: Timestamp, rhs: Timestamp) -> Bool {
    ////            return lhs.seconds == rhs.seconds
    //            fatalError()
    //        }
    //
    //        public static func <(lhs: Timestamp, rhs: Timestamp) -> Bool {
    ////            return lhs.seconds < rhs.seconds
    //            fatalError()
    //        }
    //
    //        var hostTime : Float64 {
    //            var `in` = time
    ////            CAClockTranslateTime(ref, &time, <#T##inOutputTimeFormat: CAClockTimeFormat##CAClockTimeFormat#>, <#T##outTime: UnsafeMutablePointer<CAClockTime>##UnsafeMutablePointer<CAClockTime>#>)
    ////            time.time
    //            fatalError()
    //            //            return parent.translate(self, fmt: .hostTime)
    //
    //        }
    //
    //        var samples : Float64 {
    //            fatalError()
    //            //            return parent.translate(self, fmt: .samples)
    //        }
    //
    //        var beats : Float64 {
    //            fatalError()
    //            //            return parent.translate(self, fmt: .beats)
    //        }
    //
    ////        var seconds // relative position on media timeline
    //
    //        var smpteSeconds : Float64 {
    //            fatalError()
    ////             return parent.translate(self, fmt: .smpteSeconds)
    //        }
    //
    //        var smpteTime : SMPTETime {
    ////            return parent.translate(self, fmt: .smpteTime)
    //            fatalError()
    //        }
    //
    //        var absoluteSeconds : Float64 {
    //            fatalError()
    //        }
    //    }

    fileprivate let ref: CAClockRef

    internal init(sequence : MusicSequence) {
        var r: CAClockRef? = nil
        CAClockNew(0, &r)
        ref = r!
        armed = false
        status = .stopped
    }

    deinit {
        CAClockDispose(ref)
    }

    private func get<T>(prop: CAClockPropertyID) -> T {
        var ptr = UnsafeMutablePointer<T>.allocate(capacity: 1)
        var size : UInt32 = 0
        CAClockGetProperty(ref, prop, &size, ptr)

        defer {
            ptr.deallocate()
        }

        return ptr.pointee
    }

    private func set<T>(prop: CAClockPropertyID, value: T) {
        var v = value
        CAClockSetProperty(ref, prop, UInt32(MemoryLayout<T>.size), &v)
    }

    public var playRate : Float64 {
        get {
            var f: Float64 = 0
            OSAssert(CAClockGetPlayRate(ref, &f))
            return f
        }
        set {
            OSAssert(CAClockSetPlayRate(ref, newValue))
        }
    }

    public var internalTimebase : CAClockTimebase {
        get {
            return get(prop: .internalTimebase)
        }
        set {
            set(prop: .internalTimebase, value: newValue)
        }
    }

    public var timebaseSource : AudioDeviceID /* or AudioUit */ {
        get {
            return get(prop: .timebaseSource)
        }
        set {
            set(prop: .timebaseSource, value: newValue)
        }
    }

    public var syncMode : CAClockSyncMode {
        get {
            return get(prop: .syncMode)
        }
        set {
            set(prop: .syncMode, value: newValue)
        }
    }

    public var syncSource : MIDIEndpointRef {
        get {
            return get(prop: .syncSource)
        }
        set {
            set(prop: .syncSource, value: newValue)
        }
    }

    public var smpteFormat :  CAClockSMPTEFormat {
        get {
            return get(prop: .smpteFormat)
        }
        set {
            set(prop: .smpteFormat, value: newValue)
        }
    }

    public var smpteOffset : CAClockSeconds {
        get {
            return get(prop: .smpteOffset)
        }
        set {
            set(prop: .smpteOffset, value: newValue)
        }
    }

    public var clockDestionations: [MIDIEndpointRef] {
        get {
            return get(prop: .midiClockDestinations)
        }
        set {
            set(prop: .midiClockDestinations, value: newValue)
        }
    }

    public var mtcDestinations : [MIDIEndpointRef] {
        get {
            return get(prop: .mtcDestinations)
        }
        set {
            set(prop: .mtcDestinations, value: newValue)
        }
    }

    public var mtcFreewheelTime : CAClockSeconds {
        get {
            return get(prop: .mtcFreewheelTime)
        }
        set {
            set(prop: .mtcFreewheelTime, value: newValue)
        }
    }

    public var tempoMap : [CATempoMapEntry] {
        get {
            return get(prop: .tempoMap)
        }
        set {
            set(prop: .tempoMap, value: newValue)
        }
    }

    public var meterTrack : [CAMeterTrackEntry] {
        get {
            return get(prop: .meterTrack)
        }
        set {
            set(prop: .meterTrack, value: newValue)
        }
    }

    public var status : Status {
        didSet {
            guard oldValue != status else { return }
            switch status {
            case .running:
                OSAssert(CAClockStart(ref))
            case .stopped:
                OSAssert(CAClockStop(ref))
            }
        }
    }

    public var currentTempo : CAClockTempo {
        get {
            var t = CAClockTempo()
            OSAssert(CAClockGetCurrentTempo(ref, &t, nil))
            return t
        }
        set {
            OSAssert(CAClockSetCurrentTempo(ref, newValue, nil))
        }
    }

    public var currentTime : CAClockTime {
        get {
            var time = CAClockTime()
            OSAssert(CAClockGetCurrentTime(ref, .seconds, &time))
            return time
        }
        set {
            var time = newValue
            OSAssert(CAClockSetCurrentTime(ref, &time))
        }
    }

    //    private func translate(_ time: Timestamp, fmt: CAClockTimeFormat) -> Float64 {
    //        assert(self == time.parent)
    //
    ////        var `in` = CAClockTime(format: .seconds, reserved: 0, time: 0)
    //
    //        switch fmt {
    //        case .hostTime, .samples, .beats, .seconds, .smpteSeconds:
    //            var out = Float64()
    ////            CAClockTranslateTime(ref, `in`, fmt, &out)
    ////            return Timestamp(parent: time.parent, seconds: out)
    //
    //
    //        case .smpteTime:
    //            var out = SMPTETime()
    ////            CAClockTranslateTime(ref, `in`, fmt, &out)
    //        default:
    //            break
    //        }
    //
    //        return Timestamp(parent: time.parent, seconds: 0)
    //    }
    //
    public var start : CAClockTime {
        get {
            var time = CAClockTime()
            OSAssert(CAClockGetStartTime(ref, .seconds, &time))
            return time
        }
    }
    //
    //    private var listeners : [NSObjectProtocol : (() -> ())] = [:]
    //
    //    func observe(_ listener: () -> ()) -> NSObjectProtocol {
    //        let o = NSObject()
    //        listeners[o] = listener
    //        return o
    //    }

    public var armed : Bool {
        didSet {
            guard oldValue != armed else { return }
            if armed {
                OSAssert(CAClockArm(ref))
            }
            else {
                OSAssert(CAClockDisarm(ref))
            }
        }
    }

    public static func ==(lhs: Clock, rhs: Clock) -> Bool {
        return lhs.ref == rhs.ref
    }
}

extension CAClockBeats {
    init(clock: Clock, beatTime: CABarBeatTime) {
        var t = CABarBeatTime()
        var out = CAClockBeats()
        OSAssert(CAClockBarBeatTimeToBeats(clock.ref, &t, &out))
        self = out
    }
}



