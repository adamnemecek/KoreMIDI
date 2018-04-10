//
//  MIDIMetaTrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 1/30/18.
//

import AVFoundation

public final class MIDIMetaTrack<Element : MIDIMetaEventType>: Sequence, Equatable, Hashable {
    private let sequence: MIDISequence

    internal init(sequence: MIDISequence) {
        self.sequence = sequence
    }

    public func makeIterator() -> AnyIterator<Element> {
        var i = sequence.first?.makeIterator()
        return AnyIterator {
            fatalError()
//            while let n = i.next() {
//                if Element.byte == n {
//                    return
//                }
////                if Element.byte ==  {
////
////                }
//            }
        }
    }

    public static func ==(lhs: MIDIMetaTrack, rhs: MIDIMetaTrack) -> Bool {
        return lhs.elementsEqual(rhs)
    }

    public var hashValue: Int {
        fatalError()
    }
}
