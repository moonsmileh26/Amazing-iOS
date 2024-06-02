//
//  SecondViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 19/03/24.
//

import UIKit
import FirebaseAnalyticsSwift
import FirebaseAnalytics
import FirebaseAuth

class ProfileViewController: BaseViewController, QRCodeDelegate {
    
    @IBOutlet weak var viewLoader: UIActivityIndicatorView!
    @IBOutlet weak var labelGreeting: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelVisits: UILabel!
    @IBOutlet weak var labelNumberVisits: UILabel!
    @IBOutlet weak var labelMissingVisits: UILabel!
    @IBOutlet weak var imageViewVisits: UIImageView!
    @IBOutlet weak var imageViewScanButton: UIImageView!
        
    var qrCodeImage: UIImage? = nil
    
    var user : User?
    
    var apiResult = UserModel()
    
    var mainString = "DA CLICK EN SUMA VISITAS Y OBTEN TU SERVICIOS DE LIMPIEZA, APROXIMA AL LECTOR TU TELÉFONO CON EL CÓDIGO QR PARA REGISTRAR O CANJEAR TU SERVICIO"

 
    override func viewDidLoad() {
        super.viewDidLoad()
        labelGreeting.font = UIFont(name: "BebasNeue-Regular", size: 30.0)
        labelVisits.font = UIFont(name: "BebasNeue-Regular", size: 28.0)
        labelNumberVisits.font = UIFont(name: "BebasNeue-Regular", size: 44.0)
        labelMissingVisits.font = UIFont(name: "BebasNeue-Regular", size: 24.0)
        self.labelUsername.font = UIFont(name: Fonts.latoRegular, size: 20)
        
        let range = (mainString as NSString).range(of: "SUMA VISITAS")
        
        let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 193, green: 251, blue: 2), range: range)
        
        
        mainLabel.attributedText  = mutableAttributedString
                
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imageViewScanButton.isUserInteractionEnabled = true
        imageViewScanButton.addGestureRecognizer(tapGestureRecognizer)
        
        getUserProfile()
    }
    
    func getUserProfile() {
        viewLoader.startAnimating()
        let userEmail = user?.email
        print("Fetching user \(userEmail)")
        let client = ClientRepository()
        client.fetchClient(user: userEmail ?? "user@default.com", completionBlock: { [weak self] result in
            switch result {
            case .success(let client):
                print("on Successful fetch")
                self?.showClientInfo(client: client)

            case .failure(let error):
                print("on Failure fetch")
                print(error.localizedDescription)
            }
        })
    }
    
    func showClientInfo(client: Client){
        
        let imageName = String(client.visits) + "visits"
        self.imageViewVisits.image =  UIImage(named:imageName)
        
        self.labelUsername.text = client.user
        self.labelUsername.textColor = .white
        
        let missingVisits = 5 - client.visits
        self.labelNumberVisits.text = String(client.visits)
        self.labelVisits.text = "VISITAS"
        self.labelMissingVisits.text = "TE FALTAN " + String(missingVisits)
        
        self.qrCodeImage = generateQRCode(from: user?.email ?? "user@gmail.com")

        if(missingVisits == 0) {
            self.mainString = "FELICIDADES, TIENES UNA LIMPIEZA GRATIS, ACUDE A UNA DE NUESTRAS SUCURSALES PARA OBTENER TU LIMPIEZA PROFUNDA GRATIS"
            self.mainLabel.text = self.mainString
            self.labelMissingVisits.text = "1 Limpieza Gratis"
        } else {
            self.imageViewScanButton.isHidden = false
        }
                        
        self.viewLoader.stopAnimating()
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let qrCodeViewController = QRCodeViewController()
        qrCodeViewController.delegate = self
        qrCodeViewController.qrCodeImage = self.qrCodeImage
        qrCodeViewController.appear(sender: self)
    }
    
    func didQRCodeReaded() {
        getUserProfile()
    }
    
    @IBAction func logout(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "user_email")
        
        do {
          try Auth.auth().signOut()
        } catch {
          print("Sign out error")
        }
        
        if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            self.present(loginVC, animated: true)
        }
        
    }
    
}
