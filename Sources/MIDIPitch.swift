//
//  MIDIPitch.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/9/17.
//
//

//
// PitchClass
//

public enum PitchClass : Int {
    case c, cs, d, ds, e, f, fs, g, gs, a, `as`, b
}

public struct MIDIPitch: Comparable, Hashable, RawRepresentable, Strideable, CustomStringConvertible {

    public typealias Interval = Int

    public static let min = MIDIPitch(0)
    public static let max = MIDIPitch(127)

    public let rawValue: Int8

    public init?(rawValue: Int8) {
        self.rawValue = rawValue
    }

    public init(_ value: Int8) {
        self.rawValue = value
    }

    public static func +(lhs: MIDIPitch, rhs: Interval) -> MIDIPitch? {
        return MIDIPitch(rawValue: lhs.rawValue + Int8(rhs))
    }

    public func advanced(by n: Interval) -> MIDIPitch {
        return self + n
    }

    public func distance(to other: MIDIPitch) -> Interval {
        return rawValue.distance(to: other.rawValue)
    }

    public static func ==(lhs: MIDIPitch, rhs: MIDIPitch) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }

    public static func <(lhs: MIDIPitch, rhs: MIDIPitch) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public var octave: Int {
        return Int(rawValue) / 12
    }

    public var pc: PitchClass {
        return PitchClass(rawValue: Int(rawValue) % 12)!
    }

    public var hashValue: Int {
        return rawValue.hashValue
    }

    public var description: String {
        return "\(octave)\(pc)(\(rawValue))"
    }
}
