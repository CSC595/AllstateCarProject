//
//  DashboardViewController.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/10/16.
//  Copyright © 2016 Martin Roeder. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, DEMDrivingEngineDelegate {

    // UI Objects
    @IBOutlet weak var tripDetection: DashboardItem!
    @IBOutlet weak var faceDetection: DistractionItem!
    @IBOutlet weak var phoneMotion: DistractionItem!
    @IBOutlet weak var microphoneNoise: DistractionItem!
    @IBOutlet weak var excessiveSpeed: DistractionItem!
    @IBOutlet weak var beacon: DashboardItem!
    
    // Sensor Objects
    var motionSensor:PhoneMotion?
    var microphoneSensor:MicrophoneNoise?
//    var speedSensor:SpeedSensor?
    var faceSensor: FaceDetection?
    var beaconSensor:BeaconSensor?
    var drivingEngine:DEMDrivingEngineManager?
    
    var isTripInProgress:Bool = false
    var refreshTimer: NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CoreEngine
        drivingEngine = DEMDrivingEngineManager.sharedManager() as? DEMDrivingEngineManager
        drivingEngine!.delegate = self
        drivingEngine!.registerForEventCapture(DEMEventCaptureMask.All)
        drivingEngine!.startEngine()
        
        tripDetection.enabled = true
        tripDetection.title.text = "Start"
        tripDetection.icon.image = UIImage(named: "WheelIcon")
        tripDetection.pressed = {
            self.isTripInProgress ? self.stopMockTrip() : self.startMockTrip()
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
    
    
    func didStartTripRecording(drivingEngine: DEMDrivingEngineManager!) -> String! {
        tripDetection.addText("didStartTripRecording()")
        startTrip()
        return ""
    }
    
    func didStopTripRecording(drivingEngine: DEMDrivingEngineManager!) {
        tripDetection.addText("didStopTripRecording()")
        stopTrip()
    }
    
    func didStopInvalidTripRecording(drivingEngine: DEMDrivingEngineManager!) {
        tripDetection.addText("didStopInvalidTripRecording()")
        stopTrip()
    }
    
    func drivingEngine(drivingEngine: DEMDrivingEngineManager!, didSaveTripInformation trip: DEMTripInfo!, driveStatus driveCompletionFlag: Bool) {
//        addText("distanceCovered: \(trip.distanceCovered) mi")
//        addText("averageSpeed: \(trip.averageSpeed) mph")
        tripDetection.addText("didSaveTripInformation()")
        tripDetection.addText("distanceCovered: \(trip.distanceCovered) mi")
        
        // If the trip is complete save it to our local database
        if (driveCompletionFlag) {
            DataCollector.defaultCollector().collectingSpeeds([(NSDate(), 1.0)])
            DataCollector.defaultCollector().end(Double(trip.distanceCovered))
        }
    }
    
    func drivingEngine(drivingEngine: DEMDrivingEngineManager!, didDetectBraking brakingEvent: DEMEventInfo!) {
        tripDetection.addText("drivingEngine(didDetectBraking)")
//
//        addText("drivingEngine(didDetectBraking)")
//        addText("eventID: \(brakingEvent.eventID)")
//        addText("eventDuration: \(brakingEvent.eventDuration)")
//        addText("eventType: \(brakingEvent.eventType)")
    }

    func drivingEngine(drivingEngine: DEMDrivingEngineManager!, didDetectStartOfSpeeding overSpeedingEvent: DEMEventInfo!) {

        tripDetection.addText("drivingEngine(didDetectStartOfSpeeding)")
        if let s = overSpeedingEvent {
            excessiveSpeed.addText("\(s.sensorStartReading) mph")
            if (enableSensors_Global) {
                excessiveSpeed.startDistraction()
            }
        }
    }
    
    func drivingEngine(drivingEngine: DEMDrivingEngineManager!, didDetectEndOfSpeeding overSpeedingEvent: DEMEventInfo!) {

        tripDetection.addText("drivingEngine(didDetectEndOfSpeeding)")
        excessiveSpeed.setText("Waiting for data")
        if (enableSensors_Global) {
            excessiveSpeed.stopDistraction()
        }
    }
    
    func startMockTrip() {
        print("startMockTrip()")
        let file:String = NSBundle.mainBundle().pathForResource(mockDataFiles_Global[mockDataIndex_Global], ofType: "txt")!
        drivingEngine?.setMockDataPath(file, cadence: 250)
        drivingEngine?.startTripRecording()        
    }
    
    func stopMockTrip() {
        print("stopMockTrip()")
        drivingEngine?.stopTripRecording()
        drivingEngine?.cancelMockData()
        stopTrip()
    }
    
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
//        speedSensor = SpeedSensor()
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

//        // Record speed array
//        if let s = speedSensor {
//            DataCollector.defaultCollector().collectingSpeeds(s.tmpSpeedsArr)
//            s.stop()
//        }
        
        tripDetection.title.text = "Start"

        
        // Stop sensor objects if needed
        
        // Get distance
//        let distance = Double(lround((Double(arc4random()) / 0xFFFFFFFF  * (60 - 10) + 10) * 1000)) / 1000
//        DataCollector.defaultCollector().end(distance)
        
        isTripInProgress = false
        
    }
    
    func checkSensors() {

//        tripDetection.debug.text = "Trip in progress"
        
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
        
//        if let s = speedSensor {
//            s.updateSpeed()
//            excessiveSpeed.debug.text = s.debugText
//            if (enableSensors_Global) {
//                s.isDistracted ? excessiveSpeed.startDistraction() : excessiveSpeed.stopDistraction()
//            }
//        }
        
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
