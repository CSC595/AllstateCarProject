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

    private var _badgeName: String!
    private var _badgeId: Int!
    private var _emoticon: String!

    //create getters
    var badgeName: String{
        return _badgeName
    }

    var badgeId: Int {
        return _badgeId
    }

    var emoticon: String {
        return _emoticon
    }


    //initializaers

    init (badgeName: String, badgeId: Int, emoticon:String){
        self._badgeName = badgeName
        self._badgeId = badgeId
        self._emoticon = emoticon
    }
/*    var badgeName = [String]()
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

    } */
}
