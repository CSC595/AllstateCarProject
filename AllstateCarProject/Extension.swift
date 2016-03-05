//
//  Extension.swift
//  AllstateCarProject
//
//  Created by ZZC on 1/24/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import Foundation


extension NSDate {
    func toString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.stringFromDate(self)
    }
    
    func createSpeedsTableName() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return "speeds_table_\(dateFormatter.stringFromDate(self))"
    }
    
    func durationSeconds(date: NSDate) -> Int {
        return Int(self.timeIntervalSince1970) - Int(date.timeIntervalSince1970)
    }
    
    func durationHour(date: NSDate) -> Double {
        let seconds = self.durationSeconds(date)
        let h = seconds / 3600
        let m = (seconds - 3600 * h) / 60
        let s = seconds - 3600 * h - m * 60
        var x:Double = 0
        x += Double(h)
        x += Double(m)/60
        x += Double(s)/3600
        //return Double(h) + Double(m)/60 + Double(s)/3600
        return x
    }
    
}


