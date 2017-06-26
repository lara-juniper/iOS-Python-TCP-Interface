//
//  ConfigurationTableViewCell.swift
//  iPhoneClient
//
//  Created by Lara Orlandic on 6/26/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit
import QuartzCore

class ConfigurationTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var picker: UIPickerView!
    
    let gradientLayer = CAGradientLayer()
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)


//        // gradient layer for cell
//        gradientLayer.frame = bounds
//        let color1 = UIColor(white: 1.0, alpha: 0.2).cgColor as CGColor
//        let color2 = UIColor(white: 1.0, alpha: 0.1).cgColor as CGColor
//        let color3 = UIColor.clear.cgColor as CGColor
//        let color4 = UIColor(white: 0.0, alpha: 0.1).cgColor as CGColor
//        gradientLayer.colors = [color1, color2, color3, color4]
//        gradientLayer.locations = [0.0, 0.01, 0.95, 1.0]
//        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
//    func setPickerDataSourceDelegate
//        <D: UIPickerViewDataSource & UIPickerViewDelegate>
//        (dataSourceDelegate: D, forRow row: Int){
//        
//        picker.delegate = dataSourceDelegate
//        picker.dataSource = dataSourceDelegate
//        picker.tag = row
//        
//    }

    
    
}
