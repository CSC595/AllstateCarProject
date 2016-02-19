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
    private var attitudeArray:[CMAttitude] = []
    
    init () {
        self.isDistracted = false
        self.debugText = "Waiting for data"
    
        if motionManager.deviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = sampleRate
            
            motionManager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (motion:CMDeviceMotion?, error:NSError?) -> Void in
                
                let attitude = motion!.attitude
                
                // Populate the reference array
                if self.attitudeArray.isEmpty {
                    self.attitudeArray = [CMAttitude](count:5, repeatedValue:attitude)
                }
                else {
                    self.attitudeArray.removeLast()
                    self.attitudeArray.insert(attitude, atIndex: 0)
                }
                
                // See if the device has been stable
                self.updateStability()
            })
        }
    }
    
    func updateStability() {
        
        debugText = String(format: "[ref] roll: %+.2f, pitch: %+.2f, yaw: %+.2f", attitudeArray[0].roll, attitudeArray[0].pitch, attitudeArray[0].yaw)
        
        var accRoll:Double = 0
        var accPitch:Double = 0
        var accYaw:Double = 0
        
        for index in (1..<attitudeArray.count) {
            accRoll += fabs(attitudeArray[0].roll - attitudeArray[index].roll)
            accPitch += fabs(attitudeArray[0].pitch - attitudeArray[index].pitch)
            accYaw += fabs(attitudeArray[0].yaw - attitudeArray[index].yaw)
        }
        debugText += String(format: "\n[dif] roll: %+.2f, pitch: %+.2f, yaw: %+.2f", accRoll, accPitch, accYaw)
        
        if (accRoll > xTolerance_Global) {
            isDistracted = true
        }
        else if (accPitch > yTolerance_Global) {
            isDistracted = true
        }
        else if (accYaw > zTolerance_Global) {
            isDistracted = true
        }
        else {
            isDistracted = false
        }
        
    }
}

