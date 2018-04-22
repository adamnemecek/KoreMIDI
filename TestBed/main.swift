//
//  main.swift
//  TestBed
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import Foundation
import AVFoundation

struct NoteEvent : CustomStringConvertible {
    let timestamp : Float
    let pitch : UInt8
    let duration : Float32
    let track : Int
    let velocity : UInt8

    init(event : MIDITrack.Element, track : Int) {
        fatalError()
//        switch event {
////        case let .note(ts, data):
//            self.timestamp = Float(ts.beats)
//            self.duration = data.duration
//            self.pitch = data.note
//            self.velocity = data.velocity
//            self.track = track
//            break
//        default:
//            fatalError()
//        }
    }

    init(timestamp : Float, pitch : UInt8, duration : Float32, track : Int, velocity : UInt8) {
        self.timestamp = timestamp
        self.pitch = pitch
        self.duration = duration
        self.track = track
        self.velocity = velocity
    }

    var description: String {
        return "NoteEvent(timestamp : \(timestamp), pitch : \(pitch), duration : \(duration), track : \(track), velocity : \(velocity))"
    }
}
func test() {
    Swift.print("func notes() -> [NoteEvent] {\n var ret : [NoteEvent] = []\n")
    let path = "/Users/adamnemecek/Code/hypersphere/ngrid.io/_final/sandstorm.5track.mid"
    //"/Users/adamnemecek/midi/darude-sandstorm.mid"
    let url = URL(fileURLWithPath: path)

    let s = MIDISequence(import: url)
//    var notes : [NoteEvent]

    //let notes : [MIDINote] = []

    //
    for (i,track) in s.enumerated() {

        for note in track {
//            switch note {
//            case let .note(ts, data):
//                let n = NoteEvent(event: note, track: i)
//                Swift.print("ret.append(\(n))")
//            default:
//                break
//            }
        }
//        print(track.duration, track.start)
    }
    Swift.print("return ret;\n}")

//    for (i, track) in s.enumerated() {
//        print(i, track)
//        //    track[note] = note
//    }

//    print(s.dict())


//    var track = s[4]


    //print(s.start)
    //print("duration", track.duration)
    //track.insert(<#T##MIDIEvent#>, at: <#T##MIDITimestamp#>)

//    print(s.start!, s.end!.beats)
}
test()

func tt() {
    let seq = MIDISequence()

}

enum Action {
    case get, post, update, remove, select
}

class GPUTrack {

}



func custom() {

    var seq = MIDISequence()

    var track = MIDITrack(sequence : seq)
    let m = MIDINoteMessage(note: 60, duration: 20)
//    track.insert(.note(10.0, m))

//    MIDISequenceImport(d)
    let url = URL(fileURLWithPath: "/Users/adamnemecek/midi/darude-sandstorm.mid")
//    let seq = MIDISequenceImport(url)
//    let p = MIDIPlayer(sequence: seq)
    let q = try! AVMIDIPlayer(contentsOf: url, soundBankURL: nil)
    q.prepareToPlay()
    q.play {
        print("dne")
    }

    usleep(500 * 1000000)
    print(track)
}



func tst() {
    let url = URL(fileURLWithPath: "/Users/adamnemecek/midi/hypersphere/logic5.4.mid")
    var s = MIDISequence(import: url)

//    for var e in s {
//
//        print(e.insert(.note(10, MIDINoteMessage(note: 0, duration: 0.5))))
//    }
}

//var s = MIDISequence()
//for t in s {
//    print(t)
//}






//for a in zip(Timer(), 0...10) {
//    print(a)
//}

//let kls: Classifier<MIDINote, UInt8> = Classifier(notes) { (e: MIDINote) -> UInt8 in
//    e.note
//}
//
//print(kls)
