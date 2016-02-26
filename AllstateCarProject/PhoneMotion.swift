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
    let sampleRate:Double = sampleRate_Global / 5
    
    // To get data from sensors
    private let motionManager = CMMotionManager()
    private let queue = NSOperationQueue()
    
    // Previous data points
    private var attitudeArray:[CMAttitude] = []
    private var gravityArray:[CMAcceleration] = []
    
    init () {
        self.isDistracted = false
        self.debugText = "Waiting for data"
    
        if motionManager.deviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = sampleRate
            
            motionManager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (motion:CMDeviceMotion?, error:NSError?) -> Void in
                
                let attitude = motion!.attitude
                let gravity = motion!.gravity
                
                // Populate the reference array
                if self.attitudeArray.isEmpty {
                    self.attitudeArray = [CMAttitude](count:5, repeatedValue:attitude)
                }
                else {
                    self.attitudeArray.removeLast()
                    self.attitudeArray.insert(attitude, atIndex: 0)
                }
                
                // Populate the reference array
                if self.gravityArray.isEmpty {
                    self.gravityArray = [CMAcceleration](count:5, repeatedValue:gravity)
                }
                else {
                    self.gravityArray.removeLast()
                    self.gravityArray.insert(gravity, atIndex: 0)
                }
                
                // See if the device has been stable
                useGravity_Global ? self.updateGravity() : self.updateAttitude()
                
                
            })
        }
    }
    
    func updateGravity() {
        debugText = String(format: "[ref] x: %+.2f, y: %+.2f, z: %+.2f", gravityArray[0].x, gravityArray[0].y, gravityArray[0].z)
//        print(debugText)
        var accX:Double = 0
        var accY:Double = 0
        var accZ:Double = 0
        
        for index in (1..<gravityArray.count) {
            accX += fabs(gravityArray[0].x - gravityArray[index].x)
            accY += fabs(gravityArray[0].y - gravityArray[index].y)
            accZ += fabs(gravityArray[0].z - gravityArray[index].z)
        }
        debugText += String(format: "\n[dif] x: %+.2f, y: %+.2f, z: %+.2f", accX, accY, accZ)
        
        if (accX + accY + accZ > gravityTolerance_Global) {
            isDistracted = true
        }
        else {
            isDistracted = false
        }
    }
    
    func updateAttitude() {
        
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

