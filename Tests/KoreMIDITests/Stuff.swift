//
//  Stuff.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/9/17.
//
//

import Foundation


extension Sequence {
    func split<A,B>(transform: @escaping (Element) -> (A,B)) -> AnyIterator<(A,B)> {
        var i = makeIterator()
        return AnyIterator {
            i.next().map { transform($0) }
        }
    }
}
