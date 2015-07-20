//
//  AppDelegate.swift
//  MOCPulse OSX
//
//  Created by admin on 17.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Cocoa

let host = "192.168.4.56"
let port = 4242

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        OAuthLoader.sharedInstance.authorize() { didFail, error in
        }
            //self.didAuthorize(didFail, error: error)
        TcpSocket.sharedInstance.connect(host, port: port)

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
        println("handleURLEvent")
        if let urlString = event.paramDescriptorForKeyword(AEKeyword(keyDirectObject))?.stringValue {
            if let url = NSURL(string: urlString) {
                println("oooook")
                println(url)
                OAuthLoader.sharedInstance.handleRedirectURL(url)
                //RedditLoader.handleRedirectURL(url)
            }
        }
        else {
            NSLog("No valid URL to handle")
        }
    }
    
    func notify(notification: NSNotification){
        var packet = notification.object as! PulsePacket
        
        println(packet)
        
        //Take Action on Notification
    }
}

