//
//  BooleanChartData.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/10/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import UIKit

class DistractionChartData: UIView {

    var data:Data?
    var actionType:DangerousActionTypes?
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func drawRect(rect: CGRect) {
        
        UIColor.redColor().setFill()
        UIColor.redColor().setStroke()

        let yStart:Double = 0
        let yHeight:Double = Double(rect.height)
        
        if let d = data {
            
            let totalTime:Double = d.arrivalTime.timeIntervalSinceDate(d.departureTime)
            let scaleFactor:Double = Double(rect.width) / totalTime
            
            for item in d.dangerousActionSet {
                
                if (item.1 == actionType) {
                    
                    let xStart:Double = item.0.timeIntervalSinceDate(d.departureTime) * scaleFactor
                    let xWidth:Double = item.2.timeIntervalSinceDate(item.0) * scaleFactor
                    let path = UIBezierPath(rect: CGRect(x: xStart, y: yStart, width: xWidth, height: yHeight))
                    path.fill()
                    path.stroke()                                        
                }
            }
        }
    }

}
