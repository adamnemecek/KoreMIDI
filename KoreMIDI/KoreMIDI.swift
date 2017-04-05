//
//  KoreMIDI.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation

import AudioToolbox


class MIDISequence : Collection {
    let ref : MusicSequence
    typealias Index = Int
    typealias Element = MIDITrack
    
    var startIndex: Index {
        return 0
    }
    
    var endIndex : Index {
        fatalError()
    }
    
    subscript(index: Index) -> Element {
        fatalError()
    }
    
    func index(after i: Index) -> Index {
        return i + 1
    }
    
    
    init() {
        ref = MIDISequenceCreate()
    }
    
    deinit {
        DisposeMusicSequence(ref)
    }
    
    func export() -> Data {
        fatalError()
    }
    
    var tempoTrack : MIDITrack {
        fatalError()
    }
}
extension Int {
    init(_ bool: Bool) {
        self = bool ? 1 : 0
    }
}

extension Bool {
    init(_ int: Int) {
        self = int != 0
    }
}

class MIDITrack : Sequence {
    typealias Element = Int
    let ref : MusicTrack
    
    
    init() {
        ref = MIDISequenceCreate()
    }
    
    deinit {
        
    }
    
    var loopInfo : Int {
        get {
            return self[kSequenceTrackProperty_LoopInfo]
        }
        set {
            self[kSequenceTrackProperty_LoopInfo] = newValue
        }
    }
    
    var offsetTime : Int {
        get {
            return self[kSequenceTrackProperty_OffsetTime]
        }
        set {
            self[kSequenceTrackProperty_OffsetTime] = newValue
        }
    }

    var muted : Bool {
        get {
            return Bool(self[kSequenceTrackProperty_MuteStatus])
        }
        set {
            self[kSequenceTrackProperty_OffsetTime] = Int(newValue)
        }
    }

    var soloed : Bool {
        get {
            return Bool(self[kSequenceTrackProperty_SoloStatus])
        }
        set {
            self[kSequenceTrackProperty_SoloStatus] = Int(newValue)
        }
    }

    var automatedParameters : Bool {
        get {
            return Bool(self[kSequenceTrackProperty_AutomatedParameters])
        }
        set {
            self[kSequenceTrackProperty_AutomatedParameters] = Int(newValue)
        }
    }
    
    var length : Int {
        get {
            return self[kSequenceTrackProperty_TrackLength]
        }
        set {
            self[kSequenceTrackProperty_TrackLength] = newValue
        }
    }
    
    var timeResolution : Int {
        get {
            return self[kSequenceTrackProperty_TimeResolution]
        }
        set {
            self[kSequenceTrackProperty_TimeResolution] = newValue
        }
    }
    
    func makeIterator() -> AnyIterator<Int> {
        fatalError()
    }
    
    private subscript(prop: UInt32) -> Int {
        get {
            return MIDITrackGetProperty(ref: ref, prop: prop)
        }
        set {
            MIDITrackSetProperty(ref: ref, prop: prop, to: newValue)
        }
    }
//    func insert(_ event: )
}

class EventIterator : IteratorProtocol {
    typealias Element = Int
    private let ref: MusicEventIterator
    
    init(track: MIDITrack) {
        fatalError()
    }
    deinit {
        DisposeMusicEventIterator(ref)
    }
    
    func next() -> Element? {
        fatalError()
    }
}

class MIDIEventIterator<Element> : EventIterator {
    
}


