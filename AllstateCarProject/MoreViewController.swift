//
//  MoreViewController.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/8/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import UIKit

var debugMode_Global:Bool = false

class MoreViewController: UIViewController {
    
    @IBOutlet weak var debugModeButton: UIButton!
    
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
    
    @IBAction func DebugModePressed(sender: AnyObject) {
        
        debugMode_Global = !debugMode_Global
        
        if (debugMode_Global) {
            debugModeButton.setTitle("Debug Mode On", forState: .Normal)
        }
        else {
            debugModeButton.setTitle("Debug Mode Off", forState: .Normal)
        }
        
    }
    
    
    
    
}
