//
//  MoreViewController.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/8/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    
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
        notImplemented()
    }
    func notImplemented() {
        // Not Implemented
        let controller = UIAlertController(title: "Not Implemented", message: nil, preferredStyle: .Alert)
        let noAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        controller.addAction(noAction)
        presentViewController(controller, animated: true, completion: nil)
    }
    
    
    
}
