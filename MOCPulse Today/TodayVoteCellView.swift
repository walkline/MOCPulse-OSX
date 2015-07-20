//
//  VoteCellView.swift
//  MOCPulse OSX
//
//  Created by admin on 20.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Cocoa

let RED_COLOR = CGColorCreateGenericRGB(221/255, 42/255, 61/255, 1)
let YELLOW_COLOR = CGColorCreateGenericRGB(252/255, 210/255, 56/255, 1)
let GREEN_COLOR = CGColorCreateGenericRGB(130/255, 177/255,17/255, 1)

class TodayVoteCellView: NSTableCellView {

    @IBOutlet weak var nameField: NSTextField!
    
    @IBOutlet weak var coloredView: NSView!
    
    func setupWithVote(vote: VoteModel) {

        self.nameField.stringValue = vote.name!
        
        if (vote.greenVotes > vote.yellowVotes && vote.greenVotes > vote.redVotes) {
            self.coloredView.layer!.backgroundColor = GREEN_COLOR
        } else if (vote.yellowVotes > vote.greenVotes && vote.yellowVotes > vote.redVotes) {
            self.coloredView.layer!.backgroundColor = YELLOW_COLOR
        } else if (vote.redVotes > vote.greenVotes && vote.redVotes > vote.yellowVotes) {
            self.coloredView.layer!.backgroundColor = RED_COLOR
        } else {
            self.coloredView.layer!.backgroundColor = CGColorCreateGenericRGB(0/255, 0/255, 0/255, 1)
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        //coloredView.layer!.backgroundColor = CGColorCreateGenericRGB(14/255, 60/255, 62/255, 1)
        coloredView.layer!.cornerRadius = 5
    }
    
}
