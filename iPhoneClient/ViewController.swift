//
//  ViewController.swift
//  iPhoneClient
//
//  Created by Lara Orlandic on 6/6/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        connection.connect()
        // Do any additional setup after loading the view, typically from a nib.
        let str: String = "Hello, Python!"
        array = Array(str.utf8)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Variables
    
    let connection = Connection()
    //let maxLength: Int = 65535
    var array: [UInt8] = []

    
    
    //MARK: Functions
    

    //MARK: Actions
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        print("Button pressed")
        let bytes = connection.outputStream.write(&array, maxLength: array.count)
        print("\(bytes) bytes were sent to Python")
        
    }

}

