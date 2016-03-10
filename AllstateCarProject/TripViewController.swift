//
//  SummaryViewController.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/9/16.
//  Copyright © 2016 Martin Roeder. All rights reserved.
//

import UIKit

class TripViewController : UIViewController {
   
    var data:Data?

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var driveTimeLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var attention: DistractionChart!
    @IBOutlet weak var motion: DistractionChart!
    @IBOutlet weak var noise: DistractionChart!
    @IBOutlet weak var speed: DistractionChart!
    
    @IBOutlet weak var viewPicButton: UIButton!
    
    override func viewDidLoad() {
        
        scrollView.alwaysBounceVertical = true
        
        if let d = data {
            
            driveTimeLabel.text = getDurationString(d)
            averageSpeedLabel.text = getAverageSpeedString(d)
            pointsLabel.text = "100"
            
            attention.icon.image = UIImage(named: "SteeringIcon")
            attention.title.text = "Attention"
            attention.setData(d, actionType: DangerousActionTypes.LookingAway)
            
            motion.icon.image = UIImage(named: "PhoneIcon")
            motion.title.text = "Motion"
            motion.setData(d, actionType: DangerousActionTypes.LookPhone)
            
            noise.icon.image = UIImage(named: "SoundIcon")
            noise.title.text = "Noise"
            noise.setData(d, actionType: DangerousActionTypes.MicTooLoud)
            
            speed.icon.image = UIImage(named: "SpeedIcon")
            speed.title.text = "Speed"
            speed.setData(d, actionType: DangerousActionTypes.OverSpeeded)
            
            if NSFileManager.defaultManager().fileExistsAtPath(NSHomeDirectory() + "/Documents/FaceDetectionPic/" + d.departureTime.toString().md5 + "/") {
                viewPicButton.enabled = true
            } else {
                viewPicButton.enabled = false
            }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let data = self.data {
            if segue.identifier == "showPictures" {
                let picturesCVC = segue.destinationViewController as! PicturesCollectionViewController
                picturesCVC.picDirPath = NSHomeDirectory() + "/Documents/FaceDetectionPic/" + data.departureTime.toString().md5 + "/"
            }
        }
    }
        
}
