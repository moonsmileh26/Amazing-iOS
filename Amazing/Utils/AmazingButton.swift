//
//  AmazingButton.swift
//  Amazing
//
//  Created by Humberto Solano on 12/05/24.
//

import UIKit

@IBDesignable
class AmazingButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 12.0
        self.titleLabel?.font = UIFont(name: Fonts.bebasNeue, size: 20)
        self.tintColor = Colors.amazingGreen
    }
}
