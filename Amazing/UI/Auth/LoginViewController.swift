//
//  LoginViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 12/05/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: AuthenticationViewController, AuthDelegate {
    
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
    
    func setupTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.tag = 1
        passwordTextField.tag = 2
        loginButton.addTarget(self, action: #selector(attemptLogin), for: .touchDown)
        loginButton.titleLabel?.text = "INICIA SESION"
        loginButton.titleLabel?.textColor = UIColor(red: 30,green: 30,blue: 30)
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.tapFunction))
        registerLabel.isUserInteractionEnabled = true
        registerLabel.addGestureRecognizer(tap)
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Crea una cuenta con tu email", attributes: underlineAttribute)
        registerLabel.attributedText = underlineAttributedString
        
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
    func attemptLogin() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        self.validateFields(email: email, password: password, delegate: self)
    }
    
    func onValidFields(email: String, password: String) {
        actvityLoader.startAnimating()
        doLogin(email: email, password: password)
        actvityLoader.stopAnimating()

    }
    
    func doLogin(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            
            if let error = error as? NSError {
                let authError = AuthErrorCode(_nsError: error)
                
                switch authError.code {
                case .invalidCredential:
                    print("Wrong Credentials \(error)")
                    self.showAlertMessage(message: "Verifica tus credenciales e intentalo de nuevo")
                    
                @unknown default:
                    self.showAlertMessage(message: "Algo salio mal, intentalo nuevamente")
                }
            } else {
                let userInfo = Auth.auth().currentUser
                let userEmail = userInfo?.email ?? "default"
                print("User \(userEmail) signs in successfully")
                self.showProfileView(userEmail:userEmail)
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
    
}
