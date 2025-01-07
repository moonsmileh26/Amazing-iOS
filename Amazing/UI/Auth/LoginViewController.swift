//
//  LoginViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 12/05/24.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import os

class LoginViewController: AuthenticationViewController, AuthDelegate {
    
    @IBOutlet weak var emailTextField: AmazingTextField!
    @IBOutlet weak var passwordTextField: AmazingTextField!
    @IBOutlet weak var loginButton: AmazingButton!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    
    var username = ""
    
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
        
        self.validateFields(user: "", email: email, password: password, delegate: self)
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
                    os_log("doLogin: %@", log: self.log, type: .error, authError.localizedDescription)

                }
            } else {
                let userInfo = Auth.auth().currentUser
                let userEmail = userInfo?.email ?? "default"
                print("User \(userEmail) signs in successfully")
                self.showProfileView(userEmail:userEmail)
            }
            
        }
    }
    
    @objc func appleSignIn() {
        actvityLoader.startAnimating()
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        actvityLoader.startAnimating()

        GIDSignIn.sharedInstance.signIn(withPresenting: self) {
            signInResult, error in
            guard error == nil else {
                self.actvityLoader.stopAnimating()
                return
            }
            guard signInResult != nil else {
                self.actvityLoader.stopAnimating()
                return
            }
            let user = signInResult?.user
            let email = user?.profile?.email ?? ""
            let userName = user?.profile?.givenName ?? "Usuario Amazing"
            let imageProfile = user?.profile?.imageURL(withDimension: 320)?.absoluteString ?? ""
            
            self.username = userName
            self.singUp(user: userName, email: email, imageUrl: imageProfile, delegate: self)
        }
    }
    
    func handleNewUserSignIn(userName: String, email: String, imageUrl: String) {
        let repository = ClientRepository()
        let client = Client(user: userName , visits: 0, imageUrl: imageUrl)
        repository.saveNewClient(userId: email, client: client)
        showProfileView(userEmail: email)
    }
    
    func isUserRegistered(email: String) -> Bool {
        let client = ClientRepository()

        var isUserRegistered = false
        client.fetchClient(userId: email, completionBlock: { result in
            switch result {
            case .success(let client):
                isUserRegistered = true
            case .failure(let error):
                os_log("isUserRegistered: %@", log: self.log, type: .error, error.localizedDescription)
                isUserRegistered = false
            }
        })
        return isUserRegistered
    }
    
    
    @objc
    func showRegisterView() {
        if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            self.modalPresentationStyle = .automatic
            self.present(loginVC, animated: true)
        }
    }
}

// AuthDelegate
extension LoginViewController {
    
    func onValidFields(user: String, email: String, password: String) {
        actvityLoader.startAnimating()
        doLogin(email: email, password: password)
    }
    
    func onSuccessSignUp(user: String, email: String, imageUrl: String) {
        if(self.isUserRegistered(email: email)) {
            self.showProfileView(userEmail:email)
        } else {
            self.handleNewUserSignIn(userName: user, email: email, imageUrl: imageUrl)
        }
    }
    
    func onUserRegistered(email: String) {
            self.showProfileView(userEmail:email)
        
    }
    
    func onFailedSignUp(message: String) {
        actvityLoader.stopAnimating()
        self.showAlertMessage(message: message)
    }
    
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        os_log("didCompleteWithError: %@", log: log, type: .error, error.localizedDescription)
    }
    
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            let firstName = credentials.fullName?.givenName
            let email = credentials.email
            break
        default:
            break
        }
    }
    
    
}
