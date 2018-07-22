//
//  MIDIPolyphonicKeyPressureEvent.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 2/1/18.
//


struct MIDIPolyphonicKeyPressureEvent {
    let timestamp: MIDITimestamp
    let note: UInt8
    let pressure: UInt8
}
