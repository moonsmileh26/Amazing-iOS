//
//  AuthenticationViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 20/05/24.
//

import UIKit
import FirebaseAuth

class AuthenticationViewController: BaseViewController {
    
    @IBOutlet weak var actvityLoader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDismissal()
    }
    
    func showProfileView(userEmail: String) {
        saveUserSession(userEmail: userEmail)
        if let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            
            let user = Auth.auth().currentUser
            print("Authentication VC \(String(describing: user?.uid))")
            profileVC.user = Auth.auth().currentUser
            
            self.modalPresentationStyle = .fullScreen
            self.present(profileVC, animated: true)
        }
    }
    
    func saveUserSession(userEmail: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(userEmail, forKey: "user_email")
    }
}

extension AuthenticationViewController: UITextFieldDelegate {
    
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

