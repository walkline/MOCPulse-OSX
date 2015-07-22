//
//  ColorChart.swift
//  MOCPulse
//
//  Created by Paul Kovalenko on 04.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import Cocoa

class ColorChart: NSView {

    var redColor : ColorChartObject?
    var yellowColor : ColorChartObject?
    var greenColor : ColorChartObject?
    
    var redLabel : CenteredTextField?
    var yellowLabel : CenteredTextField?
    var greenLabel : CenteredTextField?
    
    var colorsAray : NSMutableArray?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    func getGreenColor() -> ColorChartObject {
        if (greenColor == nil) {
            greenColor = ColorChartObject()
            greenColor!.val = 33
            greenColor!.color = NSColor(red: 130/255, green: 177/255, blue: 17/255, alpha: 1)
        }
        return greenColor!
    }
    
    func getYellowColor() -> ColorChartObject {
        if (yellowColor == nil) {
            yellowColor = ColorChartObject()
            yellowColor!.val = 33
            yellowColor!.color = NSColor(red: 252/255, green: 210/255, blue: 56/255, alpha: 1)
        }
        return yellowColor!
    }
    
    func getRedColor() -> ColorChartObject {
        if (redColor == nil) {
            redColor = ColorChartObject()
            redColor!.val = 33
            redColor!.color = NSColor(red: 221/255, green: 48/255, blue: 61/255, alpha: 1)
        }
        return redColor!
    }
    
    func getGreenLabel() -> CenteredTextField {
        if (greenLabel == nil) {
            greenLabel = CenteredTextField()
            greenLabel?.bezeled = false
            greenLabel?.drawsBackground = false
            greenLabel?.selectable = false
            greenLabel?.alignment = NSTextAlignment.CenterTextAlignment
            greenLabel?.textColor = NSColor.whiteColor()
            self.addSubview(greenLabel!)
        }
        return greenLabel!
    }
    
    func getYellowLabel() -> CenteredTextField {
        if (yellowLabel == nil) {
            yellowLabel = CenteredTextField()
            yellowLabel?.wantsLayer = true
            yellowLabel?.bezeled = false
            yellowLabel?.drawsBackground = false
            yellowLabel?.selectable = false
            yellowLabel?.alignment = NSTextAlignment.CenterTextAlignment
            yellowLabel?.textColor = NSColor.whiteColor()
            self.addSubview(yellowLabel!)
        }
        return yellowLabel!
    }
    
    func getRedLabel() -> CenteredTextField {
        if (redLabel == nil) {
            redLabel = CenteredTextField()
            redLabel?.wantsLayer = true
            redLabel?.bezeled = false
            redLabel?.drawsBackground = false
            redLabel?.selectable = false
            redLabel?.alignment = NSTextAlignment.CenterTextAlignment
            redLabel?.textColor = NSColor.whiteColor()
            self.addSubview(redLabel!)
        }
        return redLabel!
    }
    
    func setup() {
        colorsAray = NSMutableArray()
        colorsAray?.addObject(self.getGreenColor())
        colorsAray?.addObject(self.getYellowColor())
        colorsAray?.addObject(self.getRedColor())
        
        self.wantsLayer = true
        
        self.layer!.cornerRadius = 5
        self.layer!.masksToBounds = true
        self.layer!.backgroundColor = NSColor.blackColor().CGColor
    }
    
    func clearChart() {
        colorsAray?.removeAllObjects()
        
        self.needsDisplay = true
    }
    
    func reloadChart() {
        self.needsDisplay = true
    }
    
    func fillRectWithColorOnContext(rect : CGRect, color : CGColorRef, currentGraphicsContext : CGContextRef) {
        CGContextAddRect(currentGraphicsContext, rect);
        CGContextSetFillColorWithColor(currentGraphicsContext, color);
        CGContextFillRect(currentGraphicsContext, rect);
    }
    
    override func drawRect(rect: CGRect) {
        if (greenColor == nil || redColor == nil || yellowColor == nil) {
            return
        }
        
        var currentGraphicsContext = NSGraphicsContext.currentContext()!.CGContext
        var sumOfAllSegmentValues : CGFloat = 0.0
        
        for colorObject in [greenColor, yellowColor, redColor]
        {
            sumOfAllSegmentValues += colorObject!.val
        }
        
        if (sumOfAllSegmentValues == 0) {
            return
        }
        
        var progressRect : CGRect = rect
        
        var lastSegmentRect : CGRect = CGRectMake(0, 0, 0, 0)
        
        for colorObject in [redColor, yellowColor, greenColor]
        {
            var currentSegmentValue : CGFloat = colorObject!.val
            
            var color : CGColorRef = colorObject!.color.CGColor
            
            var percentage : CGFloat = currentSegmentValue / sumOfAllSegmentValues
            
            progressRect = rect
            
            progressRect.size.width *= percentage
            
            progressRect.origin.x += lastSegmentRect.origin.x + lastSegmentRect.size.width
            
            lastSegmentRect = progressRect;
            
            self.fillRectWithColorOnContext(lastSegmentRect, color: color, currentGraphicsContext: currentGraphicsContext)
            
            var label = CenteredTextField()
            
            if (colorObject == greenColor) {
                label = self.getGreenLabel()
            }
            else if (colorObject == yellowColor) {
                label = self.getYellowLabel()
            }
            else if (colorObject == redColor) {
                label = self.getRedLabel()
            }
            
            label.frame = lastSegmentRect
            label.val = NSString(format: "%.0f", colorObject!.val) as String
            label.needsDisplay = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}
