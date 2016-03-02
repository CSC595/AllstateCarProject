//
//  MicrophoneNoise.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/11/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import AVFoundation
//import CoreAudio

class MicrophoneNoise {
    
    var isDistracted:Bool {
        get {
            if (soundLevel > noiseLevel_Global) {
                return true
            }
            else {
                return false
            }
        }
    }
    
    var debugText:String {
        get {
            return String(format: "Sound Level: %.1f db", arguments: [soundLevel])
        }
    }
    
    var soundLevel:Float    
    var recorder: AVAudioRecorder!

    init () {
        
        self.soundLevel = -160
        
        //make an AudioSession, set it to PlayAndRecord and make it active
        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        do {
        try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        do {
        try audioSession.setActive(true)
        } catch _ {
        }
        
        //set up the URL for the audio file
        let documents: AnyObject = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true)[0]
        let str =  documents.stringByAppendingPathComponent("recordTest.caf")
        let url = NSURL.fileURLWithPath(str as String)
        
        // make a dictionary to hold the recording settings so we can instantiate our AVAudioRecorder
        let recordSettings: [String : AnyObject]  = [
            AVFormatIDKey:NSNumber(unsignedInt:kAudioFormatAppleIMA4),
            AVSampleRateKey:44100.0,
            AVNumberOfChannelsKey:2,AVEncoderBitRateKey:12800,
            AVLinearPCMBitDepthKey:16,
            AVEncoderAudioQualityKey:AVAudioQuality.Max.rawValue
            
        ]
        
        try! recorder = AVAudioRecorder(URL:url, settings: recordSettings)
        
        //If there's an error, print it - otherwise, run prepareToRecord and meteringEnabled to turn on metering (must be run in that order)
        
        recorder.prepareToRecord()
        recorder.meteringEnabled = true
    }
    
    /*
     * averagePowerForChannel() returns the current average power, in decibels, for the sound being recorded.
     * A return value of 0 dB indicates full scale or maximum power; a return value of -160 dB
     * indicates minimum power (that is, near silence).
    */
    func updateSoundMeter() {
        //we have to update meters before we can get the metering values
        recorder.record()
        recorder.updateMeters()
        soundLevel = recorder.averagePowerForChannel(0)
        recorder.stop()
    }
}
