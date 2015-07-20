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
        println("im loaded too")
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {

        var votes : [VoteModel]? = LocalObjectsManager.sharedInstance.votes
        if (votes == nil) {
            return 0
        }
        
        return votes!.count
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
    
}
