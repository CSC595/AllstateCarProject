//
//  XYChartData.swift
//  AllstateCarProject
//
//  Created by Martin Roeder on 2/14/16.
//  Copyright © 2016 Martin Roeder. All rights reserved.
//

import UIKit

class XYChartData: UIView {
    
    var data:Data?
    let axisFont = UIFont.systemFontOfSize(10)
    
    let gridLineSections:CGFloat = 5
    let defaultScale:CGFloat = 20.0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        // will redraw when rotated
        contentMode = UIViewContentMode.Redraw
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func drawRect(rect: CGRect) {
        
        // Get Scale
        let scale = getScale()
        
        // Draw Data
        drawData(rect, scale: scale)
        
        // Draw Chart
        drawLabels(rect, scale: scale)
        
        
    }
    
    func getScale() -> CGFloat {

        // find max element
        if let d = data  {
            var max:Double = 0
            for (_, speed) in d.speedArr {
                max = max > speed ? max : speed
            }
            
            if (max < 25) {
                return 5
            }
            else if (max < 50) {
                return 10
            }
            else if (max < 100) {
                return 20
            }
            else {
                return 30
            }
            
//            let maxLabel = floor(max / 20) * 20
//            let scale = CGFloat(maxLabel) / 4
        }
        
        return defaultScale
        
    }
    
    func drawLabels(rect:CGRect, scale:CGFloat) {
        
        let x:CGFloat = 0
        let labelMargin:CGFloat = 20
        let ySize = (rect.height - axisFont.pointSize) / gridLineSections
        var y:CGFloat = 0
        
        let gridLines = UIBezierPath()
        
        var text = (gridLineSections) * scale
        while (text >= 0) {
            
            let label = UILabel(frame: CGRect(x: x, y: y, width: labelMargin, height: axisFont.pointSize))
            label.textAlignment = NSTextAlignment.Center
            label.text = String(format: "%.0f", arguments: [text])
            label.font = axisFont
            label.backgroundColor = self.backgroundColor
            self.addSubview(label)
            
            gridLines.moveToPoint(CGPoint(x: labelMargin, y: y + axisFont.pointSize / 2))
            gridLines.addLineToPoint(CGPoint(x: rect.width, y: y + axisFont.pointSize / 2))
            
            text -= scale
            y += ySize
        }
        UIColor.blackColor().setStroke()
        gridLines.lineWidth = 1.0
        gridLines.stroke()
        
    }
    
    func drawData(rect:CGRect, scale:CGFloat) {
        
        if let d = data {
            
            let count = CGFloat(d.speedArr.count)
            
            if count < 2   {
                print("drawData() count too small")
                return
            }
            
            //let yScale:CGFloat = rect.height / count
            let yScale:CGFloat = rect.height / gridLineSections / scale
            let yZero:CGFloat = rect.height - axisFont.pointSize / 2
            
            let xWidth:CGFloat = rect.width / (count - 1)
            var x:CGFloat = 0
            
            // Create data path
            let dataLine = UIBezierPath()
            
            // Find first element
            let firstPt = d.speedArr.first!
            dataLine.moveToPoint(CGPoint(x: x, y: yZero - CGFloat(firstPt.1) * yScale))
            
            
            for (_, speed) in d.speedArr[1..<d.speedArr.count] {
                x += xWidth
                dataLine.addLineToPoint(CGPoint(x: x, y: yZero - CGFloat(speed) * yScale))
//                print("addingLine speed: \(speed) x: \(x) y: \(yZero - CGFloat(speed) * yScale)")
            }
            
            // Stroke data path
            UIColor.blackColor().setStroke()
            dataLine.lineWidth = 1.0
            dataLine.stroke()
        }
        
    }
    
    
    
}
