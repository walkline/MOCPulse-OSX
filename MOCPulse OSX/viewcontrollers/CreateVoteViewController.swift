//
//  CreateVoteViewController.swift
//  MOCPulse OSX
//
//  Created by admin on 20.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Cocoa

class CreateVoteViewController: NSViewController, NSTextViewDelegate {

    
    @IBOutlet weak var authorField: NSTextField!
    @IBOutlet var nameField: NSTextView!
    @IBOutlet weak var charsLeft: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authorField.stringValue = TcpSocket.sharedInstance.session!.userId
        
        self.nameField.delegate = self
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.view.window!.close()
    }
    
    @IBAction func createButtonPressed(sender: AnyObject) {
        TcpSocket.sharedInstance.session!.createVote(nameField.string!)
        self.view.window!.close()
    }
    
    func textDidChange(notification: NSNotification) {
        calculateCharsLeft()
    }

    func calculateCharsLeft() {
        let maxChars = 140
        var charsLeft = maxChars - count(self.nameField.string!)
        
        var notEnoughChars : Bool = charsLeft < 0
        
        self.charsLeft.stringValue = "\(notEnoughChars ? 0 : charsLeft)"
        
        if (notEnoughChars) {
            var voteNameText : String = self.nameField.string!
            let stringLength = count(voteNameText)
            voteNameText = voteNameText.substringToIndex(advance(voteNameText.startIndex, maxChars))
            self.nameField.string = voteNameText
        }
    }
}
