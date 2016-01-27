//
//  DataBase.swift
//  AllstateCarProject
//
//  Created by ZZC on 1/24/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import Foundation
import FMDB



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



// Data which save in "\(departureTime.timeIntervalSince1970)_speeds_table"
// [0] timeInterval        REAL
// [1] speed               REAL



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
    
    
  /*  func getAllData() -> [Data] {
        if db.open() {
            var result = [Data]()
            do{
                let rs = try self.db.executeQuery("select * from user_data_table", values:nil)
                while rs.next() {
                    let data = Data(departureTime: NSDate(timeIntervalSince1970: rs.doubleForColumn("dTimeInterval")), dangerousActionSet: DangerousActionSet(data: rs.dataForColumn("dangerousActionSet")), speedArr: SpeedArr(data: rs.dataForColumn("speedArr")), distance: rs.doubleForColumn("distance"), arrivalTime: NSDate(timeIntervalSince1970: rs.doubleForColumn("aTimeInterval")))
                    result.append(data)
                    
                }
                print("Get Data")
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
    }*/
    
}