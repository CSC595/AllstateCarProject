//
//  BooleanChart.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 1/23/16.
//  Copyright © 2016. All rights reserved.
//  http://supereasyapps.com/blog/2014/12/15/create-an-ibdesignable-uiview-subclass-with-code-from-an-xib-file-in-xcode-6

import UIKit

@IBDesignable class BooleanChart: UIView {
    
    let nibName = "BooleanChart"
    
    @IBOutlet var view: UIView!    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var dataSpace: BooleanChartData!
    
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
    
    func setData(data:Data, actionType:DangerousActionTypes) {
        
        switch(actionType) {
        case DangerousActionTypes.LookPhone:
            title.text = "Motion"
        case DangerousActionTypes.MicTooLoud:
            title.text = "Microphone"
        case DangerousActionTypes.OverSpeeded:
            title.text = "Speeding"
        }
        
        var totalTime:Double = 0
        
        for item in data.dangerousActionSet {
            if (item.1 == actionType) {
                totalTime += item.2.timeIntervalSinceDate(item.0)
            }
        }
        
        time.text = "\(round(totalTime)) s"
        
        dataSpace.actionType = actionType
        dataSpace.data = data
    }
    
}