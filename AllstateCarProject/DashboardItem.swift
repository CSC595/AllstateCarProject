//
//  DashboardItem.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/10/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import UIKit

@IBDesignable class DashboardItem: UIView {

    let nibName = "DashboardItem"

    @IBOutlet var view: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var debug: UILabel!
    
    var type:DangerousActionTypes?
    
    var switchCode: (()->())?
    var distraction:Bool = false
    var enabled:Bool?
    
    enum State {
        case good
        case bad
        case off
    }
    
    var state:State = State.off
    
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    
    @IBAction func viewTapped(sender: AnyObject) {
        if let e = enabled {
            if (e) {
                distraction ? stopDistraction() : startDistraction()
            }
        }
    }
    
    func startTrip() {
        setState(State.good)
        debug.text = "Waiting for data"
        enabled = !enableSensors_Global
        debug.hidden = hideSensorData_Global
        title.hidden = !hideSensorData_Global
    }
    
    func stopTrip() {
        enabled = false
        if (distraction) {
            distraction = false
            stopDistraction()
        }
        setState(State.off)
        debug.hidden = true
        title.hidden = false
    }
    
    func startDistraction() {
        if let t = type {
            DataCollector.defaultCollector().catchDangerousAciton(t)
            setState(State.bad)
            distraction = true
        }
    }
    
    func stopDistraction() {
        if distraction {
            if let t = type {
                DataCollector.defaultCollector().releaseDangerousAction(t)
                setState(State.good)
                distraction = false
            }
        }
    }
    
    func setState(nextState:State) {

        state = nextState
        
        switch (state) {
        case State.good:
            view.backgroundColor = UIColor.greenColor()
        case State.bad:
            view.backgroundColor = UIColor.redColor()
        case State.off:
            view.backgroundColor = UIColor.lightGrayColor()
        }
        
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//
//    }
    

}
