//
//  ConfigurationViewController.swift
//  iPhoneClient
//
//  Created by Lara Orlandic on 6/23/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import Foundation
import UIKit

class ConfigurationViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
   
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!

    
    //MARK: Variables
    //let spineNumbers: [Int] = Array(1...5)
    let tableHeaders: [String] = ["Select Number of Spines", "Select Number of Leaves"]
    let leafNumbers: [Int] = Array(1...5)
   // let picker: UIPickerView = UIPickerView(frame: CGRect(x: 200, y: 200, width: 300, height: 300))

    
    //MARK: Main app functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ConfigurationTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 50.0
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: TableView Delegate Functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableHeaders.count
    }
    
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath as IndexPath) as! ConfigurationTableViewCell
        let item = tableHeaders[indexPath.row]
        cell.textLabel?.text = item
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 12)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
       // cell.accessoryView = picker
        ////cell.setPickerDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        return cell
    }
    
    



    
//    func colorForIndex(index: Int) -> UIColor {
//        let itemCount = tableHeaders.count - 1
//        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
//        return UIColor(red: 217/255, green: val, blue: 1.0, alpha: 1.0)
//    }
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
//                   forRowAt indexPath: IndexPath) {
//        cell.backgroundColor = colorForIndex(index: indexPath.row)
//    }
}

extension ConfigurationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Picker view delegate functions
    func selectRow(_: Int, inComponent: Int, animated: Bool){
        
    }
    func selectedRow(inComponent: Int) {
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return leafNumbers.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return leafNumbers.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(leafNumbers[row])
    }
    
    
}




