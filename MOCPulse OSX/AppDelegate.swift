//
//  AppDelegate.swift
//  MOCPulse OSX
//
//  Created by admin on 17.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Cocoa

let host = "pulse.masterofcode.com"
let port = 4242

var mainWindow : NSWindowController?

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        NSAppleEventManager.sharedAppleEventManager().setEventHandler(
            self,
            andSelector: "handleURLEvent:withReply:",
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notify:", name:"newpacket", object: nil)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func handleURLEvent(event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
        if let urlString = event.paramDescriptorForKeyword(AEKeyword(keyDirectObject))?.stringValue {
            NSApplication.sharedApplication().activateIgnoringOtherApps(true)
            if let url = NSURL(string: urlString) {
                println(url)
                if (url.scheme == "mocpulse") {
                    self.handleWidgetsOpenUrl(url)
                } else {
                    OAuthLoader.sharedInstance.handleRedirectURL(url)
                }
            }
        }
        else {
            NSLog("No valid URL to handle")
        }
    }
    
    func handleWidgetsOpenUrl(url: NSURL)
    {
        var host = url.host
        
        switch url.host! {
        case "openvote":
            var param : [AnyObject] = url.pathComponents!
            var voteId: String = param[1] as! String
            
            NSNotificationCenter.defaultCenter().postNotificationName("NOTIFICATION_SHOW_VIEW", object: nil, userInfo: ["voteId":voteId])
            
        case "vote":
            var param : [AnyObject] = url.pathComponents!
            var strcolor: String = param[1] as! String
            var voteId: String = param[2] as! String
            
            var color : VoteColor = VoteColor.VOTE_COLOR_GREEN
            
            switch strcolor {
            case "green": color = VoteColor.VOTE_COLOR_GREEN
            case "yellow": color = VoteColor.VOTE_COLOR_YELLOW
            case "red": color = VoteColor.VOTE_COLOR_RED
            default : break
            }
            
            // need auth check?
            VoteModel.voteFor(id: voteId, color: color, completion: { (vote) -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName("NOTIFICATION_SHOW_VIEW", object: nil, userInfo: ["voteId":voteId])
            })
            
        default: break
            //println("Unknown url for scheme ", &action)
        }
    }
    
    func notify(notification: NSNotification){
        var packet = notification.object as! PulsePacket
        
        println(packet)
        
        //Take Action on Notification
    }
}

