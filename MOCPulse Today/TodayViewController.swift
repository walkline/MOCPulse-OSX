//
//  TodayViewController.swift
//  MOCPulse Today
//
//  Created by admin on 20.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {

    override var nibName: String? {
        return "TodayViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        VoteModel.votes(completion: { (arr: [VoteModel]?) -> Void in
            if arr?.count < 0 {
                return
            }
            
            LocalObjectsManager.sharedInstance.votes = arr
            LocalObjectsManager.sharedInstance.sortVotesByDate()
            
            var lastUnVotedVote = LocalObjectsManager.sharedInstance.getLastVote()
            if lastUnVotedVote == nil {
                self.showVotesList()
                return
            }
               
            if (lastUnVotedVote?.voted == true) {
                self.showVotesList()
            } else {
                self.showLastVote(lastUnVotedVote!)
            }
        })
    }
    
    func showVotesList() {
        var vc = VotesListViewController(nibName: "VotesListViewController", bundle: NSBundle(forClass: self.classForCoder))
        self.presentViewControllerInWidget(vc)
    }
    
    func showLastVote(vote: VoteModel) {
        var vc = LastVoteViewController(nibName: "LastVoteViewController", bundle: NSBundle(forClass: self.classForCoder))
        vc?.vote = vote
        self.presentViewControllerInWidget(vc)
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(.NoData)
    }
}
