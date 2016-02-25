//
//  Distraction.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/25/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import Foundation

class DistractionItem : DashboardItem {
    
    var type:DangerousActionTypes?
    var distraction:Bool = false

    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    
    @IBAction override func viewTapped(sender: AnyObject) {
        if let e = enabled {
            if (e) {
                distraction ? stopDistraction() : startDistraction()
            }
        }
    }
    
    override func start() {
        super.start()
        enabled = !enableSensors_Global
        setStateGood()
//            setState(State.good)
        debug.text = "Waiting for data"
    }
    
    override func stop() {
        super.stop()
        enabled = false
        if (distraction) {
            distraction = false
            stopDistraction()
        }
    }
    
    func startDistraction() {
        if let t = type {
            DataCollector.defaultCollector().catchDangerousAciton(t)
            setStateBad()
//                setState(State.bad)
            distraction = true
        }
    }
    
    func stopDistraction() {
        if distraction {
            if let t = type {
                DataCollector.defaultCollector().releaseDangerousAction(t)
                setStateGood()
//                    setState(State.good)
                distraction = false
            }
        }
    }
        
//        func setState(nextState:State) {
//            
//            state = nextState
//            
//            switch (state) {
//            case State.good:
//                view.backgroundColor = UIColor.greenColor()
//            case State.bad:
//                view.backgroundColor = UIColor.redColor()
//            case State.off:
//                view.backgroundColor = UIColor.lightGrayColor()
//            }
//            
//        }
    
        // Only override drawRect: if you perform custom drawing.
        // An empty implementation adversely affects performance during animation.
        //    override func drawRect(rect: CGRect) {
        //
        //    }
        
        
//    }

}