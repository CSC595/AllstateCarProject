//
//  DistractionChart.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/25/16.
//  Copyright © 2016 Martin Roeder. All rights reserved.
//  http://supereasyapps.com/blog/2014/12/15/create-an-ibdesignable-uiview-subclass-with-code-from-an-xib-file-in-xcode-6


import UIKit

@IBDesignable class DistractionChart: UIView {
    
    let nibName = "DistractionChart"
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var distractionDataView: DistractionChartData!
    
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
    
    func setData(data:Data, actionType:DangerousActionTypes) -> Int {
        
        var distractionTime:Int = 0
        for item in data.dangerousActionSet {
            if (item.1 == actionType) {
                distractionTime += Int(ceil(item.2.timeIntervalSinceDate(item.0)))
            }
        }
        let totalTime = data.drivingTimeSecond
        let score:Int = ((totalTime - min(distractionTime, totalTime)) * 100) / totalTime
        
        
        if let t = title.text {
            title.text = t + String(format: " Score: %d%%", arguments: [score])
        }
        else {
            title.text = String(format: "Score: %d%%", arguments: [score])
        }

        distractionDataView.actionType = actionType
        distractionDataView.data = data
        
        return score
    }
    
}

