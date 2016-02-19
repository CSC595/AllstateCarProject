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
var yTolerance_Global:Double = 0.4
var zTolerance_Global:Double = 0.8
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
    
    @IBOutlet weak var sampleRateSlider: UISlider!
    @IBOutlet weak var xToleranceSlider: UISlider!
    @IBOutlet weak var yToleranceSlider: UISlider!
    @IBOutlet weak var zToleranceSlider: UISlider!
    @IBOutlet weak var noiseSlider: UISlider!
    @IBOutlet weak var speedSlider: UISlider!



    
    override func viewDidLoad() {
        setSensorButton()
        setSensorTextButton()
        setXTolerance()
        setYTolerance()
        setZTolerance()
        setNoiseLevel()
        setSpeedLimit()
        sampleRateSlider.value = Float(sampleRate_Global)
        xToleranceSlider.value = Float(xTolerance_Global)
        yToleranceSlider.value = Float(yTolerance_Global)
        zToleranceSlider.value = Float(zTolerance_Global)
        noiseSlider.value = Float(noiseLevel_Global)
        speedSlider.value = Float(speedLimit_Global)
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
        sampleRate_Global = Double(sender.value)
        setSampleRate()
    }
    
    @IBAction func xToleranceChanged(sender: UISlider) {
        xTolerance_Global = Double(sender.value)
        setXTolerance()
    }
    
    @IBAction func yToleranceChanged(sender: UISlider) {
        yTolerance_Global = Double(sender.value)
        setYTolerance()
    }
    
    @IBAction func zToleranceChanged(sender: UISlider) {
        zTolerance_Global = Double(sender.value)
        setZTolerance()
    }
    
    @IBAction func noiseChanged(sender: UISlider) {
        noiseLevel_Global = sender.value
        setNoiseLevel()
    }
    
    @IBAction func speedLimitChanged(sender: UISlider) {
        speedLimit_Global = Double(sender.value)
        setSpeedLimit()
    }
    
    @IBAction func sensorModePressed(sender: UIButton) {
        enableSensors_Global = !enableSensors_Global
        setSensorButton()
    }
    
    @IBAction func sensorTextButtonPressed(sender: UIButton) {
        hideSensorData_Global = !hideSensorData_Global
        setSensorTextButton()
    }
    
    func setSampleRate() {
        sampleRateLabel.text = String(format: "Sample rate %.1f sec", arguments: [sampleRate_Global])
    }
    
    func setXTolerance() {
        xToleranceLabel.text = String(format: "x Tolerance +/- %.2f", arguments: [xTolerance_Global])
    }
    
    func setYTolerance() {
        yToleranceLabel.text = String(format: "y Tolerance +/- %.2f", arguments: [yTolerance_Global])
    }
    
    func setZTolerance() {
        zToleranceLabel.text = String(format: "z Tolerance +/- %.2f", arguments: [zTolerance_Global])
    }
    
    func setNoiseLevel() {
        noiseLabel.text = String(format: "Noise Level %.0f db", arguments: [noiseLevel_Global])
    }
    
    func setSpeedLimit() {
        speedLabel.text = String(format: "Speed Limit %.0f mph", arguments: [speedLimit_Global])
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
