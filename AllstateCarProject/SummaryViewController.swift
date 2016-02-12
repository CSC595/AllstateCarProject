//
//  SummaryViewController.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/9/16.
//  Copyright © 2016 Martin Roeder. All rights reserved.
//

import UIKit

class SummaryViewController : UIViewController {
   
    
    @IBOutlet weak var faceDetection: BooleanChart!
    
    @IBOutlet weak var phoneMotion: BooleanChart!
    
    @IBOutlet weak var noiseDetection: BooleanChart!
    
    @IBOutlet weak var excessiveSpeed: BooleanChart!
    
    var data:Data?
    
    override func viewDidLoad() {
        if let d = data {
            // NEED AN ADDTION TO THE DANGEROUSACTIONTYPES ENUM
            phoneMotion.setData(d, actionType: DangerousActionTypes.LookPhone)
            noiseDetection.setData(d, actionType: DangerousActionTypes.MicTooLoud)
            excessiveSpeed.setData(d, actionType: DangerousActionTypes.OverSpeeded)
        }

    }
    
}
