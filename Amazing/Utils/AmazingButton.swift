//
//  AmazingButton.swift
//  Amazing
//
//  Created by Humberto Solano on 12/05/24.
//

import UIKit

class AmazingButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 20.0
        self.titleLabel?.font = UIFont(name: Fonts.bebasNeue, size: 20)
        self.titleLabel?.textColor = UIColor(red: 0, green: 0, blue: 0)
        self.tintColor = Colors.amazingGreen
    }
}
