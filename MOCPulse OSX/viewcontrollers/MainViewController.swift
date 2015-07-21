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
let BLUE_COLOR = NSColor(calibratedRed: 57/255, green: 123/255, blue: 250/255, alpha: 1)

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
    
    @IBOutlet weak var topLeftBar: NSView!
    
    @IBOutlet weak var votedTab: NSButton!
    var vote : VoteModel?
    @IBOutlet weak var pendingTab: NSButton!
    
    var pulseEffect : PulseAnimation!
    
    var isTabPending : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isTabPending = true
        
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
        self.redButton.backgroundColor = RED_COLOR
        self.yellowButton.backgroundColor = YELLOW_COLOR
        self.greenButton.backgroundColor = GREEN_COLOR
        
        self.topLeftBar.wantsLayer = true
        self.topLeftBar.layer?.borderWidth = 1
        self.topLeftBar.layer?.borderColor = NSColor(calibratedRed: 200/255, green: 200/255, blue: 200/255, alpha: 1).CGColor
        
        var center = CGPointMake((animationView.bounds.origin.x + (animationView.bounds.size.width / 2)), (animationView.bounds.size.height / 2))
        
        var screenRect : CGRect = NSScreen.mainScreen()!.frame
        pulseEffect = PulseAnimation(radius: animationView.frame.size.height, position: center)
        
        setButtonColor(self.pendingTab, color: BLUE_COLOR)
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
        var votes : [VoteModel]? = tableArray() as! [VoteModel]
        if (votes == nil) {
            return 0
        }
        
        return votes!.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cell = tableView.makeViewWithIdentifier("Cell", owner: self) as! VoteCellView
        
        var vote: VoteModel = tableArray()[row] as! VoteModel
        
        cell.voteName.stringValue = vote.name!
        cell.authorField.stringValue = vote.owner!
        
        return cell
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        if (self.tableView.selectedRow < 0) {
            return
        }
        
        var votes : [VoteModel]? = tableArray() as? [VoteModel]
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

        voteFor(vote!, color: VoteColor.VOTE_COLOR_RED.rawValue)
    }
    
    @IBAction func greenButtonPressed(sender: AnyObject) {
        if (vote == nil) {
            return
        }
        
        showPulseAnimation(GREEN_COLOR)
        
        voteFor(vote!, color: VoteColor.VOTE_COLOR_GREEN.rawValue)
    }
    
    @IBAction func yellowButtonPressed(sender: AnyObject) {
        if (vote == nil) {
            return
        }
        
        showPulseAnimation(YELLOW_COLOR)
        
        voteFor(vote!, color: VoteColor.VOTE_COLOR_YELLOW.rawValue)
    }
    
    func voteFor(vote: VoteModel, color: Int) {
        vote.voted = true
        TcpSocket.sharedInstance.session?.voteFor(vote.id!, colorId: color)
        self.tableView.reloadData()
    }
    
    func tableArray() -> NSArray {
        var votes = LocalObjectsManager.sharedInstance.votes
        
        if votes != nil {
            var votesArray = votes?.filter{(vote:VoteModel) in vote.voted != self.isTabPending}
            var arrayToSort = NSArray(array: votesArray!)
            
            var descriptor: NSSortDescriptor = NSSortDescriptor(key: "create", ascending: false)
            
            var arraySorted: NSArray = arrayToSort.sortedArrayUsingDescriptors([descriptor])
            
            return arraySorted
        }
        return NSArray()
    }
    
    func setButtonColor(button: NSButton, color: NSColor) {
        var colorTitle = NSMutableAttributedString(attributedString: button.attributedTitle)
        var titleRange = NSMakeRange(0, colorTitle.length)
        colorTitle.addAttribute(NSForegroundColorAttributeName, value: color, range: titleRange)
        button.attributedTitle = colorTitle
    }
    
    @IBAction func onVotedPressed(sender: AnyObject) {
        self.isTabPending = false
        
        setButtonColor(self.votedTab, color: BLUE_COLOR)
        setButtonColor(self.pendingTab, color: NSColor.blackColor())
        
        self.tableView.reloadData()
    }

    @IBAction func onPendingPressed(sender: AnyObject) {
        self.isTabPending = true
        
        setButtonColor(self.pendingTab, color: BLUE_COLOR)
        setButtonColor(self.votedTab, color: NSColor.blackColor())
        
        self.tableView.reloadData()
    }
    
}
