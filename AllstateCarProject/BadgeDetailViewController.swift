//
//  BadgeDetailViewController.swift
//  AllstateCarProject
//
//  Created by Lew Flauta on 3/2/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import UIKit

class BadgeDetailViewController: UIViewController {
    var badge: Badge!

    @IBOutlet weak var badgeAwardsLabel: UILabel!
    @IBOutlet weak var badgeNameLabel: UILabel!
    @IBOutlet weak var badgeIcon: UIImageView!
    @IBOutlet weak var badgeDetailsTextBox: UITextView!

    @IBOutlet weak var badgeEarned: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        badgeNameLabel.text = badge.badgeName
        badgeAwardsLabel.text = badge.emoticon
        let imageString = String(badge.badgeId)
        let image: UIImage = UIImage(named: imageString)!
        badgeDetailsTextBox.text = "\(badge.badgeDetail)"
        badgeIcon.image = image
        badgeEarned.text = String(badge.badgeEarned) + " Time(s)"
    }




    



}
