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
        connection.sendDelegate = self //lets the connection send data to the view controller
        
        generateSpineImages(spines: numberOfSpines)
        generateLeafImages(leaves: numberOfLeaves)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that canvar recreated.
    }
    
    //MARK: Objects
    
    //@IBOutlet weak var leafSwitch1: SwitchImage!
    
    
    //MARK: Variables and Constants
    
    let connection = Connection() //set up instance of iPad-Python server connection object
    let imageHeightToWidthRatio: Double = 320/613
    
    
    //MARK: Functions
    
    //Function that is called by connection object whenever the socket receives data from Python to iPad
    func send(str: String) {
        if str == "Hello!" {
            //leafSwitch1.status = .Enabled
        }
    }
    
    //function to send strings from iPad --> Python
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
    
    func generateSpineImages(spines: Int){
        for var i: Int in 1...numberOfSpines {
            
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            
            let imageName = "leafSwitchPNG.png"
            let image = UIImage(named: imageName)
            let imageView = SwitchImage(image: image!)
            imageView.tag = i
            
            let sections = (numberOfSpines*2 + 1)*2
            let sectionWidth = Int(Double(screenWidth)/Double(sections))
            let imageWidth = sectionWidth*3
            
            let imageXPos = Int(Double(1 + 4*(i-1))*Double(sectionWidth))
            imageView.frame = CGRect(x: imageXPos, y: Int(Double(screenHeight)/3), width: imageWidth, height: Int(Double(imageWidth)*imageHeightToWidthRatio))
            view.addSubview(imageView)
            
            
        }
    }
    
    func generateLeafImages(leaves: Int) {
        
        for var i: Int in 1...numberOfLeaves {
            
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            
            let imageName = "leafSwitchPNG.png"
            let image = UIImage(named: imageName)
            let imageView = SwitchImage(image: image!)
            imageView.tag = numberOfSpines + i
            
            let sections = (numberOfLeaves*2 + 1)*2
            let sectionWidth = Int(Double(screenWidth)/Double(sections))
            let imageWidth = sectionWidth*3
            
            let imageXPos = Int(Double(1 + 4*(i-1))*Double(sectionWidth))
            imageView.frame = CGRect(x: imageXPos, y: Int(2*Double(screenHeight)/3), width: imageWidth, height: Int(Double(imageWidth)*imageHeightToWidthRatio))
            view.addSubview(imageView)
            
            
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

