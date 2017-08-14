//
//  ConfigurationViewController.swift
//  iPhoneClient
//
//  Created by Lara Orlandic on 6/23/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

//Global variables indicating the selected number of spines and leaves
var numberOfSpines: Int = 2
var numberOfLeaves: Int = 2

import Foundation
import UIKit

class ConfigurationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
   
      //MARK: Outlets
    @IBOutlet weak var configureButton: UIButton!
    @IBOutlet weak var spinePicker: UIPickerView!
    
    @IBOutlet weak var spineAndLeafLabel: UILabel!

    
    //MARK: Variables
    let spineNumbers: [Int] = Array(1...5) //number of spines/leaves available

    
    //MARK: Main app functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.spinePicker.delegate = self
        self.spinePicker.dataSource = self
        
        view.insertSubview(configureButton, aboveSubview: spinePicker)
        
        if UIScreen.main.bounds.size.width < 700 {
            spineAndLeafLabel.font = spineAndLeafLabel.font.withSize(15)
            configureButton.titleLabel!.font = UIFont(name: "Times New Roman", size: 20)
        }
        
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
    
    //Style
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        switch component {
        case 0:
            
            label?.text = String(spineNumbers[row])
            label?.font = UIFont(name:"Times New Roman", size:30)
            if UIScreen.main.bounds.size.width < 700 {
                label?.font = UIFont(name:"Times New Roman", size:15)
            }
            return label!
        default:
            label?.text = String(spineNumbers[row])
            label?.font = UIFont(name:"Times New Roman", size:30)
            if UIScreen.main.bounds.size.width < 700 {
                label?.font = UIFont(name:"Times New Roman", size:15)
            }
            return label!
        }
        
    }

    
    //Function executes when numbers are selected
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





