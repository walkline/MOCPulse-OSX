//
//  ChertView.swift
//  MOCPulse OSX
//
//  Created by Admin on 19.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Cocoa

class ChartView: NSView {

    var valuesArray : [CGFloat]!
    var colorsArray : [NSColor]!
    
    var radius : Float!
    var lineWidth : CGFloat = 0.5
    
    private var relativeValuesArray : [CGFloat]!
    private var center: CGPoint!
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        self.drawChartPieces()
    }
    
    func drawChartPieces() {
        
        if (valuesArray == nil || colorsArray == nil) {
            return
        }
        
        self.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2)
        
        var total : CGFloat = 0
        for (var i = 0; i < valuesArray.count; ++i) {
            total += valuesArray[i]
        }
        
        relativeValuesArray = [CGFloat](count: valuesArray.count, repeatedValue: 0.0)
        
        for (var i = 0; i < valuesArray.count; ++i) {
            relativeValuesArray[i] = valuesArray[i] / total
        }
        
        var lastAngel : CGFloat = 90
        var nextAngel : CGFloat = 90
        
        for (var i = 0; i < valuesArray.count; ++i) {
            lastAngel = nextAngel
            nextAngel = lastAngel - CGFloat(360 * self.relativeValuesArray[i])
            
            var gradient : NSGradient = NSGradient(colors: [colorsArray[i]])
            
            var path : NSBezierPath = NSBezierPath()
            path.moveToPoint(self.center)
            path.appendBezierPathWithArcWithCenter(self.center, radius: CGFloat(self.radius), startAngle: lastAngel, endAngle: nextAngel, clockwise: true)
            path.lineToPoint(self.center)
            path.closePath()
            
            gradient.drawInBezierPath(path, angle: -90)
            path.lineWidth = self.lineWidth
            path.stroke()
            
        }
    }
    
    func update() {
        self.hidden = true
        self.hidden = false
    }
}
