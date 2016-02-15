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
    var timer1: NSTimer?
    var timer2: NSTimer?
    var timer3: NSTimer?
    var timer4: NSTimer?
    
    var tmpSpeedsArr = [(NSDate, Double)]()
    
    // Sample Rate in Seconds
    let sampleRate:Double = 0.5
    
    // Sensor Objects
    var motionSensor:PhoneMotion?
    
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
        
        faceDetection.actionSwitch.enabled = true
        phoneMotion.actionSwitch.enabled = true
        microphoneNoise.actionSwitch.enabled = true
        excessiveSpeed.actionSwitch.enabled = true
        
        // Create Sensor Objects
        motionSensor = PhoneMotion(sampleRateInSeconds: sampleRate)
        
        DataCollector.defaultCollector().start()
        getSpeed()
        timer4 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "getSpeed", userInfo: nil, repeats: true)

        checkMotion()
        timer3 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "checkMotion", userInfo: nil, repeats: true)
    }
    
    func stopTrip() {
        
        // Disable user interaction with switches
        faceDetection.actionSwitch.enabled = false
        phoneMotion.actionSwitch.enabled = false
        microphoneNoise.actionSwitch.enabled = false
        excessiveSpeed.actionSwitch.enabled = false
        
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
        
        timer3?.invalidate()
        timer4?.invalidate()
        DataCollector.defaultCollector().collectingSpeeds(tmpSpeedsArr)
        tmpSpeedsArr = []
        DataCollector.defaultCollector().end(Double(lround((Double(arc4random()) / 0xFFFFFFFF  * (60 - 10) + 10) * 1000)) / 1000)
        tripDetection.debugData.text = "Trip Ended"
    }
    
    func startCameraDistraction() {
        faceDetection.debugData.text = "Driver Looking Away"
    }
    
    func stopCameraDistraction() {
        faceDetection.debugData.text = "Debug Data"
    }
    
    func startPhoneMotionDistraction() {
        //phoneMotion.debugData.text = "Phone Motion Detected"
        DataCollector.defaultCollector().catchDangerousAciton(DangerousActionTypes.LookPhone)
    }
    
    func stopPhoneMotionDistraction() {
        //phoneMotion.debugData.text = "Debug Data"
        DataCollector.defaultCollector().releaseDangerousAction(DangerousActionTypes.LookPhone)
    }
    
    func startMicrophoneDistraction() {
        microphoneNoise.debugData.text = "Noise Detected"
        DataCollector.defaultCollector().catchDangerousAciton(DangerousActionTypes.MicTooLoud)
    }
    
    func stopMicrophoneDistraction() {
        microphoneNoise.debugData.text = "Debug Data"
        DataCollector.defaultCollector().releaseDangerousAction(DangerousActionTypes.MicTooLoud)
    }
    
    func startExcessiveSpeed() {
        excessiveSpeed.debugData.text = "Excessive Speed Detected"
        DataCollector.defaultCollector().catchDangerousAciton(DangerousActionTypes.OverSpeeded)
    }
    
    func stopExcessiveSpeed() {
        excessiveSpeed.debugData.text = "Debug Data"
        DataCollector.defaultCollector().releaseDangerousAction(DangerousActionTypes.OverSpeeded)
    }
    
    func checkMotion() {
        if let m = motionSensor {
            phoneMotion.debugData.text = m.debugText
            if (m.isDistracted) {
                if (phoneMotion.actionSwitch.on) {
                    // We are already recording the distracted action
                }
                else {
                    startPhoneMotionDistraction()
                    phoneMotion.actionSwitch.on = true
                }
            }
            else {
                if (phoneMotion.actionSwitch.on == false) {
                    // We are not capturing a distraction
                }
                else {
                    phoneMotion.actionSwitch.on = false
                    stopPhoneMotionDistraction()
                }
            }
        }
    }
        
    func getSpeed() {
        let nextSpeed = (NSDate(), Double(lround((Double(arc4random()) / 0xFFFFFFFF * (90 - 0) + 0) * 1000)) / 1000)
        tripDetection.debugData.text = "Speed: \(nextSpeed.1) mph"
        tmpSpeedsArr.append((NSDate(),Double(lround((Double(arc4random()) / 0xFFFFFFFF  * (90 - 0) + 0) * 1000)) / 1000))
    }

}
