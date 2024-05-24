//
//  AuthenticationViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 20/05/24.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    let backgroundImageView = UIImageView()
    @IBOutlet weak var actvityLoader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        setupKeyboardDismissal()
    }
    
    private func setBackground() {
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
    
    func showProfileView(userEmail: String) {
        saveUserSession(userEmail: userEmail)
        if let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            
            profileVC.user = userEmail
            
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
