//
//  ConfigurationViewController.swift
//  iPhoneClient
//
//  Created by Lara Orlandic on 6/23/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//
var numberOfSpines: Int = 0
var numberOfLeaves: Int = 0

import Foundation
import UIKit

class ConfigurationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
   
    
    //MARK: Outlets

    @IBOutlet weak var spinePicker: UIPickerView!

    
    //MARK: Variables
    let tableHeaders: [String] = ["Select Number of Spines", "Select Number of Leaves"]
    let spineNumbers: [Int] = Array(1...5)
    let delegate: SendConfig? = nil

    
    //MARK: Main app functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.spinePicker.delegate = self
        self.spinePicker.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: Picker View Data Source and delegate functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return spineNumbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return String(spineNumbers[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            numberOfSpines = row + 1
            print("You selected \(numberOfSpines) spines.")
        case 1:
            numberOfLeaves = row + 1
            print("You selected \(numberOfLeaves) leaves.")
        default:
            break
        }
    }
    
}

protocol SendConfig {
    func sendSpineNumber(n: Int)
    func sendLeafNumber(n: Int)
}





