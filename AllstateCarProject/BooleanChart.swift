//
//  BooleanChart.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 1/23/16.
//  Copyright © 2016. All rights reserved.

import Foundation
import UIKit

class BooleanChart: UIView {
    
    var data:Data?
    var type:DangerousActionTypes?
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var chartSpace: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NSBundle.mainBundle().loadNibNamed("BooleanChart", owner: self, options: nil)[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    func setData(data:Data, type:DangerousActionTypes) {
        
        switch(type) {
        case DangerousActionTypes.LookPhone:
            title.text = "Motion"
        case DangerousActionTypes.MicTooLoud:
            title.text = "Microphone"
        case DangerousActionTypes.OverSpeeded:
            title.text = "Speeding"
        }
        
        self.data = data
        self.type = type
        
        setNeedsDisplay()
    }
    override func drawRect(rect: CGRect) {
        
        if let d = data {

            let totalTime:Double = d.arrivalTime.timeIntervalSinceDate(d.departureTime)
            
            print("totalTime \(totalTime)")
            
        }
        
        
        
        
//        //let path = UIBezierPath(rect: rect)
//        let count = resultArray.count
//        
////        UIColor.grayColor().setFill()
////        path.fill()
//        
//        if count == 0 {
//            return
//        }
//        
//        // Drawing variables
//        var x:CGFloat = 0
//        let y:CGFloat = 0
//        let w:CGFloat = frame.width / CGFloat(count)
//        let h = frame.height
//        
//        // Loop through the elments in the array
//        var index = 0
//        while index < count {
//            
//            let currentResult = resultArray[index]
//            
//            // Determine the next color
//            if resultArray[index] {
//                UIColor.greenColor().setFill()
//                UIColor.greenColor().setStroke()
//            }
//            else {
//                UIColor.redColor().setFill()
//                UIColor.redColor().setStroke()
//            }
//            
//            // Determine the size of the next color
//            var wNext:CGFloat = 0
//            while (index < resultArray.count && resultArray[index] == currentResult) {
//                wNext += w
//                index++
//            }
//            let resultPath = UIBezierPath(rect:CGRect(x: x, y: y, width: wNext, height: h))
//            //            UIGraphicsBeginImageContext(<#T##size: CGSize##CGSize#>)
//            //            UIGraphicsGetCurrentContext()
//            //            CGContextMoveToPoint(<#T##c: CGContext?##CGContext?#>, <#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>)
//            //            CGContextAddLines(<#T##c: CGContext?##CGContext?#>, <#T##points: UnsafePointer<CGPoint>##UnsafePointer<CGPoint>#>, <#T##count: Int##Int#>)
//            //            let new = UIGraphicsGetImageFromCurrentImageContext()
//            
//            // Draw rectangle
//            resultPath.fill()
//            resultPath.stroke()
//            
//            // Increment to next rectangle
//            x += wNext
//            
//        }
        
    }
}