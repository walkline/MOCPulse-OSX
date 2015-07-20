//
//  NotificationsMgr.swift
//  MOCPulse OSX
//
//  Created by admin on 20.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Cocoa

class NotificationsMgr: NSObject {
    
    static var sharedInstance = NotificationsMgr()
    
    override init() {
        super.init()
    }
    
    func notifyNewVote(vote: VoteModel) {
        var nc = NSUserNotificationCenter.defaultUserNotificationCenter()
        var note = NSUserNotification()
        note.title = "New vote"
        note.subtitle = vote.owner
        note.informativeText = vote.name
        nc.deliverNotification(note)
    }
}
