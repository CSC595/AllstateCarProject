//
//  BadgeViewController.swift
//  AllstateCarProject
//
//  Created by Lew Flauta on 2/29/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import UIKit

class BadgeViewController: UITableViewController{

    let badge = Badge()



    @IBOutlet weak var badgeTableView: UITableView!

    override func viewDidAppear(animated: Bool) {
        navigationItem.title = "Badges"
    }

    //#MARK: - TableViewFunctions
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return badge.badgeName.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("badgeCell")!
        cell.textLabel?.text = badge.badgeName[indexPath.row]
        cell.imageView!.image = UIImage(named:badge.badgeIcon[indexPath.row])
        cell.detailTextLabel?.text = badge.badgeAward[indexPath.row]
        if badge.badgeActive[indexPath.row] == false{
            cell.backgroundColor = UIColor.grayColor()
        }
        return cell
      }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailVC = segue.destinationViewController as! BadgeDetailViewController
        let badgeCell = sender as! UITableViewCell
        let strBadge = badgeCell.textLabel?.text
        detailVC.title = strBadge

        detailVC.badgeName = badge.badgeName
        detailVC.badgeAward = badge.badgeAward
        detailVC.badgeImage = badge.badgeIcon
        detailVC.badgeDetail = badge.badgeDetail}




}
