//
//  Badge.swift
//  AllstateCarProject
//
//  Created by Lew Flauta on 2/29/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import Foundation
import UIKit

class Badge {
    var badgeName = [String]()
    var badgeIcon = [String]()
    var badgeAward = [String]()
    var badgeActive = [Bool]()
    var badgeDetail = [String]()
    init(){
        badgeName = ["Keeping Speed Limit","Quiet Rides", "?????","?????","?????"]
        badgeIcon = ["SpeedIcon", "SoundIcon","QuestionIcon","QuestionIcon","QuestionIcon"]
        badgeAward = ["🌟🌟🌟","🚕🚕","","",""]
        badgeActive = [true,true,false,false,false]
        badgeDetail = ["Badge details for earning this badge go here","Badge details for earning this badge go here","Badge details for earning this badge go here","Badge details for earning this badge go here"]
    }
}
