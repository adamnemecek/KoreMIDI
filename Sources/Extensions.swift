//
//  Extensions.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AudioToolbox.MusicPlayer

func tee<T>(_ obj: T) -> T {
    print(obj)
    return obj
}

extension Range {
    func union(_ other: Range<Bound>) -> Range<Bound>{
        let s = [lowerBound, upperBound, other.lowerBound, other.upperBound].sorted()
        return s.first!..<s.last!
    }
}

extension Sequence where Iterator.Element : Hashable {
    func hashValue() -> Int {
        fatalError()
    }
}

extension Strideable {
    static func +(lhs: Self, rhs: Stride) -> Self {
        return lhs.advanced(by: rhs)
    }
}

extension Int {
    init(_ bool: Bool) {
        self = bool ? 1 : 0
    }
}

extension Bool {
    init(_ value: DarwinBoolean) {
        self = value.boolValue ? true : false
    }
}

extension Bool {
    init(_ int: Int) {
        self = int != 0
    }
}

extension Sequence {
    func reduce(combine: (Iterator.Element, Iterator.Element) throws -> Iterator.Element) rethrows -> Iterator.Element? {
        var g = makeIterator()
        guard var accu = g.next() else { return nil }
        
        while let next = g.next() {
            accu = try combine(accu, next)
        }
        return accu
    }
}

extension CABarBeatTime : CustomStringConvertible {
    public var description : String {
        return "bar: \(bar), beat: \(beat), subbeat: \(subbeat), subbeatDivisor: \(subbeatDivisor)"
    }
}

extension Data {
    init<T>(encode: T) {
        var cpy = encode
        self.init(bytes: withUnsafePointer(to: &cpy) { $0 }, count: MemoryLayout<T>.size)
    }
    
    func decode<T>() -> T {
        return withUnsafeBytes { $0.pointee }
    }
}
