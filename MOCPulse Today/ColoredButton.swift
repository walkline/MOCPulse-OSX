//
//  ColoredButton.swift
//  MOCPulse OSX
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Cocoa

class ColoredButton: NSButton {
    
    var color : NSColor!

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        self.color.set()
        NSRectFill(self.bounds)
    }
    
}
