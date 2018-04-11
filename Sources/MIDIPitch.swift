//
//  MIDIPitch.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/9/17.
//
//

public struct MIDIPitch : Comparable, Hashable, RawRepresentable, Strideable {
    public typealias Interval = Int
    private static let range = 0..<Int8.max

    public let rawValue: Int8

    public init?(rawValue: Int8) {
        self.rawValue = rawValue
    }

    public init(_ value: Int8) {
        self.rawValue = value
    }

    public static func +(lhs: MIDIPitch, rhs: Interval) -> MIDIPitch {
        fatalError()
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

    public var hashValue: Int {
        return rawValue.hashValue
    }
}

public struct MIDIDrum : Comparable, Hashable, RawRepresentable, Strideable {
    public typealias Interval = Int
    private static let range = 0..<Int8.max

    public let rawValue: Int8

    public init?(rawValue: Int8) {
        self.rawValue = rawValue
    }

    public init(_ value: Int8) {
        self.rawValue = value
    }

    public static func +(lhs: MIDIDrum, rhs: Interval) -> MIDIDrum {
        fatalError()
    }

    public func advanced(by n: Interval) -> MIDIDrum {
        return self + n
    }

    public func distance(to other: MIDIDrum) -> Interval {
        return rawValue.distance(to: other.rawValue)
    }

    public static func ==(lhs: MIDIDrum, rhs: MIDIDrum) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }

    public static func <(lhs: MIDIDrum, rhs: MIDIDrum) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public var hashValue: Int {
        return rawValue.hashValue
    }
}
