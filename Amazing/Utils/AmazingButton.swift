//
//  AmazingButton.swift
//  Amazing
//
//  Created by Humberto Solano on 12/05/24.
//

import UIKit

class AmazingButton: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()

    }
    
    func setupButton() {
        backgroundColor = Colors.amazingGreen
        layer.cornerRadius = 12.0
        font = UIFont(name: Fonts.bebasNeue, size: 20)
        textColor = UIColor(red: 46, green: 46, blue: 46)
    }
    
}
