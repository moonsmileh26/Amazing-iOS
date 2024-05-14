//
//  LoginViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 12/05/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: AmazingTextField!
    
    @IBOutlet weak var keyTextField: AmazingTextField!
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        setupTextFields()
        setupKeyboardDismissal()
    }
    
    func setBackground(){
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundImageView.image = UIImage(named: "background_1")
        backgroundImageView.contentMode = .scaleAspectFill
        view.sendSubviewToBack(backgroundImageView)
    }

}
extension LoginViewController: UITextFieldDelegate {
    
    func setupTextFields(){
        emailTextField.delegate = self
        keyTextField.delegate = self
        emailTextField.tag = 1
        keyTextField.tag = 2
    }
    
    func setupKeyboardDismissal() {
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
