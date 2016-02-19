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
    
    // sample rate
    let sampleRate:Double = 0.5
    
    // To get data from sensors
    private let motionManager = CMMotionManager()
    private let queue = NSOperationQueue()
    
    // Previous data points
    private var referenceAttitude:[CMAttitude] = []
    
    init () {
        self.isDistracted = false
        self.debugText = "Waiting for data"
    
        if motionManager.deviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = sampleRate
            
            motionManager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (motion:CMDeviceMotion?, error:NSError?) -> Void in
                
                let attitude = motion!.attitude
                
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
                
                self.isDistracted = stabilityScore < 5 ? true : false
                
            })
        }
    }
    
    func getDeviceStabilityScore(attitudeArray:[CMAttitude]) -> Int {
        
        
//        self.debugText += "\nScore: \(stabilityScore)/5"

        var score = 0
//        let marginOfError = 0.2;
        
        debugText = String(format: "[0] r: %5+.2f, p: %5+.2f, y: %5+.2f", attitudeArray[0].roll, attitudeArray[0].pitch, attitudeArray[0].yaw)
        
        for index in (1..<attitudeArray.count) {
            let deltaRoll = attitudeArray[0].roll - attitudeArray[index].roll
            let deltaPitch = attitudeArray[0].pitch - attitudeArray[index].pitch
            let deltaYaw = attitudeArray[0].yaw - attitudeArray[index].yaw
            
            debugText += String(format: "\n[%d] r: %5+.2f, p: %5+.2f, y: %5+.2f", index, deltaRoll, deltaPitch, deltaYaw)
            
//            
//                let pitchChanged = fabs(reference.pitch - a.pitch) > marginOfError
//                let rollChanged = fabs(reference.roll - a.roll) > marginOfError
//                let yawChanged = fabs(reference.yaw - a.yaw) > marginOfError
//                
//                debugText += String(format: "r: %+.2f, p: %+.2f, y: %+.2f\n", pitchChanged, rollChanged, yawChanged)
//                
//                if pitchChanged || rollChanged || yawChanged {
//                    return score
//                }
//                score++
            }
        return score
    }
    
}

