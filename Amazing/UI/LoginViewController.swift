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
                
                let userInfo = Auth.auth().currentUser
                let userEmail = userInfo?.email ?? "default"
                print("User  \(userEmail) signs in successfully")
                self.actvityLoader.stopAnimating()
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
