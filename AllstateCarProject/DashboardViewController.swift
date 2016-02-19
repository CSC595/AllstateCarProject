//
//  DashboardViewController.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/10/16.
//  Copyright © 2016 Martin Roeder. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var tripDetection: DashboardTitle!
    @IBOutlet weak var faceDetection: DashboardItem!
    @IBOutlet weak var phoneMotion: DashboardItem!
    @IBOutlet weak var microphoneNoise: DashboardItem!
    @IBOutlet weak var excessiveSpeed: DashboardItem!
        
    @IBOutlet weak var beacon: DashboardItem!
    @IBOutlet var scrollView: UIScrollView!
    var refreshTimer: NSTimer?
    
    // Sensor Objects
    var motionSensor:PhoneMotion?
    var microphoneSensor:MicrophoneNoise?
    var speedSensor:SpeedSensor?
    let beaconSensor:BeaconSensor = BeaconSensor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tripDetection.enabled = true
        tripDetection.primaryIcon.image = UIImage(named: "WheelIcon")
        tripDetection.switchCode = {
            self.tripDetection.tripInProgress ? self.startTrip() : self.stopTrip()
        }
        
        faceDetection.title.text = "Attention"
        faceDetection.icon.image = UIImage(named: "SteeringIcon")
        faceDetection.type = DangerousActionTypes.LookingAway
                
        
        phoneMotion.title.text = "Motion"
        phoneMotion.icon.image = UIImage(named: "PhoneIcon")
        phoneMotion.type = DangerousActionTypes.LookPhone

        microphoneNoise.title.text = "Noise"
        microphoneNoise.icon.image = UIImage(named: "SoundIcon")
        microphoneNoise.type = DangerousActionTypes.MicTooLoud
        
        excessiveSpeed.title.text = "Speed"
        excessiveSpeed.icon.image = UIImage(named: "SpeedIcon")
        excessiveSpeed.type = DangerousActionTypes.OverSpeeded
        
        beacon.title.text = "Beacon"
        beacon.icon.image = UIImage(named: "BeaconIcon")
        
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
        
        // Start UI Elements
        tripDetection.startTrip()
        faceDetection.startTrip()
        phoneMotion.startTrip()
        microphoneNoise.startTrip()
        excessiveSpeed.startTrip()
        beacon.startTrip()
        
        // Create Sensor Objects
        motionSensor = PhoneMotion()
        microphoneSensor = MicrophoneNoise()
        speedSensor = SpeedSensor()
        
        DataCollector.defaultCollector().start()

        checkSensors()
        refreshTimer = NSTimer.scheduledTimerWithTimeInterval(sampleRate_Global, target: self, selector: "checkSensors", userInfo: nil, repeats: true)
    }
    
    func stopTrip() {
        
        // Stop UI elements
        tripDetection.stopTrip()
        faceDetection.stopTrip()
        phoneMotion.stopTrip()
        microphoneNoise.stopTrip()
        excessiveSpeed.stopTrip()
        beacon.stopTrip()
        
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
    
    func checkSensors() {
        if let m = motionSensor {
            phoneMotion.debug.text = m.debugText
            if (enableSensors_Global) {
                m.isDistracted ? phoneMotion.startDistraction() : phoneMotion.stopDistraction()
            }
        }
        
        if let m = microphoneSensor {
            m.updateSoundMeter()
            microphoneNoise.debug.text = m.debugText
            if (enableSensors_Global) {
                m.isDistracted ? microphoneNoise.startDistraction() : microphoneNoise.stopDistraction()
            }
        }
        
        if let s = speedSensor {
            s.updateSpeed()
            excessiveSpeed.debug.text = s.debugText
            if (enableSensors_Global) {
                s.isDistracted ? excessiveSpeed.startDistraction() : excessiveSpeed.stopDistraction()
            }
        }
        
        // Update beacon status
        if (beaconSensor.isVisiting) {
            beacon.setState(DashboardItem.State.good)
        }
        else {
            beacon.setState(DashboardItem.State.off)
        }
        beacon.debug.text = beaconSensor.debugText
            
        
    }
        
}
