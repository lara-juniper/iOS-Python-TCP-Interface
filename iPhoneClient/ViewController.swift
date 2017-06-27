//
//  ViewController.swift
//  iPhoneClient
//
//  Created by Lara Orlandic on 6/6/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, dataDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        connection.connect() //connect socket
        //let str: String = "Start" //this is the message that will be sent to the Python server at the button press
        //arrayToServer = Array(str.utf8) //convert string to utf8
        connection.sendDelegate = self
        //sendMessageToPython(str: "Start")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that canvar recreated.
    }
    
    //MARK: Objects
    
    @IBOutlet weak var leafSwitch1: SwitchImage!
    
    
    //MARK: Variables
    
    let connection = Connection() //set up instance of iPad-Python server connection object
    
    
    //MARK: Functions
    
    func send(str: String) {
        if str == "Hello!" {
            leafSwitch1.status = .Enabled
        }
    }
    
    func sendMessageToPython(str: String) {
        var arrayToServer: [UInt8] = [] //initialize array to be sent to server
        arrayToServer = Array(str.utf8)
        if connection.outputStream.hasSpaceAvailable { //If there is space available on the output stream (i.e. you're not sending too much data at once)
            let bytes = connection.outputStream.write(&arrayToServer, maxLength: arrayToServer.count) //write message to output stream
            print("\(bytes) bytes were sent to Python") //print how many bytes of data were sent
        } else { //error if you're trying to send too much data
            print("Error: no space available for writing")
        }
    }
    

    //MARK: Actions
    
    //Send message from iPad to Python server using button press. Function called at each button press
    @IBAction func sendMessage(_ sender: UIButton) {
        
        print("Button pressed")
        sendMessageToPython(str: "Start")
        sleep(1)
        sendMessageToPython(str: "Spines: \(numberOfSpines)")
        sleep(1)
        sendMessageToPython(str: "Leaves: \(numberOfLeaves)")
        
    }

}

