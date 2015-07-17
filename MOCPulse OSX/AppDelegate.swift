//
//  AppDelegate.swift
//  MOCPulse OSX
//
//  Created by admin on 17.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var socket : TcpSocket?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.socket = TcpSocket()
        
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

