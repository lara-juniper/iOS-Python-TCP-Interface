//
//  Switch.swift
//  iPhoneClient
//
//  Created by Lara Orlandic on 6/14/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit

class SwitchImage: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
   var status: switchStatus = switchStatus.Neutral {
        didSet {
            if status != .Neutral {
                switch status {
                    
                case .Neutral:
                    self.backgroundColor = UIColor.white
                    
                case .Disabled:
                    self.backgroundColor = UIColor.red
                    
                case .Enabled:
                    self.backgroundColor = UIColor.green
                    
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
