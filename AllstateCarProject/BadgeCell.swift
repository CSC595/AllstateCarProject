//
//  BadgeCell.swift
//  
//
//  Created by Lew Flauta on 3/6/16.
//
//

import UIKit

class BadgeCell: UICollectionViewCell {

    var badge: Badge!

    @IBOutlet weak var badgeEmoticonLabel: UILabel!
    @IBOutlet weak var badgeNameLabel: UILabel!
    @IBOutlet weak var badgeImage: UIImageView!
    func configureCell(badge: Badge){
        self.badge = badge
        badgeNameLabel.text = self.badge.badgeName.capitalizedString
        badgeImage.image = UIImage(named: "\(self.badge.badgeId)")
        badgeEmoticonLabel.text = self.badge.emoticon
}
}