//
//  PicturesCollectionViewController.swift
//  AllstateCarProject
//
//  Created by Zhicong Zang on 3/9/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PictureViewCell"

class PicturesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var picDirPath = ""
    var pictures = [(String,UIImage)]()
    
    override func viewWillAppear(animated: Bool) {
        if NSFileManager.defaultManager().fileExistsAtPath(picDirPath) {
            pictures = []
            do {
                let contentsOfPath = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(picDirPath)
                print(contentsOfPath.count)
                for path in contentsOfPath {
                    print(path)
                    if let image = UIImage(contentsOfFile: picDirPath + path) {
                        pictures.append((path,image))
                    }
                }
            } catch _ {
                print("Error")
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pictures.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        
        let imageView = UIImageView(image: pictures[indexPath.item].1)
        imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.width / 4 * 3)
        let label = UILabel(frame: CGRect(x: 0, y: cell.frame.width / 16 * 13, width: cell.frame.width, height: cell.frame.width / 8))
        label.textAlignment = NSTextAlignment.Center
        label.text = pictures[indexPath.item].0
        label.textColor = UIColor.whiteColor()
        cell.addSubview(imageView)
        cell.addSubview(label)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((UIScreen.mainScreen().bounds.width - 10) / 2, (UIScreen.mainScreen().bounds.width - 10) / 2)
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
