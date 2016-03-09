//
//  DataBase.swift
//  AllstateCarProject
//
//  Created by ZZC on 1/24/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import Foundation
import FMDB


/****************************************************************
 
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
 
****************************************************************/

 
 
 
 
/*************************************************************************************************************************
 //
 // This is a singleton object to manage database
 //
 *************************************************************************************************************************/
class DataBaseManager {
    var db:FMDatabase
    var dbPath: String
    private static let instance = DataBaseManager()
    
    static func defaultManager() -> DataBaseManager {
        return instance
    }
    
   
    private init() {
        let dbDirectory = NSHomeDirectory() + "/Documents/database"
        
        if !NSFileManager.defaultManager().fileExistsAtPath(dbDirectory) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(dbDirectory, withIntermediateDirectories: false, attributes: nil)
            }catch _ {
                print("Error")
            }
        }
        
        self.dbPath = dbDirectory + "/user_data.sqlite"
        print(dbPath)
        self.db = FMDatabase(path: self.dbPath)
        print("DataBase init")
        
        if !NSFileManager.defaultManager().fileExistsAtPath(self.dbPath) {
            if self.open() {
                let sql1 = "CREATE TABLE IF NOT EXISTS user_data_table (dTime TEXT NOT NULL PRIMARY KEY, dTimeInterval REAL, distance REAL, aTimeInterval REAL, dTS INTEGER, dTH INTEGER, avgSpeed REAL, speedsTableName TEXT)"
                let sql2 = "CREATE TABLE IF NOT EXISTS user_dangerous_actions_table (id INTEGER PRIMARY KEY, driveTimeInterval REAL, sTimeInterval REAL, dAction TEXT, eTimeInterval REAL)"
                self.db.executeStatements(sql1)
                self.db.executeStatements(sql2)
                print("Creation Success")
                self.close()
            }else {
                print("Open error")
            }
        }
        
    }
    
    deinit {
        self.close()
    }
    
    func open() -> Bool {
        return self.db.open()
    }
    
    func close() -> Bool {
        return self.db.close()
    }
    
    /******************************************************************************************
     //
     // This is called by DataCollector.defaultCollector() to insert driving data to database
     //
     ******************************************************************************************/
    
    func insert(collector: DataCollector) -> Bool{
        if db.open() {
            do{
                if let statisticsData = collector.statisticsData() {
                    try self.db.executeUpdate("INSERT INTO user_data_table (dTime, dTimeInterval, distance, aTimeInterval, dTS, dTH, avgSpeed, speedsTableName) values (?,?,?,?,?,?,?,?)", values: statisticsData)
                    print("Inserted one data into user_data_table")
                }
                if let dangerousActionsData = collector.dangerousActionsData() {
                    for dActionData in dangerousActionsData {
                        try self.db.executeUpdate("INSERT INTO user_dangerous_actions_table (id, driveTimeInterval, sTimeInterval, dAction, eTimeInterval) values (NULL,?,?,?,?)", values: dActionData)
                        print("Inserted one data into user_dangerous_actions_table")
                    }
                }
                if let tableName = collector.speedsTableName(), let speedsData = collector.speedsData() {
                    let createSpeedsTableSql = "CREATE TABLE IF NOT EXISTS \(tableName) (timeInterval REAL NOT NULL PRIMARY KEY, speed REAL)"
                    self.db.executeStatements(createSpeedsTableSql)
                    print("success")
                    for speedData in speedsData {
                        try self.db.executeUpdate("INSERT INTO \(tableName) (timeInterval, speed) values (?,?)", values: speedData)
                        print("Inserted one data into \(tableName)")
                    }
                }
                
                self.close()
                return true
            }catch _ {
                self.close()
                print(db.lastError())
                print("Insert error")
            }
        }else {
            print("Open error")
        }
        return false
    }
    
    /******************************************************************************************
     //
     // Call this function to get all the data from database
     //
     ******************************************************************************************/
    
    func loadData() -> [Data] {
        if db.open() {
            var result = [Data]()
            do{
                let dAResult = try self.db.executeQuery("SELECT * FROM user_dangerous_actions_table ORDER BY driveTimeInterval ASC", values: nil)
                var allDangerousActionsData = [NSDate:[(NSDate, DangerousActionTypes, NSDate)]]()
                var tmpDangerousActionsSet = [(NSDate, DangerousActionTypes, NSDate)]()
                var drivingTime: Double?
                if dAResult.next()  {
                    drivingTime = dAResult.doubleForColumn("driveTimeInterval")
                    switch dAResult.stringForColumn("dAction") {
                    case "Look Phone":
                        tmpDangerousActionsSet.append((NSDate(timeIntervalSince1970: dAResult.doubleForColumn("sTimeInterval")), DangerousActionTypes.LookPhone, NSDate(timeIntervalSince1970: dAResult.doubleForColumn("eTimeInterval"))))
                    case "Mic Too Loud":
                        tmpDangerousActionsSet.append((NSDate(timeIntervalSince1970: dAResult.doubleForColumn("sTimeInterval")), DangerousActionTypes.MicTooLoud, NSDate(timeIntervalSince1970: dAResult.doubleForColumn("eTimeInterval"))))
                    case "Over Speeded":
                        tmpDangerousActionsSet.append((NSDate(timeIntervalSince1970: dAResult.doubleForColumn("sTimeInterval")), DangerousActionTypes.OverSpeeded, NSDate(timeIntervalSince1970: dAResult.doubleForColumn("eTimeInterval"))))
                    case "Looking Away":
                        tmpDangerousActionsSet.append((NSDate(timeIntervalSince1970: dAResult.doubleForColumn("sTimeInterval")), DangerousActionTypes.LookingAway, NSDate(timeIntervalSince1970: dAResult.doubleForColumn("eTimeInterval"))))
                    default:
                        break;
                    }

                    while dAResult.next() {
                        if dAResult.doubleForColumn("driveTimeInterval") == drivingTime {
                            switch dAResult.stringForColumn("dAction") {
                            case "Look Phone":
                                tmpDangerousActionsSet.append((NSDate(timeIntervalSince1970: dAResult.doubleForColumn("sTimeInterval")), DangerousActionTypes.LookPhone, NSDate(timeIntervalSince1970: dAResult.doubleForColumn("eTimeInterval"))))
                            case "Mic Too Loud":
                                tmpDangerousActionsSet.append((NSDate(timeIntervalSince1970: dAResult.doubleForColumn("sTimeInterval")), DangerousActionTypes.MicTooLoud, NSDate(timeIntervalSince1970: dAResult.doubleForColumn("eTimeInterval"))))
                            case "Over Speeded":
                                tmpDangerousActionsSet.append((NSDate(timeIntervalSince1970: dAResult.doubleForColumn("sTimeInterval")), DangerousActionTypes.OverSpeeded, NSDate(timeIntervalSince1970: dAResult.doubleForColumn("eTimeInterval"))))
                            case "Looking Away":
                                 tmpDangerousActionsSet.append((NSDate(timeIntervalSince1970: dAResult.doubleForColumn("sTimeInterval")), DangerousActionTypes.LookingAway, NSDate(timeIntervalSince1970: dAResult.doubleForColumn("eTimeInterval"))))
                            default:
                                break;
                            }
                        } else {
                            allDangerousActionsData[NSDate(timeIntervalSince1970: drivingTime!)] = tmpDangerousActionsSet
                            drivingTime = dAResult.doubleForColumn("driveTimeInterval")
                            tmpDangerousActionsSet.removeAll()
                            switch dAResult.stringForColumn("dAction") {
                            case "Look Phone":
                                tmpDangerousActionsSet.append((NSDate(timeIntervalSince1970: dAResult.doubleForColumn("sTimeInterval")), DangerousActionTypes.LookPhone, NSDate(timeIntervalSince1970: dAResult.doubleForColumn("eTimeInterval"))))
                            case "Mic Too Loud":
                                tmpDangerousActionsSet.append((NSDate(timeIntervalSince1970: dAResult.doubleForColumn("sTimeInterval")), DangerousActionTypes.MicTooLoud, NSDate(timeIntervalSince1970: dAResult.doubleForColumn("eTimeInterval"))))
                            case "Over Speeded":
                                tmpDangerousActionsSet.append((NSDate(timeIntervalSince1970: dAResult.doubleForColumn("sTimeInterval")), DangerousActionTypes.OverSpeeded, NSDate(timeIntervalSince1970: dAResult.doubleForColumn("eTimeInterval"))))
                            case "Looking Away":
                                 tmpDangerousActionsSet.append((NSDate(timeIntervalSince1970: dAResult.doubleForColumn("sTimeInterval")), DangerousActionTypes.LookingAway, NSDate(timeIntervalSince1970: dAResult.doubleForColumn("eTimeInterval"))))
                            default:
                                break;
                            }
                        }
                    }
                }
                if let d = drivingTime {
                    allDangerousActionsData[NSDate(timeIntervalSince1970: d)] = tmpDangerousActionsSet
                }

                let userDataResult = try self.db.executeQuery("SELECT * FROM user_data_table ORDER BY dTimeInterval ASC", values: nil)
                while userDataResult.next() {
                    let departureTime = NSDate(timeIntervalSince1970: userDataResult.doubleForColumn("dTimeInterval"))
                    let distance = userDataResult.doubleForColumn("distance")
                    let arrivalTime = NSDate(timeIntervalSince1970: userDataResult.doubleForColumn("aTimeInterval"))
                    let drivingTimeSecond = Int(userDataResult.intForColumn("dTS"))
                    let drivingTimeHour = userDataResult.doubleForColumn("dTH")
                    let avgSpeed = userDataResult.doubleForColumn("avgSpeed")
                    let speedsTableName = userDataResult.stringForColumn("speedsTableName")
                    let speedsResult = try self.db.executeQuery("SELECT * FROM \(speedsTableName) ORDER BY timeInterval ASC", values: nil)
                    var speedArr = [(NSDate,Double)]()
                    while speedsResult.next() {
                        speedArr.append((NSDate(timeIntervalSince1970: speedsResult.doubleForColumn("timeInterval")),speedsResult.doubleForColumn("speed")))
                    }
                    if let dangerousActionSet = allDangerousActionsData[departureTime] {
                        result.append(Data(departureTime: departureTime, dangerousActionSet: dangerousActionSet, speedArr: speedArr, distance: distance, arrivalTime: arrivalTime, drivingTimeSecond: drivingTimeSecond, drivingTimeHour: drivingTimeHour, avgSpeed: avgSpeed))
                    } else {
                        result.append(Data(departureTime: departureTime, dangerousActionSet: [], speedArr: speedArr, distance: distance, arrivalTime: arrivalTime, drivingTimeSecond: drivingTimeSecond, drivingTimeHour: drivingTimeHour, avgSpeed: avgSpeed))
                    }
                }
                print("Get \(result.count) Data")
                self.close()
                return result
            }catch _ {
                self.close()
                print("Get Data error")
            }
        }else {
            print("Open error")
        }
        return []
    }
    
    /******************************************************************************************
     //
     // Call this function to delete old database and create a new one
     //
     ******************************************************************************************/
    
    func clearData() -> Bool {
        let dbDirectory = NSHomeDirectory() + "/Documents/database"
        do {
            try NSFileManager.defaultManager().removeItemAtPath(dbDirectory)
            try NSFileManager.defaultManager().createDirectoryAtPath(dbDirectory, withIntermediateDirectories: false, attributes: nil)
        } catch _ {
            print("Clear Data error!")
            return false
        }
        self.db = FMDatabase(path: self.dbPath)
        if !NSFileManager.defaultManager().fileExistsAtPath(self.dbPath) {
            if self.open() {
                let sql1 = "CREATE TABLE IF NOT EXISTS user_data_table (dTime TEXT NOT NULL PRIMARY KEY, dTimeInterval REAL, distance REAL, aTimeInterval REAL, dTS INTEGER, dTH INTEGER, avgSpeed REAL, speedsTableName TEXT)"
                let sql2 = "CREATE TABLE IF NOT EXISTS user_dangerous_actions_table (id INTEGER PRIMARY KEY, driveTimeInterval REAL, sTimeInterval REAL, dAction TEXT, eTimeInterval REAL)"
                self.db.executeStatements(sql1)
                self.db.executeStatements(sql2)
                print("Clear Data Successful")
                self.close()
            }else {
                print("Open error")
                return false
            }
        }
        return true
    }
    
    /******************************************************************************************
    //
    // Call this function to get data by params
    //
    ******************************************************************************************/
    
    func getDataByDangerousAction(dAType:DangerousActionTypes, min: Int, max: Int) -> [Data] {
        if db.open() {
            var result = [Data]()
            let allDatas = loadData()
            for data in allDatas {
                if data.dangerousActionIsEqual(dAType, min: min, max: max) {
                    result.append(data)
                }
            }
            return result
        } else {
            print("Open error")
        }
        return []
    }
}