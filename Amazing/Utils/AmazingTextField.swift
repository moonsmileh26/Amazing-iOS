//
//  AmazingTextField.swift
//  Amazing
//
//  Created by Humberto Solano on 12/05/24.
//

import UIKit

class AmazingTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpField()
    }
        
        
    required init?(coder aDecoder: NSCoder) {
        super.init( coder: aDecoder )
        setUpField()
    }
    private func setUpField() {
            tintColor             = .white
            textColor             = UIColor(red: 46, green: 46, blue: 46)
            font                  = UIFont(name: Fonts.latoRegular, size: 18)
            backgroundColor       = UIColor(white: 1.0, alpha: 0.5)
            autocorrectionType    = .no
            layer.cornerRadius    = 10.0
            clipsToBounds         = true
            
            let placeholder       = self.placeholder != nil ? self.placeholder! : ""
        let placeholderFont   = UIFont(name: Fonts.latoRegular, size: 18)!
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes:
                                                        [NSAttributedString.Key.foregroundColor: UIColor(red: 69, green: 69, blue: 69),
                 NSAttributedString.Key.font: placeholderFont])
        
        
        
        
            
            let indentView        = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            leftView              = indentView
            leftViewMode          = .always
        }
}
