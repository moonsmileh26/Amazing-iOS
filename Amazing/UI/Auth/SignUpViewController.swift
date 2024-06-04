//
//  SignUpViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 20/05/24.
//

import UIKit
import FirebaseAuth


class SignUpViewController: AuthenticationViewController, AuthDelegate {
    
    @IBOutlet weak var nameTextField: AmazingTextField!
    @IBOutlet weak var emailTextField: AmazingTextField!
    @IBOutlet weak var passwordTextField: AmazingTextField!
    @IBOutlet weak var signUpButton: AmazingButton!
    
    var user : String = "user@default.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
    }
    
    private func setupTextFields() {
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        nameTextField.tag = 1
        emailTextField.tag = 2
        passwordTextField.tag = 3
        signUpButton.addTarget(self, action: #selector(signUpWithEmailPassword), for: .touchDown)
        
    }
    
    @objc func signUpWithEmailPassword()  {
        let email = emailTextField.text ?? "default"
        let password = passwordTextField.text ?? "default"
        user = nameTextField.text ?? "user@default.com"

        if(user.isEmpty) {
            self.validateUserField(user: user)
        } else {
            self.validateFields(email: email, password: password, delegate: self)
        }
    }
    
    func onValidFields(email: String, password: String) {
        actvityLoader.startAnimating()
        singUp(email: email, password: password)
        actvityLoader.stopAnimating()
    }
    
    func singUp(email: String, password: String) {
        
        actvityLoader.startAnimating()

        let client = ClientRepository()

        Auth.auth().createUser(withEmail: email, password: password) { auth, error in
            
            if let error = error as? NSError {
                let authError = AuthErrorCode(_nsError: error)
                switch authError.code {
                case .emailAlreadyInUse:
                    self.showAlertMessage(message: "El email ya se encuentra registrado")
                    
                case .invalidEmail:
                    self.showAlertMessage(message: "Revisa que sea un email valido")

                default:
                    self.showAlertMessage(message: "Algo salio mal, intentalo nuevamente")
                    
                }
            } else {
                let userEmail = auth?.user.email ?? email
                let newClient = Client(user: self.user, visits: 0)
                client.saveNewClient(userId: userEmail, client: newClient)
                goToProfile()
            }
        }
        
        func goToProfile() {
            sleep(3)
            self.showProfileView(userEmail: email)
            actvityLoader.stopAnimating()

        }
    }
}
