//
//  VotesListViewController.swift
//  MOCPulse OSX
//
//  Created by admin on 20.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Cocoa
import NotificationCenter


class VotesListViewController: NSViewController, NCWidgetProviding, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var tableView: NSTableView!

    override var nibName: String? {
        return "VotesListViewController"
    }
    
    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {

        var votes : [VoteModel]? = LocalObjectsManager.sharedInstance.votes
        if (votes == nil) {
            return 0
        }
        
        return votes!.count
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var arr : NSArray? = NSArray()
        NSBundle.mainBundle().loadNibNamed("VoteCellView", owner: self, topLevelObjects:&arr)
        var cell : TodayVoteCellView!
        for v in arr! {
            if (v as? TodayVoteCellView != nil) {
                cell = v as! TodayVoteCellView
            }
        }

        var vote : VoteModel = LocalObjectsManager.sharedInstance.votes![row]
        cell.setupWithVote(vote)
        
        return cell
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        var row = self.tableView.selectedRow
        
        if (row < 0) {
            return
        }
        
        self.tableView.deselectRow(row)
        
        let url:NSURL = NSURL(string:  NSString(format: "mocpulse://openvote/%@", LocalObjectsManager.sharedInstance.votes![row].id!) as String)!
        NSWorkspace.sharedWorkspace().openURL(url)
    }
}
