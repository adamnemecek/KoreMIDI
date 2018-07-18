//
//  Timer.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import Foundation

import QuartzCore

struct TimerIterator: IteratorProtocol {
    typealias Element = CFTimeInterval
    func next() ->  Element? {
        return CACurrentMediaTime()
    }
}

struct Timer: Sequence {
    func makeIterator() -> TimerIterator {
        return TimerIterator()
    }
}


