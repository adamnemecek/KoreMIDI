//
//  MIDIPlayer.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 6/5/18.
//

import AVFoundation


internal class MIDIPlayer : CustomStringConvertible {
    private enum Player {
        case bank(AVMIDIPlayer, URL)
        case engine(AVAudioSequencer)
    }

    private var player: Player
    internal let sequence: MIDISequence

    init?(sequence: MIDISequence, bank: URL) {
        guard let player = try? AVMIDIPlayer(data: sequence.export(), soundBankURL: bank) else {
            return nil
        }
        self.sequence = sequence
        self.player = .bank(player, bank)
    }

    init?(sequence: MIDISequence, engine: AVAudioEngine) {
        let sequencer = AVAudioSequencer(audioEngine: engine)
        self.sequence = sequence
        self.player = .engine(sequencer)
    }

    var description: String {
        switch player {
        case let .bank(b, url):
            return "Player: soundbank \(url)"
        case let .engine(e):
            return ""
        }
    }

    func prepareToPlay() {
        switch player {
        case let .bank(b, _):
            b.prepareToPlay()
        case let .engine(e):
            e.prepareToPlay()
        }
    }

    //    func reload() {
    //        switch player {
    //        case let .bank(b):
    //            self.player
    //        case let .engine(e):
    //            break
    //
    //        }
    //    }

    func stop() {
        switch player {
        case let .bank(b, _):
            b.stop()
        case let .engine(e):
            e.stop()
        }
    }

    func play() {
        switch player {
        case let .bank(b, _):
            b.play()
        case let .engine(e):
            try! e.start()
        }
    }

    ///
    /// Duration in seconds
    ///
    var duration: TimeInterval {
        switch player {
        case let .bank(b, _):
            return b.duration
        case let .engine(e):
            return e.duration
        }
    }

    var isPlaying: Bool {
        switch player {
        case let .bank(b, _):
            return b.isPlaying
        case let .engine(e):
            return e.isPlaying
        }
    }

    var rate: Float {
        get {
            switch player {
            case let .bank(b, _):
                return b.rate
            case let .engine(e):
                return e.rate
            }
        }
        set {
            switch player {
            case let .bank(b, _):
                b.rate = newValue
            case let .engine(e):
                e.rate = newValue
            }
        }
    }

    ///
    /// Current position inseconds
    ///
    var currentPositionInSeconds: TimeInterval {
        get {
            switch player {
            case let .bank(b, _):
                return b.currentPosition
            case let .engine(e):
                return e.currentPositionInSeconds
            }
        }
        set {
            switch player {
            case let .bank(b, _):
                b.currentPosition = newValue
            case let .engine(e):
                e.currentPositionInSeconds = newValue
            }
        }
    }
}

extension AVAudioSequencer {
    var duration: TimeInterval {
        return tracks.max { $0.lengthInSeconds }?.lengthInSeconds ?? 0
    }
}

/*

 @available(OSX 10.10, *)
 open class AVMIDIPlayer: NSObject {


 /*!    @method initWithContentsOfURL:soundBankURL:error:
 @abstract Create a player with the contents of the file specified by the URL.
 @discussion
 'bankURL' should contain the path to a SoundFont2 or DLS bank to be used
 by the MIDI synthesizer.  For OSX it can be set to nil for the default,
 but for iOS it must always refer to a valid bank file.
 */
 public init(contentsOf inURL: URL, soundBankURL bankURL: URL?) throws


 /*!    @method initWithData:soundBankURL:error:
 @abstract Create a player with the contents of the data object
 @discussion
 'bankURL' should contain the path to a SoundFont2 or DLS bank to be used
 by the MIDI synthesizer.  For OSX it can be set to nil for the default,
 but for iOS it must always refer to a valid bank file.
 */
 public init(data: Data, soundBankURL bankURL: URL?) throws


 /* transport control */

 /*! @method prepareToPlay
 @abstract Get ready to play the sequence by prerolling all events
 @discussion
 Happens automatically on play if it has not already been called, but may produce a delay in startup.
 */
 open func prepareToPlay()


 /*! @method play:
 @abstract Play the sequence.
 */
 open func play(_ completionHandler: AVFoundation.AVMIDIPlayerCompletionHandler? = nil)


 /*! @method stop
 @abstract Stop playing the sequence.
 */
 open func stop()


 /* properties */

 /*! @property duration
 @abstract The length of the currently loaded file in seconds.
 */
 open var duration: TimeInterval { get }


 /*! @property playing
 @abstract Indicates whether or not the player is playing
 */
 open var isPlaying: Bool { get }


 /*! @property rate
 @abstract The playback rate of the player
 @discussion
 1.0 is normal playback rate.  Rate must be > 0.0.
 */
 open var rate: Float


 /*! @property currentPosition
 @abstract The current playback position in seconds
 @discussion
 Setting this positions the player to the specified time.  No range checking on the time value is done.
 This can be set while the player is playing, in which case playback will resume at the new time.
 */
 open var currentPosition: TimeInterval
 }*/
