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

//        self.up
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        
        println("try load")
        VoteModel.votes(completion: { (arr: [VoteModel]?) -> Void in
            println("loaded")
            if arr?.count < 0 {
                return
            }
            
            LocalObjectsManager.sharedInstance.votes = arr
            LocalObjectsManager.sharedInstance.sortVotesByDate()
            
            var vc = VotesListViewController(nibName: "VotesListViewController", bundle: NSBundle(forClass: self.classForCoder))
            //self.view.addSubview(vc!.view)
            self.presentViewControllerInWidget(vc)
            println("end")

        })

        println("did load")
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        
        println("widgetPerformUpdateWithCompletionHandler")
        
        completionHandler(.NoData)
        

    }

}
