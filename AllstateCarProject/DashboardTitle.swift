//
//  DashboardTitle.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/18/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import UIKit

@IBDesignable class DashboardTitle: UIView {
    
    
    @IBOutlet weak var primaryIcon: UIImageView!
    let nibName = "DashboardTitle"
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var status: UILabel!
    var switchCode: (()->())?
    
    var tripInProgress:Bool = false
    var enabled:Bool?
    
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
                if (tripInProgress) {
                    stopTrip()
                }
                else {
                    startTrip()
                }

                if let callMeMaybe = switchCode {
                    callMeMaybe()
                }
                
                
            }
        }
    }
    
    func startTrip() {
        status.text = "In Progress"
        tripInProgress = true
        
        primaryIcon.layer.speed = 1.0
        UIView.animateWithDuration(1.0, delay: 0.0, options: [UIViewAnimationOptions.CurveLinear, UIViewAnimationOptions.Repeat], animations: {self.primaryIcon.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))}, completion: nil)
        
    }

    func stopTrip() {
        status.text = "Waiting for trip"
        tripInProgress = false
        primaryIcon.layer.speed = 0.0
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    //    override func drawRect(rect: CGRect) {
    //
    //    }
    
    
}
