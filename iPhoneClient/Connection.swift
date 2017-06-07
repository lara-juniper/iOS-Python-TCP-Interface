//
//  Connection.swift
//  iPhoneClient
//
//  Created by Lara Orlandic on 6/6/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import Foundation

class Connection: NSObject, StreamDelegate {
    
    let serverAddress: CFString = "127.0.0.1" as CFString
    let serverPort: UInt32 = 80
    
    var inputStream: InputStream!
    var outputStream: OutputStream!
    var buffer = [UInt8](repeating: 0, count: 1024)
    
    func connect() {
        print("connecting...")
        
        var readStream:  Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(nil, self.serverAddress, self.serverPort, &readStream, &writeStream)
        
        // Documentation suggests readStream and writeStream can be assumed to
        // be non-nil. If you believe otherwise, you can test if either is nil
        // and implement whatever error-handling you wish.
        
        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()
        
        self.inputStream.delegate = self
        self.outputStream.delegate = self
        
        self.inputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        self.outputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        self.inputStream.open()
        self.outputStream.open()
    }
    
    func stream(_ stream: Stream, handle eventCode: Stream.Event) {
        print("stream event")
        
        if stream === inputStream {
            
            print("input")
            
            switch eventCode {
                
            case Stream.Event.openCompleted:
                print("input: openCompleted")
                break
                
            case Stream.Event.hasBytesAvailable:
                print("input: HasBytesAvailable")
                
                
                inputStream.read(&buffer, maxLength: buffer.count)
                while inputStream.hasBytesAvailable {
                    _ = inputStream.read(&buffer, maxLength: buffer.count)
                    let str = String(bytes: buffer, encoding: String.Encoding.utf8)
                    print(str ?? "oops")
                    
                }
                
            default:
                print("default")
            }
        }
        
        if stream == outputStream {
            
            print("output")
            
            switch eventCode {
                
            case Stream.Event.hasBytesAvailable:
                print("output: HasBytesAvailable")
                
            default:
                print("default")
                
            }
            
            
        }
        
    }
    
}
