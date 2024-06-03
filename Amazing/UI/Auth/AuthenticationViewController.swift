//
//  AuthenticationViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 20/05/24.
//

import UIKit
import FirebaseAuth

protocol AuthDelegate {
    func onValidFields(email: String, password: String)
}

class AuthenticationViewController: BaseViewController {
    
    private var delegate: AuthDelegate
    
    init?(delegate: AuthDelegate, coder: NSCoder) {
            self.delegate = delegate
            super.init(coder: coder)
        }

    @available(*, unavailable, renamed: "init(delegate:coder:)")
        required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }
    
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
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let minPassword = 6
        return password.count >= minPassword
    }
    
    func validateUserField(user: String) {
        if(user.isEmpty) {
            self.showAlertMessage(message: "Ingresa todos los campos para continuar")
        }
    }
    
    func validateFields(email: String, password: String) {
        if(email.isEmpty || password.isEmpty) {
            self.showAlertMessage(message: "Ingresa todos los campos para continuar")
        } else if(!isValidEmail(email)){
            self.showAlertMessage(message: "Revisa que sea un email valido")
        } else if(!isValidPassword(password)){
            self.showAlertMessage(message: "Tu contraseña debe tener al menos 6 caracteres")
        } else {
            delegate.onValidFields(email: email, password: password)
        }
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

