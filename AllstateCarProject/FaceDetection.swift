//
//  FaceDetection.swift
//  AllstateCarProject
//
//  Created by ZZC on 2/24/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let serverIP = "http://75.102.224.118:5000/"
let startServiceURL = serverIP + "run_app"
let endServiceURL = serverIP + "stop_app"
let getResultURL = serverIP + "result"

class FaceDetection {
    var debugText: String
    var isDistracted: Bool = false
    
    
    init() {
        
        debugText = "Connecting..."
        Alamofire.request(.GET, startServiceURL).responseJSON { (response) -> Void in
            let result = response.result
            switch result{
            case .Success:
                if let value = result.value {
                    let json = JSON(value)
                    for(_,subJson):(String,JSON) in json {
                        let status = subJson[0]["status"].stringValue
                        self.debugText = "Server is \(status)."
                    }
                }
            case .Failure(let error):
                self.debugText = "\(error)"
            }
        }
    }
    
    func checkResult() {
        Alamofire.request(.GET, getResultURL).responseJSON { (response) -> Void in
            let result = response.result
            switch result{
            case .Success:
                if let value = result.value {
                    let json = JSON(value)
                    for(_,subJson):(String,JSON) in json {
                        let rs = subJson[0]["lookaround"].stringValue
                        if rs == "yes" {
                            self.isDistracted = true
                        } else if rs == "no" {
                            self.isDistracted = false
                        } else {
                            self.debugText = "Service isn't available."
                        }
                    }
                }
            case .Failure(let error):
                self.debugText = "\(error)"
            }
        }
    }
    
    func endService() {
        isDistracted = false
        Alamofire.request(.GET, endServiceURL).responseJSON { (response) -> Void in
            let result = response.result
            switch result{
            case .Success:
                if let value = result.value {
                    let json = JSON(value)
                    for(_,subJson):(String,JSON) in json {
                        let status = subJson[0]["status"].stringValue
                        self.debugText = "Server is \(status)."
                    }
                }
            case .Failure(let error):
                self.debugText = "\(error)"
            }
        }
    }
    
}
