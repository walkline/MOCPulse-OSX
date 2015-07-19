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
}
