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
    
    var redLabel : NSTextField?
    var yellowLabel : NSTextField?
    var greenLabel : NSTextField?
    
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
    
    func getGreenLabel() -> NSTextField {
        if (greenLabel == nil) {
            greenLabel = NSTextField()
            greenLabel?.wantsLayer = true
            greenLabel?.bezeled = false
            greenLabel?.drawsBackground = false
            greenLabel?.selectable = false
            greenLabel?.alignment = NSTextAlignment.CenterTextAlignment
//            greenLabel?.minimumScaleFactor = 0.5
            greenLabel?.textColor = NSColor.whiteColor()
            self.addSubview(greenLabel!)
        }
        return greenLabel!
    }
    
    func getYellowLabel() -> NSTextField {
        if (yellowLabel == nil) {
            yellowLabel = NSTextField()
            yellowLabel?.wantsLayer = true
            yellowLabel?.bezeled = false
            yellowLabel?.drawsBackground = false
            yellowLabel?.selectable = false
            yellowLabel?.alignment = NSTextAlignment.CenterTextAlignment
//            yellowLabel?.minimumScaleFactor = 0.5
//            yellowLabel?.textAlignment = NSTextAlignment.Center
            yellowLabel?.textColor = NSColor.whiteColor()
            self.addSubview(yellowLabel!)
        }
        return yellowLabel!
    }
    
    func getRedLabel() -> NSTextField {
        if (redLabel == nil) {
            redLabel = NSTextField()
            redLabel?.wantsLayer = true
            redLabel?.bezeled = false
            redLabel?.drawsBackground = false
            redLabel?.selectable = false
            redLabel?.alignment = NSTextAlignment.CenterTextAlignment
//            redLabel?.minimumScaleFactor = 0.5
//            redLabel?.textAlignment = NSTextAlignment.Center
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
            
            var label = NSTextField()
            
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
            label.stringValue = NSString(format: "%.0f", colorObject!.val) as String
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}
