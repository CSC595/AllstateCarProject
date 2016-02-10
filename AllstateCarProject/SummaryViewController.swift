//
//  SummaryViewController.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/9/16.
//  Copyright © 2016 Martin Roeder. All rights reserved.
//

import UIKit

class SummaryViewController : UIViewController {
    
    @IBOutlet weak var cameraChart: BooleanChart!
    @IBOutlet weak var motionChart: BooleanChart!
    @IBOutlet weak var microphoneChart: BooleanChart!
    
    var data:Data?
    
    override func viewDidLoad() {
        if let d = data {
            motionChart.setData(d, actionType: DangerousActionTypes.LookPhone)
            microphoneChart.setData(d, actionType: DangerousActionTypes.MicTooLoud)
            cameraChart.setData(d, actionType: DangerousActionTypes.OverSpeeded)
        }

    }
    
    override func viewDidAppear(animated: Bool) {
    }
}
