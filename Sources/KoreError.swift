//
//  OSStatus.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/14/17.
//
//

import AVFoundation

enum KoreError : String, Error {
    case invalidClient = "invalid client"
}


//enum Error: UInt32 {
//    case invalidSequence
//    kAudioToolboxErr_InvalidSequenceType: OSStatus { get }
//    kAudioToolboxErr_TrackIndexError: OSStatus { get }
//    public var kAudioToolboxErr_TrackNotFound: OSStatus { get }
//    public var kAudioToolboxErr_EndOfTrack: OSStatus { get }
//    public var kAudioToolboxErr_StartOfTrack: OSStatus { get }
//    public var kAudioToolboxErr_IllegalTrackDestination: OSStatus { get }
//    public var kAudioToolboxErr_NoSequence: OSStatus { get }
//    public var kAudioToolboxErr_InvalidEventType: OSStatus { get }
//    public var kAudioToolboxErr_InvalidPlayerState: OSStatus { get }
//    public var kAudioToolboxErr_CannotDoInCurrentContext: OSStatus { get }
//    public var kAudioToolboxError_NoTrackDestination: OSStatus { get }
//
//}


/*
/**
 Not as detailed as Adamson's CheckError, but adequate.
 For other projects you can uncomment the Core MIDI constants.
 */


func CheckError(_ error:OSStatus) {
    if error == 0 {return}

    switch error {
    case kMIDIInvalidClient :
        print( "kMIDIInvalidClient ")

    case kMIDIInvalidPort :
        print( "kMIDIInvalidPort ")

    case kMIDIWrongEndpointType :
        print( "kMIDIWrongEndpointType")

    case kMIDINoConnection :
        print( "kMIDINoConnection ")

    case kMIDIUnknownEndpoint :
        print( "kMIDIUnknownEndpoint ")

    case kMIDIUnknownProperty :
        print( "kMIDIUnknownProperty ")

    case kMIDIWrongPropertyType :
        print( "kMIDIWrongPropertyType ")

    case kMIDINoCurrentSetup :
        print( "kMIDINoCurrentSetup ")

    case kMIDIMessageSendErr :
        print( "kMIDIMessageSendErr ")

    case kMIDIServerStartErr :
        print( "kMIDIServerStartErr ")

    case kMIDISetupFormatErr :
        print( "kMIDISetupFormatErr ")

    case kMIDIWrongThread :
        print( "kMIDIWrongThread ")

    case kMIDIObjectNotFound :
        print( "kMIDIObjectNotFound ")

    case kMIDIIDNotUnique :
        print( "kMIDIIDNotUnique ")

    default: print( "huh? \(error) ")
    }

    switch(error) {
    //AUGraph.h
    case kAUGraphErr_NodeNotFound:
        print("Error:kAUGraphErr_NodeNotFound \n")

    case kAUGraphErr_OutputNodeErr:
        print( "Error:kAUGraphErr_OutputNodeErr \n")

    case kAUGraphErr_InvalidConnection:
        print("Error:kAUGraphErr_InvalidConnection \n")

    case kAUGraphErr_CannotDoInCurrentContext:
        print( "Error:kAUGraphErr_CannotDoInCurrentContext \n")

    case kAUGraphErr_InvalidAudioUnit:
        print( "Error:kAUGraphErr_InvalidAudioUnit \n")

        // core audio

    case kAudio_UnimplementedError:
        print("kAudio_UnimplementedError")
    case kAudio_FileNotFoundError:
        print("kAudio_FileNotFoundError")
    case kAudio_FilePermissionError:
        print("kAudio_FilePermissionError")
    case kAudio_TooManyFilesOpenError:
        print("kAudio_TooManyFilesOpenError")
    case kAudio_BadFilePathError:
        print("kAudio_BadFilePathError")
    case kAudio_ParamError:
        print("kAudio_ParamError")
    case kAudio_MemFullError:
        print("kAudio_MemFullError")

    // AudioToolbox

    case kAudioToolboxErr_InvalidSequenceType :
        print( " kAudioToolboxErr_InvalidSequenceType ")

    case kAudioToolboxErr_TrackIndexError :
        print( " kAudioToolboxErr_TrackIndexError ")

    case kAudioToolboxErr_TrackNotFound :
        print( " kAudioToolboxErr_TrackNotFound ")

    case kAudioToolboxErr_EndOfTrack :
        print( " kAudioToolboxErr_EndOfTrack ")

    case kAudioToolboxErr_StartOfTrack :
        print( " kAudioToolboxErr_StartOfTrack ")

    case kAudioToolboxErr_IllegalTrackDestination :
        print( " kAudioToolboxErr_IllegalTrackDestination")

    case kAudioToolboxErr_NoSequence :
        print( " kAudioToolboxErr_NoSequence ")

    case kAudioToolboxErr_InvalidEventType :
        print( " kAudioToolboxErr_InvalidEventType")

    case kAudioToolboxErr_InvalidPlayerState :
        print( " kAudioToolboxErr_InvalidPlayerState")

        // AudioUnit


    case kAudioUnitErr_InvalidProperty :
        print( " kAudioUnitErr_InvalidProperty")

    case kAudioUnitErr_InvalidParameter :
        print( " kAudioUnitErr_InvalidParameter")

    case kAudioUnitErr_InvalidElement :
        print( " kAudioUnitErr_InvalidElement")

    case kAudioUnitErr_NoConnection :
        print( " kAudioUnitErr_NoConnection")

    case kAudioUnitErr_FailedInitialization :
        print( " kAudioUnitErr_FailedInitialization")

    case kAudioUnitErr_TooManyFramesToProcess :
        print( " kAudioUnitErr_TooManyFramesToProcess")

    case kAudioUnitErr_InvalidFile :
        print( " kAudioUnitErr_InvalidFile")

    case kAudioUnitErr_FormatNotSupported :
        print( " kAudioUnitErr_FormatNotSupported")

    case kAudioUnitErr_Uninitialized :
        print( " kAudioUnitErr_Uninitialized")

    case kAudioUnitErr_InvalidScope :
        print( " kAudioUnitErr_InvalidScope")

    case kAudioUnitErr_PropertyNotWritable :
        print( " kAudioUnitErr_PropertyNotWritable")

    case kAudioUnitErr_InvalidPropertyValue :
        print( " kAudioUnitErr_InvalidPropertyValue")

    case kAudioUnitErr_PropertyNotInUse :
        print( " kAudioUnitErr_PropertyNotInUse")

    case kAudioUnitErr_Initialized :
        print( " kAudioUnitErr_Initialized")

    case kAudioUnitErr_InvalidOfflineRender :
        print( " kAudioUnitErr_InvalidOfflineRender")

    case kAudioUnitErr_Unauthorized :
        print( " kAudioUnitErr_Unauthorized")

    default:
        print("huh?")
    }
}*/
