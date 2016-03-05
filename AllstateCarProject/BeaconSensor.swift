//
//  BeaconSensor.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/15/16.
//  Copyright © 2016 ZZC. All rights reserved.
//
//  info: https://docs.gimbal.com/iosdocs/v2/swiftguide.html

class BeaconSensor: NSObject, GMBLPlaceManagerDelegate {
    
    var placeManager:GMBLPlaceManager?
    
    var isDriver:Bool
    var placeCount:Int
    var debugText:String
    var signalStrength:[String:Int]
    
    let noBeacon:Int = -1000

    
    override init() {
        
//        isVisiting = false
        placeCount = 0
        isDriver = false
        debugText = "No beacons detected"
        signalStrength = [String:Int]()
        signalStrength["Front Left"] = noBeacon
        signalStrength["Front Right"] = noBeacon
        signalStrength["Back Left"] = noBeacon
        signalStrength["Back Right"] = noBeacon
        
        super.init()
        
        // Get api key from file
        Gimbal.setAPIKey(GetKey.byName("gimbal"), options: nil)
        self.placeManager = GMBLPlaceManager()
        placeManager!.delegate = self
        GMBLPlaceManager.startMonitoring()

    }
    
    func placeManager(manager: GMBLPlaceManager!, didBeginVisit visit: GMBLVisit!) {
        updateSensor()
    }
    
    func placeManager(manager: GMBLPlaceManager!, didEndVisit visit: GMBLVisit!) {
        
        // Unwrap the name of the place
        if let n = visit.place.name {
            
            // If it matches an item in the dictionary, update that value
            if let _ = signalStrength[n] {
                signalStrength[n] = noBeacon
            }
        }
        
        updateSensor()
        
        
//        if let pm = placeManager {
//            if (pm.currentVisits().count == 0) {
//                isVisiting = false
//            }
//        }
    }
        
    //This will be invoked when a user sights a beacon
    func placeManager(manager: GMBLPlaceManager!, didReceiveBeaconSighting sighting: GMBLBeaconSighting!, forVisits visits: [AnyObject]!) {
        
        if let v = visits[0] as? GMBLVisit {
            if let n = v.place.name {
                if let s = sighting {
                    signalStrength[n] = s.RSSI
                }
            }
        }
        updateSensor()
        
//                isVisiting = true
//            }
//            else {
//                debugText = "No visits in progress"
//            }
//        }
        
//        if let s = sighting {
//            if let b = s.beacon {
//                debugText += "\nName: \(b.name)"
//                debugText += "\nID: \(b.identifier)"
//                debugText += "\nRSSI: \(s.RSSI) dBm"
//            }
//            
//        }
        
        
    }
    
    func updateSensor() {

        if let pm = placeManager {
            let c = pm.currentVisits().count
            debugText = "\(c) visit(s) detected"
            placeCount = c
        }
        
        if let a = signalStrength["Front Left"] {
            if let b = signalStrength["Front Right"] {
                if let c = signalStrength["Back Left"] {
                    if let d = signalStrength["Back Right"] {
                        debugText += String(format: "\n[ %3d | %3d ]\n[ %3d | %3d ]", arguments: [a, b, c, d])
                        
                        if let max = [a, b, c, d].maxElement() {
                            
                            if (max > noBeacon) {
                            
                                if let index = [a, b, c, d].indexOf(max) {
                                    switch (index) {
                                    case 0:
                                        debugText += "\nDriver"
                                        isDriver = true
                                    case 1:
                                        debugText += "\nFront Passenger"
                                        isDriver = false
                                    case 2:
                                        debugText += "\nBack Left Passenger"
                                        isDriver = false
                                    case 3:
                                        debugText += "\nBack Right Passenger"
                                        isDriver = false
                                    default:
                                        debugText += "\nUnknown Position"
                                        isDriver = false
                                    }
                                }
                            }
                            else {
                                debugText += "\nUnknown Position"
                                isDriver = false
                            }
                        }
                    }                        
                }
            }
        }
    }
    
    func printVisits() {
        if let pm = placeManager {
            for v in pm.currentVisits() {
                let x:GMBLVisit = v as! GMBLVisit
                print(x.place)
            }
        }
    }

    func printSighting(sighting: GMBLBeaconSighting!) {
        if let s = sighting {
            
            print("Date: \(s.date)")
            print("RSSI: \(s.RSSI) dBm")
            if let b = s.beacon {
                print("ID: \(b.identifier)")
                print("UUID: \(b.uuid)")
                print("Name: \(b.name)")
                print("Icon URL: \(b.iconURL)")

                switch (b.batteryLevel) {
                case GMBLBatteryLevel.High:
                    print("Battery: High")
                case GMBLBatteryLevel.MediumHigh:
                    print("Battery: Med-High")
                case GMBLBatteryLevel.MediumLow:
                    print("Battery: Med-Low")
                case GMBLBatteryLevel.Low:
                    print("Battery Low")
                }
                
                print("Temperature: \(b.temperature)F")
            }
        }
    }
}
