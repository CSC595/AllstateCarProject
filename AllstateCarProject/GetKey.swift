//
//  GetKey.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/18/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import Foundation

class GetKey {
    static func byName(name:String) -> String {
        
        do {

            let bundle = NSBundle.mainBundle()
            let path = bundle.pathForResource(name, ofType: "apikey")
            return try String(contentsOfFile: path!, encoding:NSUTF8StringEncoding)
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return ""
        }
    }
}