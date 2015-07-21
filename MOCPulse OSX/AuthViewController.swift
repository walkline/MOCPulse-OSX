//
//  AuthViewController.swift
//  MOCPulse OSX
//
//  Created by admin on 21.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Cocoa

class AuthViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didAuth:", name:"didAuth", object: nil)
    }
    
    func didAuth(n: NSNotification) {
        var window : NSWindowController = NSStoryboard(name: "Main", bundle: nil)!.instantiateControllerWithIdentifier("MainWindow")! as! NSWindowController
        mainWindow = window
        mainWindow!.showWindow(self)
        self.view.window?.close()
    }
    
    @IBAction func signInPressed(sender: AnyObject) {
        OAuthLoader.sharedInstance.authorize() { didFail, error in
        }
    }
}
