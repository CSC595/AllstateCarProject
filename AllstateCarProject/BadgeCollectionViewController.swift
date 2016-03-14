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
    let min = 1 //min number of distracted events per drive
    let max = 2 //max number of distracted events per drive
    let badgeIncrement = 1 //number of awards before receiving another star. eg increment of 5 means for 6 accomplishments you will receive 2 award emoticons

    @IBOutlet var collection: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        navigationItem.title = "Badges"
        parseCSV()
        datas = DataBaseManager.defaultManager().loadData()
        compileDatasForPerfectBadges()
        compileDatasForSecondaryBadges()
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


    func compileDatasForSecondaryBadges(){

        for data in datas {

            let countAttention = data.countOfDangerousAction(DangerousActionTypes.LookingAway)
            let countFocus = data.countOfDangerousAction(DangerousActionTypes.LookPhone)
            let countSound = data.countOfDangerousAction(DangerousActionTypes.MicTooLoud)
            let countSpeed = data.countOfDangerousAction(.OverSpeeded)


            if countSpeed >= min && countSpeed <= max {
                badges[5].badgeEarned = badges[5].badgeEarned + 1
                badges[5].emoticon = setEmoticons(badges[5].badgeEarned, min: min, max: max)
            }
            if countSound >= min && countSpeed <= max {
                badges[6].badgeEarned = badges[6].badgeEarned + 1
                badges[6].emoticon = setEmoticons(badges[6].badgeEarned, min: min, max: max)
            }
            if countFocus >= min && countSpeed <= max {
                badges[7].badgeEarned = badges[7].badgeEarned + 1
                badges[7].emoticon = setEmoticons(badges[7].badgeEarned, min: min, max: max)
            }
            if countAttention >= min && countSpeed <= max {
                badges[8].badgeEarned = badges[8].badgeEarned + 1
                badges[8].emoticon = setEmoticons(badges[8].badgeEarned, min: min, max: max)
            }


        }
        
        
    }

    func incrementBadgesEarned(badgesEarned: Int)->Int{
        return 0
    }









    

    func setEmoticons ( badgesEarned: Int,min: Int, max: Int) -> String {
        var emoticon = ""
        if badgesEarned == 0 {return ""}
        if min == 0 && max == 0 {
            //if badgesEarned > 5 {badgesEarned = 5}
            for var badg=0; badg < badgesEarned; badg += badgeIncrement {
                emoticon += "🌟"

            }
            
        } else {
            //if badgesEarned > 5 {badgesEarned = 5}
            for var badg=0; badg < badgesEarned; badg += badgeIncrement {
                emoticon += "🚕"

            }

        }
//        var maxIndexOfEmoticon = emoticon.characters.count
//        if maxIndexOfEmoticon > 5 {maxIndexOfEmoticon=5}
//        let finalEmoticon = (emoticon as NSString).substringToIndex(maxIndexOfEmoticon)
//        return finalEmoticon
        return emoticon
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

