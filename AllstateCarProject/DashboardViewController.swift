//
//  DashboardViewController.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/10/16.
//  Copyright © 2016 Martin Roeder. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    // UI Objects
    @IBOutlet weak var tripDetection: DashboardItem!
    @IBOutlet weak var faceDetection: DistractionItem!
    @IBOutlet weak var phoneMotion: DistractionItem!
    @IBOutlet weak var microphoneNoise: DistractionItem!
    @IBOutlet weak var excessiveSpeed: DistractionItem!
    @IBOutlet weak var beacon: DashboardItem!

    @IBOutlet var scrollView: UIScrollView!
//    @IBOutlet weak var stackView: UIStackView!
    
    // Sensor Objects
    var motionSensor:PhoneMotion?
    var microphoneSensor:MicrophoneNoise?
    var speedSensor:SpeedSensor?
    var faceSensor: FaceDetection?
    var beaconSensor:BeaconSensor?


    var isTripInProgress:Bool = false
    var refreshTimer: NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tripDetection.enabled = true
        tripDetection.title.text = "Start"
        tripDetection.icon.image = UIImage(named: "WheelIcon")
        tripDetection.pressed = {
            self.isTripInProgress ? self.stopTrip() : self.startTrip()
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
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
//    }

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
        tripDetection.start()
        faceDetection.start()
        phoneMotion.start()
        microphoneNoise.start()
        excessiveSpeed.start()
        beacon.start()
        
        // Create Sensor Objects
        motionSensor = PhoneMotion()
        microphoneSensor = MicrophoneNoise()
        speedSensor = SpeedSensor()
        faceSensor = FaceDetection()
        beaconSensor = BeaconSensor()
        
        tripDetection.title.text = "Stop"
        
        DataCollector.defaultCollector().start()

        checkSensors()
        refreshTimer = NSTimer.scheduledTimerWithTimeInterval(sampleRate_Global, target: self, selector: "checkSensors", userInfo: nil, repeats: true)
        
        isTripInProgress = true
    }
    
    func stopTrip() {
        
        // Stop UI elements
        tripDetection.stop()
        faceDetection.stop()
        phoneMotion.stop()
        microphoneNoise.stop()
        excessiveSpeed.stop()
        beacon.stop()
        
        if let t = refreshTimer {
            t.invalidate()
        }
        
        if let f = faceSensor {
            f.endService()
        }

        // Record speed array
        if let s = speedSensor {
            DataCollector.defaultCollector().collectingSpeeds(s.tmpSpeedsArr)
            s.stop()
        }
        
        tripDetection.title.text = "Start"

        
        // Stop sensor objects if needed
        
        // Get distance
        let distance = Double(lround((Double(arc4random()) / 0xFFFFFFFF  * (60 - 10) + 10) * 1000)) / 1000
        DataCollector.defaultCollector().end(distance)
        
        isTripInProgress = false
        
    }
    
    func checkSensors() {

        tripDetection.debug.text = "Trip in progress"
        
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
        
        if let f = faceSensor {
            f.checkResult()
            faceDetection.debug.text = f.debugText
            if (enableSensors_Global) {
                f.isDistracted ? faceDetection.startDistraction() : faceDetection.stopDistraction()
            }
        }
        
        // Update beacon status
        if let b = beaconSensor {
            beacon.debug.text = b.debugText
            if (b.isVisiting) {
                beacon.setStateGood()
            }
        }
    }
        
}
