//
//  EventType.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 2/7/18.
//

public protocol EventType: Comparable, Hashable {
    associatedtype Timestamp: Comparable & Hashable
    var timestamp: Timestamp { get }
}

extension EventType {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }

    public var hashValue: Int {
        return timestamp.hashValue
    }
}

