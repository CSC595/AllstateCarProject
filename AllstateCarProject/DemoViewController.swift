//
//  ViewController.swift
//  AllstateCarProject
//
//  Created by ZZC on 1/24/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreAudio



class DemoViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var LookPhoneButton: UIButton!
    @IBOutlet weak var MicTooLoudButton: UIButton!
    @IBOutlet weak var OverSpeededButton: UIButton!
    @IBOutlet weak var distanceTextField: UITextField!
    
    var timer1: NSTimer?
    var timer2: NSTimer?
    var timer3: NSTimer?
    var timer4: NSTimer?
    
    var tmpSpeedsArr = [(NSDate, Double)]()

    //sound
    var recorder: AVAudioRecorder!
    var levelTimer = NSTimer()
    var lowPassResults: Double = 0.0


    override func viewDidLoad() {
        super.viewDidLoad()
        buttonShow(false)

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func buttonShow(isDriving: Bool) {
        startButton.enabled = !isDriving
        stopButton.enabled = isDriving
        LookPhoneButton.enabled = isDriving
        MicTooLoudButton.enabled = isDriving
        OverSpeededButton.enabled = isDriving
        
    }
    
    @IBAction func startButtonPressed(sender: UIButton) {
        buttonShow(true)
        distanceTextField.text = "\(Double(lround((Double(arc4random()) / 0xFFFFFFFF  * (60 - 10) + 10) * 1000)) / 1000)"
        DataCollector.defaultCollector().start()
        getSpeed()
        timer4 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "getSpeed", userInfo: nil, repeats: true)
        
    }
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        buttonShow(false)
        timer4?.invalidate()
        DataCollector.defaultCollector().collectingSpeeds(tmpSpeedsArr)
        tmpSpeedsArr = []
        DataCollector.defaultCollector().end(Double(distanceTextField.text!)!)
    }

    @IBAction func LookPhoneButtonPressed(sender: UIButton) {
        DataCollector.defaultCollector().catchDangerousAciton(DangerousActionTypes.LookPhone)
        timer1 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "lookPhoneFinished", userInfo: nil, repeats: false)
        sender.enabled = false
    }
    
    @IBAction func MicTooLoudButtonPressed(sender: UIButton) {
        MicTooLoudStart()
    }
    
    @IBAction func OverSpeededButtonPressed(sender: AnyObject) {
        DataCollector.defaultCollector().catchDangerousAciton(DangerousActionTypes.OverSpeeded)
        timer3 = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "OverSpeededFinished", userInfo: nil, repeats: false)
        OverSpeededButton.enabled = false
    }
    
    @IBAction func BeaconPressed(sender: AnyObject) {
        
        // Not Implemented
        let controller = UIAlertController(title: "Not Implemented", message: nil, preferredStyle: .Alert)
        let noAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        controller.addAction(noAction)
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func lookPhoneFinished() {
        DataCollector.defaultCollector().releaseDangerousAction(DangerousActionTypes.LookPhone)
        timer1?.invalidate()
        LookPhoneButton.enabled = true
    }
    func MicTooLoudStart(){
        DataCollector.defaultCollector().catchDangerousAciton(DangerousActionTypes.MicTooLoud)
        timer2 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "MicTooLoudFinished", userInfo: nil, repeats: false)
        MicTooLoudButton.enabled = false
    }
    func MicTooLoudFinished(){
        DataCollector.defaultCollector().releaseDangerousAction(DangerousActionTypes.MicTooLoud)
        timer2?.invalidate()
        MicTooLoudButton.enabled = true
    }
    func OverSpeededFinished(){
        DataCollector.defaultCollector().releaseDangerousAction(DangerousActionTypes.OverSpeeded)
        timer3?.invalidate()
        OverSpeededButton.enabled = true
    }
    func getSpeed() {
        tmpSpeedsArr.append((NSDate(),Double(lround((Double(arc4random()) / 0xFFFFFFFF  * (20 - 0) + 0) * 1000)) / 1000))
    }

    //This selector/function is called every time our timer (levelTime) fires
    func levelTimerCallback() {
        //we have to update meters before we can get the metering values
        recorder.record()
        recorder.updateMeters()
        if (recorder.averagePowerForChannel(0) > -30) && (MicTooLoudButton.enabled == true) {
            MicTooLoudStart()

        } else {

        }
        recorder.stop()
        
        
    }
   
    

}

