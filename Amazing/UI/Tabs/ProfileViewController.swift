//
//  SecondViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 19/03/24.
//

import UIKit
import FirebaseAnalyticsSwift
import FirebaseAnalytics

class ProfileViewController: UIViewController, QRCodeDelegate {
    
    @IBOutlet weak var viewLoader: UIActivityIndicatorView!
    @IBOutlet weak var labelGreeting: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelVisits: UILabel!
    @IBOutlet weak var labelNumberVisits: UILabel!
    @IBOutlet weak var labelMissingVisits: UILabel!
    @IBOutlet weak var imageViewVisits: UIImageView!
    @IBOutlet weak var imageViewScanButton: UIImageView!
    let backgroundImageView = UIImageView()
    
    var qrCodeImage: UIImage? = nil
    
    var user = ""
    
    var apiResult = UserModel()
    
    var mainString = "DA CLICK EN SUMA VISITAS Y OBTEN TU SERVICIOS DE LIMPIEZA, APROXIMA AL LECTOR TU TELÉFONO CON EL CÓDIGO QR PARA REGISTRAR O CANJEAR TU SERVICIO"

 
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
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
        print("Fetching user \(user)")

        APIFetchHandler.sharedInstance.fetchAPIData(user: self.user) { apiData in
            self.apiResult = apiData
            DispatchQueue.main.async {
                
                Analytics.logEvent("User Profile Screen", parameters: ["user":self.apiResult.email])

                
                let imageName = String(self.apiResult.visits) + "visits"
                self.imageViewVisits.image =  UIImage(named:imageName)
                
                
                self.labelUsername.text = self.apiResult.user.uppercased()
                self.labelUsername.textColor = .white
                
                let missingVisits = 5 - self.apiResult.visits
                self.labelNumberVisits.text = String(self.apiResult.visits)
                self.labelVisits.text = "VISITAS"
                self.labelMissingVisits.text = "TE FALTAN " + String(missingVisits)
                
                self.qrCodeImage = generateQRCode(from: self.apiResult.email)

                if(missingVisits == 0) {
                    self.mainString = "FELICIDADES, TIENES UNA LIMPIEZA GRATIS, ACUDE A UNA DE NUESTRAS SUCURSALES PARA OBTENER TU LIMPIEZA PROFUNDA GRATIS"
                    self.mainLabel.text = self.mainString
                    self.labelMissingVisits.text = "1 Limpieza Gratis"
                } else {
                    self.imageViewScanButton.isHidden = false
                }
                
                self.viewLoader.stopAnimating()
            }
        }
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
    
    private func setBackground() {
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundImageView.image = UIImage(named: "background_1")
        backgroundImageView.contentMode = .scaleAspectFill
        view.sendSubviewToBack(backgroundImageView)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

extension UIViewController{
    
    public func showAlertMessage(title: String, message: String){
        
        let alertMessagePopUpBox = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Aceptar", style: .default)
        
        alertMessagePopUpBox.addAction(okButton)
        self.present(alertMessagePopUpBox, animated: true)
    }
}
