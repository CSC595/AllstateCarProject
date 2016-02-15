//
//  BeaconSensor.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/15/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import Foundation


/* CODE FROM MY SAMPLE APP, HASN'T BEEN INTEGRATED YET

class GimbalViewController: UIViewController, GMBLBeaconManagerDelegate, GMBLPlaceManagerDelegate, GMBLCommunicationManagerDelegate {
    
    var placeManager:GMBLPlaceManager?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var batteryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var isMonitoringLabel: UILabel!
    @IBOutlet weak var visitStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Gimbal.setAPIKey("OMITTED", options: nil)
        self.placeManager = GMBLPlaceManager()
        placeManager!.delegate = self
        
        GMBLPlaceManager.startMonitoring()
        isMonitoringLabel.text = "GMBLPlaceManager.isMonitoring(): \(GMBLPlaceManager.isMonitoring())"
        
        checkVisit()
    }
    
    //This will be invoked when a user sights a beacon
    func beaconManager(manager: GMBLBeaconManager!, didReceiveBeaconSighting sighting: GMBLBeaconSighting!) {
        print("beaconManager didReceiveBeaconSighting")
    }
    
    func placeManager(manager: GMBLPlaceManager!, didBeginVisit visit: GMBLVisit!) {
        checkVisit()
    }
    
    func placeManager(manager: GMBLPlaceManager!, didEndVisit visit: GMBLVisit!) {
        checkVisit()
    }
    
    func placeManager(manager: GMBLPlaceManager!, didReceiveBeaconSighting sighting: GMBLBeaconSighting!, forVisits visits: [AnyObject]!) {
        if let s = sighting {
            dateLabel.text = "Date: \(s.date)"
            rssiLabel.text = "RSSI: \(s.RSSI)dBm"
            if let b = s.beacon {
                idLabel.text = "ID: \(b.identifier)"
                uuidLabel.text = "UUID: \(b.uuid)"
                nameLabel.text = "Name: \(b.name)"
                iconLabel.text = "Icon URL: \(b.iconURL)"
                
                switch (b.batteryLevel) {
                case GMBLBatteryLevel.High:
                    batteryLabel.text = "Battery: High"
                case GMBLBatteryLevel.MediumHigh:
                    batteryLabel.text = "Battery: Med-High"
                case GMBLBatteryLevel.MediumLow:
                    batteryLabel.text = "Battery: Med-Low"
                case GMBLBatteryLevel.Low:
                    batteryLabel.text = "Battery Low"
                }
                temperatureLabel.text = "Temperature: \(b.temperature)F"
                
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func checkVisit() {
        if let pm = placeManager {
            
            for x in pm.currentVisits() {
                print (x)
            }
            let count = pm.currentVisits().count
            if (count > 0) {
                visitStatusLabel.text = "[\(count)] visit in progress"
            }
            else {
                visitStatusLabel.text = "No visit in progress"
                dateLabel.text = "Date:"
                rssiLabel.text = "RSSI:"
                idLabel.text = "ID:"
                uuidLabel.text = "UUID:"
                nameLabel.text = "Name:"
                iconLabel.text = "Icon URL:"
                batteryLabel.text = "Battery:"
                temperatureLabel.text = "Temperature:"
            }
        }
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

*/