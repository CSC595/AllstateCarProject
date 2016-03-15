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
    private var _badgeImage: String!
    private var _badgeType: String!
    private var _badgeDetail: String!
    var emoticon: String!
    var badgeEarned: Int!

    //create getters
    var badgeName: String{
        return _badgeName
    }

    var badgeId: Int {
        return _badgeId
    }

    var badgeType: String {
        return _badgeType
    }

    var badgeDetail: String {
        return _badgeDetail
    }






    //initializaers

    init (badgeName: String, badgeId: Int, badgeImage: String, emoticon: String, badgeEarned: Int, badgeType:String, badgeDetail: String){
        self._badgeName = badgeName
        self._badgeId = badgeId
        self._badgeImage = badgeImage
        self.emoticon = emoticon
        self.badgeEarned = badgeEarned
        self._badgeType = badgeType
        self._badgeDetail = badgeDetail
    }

}
