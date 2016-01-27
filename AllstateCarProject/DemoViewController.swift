//
//  ViewController.swift
//  AllstateCarProject
//
//  Created by ZZC on 1/24/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import UIKit



class DemoViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var LookPhoneButton: UIButton!
    @IBOutlet weak var MicTooLoudButton: UIButton!
    @IBOutlet weak var OverSpeededButton: UIButton!
    @IBOutlet weak var distanceTextField: UITextField!
    
    var timer1: NSTimer?
    var timer2: NSTimer?
    var timer3: NSTimer?
    var timer4: NSTimer?
    
    var tmpSpeedsArr = [(NSDate, Double)]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonShow(false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonShow(isDriving: Bool) {
        startButton.enabled = !isDriving
        stopButton.enabled = isDriving
        LookPhoneButton.enabled = isDriving
        MicTooLoudButton.enabled = isDriving
        OverSpeededButton.enabled = isDriving
        
    }
    
    @IBAction func startButtonPressed(sender: UIButton) {
        buttonShow(true)
        distanceTextField.text = "\(Double(lround((Double(arc4random()) / 0xFFFFFFFF  * (60 - 10) + 10) * 1000)) / 1000)"
        DataCollector.defaultCollector().start()
        timer4 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "getSpeed", userInfo: nil, repeats: true)
    }
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        buttonShow(false)
        timer4?.invalidate()
        DataCollector.defaultCollector().collectingSpeeds(tmpSpeedsArr)
        tmpSpeedsArr = []
        DataCollector.defaultCollector().end(Double(distanceTextField.text!)!)
    }

    @IBAction func LookPhoneButtonPressed(sender: UIButton) {
        DataCollector.defaultCollector().catchDangerousAciton(DangerousActionTypes.LookPhone)
        timer1 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "lookPhoneFinished", userInfo: nil, repeats: false)
        sender.enabled = false
    }
    
    @IBAction func MicTooLoudButtonPressed(sender: UIButton) {
        DataCollector.defaultCollector().catchDangerousAciton(DangerousActionTypes.MicTooLoud)
        timer2 = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "MicTooLoudFinished", userInfo: nil, repeats: false)
        sender.enabled = false
    }
    
    @IBAction func OverSpeededButtonPressed(sender: AnyObject) {
        DataCollector.defaultCollector().catchDangerousAciton(DangerousActionTypes.MicTooLoud)
        timer3 = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "OverSpeededFinished", userInfo: nil, repeats: false)
        OverSpeededButton.enabled = false
    }
    
    func lookPhoneFinished() {
        DataCollector.defaultCollector().releaseDangerousAction(DangerousActionTypes.LookPhone)
        timer1?.invalidate()
        LookPhoneButton.enabled = true
    }
    func MicTooLoudFinished(){
        DataCollector.defaultCollector().releaseDangerousAction(DangerousActionTypes.LookPhone)
        timer2?.invalidate()
        MicTooLoudButton.enabled = true
    }
    func OverSpeededFinished(){
        DataCollector.defaultCollector().releaseDangerousAction(DangerousActionTypes.LookPhone)
        timer3?.invalidate()
        OverSpeededButton.enabled = true
    }
    func getSpeed() {
        tmpSpeedsArr.append((NSDate(),Double(lround((Double(arc4random()) / 0xFFFFFFFF  * (20 - 0) + 0) * 1000)) / 1000))
    }
    

}

