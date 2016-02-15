//
//  DashboardViewController.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/10/16.
//  Copyright © 2016 Martin Roeder. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var tripDetection: DashboardItem!
    @IBOutlet weak var faceDetection: DashboardItem!
    @IBOutlet weak var phoneMotion: DashboardItem!
    @IBOutlet weak var microphoneNoise: DashboardItem!
    @IBOutlet weak var excessiveSpeed: DashboardItem!
    @IBOutlet weak var beaconDetection: DashboardItem!
    
    @IBOutlet var scrollView: UIScrollView!
    var refreshTimer: NSTimer?
    
    // Sample Rate in Seconds
    let sampleRate:Double = 2.0
    
    // Sensor Objects
    var motionSensor:PhoneMotion?
    var microphoneSensor:MicrophoneNoise?
    var speedSensor:SpeedSensor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tripDetection.actionSwitch.enabled = true
        beaconDetection.actionSwitch.enabled = true
        
        tripDetection.switchCode = {
            self.tripDetection.actionSwitch.on ? self.startTrip() : self.stopTrip()
        }
        faceDetection.switchCode = {
            self.faceDetection.actionSwitch.on ? self.startCameraDistraction() : self.stopCameraDistraction()
        }
        phoneMotion.switchCode = {
            self.phoneMotion.actionSwitch.on ? self.startPhoneMotionDistraction() : self.stopPhoneMotionDistraction()
        }
        microphoneNoise.switchCode = {
            self.microphoneNoise.actionSwitch.on ? self.startMicrophoneDistraction() : self.stopMicrophoneDistraction()
        }
        excessiveSpeed.switchCode = {
            self.excessiveSpeed.actionSwitch.on ? self.startExcessiveSpeed() : self.stopExcessiveSpeed()
        }
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func startTrip() {
        tripDetection.debugData.text = "Trip in progress"
        
        faceDetection.actionSwitch.enabled = true
        phoneMotion.actionSwitch.enabled = debugMode_Global
        microphoneNoise.actionSwitch.enabled = debugMode_Global
        excessiveSpeed.actionSwitch.enabled = debugMode_Global
        
        // Create Sensor Objects
        motionSensor = PhoneMotion(sampleRateInSeconds: sampleRate)
        microphoneSensor = MicrophoneNoise()
        speedSensor = SpeedSensor()
        
        DataCollector.defaultCollector().start()

        checkSensors()
        refreshTimer = NSTimer.scheduledTimerWithTimeInterval(sampleRate, target: self, selector: "checkSensors", userInfo: nil, repeats: true)
    }
    
    func stopTrip() {
        
        // Disable user interaction with switches
        faceDetection.actionSwitch.enabled = false
        phoneMotion.actionSwitch.enabled = false
        microphoneNoise.actionSwitch.enabled = false
        excessiveSpeed.actionSwitch.enabled = false
        
        tripDetection.debugData.text = "Trip Ended"
        faceDetection.debugData.text = "Waiting for data"
        phoneMotion.debugData.text = "Waiting for data"
        microphoneNoise.debugData.text = "Waiting for data"
        excessiveSpeed.debugData.text = "Waiting for data"
        
        // Stop actions and turn swithces off
        if (faceDetection.actionSwitch.on) {
            faceDetection.actionSwitch.on = false
            stopCameraDistraction()
        }
        if (phoneMotion.actionSwitch.on) {
            phoneMotion.actionSwitch.on = false
            stopPhoneMotionDistraction()
        }
        if (microphoneNoise.actionSwitch.on) {
            microphoneNoise.actionSwitch.on = false
            stopMicrophoneDistraction()
        }
        if (excessiveSpeed.actionSwitch.on) {
            excessiveSpeed.actionSwitch.on = false
            stopExcessiveSpeed()
        }
        
        if let t = refreshTimer {
            t.invalidate()
        }

        // Record speed array
        if let s = speedSensor {
            DataCollector.defaultCollector().collectingSpeeds(s.tmpSpeedsArr)
            s.stop()
        }
        
        // Stop sensor objects if needed
        
        // Get distance
        let distance = Double(lround((Double(arc4random()) / 0xFFFFFFFF  * (60 - 10) + 10) * 1000)) / 1000
        DataCollector.defaultCollector().end(distance)
        
        
    }
    
    func startCameraDistraction() {
        faceDetection.debugData.text = "Driver Looking Away"
    }
    
    func stopCameraDistraction() {
        faceDetection.debugData.text = "Waiting for data"
    }
    
    func startPhoneMotionDistraction() {
        phoneMotion.actionSwitch.on = true
        DataCollector.defaultCollector().catchDangerousAciton(DangerousActionTypes.LookPhone)
    }
    
    func stopPhoneMotionDistraction() {
        phoneMotion.actionSwitch.on = false
        DataCollector.defaultCollector().releaseDangerousAction(DangerousActionTypes.LookPhone)
    }
    
    func startMicrophoneDistraction() {
        microphoneNoise.actionSwitch.on = true
        DataCollector.defaultCollector().catchDangerousAciton(DangerousActionTypes.MicTooLoud)
    }
    
    func stopMicrophoneDistraction() {
        microphoneNoise.actionSwitch.on = false
        DataCollector.defaultCollector().releaseDangerousAction(DangerousActionTypes.MicTooLoud)
    }
    
    func startExcessiveSpeed() {
        excessiveSpeed.actionSwitch.on = true
        DataCollector.defaultCollector().catchDangerousAciton(DangerousActionTypes.OverSpeeded)
    }
    
    func stopExcessiveSpeed() {
        excessiveSpeed.actionSwitch.on = false
        DataCollector.defaultCollector().releaseDangerousAction(DangerousActionTypes.OverSpeeded)
    }
    
    func checkSensors() {
        if let m = motionSensor {
            phoneMotion.debugData.text = m.debugText
            if (!debugMode_Global) {
                m.isDistracted ? startPhoneMotionDistraction() : stopPhoneMotionDistraction()
            }
        }
        
        if let m = microphoneSensor {
            m.updateSoundMeter()
            microphoneNoise.debugData.text = m.debugText
            if (!debugMode_Global) {
                m.isDistracted ? startMicrophoneDistraction() : stopMicrophoneDistraction()
            }
        }
        
        if let s = speedSensor {
            s.updateSpeed()
            excessiveSpeed.debugData.text = s.debugText
            if (!debugMode_Global) {
                s.isDistracted ? startExcessiveSpeed() : stopExcessiveSpeed()
            }
        }

    }
        
}
