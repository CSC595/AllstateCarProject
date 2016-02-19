//
//  MoreViewController.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/8/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import UIKit

var enableSensors_Global:Bool = true
var hideSensorData_Global:Bool = false
var sampleRate_Global:Double = 2.0
var xTolerance_Global:Double = 0.4
var yTolerance_Global:Double = 0.2
var zTolerance_Global:Double = 0.2
var noiseLevel_Global:Float = -30
var speedLimit_Global:Double = 80.0


class MoreViewController: UIViewController {
    
    @IBOutlet weak var enableSensorsButton: UIButton!
    @IBOutlet weak var hideSensorTextButton: UIButton!
    
    @IBOutlet var sampleRateLabel: UILabel!
    @IBOutlet weak var xToleranceLabel: UILabel!
    @IBOutlet weak var yToleranceLabel: UILabel!
    @IBOutlet weak var zToleranceLabel: UILabel!
    @IBOutlet weak var noiseLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    override func viewDidLoad() {
        setSensorButton()
        setSensorTextButton()
    }
    
    @IBAction func ClearDataPressed(sender: AnyObject) {
        if DataBaseManager.defaultManager().clearData() {
            let controller = UIAlertController(title: "Clear Successful", message: nil, preferredStyle: .Alert)
            let noAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            controller.addAction(noAction)
            presentViewController(controller, animated: true, completion: nil)
        } else {
            let controller = UIAlertController(title: "Clear Error", message: nil, preferredStyle: .Alert)
            let noAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            controller.addAction(noAction)
            presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func sampleRateChanged(sender: UISlider) {
        let currentValue = Double(sender.value)
        sampleRate_Global = currentValue
        sampleRateLabel.text = String(format: "Sample rate %.1f sec", arguments: [sampleRate_Global])
    }
    
    @IBAction func xToleranceChanged(sender: UISlider) {
        let currentValue = Double(sender.value)
        xTolerance_Global = currentValue
        xToleranceLabel.text = String(format: "x Tolerance +/- %.2f", arguments: [xTolerance_Global])
    }
    
    @IBAction func yToleranceChanged(sender: UISlider) {
        let currentValue = Double(sender.value)
        yTolerance_Global = currentValue
        yToleranceLabel.text = String(format: "y Tolerance +/- %.2f", arguments: [yTolerance_Global])
    }
    
    @IBAction func zToleranceChanged(sender: UISlider) {
        let currentValue = Double(sender.value)
        zTolerance_Global = currentValue
        zToleranceLabel.text = String(format: "z Tolerance +/- %.2f", arguments: [zTolerance_Global])
    }
    
    @IBAction func noiseChanged(sender: UISlider) {
        let currentValue = Float(sender.value)
        noiseLevel_Global = currentValue
        noiseLabel.text = String(format: "Noise Level %.0f db", arguments: [noiseLevel_Global])
    }
    
    @IBAction func speedLimitChanged(sender: UISlider) {
        let currentValue = Double(sender.value)
        speedLimit_Global = currentValue
        speedLabel.text = String(format: "Speed Limit %.0f mph", arguments: [speedLimit_Global])
    }
    
    
    @IBAction func sensorModePressed(sender: UIButton) {
        enableSensors_Global = !enableSensors_Global
        setSensorButton()
    }
    
    @IBAction func sensorTextButtonPressed(sender: UIButton) {
        hideSensorData_Global = !hideSensorData_Global
        setSensorTextButton()
    }
    
    func setSensorButton() {
        if (enableSensors_Global) {
            enableSensorsButton.setTitle("Sensors are enabled", forState: .Normal)
        }
        else {
            enableSensorsButton.setTitle("Sensors are disabled", forState: .Normal)
        }
    }
    
    func setSensorTextButton() {
        if (hideSensorData_Global) {
            hideSensorTextButton.setTitle("Sensor data is hidden", forState: .Normal)
        }
        else {
            hideSensorTextButton.setTitle("Sensor data is showing", forState: .Normal)
        }
    }
    
    
    
}
