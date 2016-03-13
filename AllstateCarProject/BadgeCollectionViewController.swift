//
//  BadgeCollectionViewController.swift
//  AllstateCarProject
//
//  Created by Lew Flauta on 3/6/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "BadgeCell"

class BadgeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var badges = [Badge]()
    var datas = [Data]()

    @IBOutlet var collection: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        navigationItem.title = "Badges"
        parseCSV()
        datas = DataBaseManager.defaultManager().loadData()
        compileDatasForPerfectBadges()
        //compileBadgePerfectDrive()

    }

    func compileDatasForPerfectBadges(){
        for data in datas {
            let countAttention = data.countOfDangerousAction(DangerousActionTypes.LookingAway)
            let countFocus = data.countOfDangerousAction(DangerousActionTypes.LookPhone)
            let countSound = data.countOfDangerousAction(DangerousActionTypes.MicTooLoud)
            let countSpeed = data.countOfDangerousAction(.OverSpeeded)
            let countPerfect = countSound + countSpeed + countAttention + countFocus
            if countPerfect == 0 {
                badges[0].badgeEarned = badges[0].badgeEarned + 1
                badges[0].emoticon = setEmoticons(badges[0].badgeEarned, min: 0, max: 0)
            }
            if countSpeed == 0 {
                badges[1].badgeEarned = badges[1].badgeEarned + 1
                badges[1].emoticon = setEmoticons(badges[1].badgeEarned, min: 0, max: 0)
            }
            if countSound == 0 {
                badges[2].badgeEarned = badges[2].badgeEarned + 1
                badges[2].emoticon = setEmoticons(badges[2].badgeEarned, min: 0, max: 0)
            }
            if countFocus == 0 {
                badges[3].badgeEarned = badges[3].badgeEarned + 1
                badges[3].emoticon = setEmoticons(badges[3].badgeEarned, min: 0, max: 0)
            }
            if countAttention == 0 {
                badges[4].badgeEarned = badges[4].badgeEarned + 1
                badges[4].emoticon = setEmoticons(badges[4].badgeEarned, min: 0, max: 0)
            }


            }


    }

    func incrementBadgesEarned(badgesEarned: Int)->Int{
        return 0
    }







//    func compileBadgePerfectDrive(){
//        for data in datas {
//            let countActions = data.countOfDangerousAction(DangerousActionTypes.MicTooLoud) + data.countOfDangerousAction(DangerousActionTypes.OverSpeeded) + data.countOfDangerousAction(DangerousActionTypes.LookingAway) + data.countOfDangerousAction(DangerousActionTypes.MicTooLoud)
//
//            print (countActions)
//
//            badges[0].emoticon = setEmoticons(badges[0].badgeEarned)
//            }
//        }

    

    func setEmoticons (badgesEarned: Int,min: Int, max: Int) -> String {
        if badgesEarned == 0 {return ""}
        if min == 0 && max == 0 {return "🌟"}
        return "😙"
    }




    func parseCSV(){
        let path = NSBundle.mainBundle().pathForResource("badge", ofType: "csv")!
        print("parse CSV")

        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows{
                let badgeId = Int(row["badgeId"]!)!
                let badgeName = row["badgeName"]!
                let badgeImage = row["badgeImage"]!
                let emoticon = row["emoticon"]!
                let badgeEarned = Int(row["badgeEarned"]!)!
                let badgeType = row["badgeType"]!
                let badgeDetail = row["badgeDetail"]!
                let reward = Badge(badgeName: badgeName, badgeId: badgeId, badgeImage: badgeImage, emoticon: emoticon, badgeEarned: badgeEarned, badgeType: badgeType, badgeDetail: badgeDetail)
                badges.append(reward)
                print (reward)
            }
        } catch let err as NSError {
            print (err.debugDescription)
        }
    }


    // MARK: - Collection View Methods
    // TODO: make it divide into three columns
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("badgeCell", forIndexPath: indexPath) as? BadgeCell {


            let badg = badges[indexPath.row]
            cell.configureCell(badg)
            if badg.badgeEarned == 0 {
                cell.alpha = 0.3
            }
            return cell
        }else{
            return UICollectionViewCell()
        }

    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var badg: Badge!
        badg = badges[indexPath.row]
        performSegueWithIdentifier("BadgeDetailVC", sender: badg)
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badges.count

    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       if segue.identifier == "BadgeDetailVC"{
        if let detailsVC = segue.destinationViewController as? BadgeDetailViewController{
            if let badg = sender as? Badge{
                detailsVC.badge = badg
            }
        }
    }


    
    
}
}

