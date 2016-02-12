//
//  MicrophoneNoise.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/11/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import AVFoundation
import CoreAudio

class MicrophoneNoise {
    var recorder: AVAudioRecorder!
    var levelTimer = NSTimer()
    var lowPassResults: Double = 0.0

    func MicrophoneNoise() {
    
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
        
        //start recording
        
        
        //instantiate a timer to be called with whatever frequency we want to grab metering values
        self.levelTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("levelTimerCallback"), userInfo: nil, repeats: true)
    }
}
