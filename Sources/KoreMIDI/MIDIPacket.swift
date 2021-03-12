//
//  MIDIPacket.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 5/12/17.
//
//

import Foundation
import AudioToolbox.MusicPlayer

protocol MIDIEventConvertible {

}

internal protocol VLQ {
    associatedtype Length : UnsignedInteger
    var length : Length { get }
}

extension MemoryLayout where T : VLQ {
    @inline(__always)
    static func size(ofVLQ value: T) -> Int {
//        return MemoryLayout.size + Int(value.length.toIntMax())
        fatalError()
    }
}

extension UnsafePointer where Pointee : VLQ {
    var dynamicSize : Int {
        @inline(__always)
        get {
            return MemoryLayout<Pointee>.size(ofVLQ: pointee)
        }
    }
}

extension MIDIPacket : VLQ {
    
}

extension MIDIEventConvertible {
    @inline(__always)
    init(event: DataEvent<Float, Foundation.Data>) {
//        self = event.data.decode()
        fatalError()
    }
}

extension Data {
    /// packet is dynamically sized by defailt
    init<Value: VLQ>(vlq bytes: UnsafePointer<Value>) {
        self.init(bytes: bytes, count: bytes.dynamicSize)
    }
}

extension DataEvent where Data : MIDIEventConvertible {
    @inline(__always)
    internal init(timestamp: Timestamp, bytes: UnsafePointer<MIDIPacket>) {
        self.timestamp = timestamp
        self.data = Foundation.Data(vlq: bytes).decode()

    }
}
