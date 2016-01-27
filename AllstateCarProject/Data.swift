//
//  Data.swift
//  AllstateCarProject
//
//  Created by ZZC on 1/24/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import Foundation

enum DangerousActionTypes {
    case LookPhone
    case MicTooLoud
    case OverSpeeded
    
}

/*struct DangerousActionSet {
    private var result: [(DangerousActionType,NSDate)]
    
    init(){
        result = [(DangerousActionType,NSDate)]()
    }
    
    init(data: NSData) {
        let pointer = UnsafePointer<(DangerousActionType,NSDate)>(data.bytes)
        let count = data.length / sizeof((DangerousActionType,NSDate))
        let buffer = UnsafeBufferPointer<(DangerousActionType,NSDate)>(start:pointer, count:count)
        result = [(DangerousActionType,NSDate)](buffer)
    }
    
    mutating func addAction(dAction:DangerousActionType, time: NSDate) {
        result.append((dAction, time))
    }
    
    func getSet() -> [(DangerousActionType,NSDate)] {
        return self.result
    }
    
    func encodeToNSData() -> NSData {
        return NSData(bytes: result, length: result.count * sizeof((DangerousActionType,NSDate)))
    }
}

struct SpeedArr {
    private var result: [Double]
    
    init(){
        result = [Double]()
    }
    
    init(data: NSData) {
        let pointer = UnsafePointer<(Double)>(data.bytes)
        let count = data.length / sizeof(Double)
        let buffer = UnsafeBufferPointer<(Double)>(start:pointer, count:count)
        result = [Double](buffer)
    }
    
    mutating func addAction(speed: Double) {
        result.append(speed)
    }
    
    func getSet() -> [Double] {
        return self.result
    }
    
    func encodeToNSData() -> NSData {
        return NSData(bytes: result, length: result.count * sizeof(Double))
    }
}*/

struct Data {
    
    let departureTime: NSDate
    var dangerousActionSet = [(NSDate, DangerousActionTypes)]()
    var speedArr = [(NSDate, Double)]()
    let distance: Double
    let arrivalTime: NSDate
    let drivingTimeSecond: Int
    let drivingTimeHour: Double
    let avgSpeed: Double
    
    
    
    
    init(departureTime: NSDate, dangerousActionSet: [(NSDate, DangerousActionTypes)], speedArr: [(NSDate, Double)], distance: Double, arrivalTime: NSDate) {
        self.departureTime = departureTime
        self.dangerousActionSet = dangerousActionSet
        self.speedArr = speedArr
        self.distance = distance
        self.arrivalTime = arrivalTime
        self.drivingTimeSecond = arrivalTime.durationSeconds(departureTime)
        self.drivingTimeHour = arrivalTime.durationHour(departureTime)
        self.avgSpeed = distance / self.drivingTimeHour
        
    }
    
    // Data which save in DB
    // [0] dTime               TEXT   PRIMARY KEY
    // [1] dTimeInterval       REAL
    // [2] distance            REAL
    // [3] aTimeInterval       REAL
    // [4] dTS                 INTEGER
    // [5] dTH                 REAL
    // [6] avgSpeed            REAL
    // [7] speedTableName      TEXT
    // [8] dActionsTableName   TEXT
    
    func createStatisticsData() -> [AnyObject] {
        return [departureTime.toString(), departureTime.timeIntervalSince1970, distance, arrivalTime.timeIntervalSince1970, drivingTimeSecond, drivingTimeHour ,avgSpeed, "\(departureTime.timeIntervalSince1970)_speed_table", "\(departureTime.timeIntervalSince1970)_dangerous_actions_table"]
    }
    
    func dActionTableName() -> String {
        return "\(departureTime.timeIntervalSince1970)_dangerous_actions_table"
    }
    
    func speedArrTableName() -> String {
        return "\(departureTime.timeIntervalSince1970)_speed_table"
    }
    
    
    
    
}

