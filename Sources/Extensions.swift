//
//  Extensions.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AVFoundation

func tee<T>(_ obj: T) -> T {
    print(obj)
    return obj
}

extension Range {
    func union(_ other: Range) -> Range<Bound>{
        return Swift.min(lowerBound, other.lowerBound)..<Swift.max(upperBound, other.upperBound)
    }
}

//extension Sequence where Iterator.Element : Hashable {
//    func hashValue() -> Int {
//        fatalError()
//    }
//}

extension Strideable {
    static func +(lhs: Self, rhs: Stride) -> Self {
        return lhs.advanced(by: rhs)
    }

    static func -(lhs: Self, rhs: Self) -> Stride {
        return lhs.distance(to: rhs)
    }
}

extension Int {
    init(_ bool: Bool) {
        self = bool ? 1 : 0
    }
}

extension Bool {
    init(_ value: DarwinBoolean) {
        self = value.boolValue
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

    func all(predicate:(Iterator.Element) -> Bool) -> Bool {
        for e in self where predicate(e) {
            return false
        }
        return true
    }
}

protocol DefaultConstructible {
    init()
}

//
//extension Sequence {
//    func reduce<E: DefaultConstructible>(combine: (E, Iterator.Element) throws -> Iterator.Element) rethrows -> Iterator.Element? {
//        var g = makeIterator()
//        guard var accu = g.next() else { return nil }
//
//        while let next = g.next() {
//            accu = try combine(accu, next)
//        }
//        return accu
//    }
//}

extension CABarBeatTime : Equatable, Hashable, CustomStringConvertible {
    public static func ==(lhs: CABarBeatTime, rhs: CABarBeatTime) -> Bool {
        return lhs.bar == rhs.bar &&
            lhs.beat == rhs.beat &&
            lhs.subbeat == rhs.subbeat &&
            lhs.subbeatDivisor == rhs.subbeatDivisor
    }

    public var hashValue: Int {
        return bar.hashValue
    }

    public var description : String {
        return "bar: \(bar), beat: \(beat), subbeat: \(subbeat), subbeatDivisor: \(subbeatDivisor)"
    }
}

extension Data {
    init<T>(noCopy: inout T, count: Int? = nil) {
        self.init(bytesNoCopy: &noCopy,
                  count: count ?? MemoryLayout<T>.size,
                  deallocator: .none)
    }

    init<T>(encode: T) {
        var cpy = encode
        self.init(bytes: &cpy, count: MemoryLayout<T>.size)
    }

    init<T>(encode: inout T) {
        self.init(bytes: &encode, count: MemoryLayout<T>.size)
    }

    @inline(__always)
    func decode<T>() -> T {
        return withUnsafeBytes { $0.pointee }
    }

    //    subscript(from index: Index) -> Data {
    //        return subdata(in: index..<endIndex)
    //    }
}


extension Sequence where Iterator.Element : Comparable {
    func range() -> ClosedRange<Iterator.Element>? {
        var min : Iterator.Element? = nil
        var max : Iterator.Element? = nil
        for e in self {
            min = Swift.min(e, min ?? e)
            max = Swift.max(e, max ?? e)
        }
        return min.map { $0...max! }
    }
}

