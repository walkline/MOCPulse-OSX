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
    
    @IBOutlet weak var redButton: NSButtonCell!
    @IBOutlet weak var greenButton: NSButtonCell!
    @IBOutlet weak var yellowButton: NSButtonCell!
    
    @IBOutlet weak var buttonsHolder: NSView!
    
    @IBOutlet weak var animationView: NSView!
    
    @IBOutlet weak var topLeftBar: NSView!
    
    @IBOutlet weak var votedTab: NSButton!
    var vote : VoteModel?
    @IBOutlet weak var pendingTab: NSButton!
    
    @IBOutlet weak var colorChart: ColorChart!
    
    var pulseEffect : PulseAnimation!
    
    var isTabPending : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTable:", name:"reloadVotes", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateVote:", name:"voteUpdated", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleLoadNotification:"), name: "NOTIFICATION_SHOW_VIEW", object: nil)

        setupView()
        setupTabs()
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
        
//        var center = CGPointMake((animationView.bounds.origin.x + (animationView.bounds.size.width / 2)), (animationView.bounds.size.height / 2))
//        
//        var screenRect : CGRect = NSScreen.mainScreen()!.frame
//        pulseEffect = PulseAnimation(radius: animationView.frame.size.height, position: center)
        
        setButtonColor(self.pendingTab, color: BLUE_COLOR)
    }
    
    func setupTabs() {
        setButtonColor(self.pendingTab, color: BLUE_COLOR)
        self.isTabPending = true
        if (tableArray().count == 0) {
            self.isTabPending = false
            setButtonColor(self.pendingTab, color: NSColor.blackColor())
            setButtonColor(self.votedTab, color: BLUE_COLOR)
        }
    }
    
    func showPulseAnimation(color : NSColor) {
//        if (pulseEffect.superlayer == nil) {
//            animationView.layer!.insertSublayer(pulseEffect, below: animationView.layer!)
//        }
//        
//        var center = CGPointMake((animationView.bounds.origin.x + (animationView.bounds.size.width / 2)), (animationView.bounds.size.height / 2))
//        pulseEffect.position = center
//        pulseEffect.radius = animationView.frame.size.height
//        
//        pulseEffect.backgroundColor = color.CGColor
//        pulseEffect.addAnimation(pulseEffect.animationGroup, forKey: "pulse")
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
        cell.authorField.stringValue = vote.displayOwnerName()
        
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
      
        println("showVote g:\(vote.greenVotes); y: \(vote.redVotes); r:\(vote.yellowVotes).")
        
        self.vote = vote
        self.authorName.stringValue = vote.displayOwnerName()
        self.questionField.string = vote.name
      
        var greenColor : ColorChartObject = colorChart.getGreenColor()
        greenColor.val = CGFloat(vote.greenVotes!)
        var yellowColor : ColorChartObject = colorChart.getYellowColor()
        yellowColor.val = CGFloat(vote.yellowVotes!)
        var redColor : ColorChartObject = colorChart.getRedColor()
        redColor.val = CGFloat(vote.redVotes!)
        
        colorChart.reloadChart()
        
        self.buttonsHolder.hidden = vote.voted == true
        self.colorChart.hidden = vote.voted == false
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
    
    func handleLoadNotification(notification: NSNotification) {
        var vote = (notification.userInfo as! [NSString:VoteModel])["vote"]
        if vote != nil {
            self.showVote(vote!)
        } else {
            var voteId = (notification.userInfo as! [NSString:NSString])["voteId"]
            if voteId != nil {
                var newVote = LocalObjectsManager.sharedInstance.getVoteById(voteId! as String)
                if (newVote != nil) {
                    self.showVote(newVote!)
                }
            }
        }
    }
}
