//
//  main.swift
//  Sequencer
//
//  Created by Adam Nemecek on 6/8/18.
//

import Foundation
import AVFoundation


//AVAudioSequencer

extension AVAudioSequencer {
    convenience init?(url: URL) {
        self.init()
//         try? load(from: url, options: [.smfChannelsToTracks]) else { return nil }
        fatalError()
    }
}

func main() {
    let url = "/Users/adamnemecek/midi/darude-sandstorm.mid"
    print(url)
    let u = URL(fileURLWithPath: url)
    var v = AVAudioSequencer()
    try? v.load(from: u, options: [])
//    print(Array(v.tracks[0]) )

}

main()


