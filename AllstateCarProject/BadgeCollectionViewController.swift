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

    var badge =  [Badge]()
    var datas = [Data]()

    @IBOutlet var collection: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        navigationItem.title = "Badges"
        parseCSV()
        datas = DataBaseManager.defaultManager().loadData()
        compileDatasForBadges()

    }

    func compileDatasForBadges(){
        for data in datas {
            let countActions = data.countOfDangerousAction(DangerousActionTypes.MicTooLoud)
            print(countActions)
        }
        //print (datas[0].countOfDangerousAction(DangerousActionTypes.MicTooLoud))
        //print (datas[1].countOfDangerousAction(DangerousActionTypes.MicTooLoud))
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
                //let emoticon = row["emoticon"]!
                let reward = Badge(badgeName: badgeName, badgeId: badgeId)
                badge.append(reward)
                print (reward)
            }
        } catch let err as NSError {
            print (err.debugDescription)
        }
    }



    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("badgeCell", forIndexPath: indexPath) as? BadgeCell {


            let badg = badge[indexPath.row]
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
        badg = badge[indexPath.row]
        performSegueWithIdentifier("BadgeDetailVC", sender: badg)
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badge.count

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

