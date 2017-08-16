//
//  LineView.swift
//  dynamicImageResizing
//
//  Created by Lara Orlandic on 6/28/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import Foundation
import UIKit

class LineView : UIView {
    
    //start and endpoints of the line
    var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var endPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            context.setStrokeColor(UIColor.gray.cgColor)
            context.setLineWidth(2)
            context.beginPath()
            context.move(to: startPoint) // This would be oldX, oldY
            context.addLine(to: endPoint) // This would be newX, newY
            context.strokePath()
        }
    }
    
    func setEndpoints(start: CGPoint, end: CGPoint) {
        startPoint = start
        endPoint = end
    }
}
