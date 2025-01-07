//
//  AuthenticationViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 20/05/24.
//

import UIKit
import FirebaseAuth
import os
import FirebaseCore
import GoogleSignIn

protocol AuthDelegate {
    func onValidFields(user: String, email: String, password: String)
    func onSuccessSignUp(user: String, email: String, imageUrl: String)
    func onUserRegistered(email: String)
    func onFailedSignUp(message: String)
    
}

class AuthenticationViewController: BaseViewController {
    
    @IBOutlet weak var actvityLoader: UIActivityIndicatorView!
    
    let log = OSLog(subsystem: "AuthenticationViewController", category: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDismissal()
    }
    
    func showProfileView(userEmail: String) {
        saveUserSession(userEmail: userEmail)
        if let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            
            let user = Auth.auth().currentUser
            if(user != nil) {
                profileVC.user = Auth.auth().currentUser
            }
            profileVC.userEmail = userEmail
            
            os_log("AuthenticationViewController#showProfileView: %@", log: self.log, type: .info, String(describing: user?.uid ?? userEmail))
        
            
            self.modalPresentationStyle = .fullScreen
            self.present(profileVC, animated: true)
        }
        actvityLoader.stopAnimating()
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
    
    func validateFields(user: String, email: String, password: String, delegate: AuthDelegate) {
        if(email.isEmpty || password.isEmpty) {
            self.showAlertMessage(message: "Ingresa todos los campos para continuar")
        } else if(!isValidEmail(email)){
            self.showAlertMessage(message: "Revisa que sea un email valido")
        } else if(!isValidPassword(password)){
            self.showAlertMessage(message: "Tu contraseña debe tener al menos 6 caracteres")
        } else {
            delegate.onValidFields(user: user, email: email, password: password)
        }
        actvityLoader.stopAnimating()
    }
    
    func singUp(user: String, email: String, password: String = "123456", imageUrl: String, delegate: AuthDelegate) {
        
        actvityLoader.startAnimating()
        
        
        Auth.auth().createUser(withEmail: email, password: password) { auth, error in
            
            if let error = error as? NSError {
                let authError = AuthErrorCode(_nsError: error)
                os_log("AuthenticationViewController#singUp: %@", log: self.log, type: .error, authError.localizedDescription)
                
                var errorMessage = ""
                switch authError.code {
                case .emailAlreadyInUse:
                    errorMessage = "El email ya se encuentra registrado"
                    delegate.onUserRegistered(email: email)
                    return
                    
                case .invalidEmail:
                    errorMessage = "Revisa que sea un email valido"

                default:
                    errorMessage = "Algo salio mal, intentalo nuevamente"
                    
                }
                delegate.onFailedSignUp(message: errorMessage)
                
            } else {
                delegate.onSuccessSignUp(user: user, email: email, imageUrl: imageUrl)
            }
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

