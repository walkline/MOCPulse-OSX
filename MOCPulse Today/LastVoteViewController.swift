//
//  LastVoteViewController.swift
//  MOCPulse OSX
//
//  Created by admin on 21.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Cocoa
import NotificationCenter


let _RED_COLOR = NSColor(calibratedRed: 221/255, green: 42/255, blue: 61/255, alpha: 6.9)
let _YELLOW_COLOR = NSColor(calibratedRed: 252/255, green: 210/255, blue: 56/255, alpha: 6.9)
let _GREEN_COLOR = NSColor(calibratedRed: 130/255, green: 177/255, blue: 17/255, alpha: 6.9)
//

class LastVoteViewController: NSViewController, NCWidgetProviding  {

    @IBOutlet weak var authorName: NSTextField!
    @IBOutlet var voteName: NSTextView!
    
    @IBOutlet weak var redButton: ColoredButton!
    @IBOutlet weak var yellowButton: ColoredButton!
    @IBOutlet weak var grennButton: ColoredButton!

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
        redButton.color = NSColor.redColor()
        yellowButton.color = NSColor.yellowColor()
        grennButton.color = _GREEN_COLOR
    }

    func loadVote(vote: VoteModel) {
        self.authorName.stringValue = vote.owner!
        self.voteName.string = vote.name
    }
    
    @IBAction func onRedPressed(sender: AnyObject) {
        let url:NSURL = NSURL(string: NSString(format: "mocpulse://vote/red/%@", vote.id!) as String)!
        NSWorkspace.sharedWorkspace().openURL(url)
    }
    
    @IBAction func onGreenPressed(sender: AnyObject) {
        let url:NSURL = NSURL(string: NSString(format: "mocpulse://vote/green/%@", vote.id!) as String)!
        NSWorkspace.sharedWorkspace().openURL(url)
    }

    @IBAction func onYellowPressed(sender: AnyObject) {
        let url:NSURL = NSURL(string: NSString(format: "mocpulse://vote/yellow/%@", vote.id!) as String)!
        NSWorkspace.sharedWorkspace().openURL(url)
    }

}
