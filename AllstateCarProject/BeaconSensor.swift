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
    
    var isVisiting:Bool
    var debugText:String
    
    override init() {
        
        isVisiting = false
        debugText = "Waiting for data"

        super.init()
        
        // Get api key from file

        Gimbal.setAPIKey(GetKey.byName("gimbal"), options: nil)
        self.placeManager = GMBLPlaceManager()
        placeManager!.delegate = self
        
        GMBLPlaceManager.startMonitoring()

    }
    
    func placeManager(manager: GMBLPlaceManager!, didBeginVisit visit: GMBLVisit!) {
        debugText = "Visit Started"
    }
    
    func placeManager(manager: GMBLPlaceManager!, didEndVisit visit: GMBLVisit!) {
        debugText = "Visit Ended"
        if let pm = placeManager {
            if (pm.currentVisits().count == 0) {
                isVisiting = false
            }
        }
    }
    
    //This will be invoked when a user sights a beacon
    func placeManager(manager: GMBLPlaceManager!, didReceiveBeaconSighting sighting: GMBLBeaconSighting!, forVisits visits: [AnyObject]!) {
        
        if let pm = placeManager {
            if (pm.currentVisits().count > 1) {
                debugText = "\(pm.currentVisits().count) visits detected"
                printVisits()
            }
            else {
                debugText = "Visit in progress"
            }
            isVisiting = true
        }
        
        if let s = sighting {
            if let b = s.beacon {
                debugText += "\nName: \(b.name)"
                debugText += "\nID: \(b.identifier)"
                debugText += "\nRSSI: \(s.RSSI) dBm"
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
