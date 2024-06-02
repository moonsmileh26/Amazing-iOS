//
//  SignUpViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 20/05/24.
//

import UIKit
import FirebaseAuth


class SignUpViewController: AuthenticationViewController {
    
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
        actvityLoader.startAnimating()
        let user = nameTextField.text ?? "Usuario"
        let email = emailTextField.text ?? "default"
        let password = passwordTextField.text!
        
        let client = ClientRepository()

        
        Auth.auth().createUser(withEmail: email, password: password) { auth, error in
            print(auth ?? "")
            let userEmail = auth?.user.email ?? email
            let newClient = Client(user: user, visits: 0)
            client.saveNewClient(userId: userEmail, client: newClient)
            
            self.showProfileView(userEmail: userEmail)
        }
        actvityLoader.stopAnimating()
    }
    
}
