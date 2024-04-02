//
//  CircleView.swift
//  Amazing
//
//  Created by Humberto Solano on 29/03/24.
//

import Foundation
import UIKit

@IBDesignable class CircleView: UIView {
   
    @IBInspectable var ringThickness: CGFloat = 7.0 {
            didSet {
                print("ringThickness was set here")
            }
        }
    
    @IBInspectable var ringColor: UIColor = UIColor(_colorLiteralRed: 205.0, green: 249.0, blue: 80.0, alpha: 1.0) {
             didSet {
                 print("bColor was set here")
            }
        }

    
    override func draw(_ rect: CGRect) {
        let dotPath = UIBezierPath(ovalIn:rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dotPath.cgPath
        layer.addSublayer(shapeLayer)
        shapeLayer.strokeColor = ringColor.cgColor

                
    }
}

