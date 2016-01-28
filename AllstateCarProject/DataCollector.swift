//
//  Data.swift
//  AllstateCarProject
//
//  Created by ZZC on 1/24/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import Foundation

enum DangerousActionTypes:String {
    case LookPhone = "Look Phone"
    case MicTooLoud = "Mic Too Loud"
    case OverSpeeded = "Over Speeded"
    
}

struct Data {
    let departureTime: NSDate
    let dangerousActionSet: [(NSDate, DangerousActionTypes, NSDate)]
    let speedArr: [(NSDate, Double)]
    let distance: Double
    let arrivalTime: NSDate
    let drivingTimeSecond: Int
    let drivingTimeHour: Double
    let avgSpeed: Double
    
    
    init(departureTime: NSDate, dangerousActionSet: [(NSDate, DangerousActionTypes, NSDate)], speedArr: [(NSDate, Double)], distance: Double, arrivalTime: NSDate, drivingTimeSecond: Int, drivingTimeHour: Double, avgSpeed: Double) {
        self.departureTime = departureTime
        self.dangerousActionSet = dangerousActionSet
        self.speedArr = speedArr
        self.distance = distance
        self.arrivalTime = arrivalTime
        self.drivingTimeSecond = drivingTimeSecond
        self.drivingTimeHour = drivingTimeHour
        self.avgSpeed = avgSpeed
        
  
    }
}






// Data which save in "user_data_table"
// [0] dTime               TEXT         PRIMARY KEY
// [1] dTimeInterval       REAL
// [2] distance            REAL
// [3] aTimeInterval       REAL
// [4] dTS                 INTEGER
// [5] dTH                 REAL
// [6] avgSpeed            REAL
// [7] speedsTableName     TEXT



// Data which save in "user_dangerous_actions_table"
// [0] id                  INTEGER      PRIMARY KEY
// [1] driveTimeInterval   REAL
// [2] sTimeInterval       REAL
// [3] dAction             TEXT
// [4] eTimeInterval       REAL



// Data which save in "\(dTimeInterval.createSpeedsTableName())"
// [0] timeInterval        REAL
// [1] speed               REAL


class DataCollector {
    
    
    
    private var departureTime: NSDate?
    private var dangerousActionSet = [(NSDate, DangerousActionTypes, NSDate)]()
    private var speedArr = [(NSDate, Double)]()
    private var distance: Double?
    private var arrivalTime: NSDate?
    private var drivingTimeSecond: Int?
    private var drivingTimeHour: Double?
    private var avgSpeed: Double?
    
    private var tmpDangerousActions = [DangerousActionTypes:NSDate]()
    
    
    private static let instance = DataCollector()
    
    static func defaultCollector() -> DataCollector {
        return instance
    }
    
    private init() {
        initData()
    }
    
    private func initData() {
        departureTime = nil
        dangerousActionSet = []
        speedArr = []
        distance = nil
        arrivalTime = nil
        drivingTimeSecond = nil
        drivingTimeHour = nil
        avgSpeed = nil
    }
    
    //Data Collecting Part
    func start() {
        departureTime = NSDate()
    }
    
    func end(distance: Double) {
        if let departureTime = self.departureTime {
            arrivalTime = NSDate()
            self.distance = distance
            drivingTimeSecond = arrivalTime!.durationSeconds(departureTime)
            drivingTimeHour = arrivalTime!.durationHour(departureTime)
            avgSpeed = distance / drivingTimeHour!
            DataBaseManager.defaultManager().insert(self)
            initData()
        }
        
    }
    
    func catchDangerousAciton(type: DangerousActionTypes) {
        if tmpDangerousActions[type] == nil {
            tmpDangerousActions[type] = NSDate()
        }
    }
    
    func releaseDangerousAction(type: DangerousActionTypes) {
        if let startTime = tmpDangerousActions[type] {
            dangerousActionSet.append((startTime, type, NSDate()))
        }
    }
    
    func collectingSpeeds(arr:[(NSDate, Double)]) {
        speedArr = arr
    }
    
    
    
    // Data Sending Part
    func statisticsData() -> [AnyObject]? {
        if let departureTime = self.departureTime, let distance = self.distance, let arrivalTime = self.arrivalTime, let drivingTimeSecond = self.drivingTimeSecond, let drivingTimeHour = self.drivingTimeHour, let avgSpeed = self.avgSpeed {
            return [departureTime.toString(), departureTime.timeIntervalSince1970, distance, arrivalTime.timeIntervalSince1970, drivingTimeSecond, drivingTimeHour ,avgSpeed, departureTime.createSpeedsTableName()]
            
        }
        return nil
    }
    
    
    
    func speedsTableName() -> String? {
        if let departureTime = self.departureTime {
            return departureTime.createSpeedsTableName()
        }
        return nil
    }
    
    func dangerousActionsData() -> [[AnyObject]]? {
        if dangerousActionSet.count > 0, let departureTime = self.departureTime {
            var r = [[AnyObject]]()
            for dangerousAction in dangerousActionSet {
                r.append([departureTime.timeIntervalSince1970, dangerousAction.0.timeIntervalSince1970, dangerousAction.1.rawValue, dangerousAction.2.timeIntervalSince1970])
            }
            return r
        }
        return nil
    }
    
    func speedsData() -> [[AnyObject]]? {
        if speedArr.count > 0 {
            var r = [[AnyObject]]()
            for speed in speedArr {
                r.append([speed.0.timeIntervalSince1970, speed.1])
            }
            return r
        }
        return nil
    }
    
    
    
}

