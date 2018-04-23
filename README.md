# KoreMIDI: MIDI Swift library

This project as a wrapper around the AudioToolbox framework and tries to make it look like a 21st century framework.  

## Documentation
### MIDI File Docs
* http://www.onicos.com/staff/iz/formats/midi-event.html
* http://www.somascape.org/midi/tech/mfile.html

Note In the above description, note data refers to all MIDI events (Channel MIDI messages), whereas timing related events refers to the following Meta events : Marker, Cue Point, Tempo, SMPTE Offset, Time Signature, and Key Signature. Key Signature events are not strictly timing related, though they fall into this group. These Meta events are all detailed later.

note that you never need event -> packet since you aren't sending the events directly

```
let sequence = MIDISequence(url: "darude-sandstorm.mid")

let tempo = sequence.tempo


class Document : NSDocument {
    
}

```

```
enum MIDIEvent <Timestamp> : Comparable, Strideable, Hashable,      CustomStringConvertible {
    
}

public protocol Temporal {
    associatedtype Timestamp : Comparable, Strideable
}

public protocol TimeSeries : Sequence, Temporal {
    var start: Timestamp { get }
    var end : Timestamp { get }

    var duration : Timestamp.Stride { get }

    func timestamp(after t: Timestamp) -> Timestamp

    //    subscript(timerange: Range<Timestamp>) -> SubSequence { get }
}

```

```
class MIDISequence : MutableCollection, RangeReplaceableCollection, Hashable, Comparable {
    typealias Index = Int
    typealias Element = MIDITrack

    /// Create a new sequence
    init()

    /// Import Data containing MIDI
    init(import data: Data)

    /// 
    init(import url: URL)

    /// export sequence as data
    func export() -> Data

    ///
    func save(to url: URL)

    ///
    public var tempoTrack: MIDITrack<> { get }
}

class MIDITempo : Sequence {
    typealias Element = MIDITempo
}
```


```
class MIDITrack : Sequence, Hashable, Equatable {
    public typealias Element = MIDIEvent
    public typealias Timestamp = MIDITimestamp

    init()
    var timerange: Range<MIDITimestamp> { get }
    var start: MIDITimestamp { get }
    var end: MIDITimestamp { get }
    var duration : Int { get set }

    /// 
    subscript(timerange timerange: Range<MIDITimestamp>) -> AnyIterator<Element>

    var loopInfo : Int { get set }
    var muted : Bool { get set }
    var soloed : Bool { get set }
    var automatedParams : Bool { get set }
    var timeResolution : Int { get set } 

    mutating func move(_ timerange: Range<MIDITimestamp>, to timestamp: MIDITimestamp)

}
```

 

## MIDITimestamp

MIDITimestamp is the timestamp in the context of a . 

```
struct MIDITimestamp : Comparable, Hashable, Strideable, CustomStringConvertible {
var beats: AVMusicTimeStamp { get }
var seconds: Float64 { get }
func beatTime(for subdivisor: UInt32 = 4) -> CABarBeatTime
static func +(lhs: MIDITimestamp, rhs: MIDITimestamp) -> MIDITimestamp
}
```


```
enum MIDIEventType : RawRepresentable {
    case extendedNote, extendedTempo, user, meta, note, channel, rawData, parameter, auPreset
}

```



```swift

    let sequence = MIDISequence(url: "darude-sandstorm.mid")
    let lyrics = sequence.lyrics
    /// this is a separate property as 

    let drums = sequence.drums
    let track = sequence[0]
    
 
```
