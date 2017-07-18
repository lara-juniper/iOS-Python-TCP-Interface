//
//  Switch.swift
//  iPhoneClient
//
//  Created by Lara Orlandic on 6/14/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit

class SwitchImage: UIImageView {
    
    var IPAddress = "10.0.0.0"
    
   var status: switchStatus = switchStatus.Neutral {
        didSet {
            if status != .Neutral {
                switch status {
                    
                case .Neutral:
                    //self.backgroundColor = UIColor.white
                    self.image = #imageLiteral(resourceName: "leafSwitchPNG")
                    
                case .Disabled:
                    //self.backgroundColor = UIColor.red
                    self.image = #imageLiteral(resourceName: "leafSwitchPNGRed")
                    
                case .Enabled:
                   // self.backgroundColor = UIColor.green
                    self.image = #imageLiteral(resourceName: "leafSwitchPNGGreen")
                    
                }
            }
        }
    }
    
    enum switchStatus {
        case Neutral
        case Disabled
        case Enabled
    }

}
