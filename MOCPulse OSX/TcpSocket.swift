//
//  TcpSocket.swift
//  MOCPulse OSX
//
//  Created by admin on 17.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Foundation

class TcpSocket: NSObject, NSStreamDelegate {
    var input : NSInputStream?
    var output: NSOutputStream?
    
    override init() {
        super.init()

        let host = "127.0.0.1"
        let port = 4242
        NSStream.getStreamsToHostWithName(host, port: port, inputStream: &(self.input), outputStream: &(self.output))
        
        self.input!.delegate  = self
        self.output!.delegate = self
        
        self.input!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.output!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        self.input!.open()
        self.output!.open()
    }
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        switch(eventCode) {
        case NSStreamEvent.EndEncountered :
            println("EndEncountered")
        case NSStreamEvent.ErrorOccurred:
            println("ErrorOccurred")
        case NSStreamEvent.HasSpaceAvailable:
            println("HasSpaceAvailable")
        case NSStreamEvent.HasBytesAvailable:
            let buf = NSMutableData(capacity: 6)
            var buffer = UnsafeMutablePointer<UInt8>(buf!.bytes)
            let length = self.input!.read(buffer, maxLength: 6)
            var data = Array(UnsafeBufferPointer(start: buffer, count: length))
            println("read")
            println(length)
            println("\(data)")
        default:
            println("unk event")
        }
    }
}
