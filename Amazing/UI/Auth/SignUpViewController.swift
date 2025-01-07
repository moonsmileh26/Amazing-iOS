//
//  SignUpViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 20/05/24.
//

import UIKit
import FirebaseAuth
import os


class SignUpViewController: AuthenticationViewController, AuthDelegate {
    
    @IBOutlet weak var nameTextField: AmazingTextField!
    @IBOutlet weak var emailTextField: AmazingTextField!
    @IBOutlet weak var passwordTextField: AmazingTextField!
    @IBOutlet weak var signUpButton: AmazingButton!
        
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
        let email = emailTextField.text ?? "user@default"
        let password = passwordTextField.text ?? "default"
        let user = nameTextField.text ?? "Usuario Amazing"
        self.validateFields(user: user, email: email, password: password, delegate: self)
        
    }
    
    func onValidFields(user: String, email: String, password: String) {
        actvityLoader.startAnimating()
        singUp(user: user, email: email, password: password, imageUrl: "", delegate: self)
        actvityLoader.stopAnimating()
    }

    
    func onSuccessSignUp(user: String, email: String, imageUrl: String) {
        let repository = ClientRepository()

        let client = Client(user: user, visits: 0)
        repository.saveNewClient(userId: email, client: client)
        
        actvityLoader.stopAnimating()
        self.showProfileView(userEmail: email)
    }
    
    func onUserRegistered(email: String) {
        self.showProfileView(userEmail: email)
    }
    
    func onFailedSignUp(message: String) {
        actvityLoader.stopAnimating()
        self.showAlertMessage(message: message)
        os_log("onFailedSignUp: %@", log: log, type: .error, message)
    }

}
