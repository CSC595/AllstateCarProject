//
//  SummaryViewController.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/9/16.
//  Copyright © 2016 Martin Roeder. All rights reserved.
//

import UIKit

class SummaryViewController : UIViewController {
   
    var data:Data?

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var driveTimeLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var faceDetection: BooleanChart!
    @IBOutlet weak var phoneMotion: BooleanChart!
    @IBOutlet weak var noiseDetection: BooleanChart!
    @IBOutlet weak var excessiveSpeed: BooleanChart!
    
    override func viewDidLoad() {
        
        scrollView.contentSize.height = 700
        
        if let d = data {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEE MMM d, yyyy 'at' h:mm a"
            dateLabel.text = dateFormatter.stringFromDate(d.departureTime)
            
            let hours:Double = d.drivingTimeHour
            let minutes:Double = (hours - floor(hours)) * 60
            let seconds:Double = (minutes - floor(minutes)) * 60
            driveTimeLabel.text = String(format: "Duration %02.0f:%02.0f:%02.0f", arguments: [floor(hours), floor(minutes), floor(seconds)])
            
            averageSpeedLabel.text = String(format: "Average Speed %.1f mph", arguments: [d.avgSpeed])

            pointsLabel.text = "100"
            
            // NEED AN ADDTION TO THE DANGEROUSACTIONTYPES ENUM
            phoneMotion.setData(d, actionType: DangerousActionTypes.LookPhone)
            noiseDetection.setData(d, actionType: DangerousActionTypes.MicTooLoud)
            excessiveSpeed.setData(d, actionType: DangerousActionTypes.OverSpeeded)
            
        }

    }
    
}
