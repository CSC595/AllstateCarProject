//
//  BadgeDetailViewController.swift
//  AllstateCarProject
//
//  Created by Lew Flauta on 3/2/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import UIKit

class BadgeDetailViewController: UIViewController {


    @IBOutlet weak var badgeAwardsLabel: UILabel!
    @IBOutlet weak var badgeNameLabel: UILabel!
    @IBOutlet weak var badgeIcon: UIImageView!
    @IBOutlet weak var badgeDetailsTextBox: UITextView!
    var badgeName = [String]()
    var badgeImage = [String]()
    var badgeAward = [String]()
    var badgeActive = [Bool]()
    var badgeDetail = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        badgeAwardsLabel.text = "\(badgeAward)"
        badgeDetailsTextBox.text = "\(badgeDetail)"
        //badgeIcon = UIImage(named: badgeImage)
    }




    



}
