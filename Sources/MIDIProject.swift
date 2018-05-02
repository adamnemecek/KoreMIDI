//
//  MIDIProject.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import Cocoa
import AVFoundation




class MIDIProject : NSDocument {

    let sequence: MIDISequence
    let url : URL

    init(url: URL) {
        self.url = url
        self.sequence = MIDISequence(import: url)
        super.init()
    }
}

//class MIDIProject {
//    let sequence : MIDISequence
//}
//
//class MIDIProjectController : MIDIProject {
//
//}

extension MIDIPacketList {

//    init<S: Sequence>(_ data: S) where S.Element == UInt8 {
//        self.init(packet: MIDIPacket(Array(data)))
//    }

    init(packet: MIDIPacket) {
        self.init(numPackets: 1, packet: packet)
    }
}

extension Data {
    var bytes: UnsafeRawPointer {
        return (self as NSData).bytes
    }
}



extension MIDIPacket {
//    init(event: MIDIEvent) {
//        switch event {
//        case let .note(ts, e):
//            self.init(Data(encode: e), timestamp: MIDITimeStamp(ts.beats))
//        default:
//            fatalError()
//        }
//    }

    init(_ data: [UInt8], timestamp: MIDITimeStamp = 0) {
        self.init()
        self.timeStamp = timestamp
        self.length = UInt16(data.count)
        _ = withUnsafeMutableBytes(of: &self.data) {
            memcpy($0.baseAddress, data, data.count)
        }
    }

    init(_ data: Data, timestamp: MIDITimeStamp = 0) {
        self.init()
        self.timeStamp = timestamp
        self.length = UInt16(data.count)

//        fatalError()
        _ = withUnsafeMutableBytes(of: &self.data) {
            memcpy($0.baseAddress, data.bytes, data.count)
        }
    }
}
