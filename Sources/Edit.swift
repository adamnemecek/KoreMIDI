//
//  File.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import Foundation

//
//enum Edit<Element : Equatable & Hashable & Comparable> : Equatable, Hashable, Comparable {
//    case create(Element), update(Element, Element), delete(Element)
//
//    static func ==(lhs: Edit, rhs: Edit) -> Bool {
//        switch (lhs, rhs) {
//        case let (.create(l), .create(r)) where l == r:
//            return true
//        case let (.update(_, l), .update(_, r)) where l == r:
//            return true
//        case let (.delete(l), .delete(r)) where l == r:
//            return true
//
//        default: return false
//        }
//    }
//
//    private var comparable : Element {
//        switch self {
//        case let .create(v):
//            return v
//        case let .update(l, _):
//            return l
//        case let .delete(v):
//            return v
//        }
//    }
//
//    static func <(lhs: Edit, rhs: Edit) -> Bool {
//        return lhs.comparable < rhs.comparable
//    }
//
//    var hashValue : Int {
//        switch self {
//        case let .create(v):
//            return v.hashValue
//        case let .update(l, _):
//            return l.hashValue
//        case let .delete(v):
//            return v.hashValue
//        }
//    }
//
//
//}
//
//extension RangeReplaceableCollection where Element : Equatable & Hashable {
//
//    mutating
//    func edit<S : Sequence>(_ seq: S) where S.Element == Edit<Element> {
////        let q = seq.filter { $0.self == .create.self }
// 
//    }
//}
