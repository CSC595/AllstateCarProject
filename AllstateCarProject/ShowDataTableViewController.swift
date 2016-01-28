//
//  ShowDataTableViewController.swift
//  AllstateCarProject
//
//  Created by ZZC on 1/27/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import UIKit

class ShowDataTableViewController: UITableViewController {
    
    var datas = [Data]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datas = DataBaseManager.defaultManager().loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("showData", forIndexPath: indexPath)
        let data = datas[indexPath.row]
        
        cell.textLabel?.text = "Start Time: \(data.departureTime.toString())"
        print("############################\nStart Time: \(data.departureTime.toString())\nEnd Time: \(data.arrivalTime.toString())\nDistance: \(data.distance)\nDurtion Hour: \(data.drivingTimeHour)\nDurtion Second: \(data.drivingTimeSecond)\nAvg Speed: \(data.avgSpeed)\n Number of Dangerous Actions: \(data.dangerousActionSet.count)\n############################")
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    


}
