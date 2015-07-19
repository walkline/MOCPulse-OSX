//
//  MainViewController.swift
//  MOCPulse OSX
//
//  Created by Admin on 19.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Cocoa

let RED_COLOR = NSColor(calibratedRed: 221/255, green: 42/255, blue: 61/255, alpha: 1)
let YELLOW_COLOR = NSColor(calibratedRed: 252/255, green: 210/255, blue: 56/255, alpha: 1)
let GREEN_COLOR = NSColor(calibratedRed: 130/255, green: 177/255, blue: 17/255, alpha: 1)

class MainViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var detailVoteView: NSView!
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var authorName: NSTextField!
    @IBOutlet var questionField: NSTextView!
    @IBOutlet weak var chartView: ChartView!
    
    @IBOutlet weak var redButton: NSButtonCell!
    @IBOutlet weak var greenButton: NSButtonCell!
    @IBOutlet weak var yellowButton: NSButtonCell!
    
    @IBOutlet weak var redCounter: NSTextField!
    @IBOutlet weak var yellowCounter: NSTextField!
    @IBOutlet weak var greenCounter: NSTextField!
    
    @IBOutlet weak var buttonsHolder: NSView!
    
    @IBOutlet weak var animationView: NSView!
    
    var vote : VoteModel?
    
    var pulseEffect : PulseAnimation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTable:", name:"reloadVotes", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateVote:", name:"voteUpdated", object: nil)

        setupView()
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func setupView() {
        self.redButton.backgroundColor = NSColor(calibratedRed: 221/255, green: 42/255, blue: 61/255, alpha: 1)
        self.yellowButton.backgroundColor = NSColor(calibratedRed: 252/255, green: 210/255, blue: 56/255, alpha: 1)
        self.greenButton.backgroundColor = NSColor(calibratedRed: 130/255, green: 177/255, blue: 17/255, alpha: 1)
        
        var center = CGPointMake((animationView.bounds.origin.x + (animationView.bounds.size.width / 2)), (animationView.bounds.size.height / 2))
        
        var screenRect : CGRect = NSScreen.mainScreen()!.frame
        pulseEffect = PulseAnimation(radius: animationView.frame.size.height, position: center)
    }
    
    func showPulseAnimation(color : NSColor) {
        if (pulseEffect.superlayer == nil) {
            animationView.layer!.insertSublayer(pulseEffect, below: animationView.layer!)
        }
        
        var center = CGPointMake((animationView.bounds.origin.x + (animationView.bounds.size.width / 2)), (animationView.bounds.size.height / 2))
        pulseEffect.position = center
        pulseEffect.radius = animationView.frame.size.height
        
        pulseEffect.backgroundColor = color.CGColor
        pulseEffect.addAnimation(pulseEffect.animationGroup, forKey: "pulse")
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        var votes : [VoteModel]? = LocalObjectsManager.sharedInstance.votes
        if (votes == nil) {
            return 0
        }
        
        return votes!.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cell = tableView.makeViewWithIdentifier("Cell", owner: self) as! VoteCellView
        cell.voteName.stringValue = LocalObjectsManager.sharedInstance.votes![row].name!
        cell.authorField.stringValue = LocalObjectsManager.sharedInstance.votes![row].owner!
        return cell
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        if (self.tableView.selectedRow < 0) {
            return
        }
        
        var votes : [VoteModel]? = LocalObjectsManager.sharedInstance.votes
        if (votes != nil) {
            showVote(votes![self.tableView.selectedRow])
        }
    }
    
    func updateTable(n: NSNotification) {
        self.tableView.reloadData()
        self.tableView.selectRowIndexes(NSIndexSet(index: 0), byExtendingSelection: true)
    }
    
    func updateVote(n: NSNotification) {
        var newVote = n.object as! VoteModel
        if (newVote.id == self.vote?.id) {
            self.showVote(newVote)
        }
    }
    
    func showVote(vote: VoteModel) {
        self.vote = vote
        self.authorName.stringValue = vote.owner!
        self.questionField.string = vote.name
        
        self.greenCounter.stringValue = NSString(format: "G: %d", vote.greenVotes) as String
        self.redCounter.stringValue = NSString(format: "R: %d", vote.redVotes) as String
        self.yellowCounter.stringValue = NSString(format: "Y: %d", vote.yellowVotes) as String
        
        var vArr : [CGFloat] = [CGFloat]()
        var cArr : [NSColor] = [NSColor]()
        
        if (vote.redVotes > 0) {
            vArr += [CGFloat(vote.redVotes)]
            cArr += [RED_COLOR]
        }
        
        if (vote.yellowVotes > 0) {
            vArr += [CGFloat(vote.yellowVotes)]
            cArr += [YELLOW_COLOR]
        }
        
        if (vote.greenVotes > 0) {
            vArr += [CGFloat(vote.greenVotes)]
            cArr += [GREEN_COLOR]
        }
        
        if (vArr.count <= 0) {
            vArr = [CGFloat(1), CGFloat(1), CGFloat(1)]
            cArr = [RED_COLOR, YELLOW_COLOR, GREEN_COLOR]
        }
        
        chartView.valuesArray = vArr
        chartView.colorsArray = cArr
        
        chartView.radius = 50
        chartView.update()
        
        self.buttonsHolder.hidden = vote.voted == true

    }
    
    @IBAction func redButtonPressed(sender: AnyObject) {
        if (vote == nil) {
            return
        }
        
        showPulseAnimation(RED_COLOR)
        
        vote?.voted = true
        
        TcpSocket.sharedInstance.session?.voteFor(vote!.id!, colorId: VoteColor.VOTE_COLOR_RED.rawValue)
    }
    
    @IBAction func greenButtonPressed(sender: AnyObject) {
        if (vote == nil) {
            return
        }
        
        showPulseAnimation(GREEN_COLOR)
        
        vote?.voted = true
        
        TcpSocket.sharedInstance.session?.voteFor(vote!.id!, colorId: VoteColor.VOTE_COLOR_GREEN.rawValue)
    }
    
    @IBAction func yellowButtonPressed(sender: AnyObject) {
        if (vote == nil) {
            return
        }
        
        showPulseAnimation(YELLOW_COLOR)
        
        vote?.voted = true
        
        TcpSocket.sharedInstance.session?.voteFor(vote!.id!, colorId: VoteColor.VOTE_COLOR_YELLOW.rawValue)
    }
}
