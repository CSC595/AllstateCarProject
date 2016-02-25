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
    
    var pressed:(()->())?
    var enabled:Bool?
    
    var statusText:[String] = []
    
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
                if let p = pressed {
                    p()
                }
            }
        }
    }
    
    func start() {
        debug.hidden = hideSensorData_Global
        title.hidden = !hideSensorData_Global
    }
    
    func stop() {
        setStateOff()
//        debug.hidden = true
//        title.hidden = false

    }
    func setStateGood() {
        view.backgroundColor = UIColor.greenColor()
    }
    
    func setStateBad() {
        view.backgroundColor = UIColor.redColor()
    }
    
    func setStateOff() {
        view.backgroundColor = UIColor.lightGrayColor()
    }
    
    func setText(text:String) {
        debug.text = text
    }
    
    func addText(text:String) {
        
        if (statusText.count > 4) {
            statusText.removeFirst()
        }
        statusText.append(text)
        
        var newText = ""
        for s in statusText {
            newText += "\(s)\n"
        }
        
        debug.text = newText.substringToIndex(newText.endIndex.advancedBy(-1))
        
    }
    
    func clearText() {
        statusText.removeAll()
    }

}
