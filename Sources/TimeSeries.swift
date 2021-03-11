//
//  TimeSeries.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/9/17.
//
//

import Foundation

public protocol Temporal {
    associatedtype Timestamp: Comparable, Strideable
}

public protocol TimeSeries: Sequence, Temporal {
    var start: Timestamp { get }
    var end: Timestamp { get }

    var duration: Timestamp.Stride { get }
//    func timestamp(after t: Timestamp) -> Timestamp
    //    subscript(timerange: Range<Timestamp>) -> SubSequence { get }
}

extension TimeSeries {
    var timerange: Range<Timestamp> {
        return start..<end
    }
}

protocol MutableTimeSeries: TimeSeries {
//    subscript(timerange: Range<Timestamp>) -> SubSequence { get set }
}

extension TimeSeries {
    var duration: Timestamp.Stride {
        return start.distance(to: end)
    }
}
//
//
//
//struct Cursor {
//
//}
