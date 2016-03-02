//
//  ShowDataTableViewController.swift
//  AllstateCarProject
//
//  Created by ZZC on 1/27/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {
    
    var datas = [Data]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datas = DataBaseManager.defaultManager().loadData()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("loadData"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
    }
    
    override func viewWillAppear(animated: Bool) {
        datas = DataBaseManager.defaultManager().loadData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell", forIndexPath: indexPath)

        let data = datas[indexPath.row]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM d, yyyy 'at' h:mm a"
        cell.textLabel!.text = dateFormatter.stringFromDate(data.departureTime)
        cell.textLabel!.font = UIFont(name: "Verdana", size: 14)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func loadData() {
        datas = DataBaseManager.defaultManager().loadData()
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data = datas[indexPath.row]
        data.printSelf()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the sending cell
        let senderCell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(senderCell)!
        
        // Get the destination VC and set the selected Item
        let destinationVC = segue.destinationViewController as! TripViewController
        destinationVC.data = datas[indexPath.row]
    }


}
