//
//  VoteCellView.swift
//  MOCPulse OSX
//
//  Created by Admin on 19.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Cocoa

class VoteCellView: NSTableCellView {

    @IBOutlet weak var authorField: NSTextFieldCell!
    @IBOutlet weak var voteName: NSTextFieldCell!
    
    override func drawRect(dirtyRect: NSRect) {

        super.drawRect(dirtyRect)
        // Drawing code here.
    }
    
    override var backgroundStyle:NSBackgroundStyle{
        //check value when the style was setted
        didSet{
            self.wantsLayer = true
            self.layer?.borderWidth = 0
            //if it is dark the cell is highlighted -> apply the app color to it
            if backgroundStyle == .Dark{
                authorField.textColor = NSColor.whiteColor()
                //self.layer!.backgroundColor = NSColor.grayColor().CGColor
            }
                //else go back to the standard color
            else{
                authorField.textColor = BLUE_COLOR
                self.layer!.backgroundColor = NSColor.clearColor().CGColor
            }
        }
    }
}
