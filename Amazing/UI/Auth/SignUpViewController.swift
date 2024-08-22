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
    
    var user : String = "Amazing User"
    
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
        user = nameTextField.text ?? "Amazing User"

        if(user.isEmpty) {
            self.validateUserField(user: user)
        } else {
            self.validateFields(email: email, password: password, delegate: self)
        }
    }
    
    func onValidFields(email: String, password: String) {
        actvityLoader.startAnimating()
        singUp(email: email, password: password, delegate: self)
        actvityLoader.stopAnimating()
    }
    
    func onSuccessSignUp(email: String) {
        let client = ClientRepository()

        let userEmail = email
        let newClient = Client(user: self.user, visits: 0)
        client.saveNewClient(userId: email, client: newClient)
        
        actvityLoader.stopAnimating()
        self.showProfileView(userEmail: userEmail)
    }
    
    func onFailedSignUp(message: String) {
        actvityLoader.stopAnimating()
        self.showAlertMessage(message: message)
    }

}
