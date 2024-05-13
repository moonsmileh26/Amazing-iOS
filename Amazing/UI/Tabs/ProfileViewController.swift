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
    
    var qrCodeImage: UIImage? = nil
    
    var apiResult = UserModel()
    
    var mainString = "DA CLICK EN SUMA VISITAS Y OBTEN TU SERVICIOS DE LIMPIEZA, APROXIMA AL LECTOR TU TELÉFONO CON EL CÓDIGO QR PARA REGISTRAR O CANJEAR TU SERVICIO"

 
    override func viewDidLoad() {
        super.viewDidLoad()
        labelGreeting.font = UIFont(name: "BebasNeue-Regular", size: 26.0)
        labelVisits.font = UIFont(name: "BebasNeue-Regular", size: 24.0)
        labelNumberVisits.font = UIFont(name: "BebasNeue-Regular", size: 32.0)
        labelMissingVisits.font = UIFont(name: "BebasNeue-Regular", size: 22.0)
        
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

        APIFetchHandler.sharedInstance.fetchAPIData { apiData in
            self.apiResult = apiData
            DispatchQueue.main.async {
                
                Analytics.logEvent("User Profile Screen", parameters: ["user":self.apiResult.email])

                
                let imageName = String(self.apiResult.visits) + "visits"
                self.imageViewVisits.image =  UIImage(named:imageName)
                
                
                self.labelUsername.text = self.apiResult.user.uppercased()
                let missingVisits = 5 - self.apiResult.visits
                self.labelNumberVisits.text = String(self.apiResult.visits)
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
