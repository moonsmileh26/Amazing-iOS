//
//  LoginViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 12/05/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: AuthenticationViewController {
    
    @IBOutlet weak var emailTextField: AmazingTextField!
    @IBOutlet weak var passwordTextField: AmazingTextField!
    @IBOutlet weak var loginButton: AmazingButton!
    @IBOutlet weak var registerLabel: UILabel!
    
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
    }
    
    func setupTextFields(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.tag = 1
        passwordTextField.tag = 2
        loginButton.addTarget(self, action: #selector(doLogin), for: .touchDown)
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.tapFunction))
        registerLabel.isUserInteractionEnabled = true
        registerLabel.addGestureRecognizer(tap)
        
        googleButton.tintColor = UIColor(red: 19, green: 19, blue: 19)
        googleButton.layer.cornerRadius = 0.5
        googleButton.setImage(UIImage(named: "google_icon"), for: .normal)
        
        appleButton.layer.cornerRadius = 20
        appleButton.layer.masksToBounds = true
        appleButton.setImage(UIImage(named: "apple_icon"), for: .normal)
        
    }
    
    @IBAction func tapFunction(sender: UITapGestureRecognizer) {
        if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            
            self.present(loginVC, animated: true)
        }
    }
    
    
    @objc
    func doLogin() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if(!isValidEmail(email)){
            
        } else if(!isValidPassword(password)){
            
        } else {
            actvityLoader.startAnimating()
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                
                                
                if let error = error as? NSError {
                    let authError = AuthErrorCode(_nsError: error)
                    
                    switch authError.code {
                    case .wrongPassword:
                        print("Wrong password \(error)")
                        
                    case .invalidCredential:
                        print("Wrong Credentials \(error)")
                        self.showAlertMessage(message: "Verifica tus credenciales e intentalo de nuevo")

                        
                    @unknown default:
                        print("Default error \(error)")
                    }
                    
                    
                } else {
                    let userInfo = Auth.auth().currentUser
                    let userEmail = userInfo?.email ?? "default"
                    print("User \(userEmail) signs in successfully")
                    self.showProfileView(userEmail:userEmail)
                }
                
                self.actvityLoader.stopAnimating()
            }
        }
    }
    @objc
    func showRegisterView() {
        if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {     
            self.modalPresentationStyle = .automatic
            self.present(loginVC, animated: true)
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let minPassword = 3
        return password.count >= minPassword
    }

}
