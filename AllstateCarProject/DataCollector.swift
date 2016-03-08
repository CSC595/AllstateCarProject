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
    case LookingAway = "Looking Away"
    
}


/************************************************************************************************************************
 //
 // Data structure which save a whole trip data in it
 //
 // departureTime: Departure time of trip
 // dangerousActionSet: Saved all dangerous Actions during this trip --> [(Strat time, Dangerous action type, End time)]
 // speedArr: Save speed(mile/hour) data of whole trip --> [(Time point, Speed)]
 // distane: Distance(mile) of one trip
 // arrivaltime: Arrival time of trip
 // driingTimeSecond: Time(second) spent in the trip
 // duringTimeHour: Time(hour) Spent in the trip
 // avgSpeed: Average speed(mile/hour) during whole trip
 //
 ************************************************************************************************************************/

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
    
    /*************************
     //
     // Call to print itself
     //
     *************************/
    func printSelf() {
        print("############################\nStart Time: \(self.departureTime.toString())\nEnd Time: \(self.arrivalTime.toString())\nDistance: \(self.distance)\nDurtion Hour: \(self.drivingTimeHour)\nDurtion Second: \(self.drivingTimeSecond)\nAvg Speed: \(self.avgSpeed)\nNumber of Dangerous Actions: \(self.dangerousActionSet.count)")
        for i in dangerousActionSet {
            print("From \(i.0.toString()) to \(i.2.toString()): \(i.1.rawValue)")
        }
        for i in speedArr {
            print("\(i.0.toString()): \(i.1) mile/h")
        }
        print("############################")
    }
    
    /*************************
     //
     // Data to String
     //
     *************************/
    
    func toString() -> String {
        var str = "Start Time: \(self.departureTime.toString())\nEnd Time: \(self.arrivalTime.toString())\nDistance: \(self.distance)\nDurtion Hour: \(self.drivingTimeHour)\nDurtion Second: \(self.drivingTimeSecond)\nAvg Speed: \(self.avgSpeed)\nNumber of Dangerous Actions: \(self.dangerousActionSet.count)\n"
        for i in dangerousActionSet {
            str = str + "From \(i.0.toString()) to \(i.2.toString()): \(i.1.rawValue)\n"
        }
        for i in speedArr {
            str = str + "\(i.0.toString()): \(i.1) mile/h\n"
        }
        return str
    }
    
    /***********************************
     //
     // Count of Dangerous Action
     //
     ************************************/
    
    func countOfDangerousAction(dAType: DangerousActionTypes) -> Int {
        var num = 0
        for dangerousAction in dangerousActionSet {
            if dangerousAction.1 == dAType {
                num += 1
            }
        }
        return num
    }
    
    /***********************************
    //
    // Data meets the requirment or not
    //
    ************************************/
    
    func dangerousActionIsEuqal(dAType: DangerousActionTypes, min: Int, max: Int) -> Bool {
        let num = countOfDangerousAction(dAType)
        if num <= max && num >= min {
            return true
        }
        return false
    }
}


/************************************************************************************************************************
 //
 // Singleton object used to collect driving data and save it to database
 //
 // departureTime: Departure time of trip
 // dangerousActionSet: Saved all dangerous Actions during this trip --> [(Strat time, Dangerous action type, End time)]
 // speedArr: Save speed(mile/hour) data of whole trip --> [(Time point, Speed)]
 // distane: Distance(mile) of one trip
 // arrivaltime: Arrival time of trip
 // driingTimeSecond: Time(second) spent in the trip
 // duringTimeHour: Time(hour) Spent in the trip
 // avgSpeed: Average speed(mile/hour) during whole trip
 //
 ************************************************************************************************************************/

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
    
    /*********************************************************************************************
     //
     // Data collecting part
     //
     *********************************************************************************************/
    
    // Start a new collection
    func start() {
        departureTime = NSDate()
    }
    
    // Finish the collection
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
    
    // Cell it when catch a dangerous action
    func catchDangerousAciton(type: DangerousActionTypes) {
        if tmpDangerousActions[type] == nil {
            tmpDangerousActions[type] = NSDate()
        }
    }
    
    // Remember to release dangerous action
    func releaseDangerousAction(type: DangerousActionTypes) {
        if let startTime = tmpDangerousActions[type] {
            if let dTime = departureTime {
                if (startTime.compare(dTime) == NSComparisonResult.OrderedAscending) {
                    dangerousActionSet.append((dTime, type, NSDate()))
                }
                else {
                    dangerousActionSet.append((startTime, type, NSDate()))
                }
            }
            tmpDangerousActions[type] = nil
        }
    }
    
    // This is just a interface to get the Speed. We'll use Allstate API to full it
    func collectingSpeeds(arr:[(NSDate, Double)]) {
        speedArr = arr
    }
    
    
    
    /*********************************************************************************************
     //
     // Data saving part
     //
     *********************************************************************************************/
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

