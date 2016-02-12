//
//  DashboardItem.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/10/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import UIKit

@IBDesignable class DashboardItem: UIView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var debugData: UILabel!
    @IBOutlet weak var actionSwitch: UISwitch!
    @IBOutlet var view: UIView!
    
    let nibName = "DashboardItem"
    
    var switchCode: (()->())?
    
    @IBInspectable var Name: String {
        get {
            if let x = title.text {
                return x
            }
            return ""
        }
        set(name) {
            title.text = name
        }
    }
    
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

    @IBAction func switchTapped(sender: UISwitch) {
        if let callMeMaybe = switchCode {
            callMeMaybe()
        }        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
