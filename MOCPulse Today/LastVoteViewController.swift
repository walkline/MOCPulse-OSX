//
//  LastVoteViewController.swift
//  MOCPulse OSX
//
//  Created by admin on 21.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Cocoa
import NotificationCenter


let _RED_COLOR = NSColor(calibratedRed: 221/255, green: 42/255, blue: 61/255, alpha: 1)
let _YELLOW_COLOR = NSColor(calibratedRed: 252/255, green: 210/255, blue: 56/255, alpha: 1)
let _GREEN_COLOR = NSColor(calibratedRed: 130/255, green: 177/255, blue: 17/255, alpha: 1)


class LastVoteViewController: NSViewController, NCWidgetProviding  {

    @IBOutlet weak var authorName: NSTextField!
    @IBOutlet var voteName: NSTextView!
    
    @IBOutlet weak var redButton: NSButton!
    @IBOutlet weak var yellowButton: NSButton!
    @IBOutlet weak var grennButton: NSButton!

    var vote : VoteModel!
    
    override var nibName: String? {
        return "LastVoteViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        loadVote(vote)
    }
    
    func setupView() {
        self.redButton.wantsLayer = true
        self.yellowButton.wantsLayer = true
        self.grennButton.wantsLayer = true
        
        self.redButton.layer?.backgroundColor = _RED_COLOR.CGColor
        self.yellowButton.layer?.backgroundColor = _YELLOW_COLOR.CGColor
        self.grennButton.layer?.backgroundColor = _GREEN_COLOR.CGColor
    }

    func loadVote(vote: VoteModel) {
        self.authorName.stringValue = vote.owner!
        self.voteName.string = vote.name
    }
}
