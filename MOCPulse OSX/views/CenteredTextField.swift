//
//  CenteredTextField.swift
//  MOCPulse OSX
//
//  Created by admin on 22.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Cocoa

class CenteredTextField: NSTextField {
    var val : NSString!
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        var text : NSString = val
        text.drawInRect(adjustedFrameToVerticallyCenterText(dirtyRect), withAttributes: [NSForegroundColorAttributeName:NSColor.whiteColor()])
    }
    
    func adjustedFrameToVerticallyCenterText(frame: NSRect) -> NSRect {
        var offset1 = floor((NSHeight(frame) - (self.font!.ascender - self.font!.descender)) / 2)
        var offset2 = floor((NSWidth(frame) - (self.font!.ascender - self.font!.descender)) / 2)
        return NSInsetRect(frame, offset2, offset1)
    }
}
