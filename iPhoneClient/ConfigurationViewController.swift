//
//  ConfigurationViewController.swift
//  iPhoneClient
//
//  Created by Lara Orlandic on 6/23/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

//Global variables indicating the selected number of spines and leaves
var numberOfSpines: Int = 0
var numberOfLeaves: Int = 0

import Foundation
import UIKit

class ConfigurationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
   
    
    //MARK: Outlets

    @IBOutlet weak var spinePicker: UIPickerView!

    
    //MARK: Variables
    let spineNumbers: [Int] = Array(0...5) //number of spines/leaves available

    
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
    
    //Number of sub-pickers in picker. Selected two: one for leaves, one for spines
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //Select number of options in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return spineNumbers.count
    }
    
    //Establish data in pickers
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return String(spineNumbers[row])
    }
    
    //Function executes when numbers are selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            numberOfSpines = row
            print("You selected \(numberOfSpines) spines.")
        case 1:
            numberOfLeaves = row 
            print("You selected \(numberOfLeaves) leaves.")
        default:
            break
        }
    }
    
}





