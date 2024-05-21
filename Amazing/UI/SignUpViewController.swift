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

    }
    
    private func setupTextFields() {
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        nameTextField.tag = 1
        emailTextField.tag = 2
        passwordTextField.tag = 3
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchDown)

    }
    
    func signUpWithEmailPassword() async -> Bool {
        actvityLoader.startAnimating()
        let email = emailTextField.text!
        let password = passwordTextField.text!
        var errorMessage = ""
        
        do  {
            try await Auth.auth().createUser(withEmail: email, password: password)
            print("Sign Up successful")
            return true
        }
        catch {
            print(error)
            print("Sign Up failured")
            errorMessage = error.localizedDescription
            return false
      }
    }
    
    @objc
    func signUp() async {
        await signUpWithEmailPassword()
        actvityLoader.stopAnimating()

    }
}
