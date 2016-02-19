//
//  SpeedSensor.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/15/16.
//  Copyright © 2016 Martin Roeder. All rights reserved.
//

import Foundation

class SpeedSensor {
    
    var isDistracted:Bool {
        get {
            if (currentSpeed > speedLimit_Global) {
                return true
            }
            else {
                return false
            }
        }
    }
    
    var debugText:String {
        get {
            return String(format: "Speed: %.1f mph", arguments: [currentSpeed])
        }
    }
    
    var currentSpeed:Double {
        get {
            if let (_, speed) = tmpSpeedsArr.last {
                return speed
            }
            else {
                return 0
            }
        }
    }
    
    var tmpSpeedsArr = [(NSDate, Double)]()
    
    func updateSpeed() {
        let nextSpeed = (NSDate(), Double(lround((Double(arc4random()) / 0xFFFFFFFF * (90 - 0) + 0) * 1000)) / 1000)
        tmpSpeedsArr.append(nextSpeed)
    }
    
    func stop() {
        tmpSpeedsArr = []
    }
    
    
}

