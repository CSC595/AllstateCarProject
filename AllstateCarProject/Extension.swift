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
    
    func picName() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
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

extension String {
    var md5: String {
        let string = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let stringLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(string!, stringLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.destroy()
        return hash as String
        
    }
}


