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
    
    @IBOutlet weak var trafficScoreLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var faceDetection: BooleanChart!
    @IBOutlet weak var phoneMotion: BooleanChart!
    @IBOutlet weak var noiseDetection: BooleanChart!
    @IBOutlet weak var excessiveSpeed: BooleanChart!
    @IBOutlet weak var speedChart: XYChart!
    
    override func viewDidLoad() {
        
        scrollView.contentSize.height = 864
        
        if let d = data {
            
            
            driveTimeLabel.text = getDurationString(d)
            averageSpeedLabel.text = getAverageSpeedString(d)
            trafficScoreLabel.text = getTrafficScoreString(d)

            pointsLabel.text = "100"
            
            faceDetection.setData(d, actionType: DangerousActionTypes.LookingAway)
            phoneMotion.setData(d, actionType: DangerousActionTypes.LookPhone)
            noiseDetection.setData(d, actionType: DangerousActionTypes.MicTooLoud)
            excessiveSpeed.setData(d, actionType: DangerousActionTypes.OverSpeeded)
            speedChart.setData(d)
            
            
        }

    }
    
    func getDurationString(d:Data) -> String {

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM d, yyyy 'at' h:mm a"
        dateLabel.text = dateFormatter.stringFromDate(d.departureTime)
        
        let hours:Double = d.drivingTimeHour
        let minutes:Double = (hours - floor(hours)) * 60
        let seconds:Double = (minutes - floor(minutes)) * 60
        
        return String(format: "Duration %02.0f:%02.0f:%02.0f", arguments: [floor(hours), floor(minutes), floor(seconds)])
    }
    
    func getAverageSpeedString(d:Data) -> String {
        return String(format: "Average Speed: %.1f mph", arguments: [d.avgSpeed])
    }
    
    func getTrafficScoreString(d:Data) -> String {
        
        var slowSpeeds:Double = 0
        for s in d.speedArr {
            if (s.1 < 5.0) {
                slowSpeeds++
            }
        }
        let count = Double(d.speedArr.count)
        let score = (count - slowSpeeds) / count * 100
        
        return String(format: "Traffic Score %.0f%%", arguments: [score])
    }
    
}
