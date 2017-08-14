//
//  ViewController.swift
//  iPhoneClient
//
//  Created by Lara Orlandic on 6/6/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, dataDelegate, Rotation {

    override func viewDidLoad() {
        super.viewDidLoad()
        connection.connect() //connect socket
        connection.sendDelegate = self //lets the connection send data to the view controller
        appDelegate.delegate = self //enables view controller to run functions when device rotates
        
        loadingView.transform = CGAffineTransform(scaleX: 2, y: 2)
        loadingView.isHidden = true
        
        enableEVPNButton.isEnabled = false
        enableVTEPButton.isEnabled = false
        exitButton.isEnabled = false
        
        
        if numberOfSpines > 0 {
            generateSpineImages(spines: numberOfSpines) //create spine objects and display them
        }
        if numberOfLeaves > 0 {
            generateLeafImages(leaves: numberOfLeaves) //create leaf objects and display them
        }
        
        print("You created \(spineImages.count) spine images and \(leafImages.count) leaf images")
        
        drawLines() //draw lines between spine and leaf images
        
        showIPs()
        
        //order the views one on top of each other to avoid buttons being unclickable
        view.insertSubview(enableEBGPButton, aboveSubview: spineImages[spineImages.count - 1])
        view.insertSubview(backButton, aboveSubview: enableEBGPButton)
        view.insertSubview(exitButton, aboveSubview: backButton)
        view.insertSubview(enableEVPNButton, aboveSubview: exitButton)
        view.insertSubview(enableVTEPButton, aboveSubview: enableEVPNButton)
        
        allButtons.append(enableEVPNButton)
        allButtons.append(enableVTEPButton)
        allButtons.append(enableEBGPButton)
        allButtons.append(backButton)
        allButtons.append(exitButton)
        
        if UIScreen.main.bounds.size.width < 700 {
            for button in allButtons {
                button.titleLabel!.font = UIFont(name: "Times New Roman", size: 20)
            }
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that canvar recreated.
    }
    
    //MARK: Objects
    
    //App delegate, which runs functions when the app closes, rotates the screen, etc
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //Arrays of spine and leaf images, and the lines connecting them
    var spineImages: [SwitchImage] = []
    var leafImages: [SwitchImage] = []
    var lines: [LineView] = []
    var evpnLines: [LineView] = []
    var allButtons: [UIButton] = []
    
    //Outlets to the buttons
    @IBOutlet weak var enableEBGPButton: UIButton!

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    @IBOutlet weak var enableEVPNButton: UIButton!
    
    @IBOutlet weak var enableVTEPButton: UIButton!
    
    
    //MARK: Variables and Constants
    
    let connection = Connection() //set up instance of iPad-Python server connection object
    let imageHeightToWidthRatio: Double = 320/613 //height to width ratio of switch images
    
    
    //MARK: Functions
    
    //Function is called to draw lines between every spine and every leaf
    func drawLines() {
        for spine in spineImages {
            for leaf in leafImages {
                let line = LineView(frame: view.frame)
                line.setEndpoints(start: spine.center, end: leaf.center)
                view.insertSubview(line, belowSubview: spine)
                lines.append(line)
            }
        }
    }
    
    //Function executed by connection object every time iPad receives data from Python
    func send(str: String) {
        
        let enabledSwitches = processInputString(str: str)
        let allSwitches = leafImages + spineImages
        
        for number in enabledSwitches {
            allSwitches[number - 1].status = .Enabled
        }
    }
    
    //Manage Python --> iPad communication (command parsing)
    func processInputString(str: String) -> [Int] {
        let commandVec = str.components(separatedBy: "\n")
        var switchNumbers: [Int] = []
        for command in commandVec {
            let split = command.components(separatedBy: ":")
            if split[0] == "VM" { //collect the numbers of switches and leaves that have been successfully enabled
                let vm = split[1]
                if let vmNumber = Int(vm) {
                    switchNumbers.append(vmNumber)
                }
            } else if split[0] == "done" { //If the VMs have been spun up, reenable the exit button
                exitButton.isEnabled = true
                stopLoading()
                enableEVPNButton.isEnabled = true
            } else if split[0] == "eVPNdone" {
                stopLoading()
                enableVTEPButton.isEnabled = true
                exitButton.isEnabled = true
                
            } else if split[0] == "VTEPdone" {
                drawEVPNLines()
                exitButton.isEnabled = true
                stopLoading()
            } else if split[0] == "deleted" {
                backButton.isEnabled = true
                enableEBGPButton.isEnabled = false
                enableEVPNButton.isEnabled = false
                enableVTEPButton.isEnabled = false
                exitButton.isEnabled = false
            }
        }

        return switchNumbers //return which switch numbers should be enabled
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
        for i in 1...numberOfSpines {
            
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            
            let imageName = "leafSwitchPNG.png"
            let image = UIImage(named: imageName)
            let imageView = SwitchImage(image: image!)
            imageView.tag = numberOfLeaves + i
            spineImages.append(imageView)
            
            let sections = (numberOfSpines*2 + 1)*2
            let sectionWidth = Int(Double(screenWidth)/Double(sections))
            let imageWidth = sectionWidth*3
            
            let imageXPos = Int(Double(1 + 4*(i-1))*Double(sectionWidth))
            imageView.frame = CGRect(x: imageXPos, y: Int(Double(screenHeight)/3) - 50, width: imageWidth, height: Int(Double(imageWidth)*imageHeightToWidthRatio))
            view.addSubview(imageView)
            
            
        }
    }
    
    func generateLeafImages(leaves: Int) {
        
        for i in 1...numberOfLeaves {
            
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            
            let imageName = "leafSwitchPNG.png"
            let image = UIImage(named: imageName)
            let imageView = SwitchImage(image: image!)
            imageView.tag = i
            leafImages.append(imageView)
            
            let sections = (numberOfLeaves*2 + 1)*2
            let sectionWidth = Int(Double(screenWidth)/Double(sections))
            let imageWidth = sectionWidth*3
            
            let imageXPos = Int(Double(1 + 4*(i-1))*Double(sectionWidth))
            imageView.frame = CGRect(x: imageXPos, y: Int(2*Double(screenHeight)/3) - 50, width: imageWidth, height: Int(Double(imageWidth)*imageHeightToWidthRatio))
            view.addSubview(imageView)
            
            
        }
        
    }
    
    func resizeSpineWhenRotate(){
        var counter: Int = 0
        for spine in spineImages {
            counter = counter + 1
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            
            let sections = (numberOfSpines*2 + 1)*2
            let sectionWidth = Int(Double(screenHeight)/Double(sections))
            let imageWidth = sectionWidth*3
            
            let imageXPos = Int(Double(1 + 4*(counter-1))*Double(sectionWidth))
            spine.frame = CGRect(x: imageXPos, y: Int(Double(screenWidth)/3) - 50, width: imageWidth, height: Int(Double(imageWidth)*imageHeightToWidthRatio))
            
        }
    }
    
    func resizeLeafWhenRotate(){
        var counter: Int = 0
        for leaf in leafImages {
            counter = counter + 1
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            
            let sections = (numberOfLeaves*2 + 1)*2
            let sectionWidth = Int(Double(screenHeight)/Double(sections))
            let imageWidth = sectionWidth*3
            
            let imageXPos = Int(Double(1 + 4*(counter-1))*Double(sectionWidth))
            leaf.frame = CGRect(x: imageXPos, y: Int(2*Double(screenWidth)/3) - 50, width: imageWidth, height: Int(Double(imageWidth)*imageHeightToWidthRatio))
        }
    }
    
    func redrawLinesWhenRotate() {
        for line in lines {
            line.removeFromSuperview()
        }
        for line in evpnLines {
            line.removeFromSuperview()
        }
        drawLines()
        drawEVPNLines()
    }
    
    func showIPs() {
        for spine in spineImages {
            let IP = "10.10.139." + String(spine.tag)
            spine.IPAddress = IP
            let IPHeight = spine.center.y - spine.frame.height - CGFloat(numberOfSpines - 2)*15
            let label: UILabel = UILabel(frame: CGRect(x: spine.center.x, y: IPHeight, width: 200, height: 100))
            label.text = IP
            view.insertSubview(label, aboveSubview: spine)
        }
        for leaf in leafImages {
            let IP = "10.10.139." + String(leaf.tag)
            leaf.IPAddress = IP
            let IPHeight = numberOfLeaves==1 ? leaf.center.y + 30 : leaf.center.y - CGFloat(numberOfLeaves*2)
            let label: UILabel = UILabel(frame: CGRect(x: leaf.center.x, y: IPHeight, width: 200, height: 100))
            label.text = IP
            view.insertSubview(label, aboveSubview: leaf)
        }
    }
    
    func drawEVPNLines() {
        if leafImages.count > 1 {
            let line: LineView = LineView(frame: view.frame)
            line.setEndpoints(start: leafImages[0].center, end: leafImages[1].center)
            let line2: LineView = LineView(frame: view.frame)
            line2.setEndpoints(start: CGPoint(x: leafImages[0].center.x, y: leafImages[1].center.y - 10), end: CGPoint(x: leafImages[1].center.x, y: leafImages[1].center.y - 10))
            view.insertSubview(line, belowSubview: spineImages[0])
            view.insertSubview(line2, belowSubview: spineImages[0])
            evpnLines.append(line)
            evpnLines.append(line2)
        }
    }


    //MARK: Actions that define what happens when you press a button on the iPad screen
    
    
    
    //enable eBGP
    @IBAction func sendMessage(_ sender: UIButton) {
        
        print("Button pressed")
        sendMessageToPython(str: "spineLeaf:\(numberOfSpines):\(numberOfLeaves)\n")
        startLoading()
        
    }
    //Disconnect from socket when disconnected
    @IBAction func backButtonPress(_ sender: Any) {
        sendMessageToPython(str: "disconnect:\n")
    }
    
    //Exit the app and close the VMs
    @IBAction func ExitButtonPress(_ sender: Any) {
        sendMessageToPython(str: "delete:\n")
        let allSwitches = spineImages + leafImages
        for s in allSwitches {
            s.status = .Disabled
        }
        for line in evpnLines {
            line.removeFromSuperview()
        }
    }
    
    
    @IBAction func enableEVPN(_ sender: Any) {
        sendMessageToPython(str: "eVPN:\n")
        startLoading()
    }
    
    @IBAction func enableVTEP(_ sender: Any) {
        sendMessageToPython(str: "VTEP:\n")
        startLoading()
    }
    
    func startLoading() {
        loadingView.isHidden = false
        loadingView.startAnimating()
        for button in allButtons {
            button.isEnabled = false
        }
    }
    
    func stopLoading() {
        loadingView.isHidden = true
        loadingView.stopAnimating()
    }
    
}

