//
//  PhoneMotion.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/11/16.
//  Copyright © 2016 Martin Roeder. All rights reserved.
//

import CoreMotion

class PhoneMotion {
    
    var isDistracted:Bool
    var debugText:String
    
    // To get data from sensors
    private let motionManager = CMMotionManager()
    private let queue = NSOperationQueue()
    
    // Previous data points
    private var referenceAttitude:[CMAttitude] = []
    
    init (sampleRateInSeconds:Double) {
        self.isDistracted = false
        self.debugText = "Phone Motion"
    
        if motionManager.deviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = sampleRateInSeconds
            
            motionManager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (motion:CMDeviceMotion?, error:NSError?) -> Void in
                
                let attitude = motion!.attitude
                self.debugText = String(format: "Roll: %+.2f, Pitch: %+.2f, Yaw: %+.2f",
                    attitude.roll, attitude.pitch, attitude.yaw)
                
                // Populate the reference array
                if self.referenceAttitude.isEmpty {
                    self.referenceAttitude = [CMAttitude](count:5, repeatedValue:attitude)
                }
                else {
                    self.referenceAttitude.removeLast()
                    self.referenceAttitude.insert(attitude, atIndex: 0)
                }
                
                // See if the device has been stable
                let stabilityScore = self.getDeviceStabilityScore(self.referenceAttitude)
                
                self.debugText += "\nScore: \(stabilityScore)/5"
                
                self.isDistracted = stabilityScore < 5 ? true : false
                
            })
        }
    }
    
    func getDeviceStabilityScore(attitudeArray:[CMAttitude]) -> Int {
        
        var score = 0
        let marginOfError = 0.2;
        
        if let reference = attitudeArray.first {
            for a in attitudeArray {
                let pitchChanged = fabs(reference.pitch - a.pitch) > marginOfError
                let rollChanged = fabs(reference.roll - a.roll) > marginOfError
                let yawChanged = fabs(reference.yaw - a.yaw) > marginOfError
                
                if pitchChanged || rollChanged || yawChanged {
                    return score
                }
                score++
            }
        }
        
        return score
    }
    
}

