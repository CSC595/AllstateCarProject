//
//  DataBase.swift
//  AllstateCarProject
//
//  Created by ZZC on 1/24/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import Foundation
import FMDB



// Data which save in DB
// [0] dTime               TEXT   PRIMARY KEY
// [1] dTimeInterval       REAL
// [2] dangerousActionSet  BLOB
// [3] speedArr            BLOB
// [4] distance            REAL
// [5] aTimeInterval       REAL
// [6] dTS                 INTEGER
// [7] dTH                 REAL
// [8] avgSpeed            REAL

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
                let sql = "CREATE TABLE IF NOT EXISTS user_data_table (dTime TEXT NOT NULL PRIMARY KEY, dTimeInterval REAL, dangerousActionSet BLOB, speedArr BLOB, distance REAL, aTimeInterval REAL, dTS INTEGER, dTH INTEGER, avgSpeed REAL)"
                
                self.db.executeStatements(sql)
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
    
    func insertData(data:Data) -> Bool{
        if db.open() {
            do{
                try self.db.executeUpdate("insert into user_data_table (dTime, dTimeInterval, dangerousActionSet, speedArr, distance, aTimeInterval, dTS, dTH, avgSpeed) values (?,?,?,?,?,?,?,?,?)", values: data.toArray())
                
                print("Inserted one data")
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
    
    
    func getAllData() -> [Data] {
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
    }
    
}