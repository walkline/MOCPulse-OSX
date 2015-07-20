//
//  CreateVoteViewController.swift
//  MOCPulse OSX
//
//  Created by admin on 20.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Cocoa

class CreateVoteViewController: NSViewController {

    
    @IBOutlet weak var authorField: NSTextField!
    @IBOutlet var nameField: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authorField.stringValue = TcpSocket.sharedInstance.session!.userId
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.view.window!.close()
    }
    
    @IBAction func createButtonPressed(sender: AnyObject) {
        TcpSocket.sharedInstance.session!.createVote(nameField.string!)
        self.view.window!.close()
    }

}
