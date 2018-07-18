//
//  main.swift
//  KoreMIDI2
//
//  Created by Adam Nemecek on 7/15/18.
//

import Foundation

print("Hello, World!")

public enum MIDIMetaEvent {
    case copyright(String)
    

    internal init(event: UnsafePointer<MIDIMetaEvent>) {
        fatalError()
    }
}


