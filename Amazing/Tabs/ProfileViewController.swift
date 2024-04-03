//
//  SecondViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 19/03/24.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var viewLoader: UIActivityIndicatorView!
    @IBOutlet weak var labelGreeting: UILabel!
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var labelUsername: UILabel!
    
    
    
    @IBOutlet weak var labelVisits: UILabel!
    
    
    @IBOutlet weak var labelNumberVisits: UILabel!
    var apiResult = UserModel()
    
    @IBOutlet weak var labelMissingVisits: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelGreeting.font = UIFont(name: "BebasNeue-Regular", size: 26.0)
        
        labelVisits.font = UIFont(name: "BebasNeue-Regular", size: 20.0)
        labelNumberVisits.font = UIFont(name: "BebasNeue-Regular", size: 26.0)
        labelMissingVisits.font = UIFont(name: "BebasNeue-Regular", size: 20.0)
        
        

        let mainString = "DA CLICK EN SUMA VISITAS Y OBTEN TU SERVICIOS DE LIMPIEZA, APROXIMA AL LECTOR TU TELÉFONO CON EL CÓDIGO QR PARA REGISTRAR O CANJEAR TU SERVICIO"
        
        let range = (mainString as NSString).range(of: "SUMA VISITAS")
        
        let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 193, green: 251, blue: 2), range: range)
        
        
        
        mainLabel.attributedText  = mutableAttributedString
        
        viewLoader.startAnimating()
        
        APIFetchHandler.sharedInstance.fetchAPIData { apiData in
            self.apiResult = apiData
            DispatchQueue.main.async {
                self.labelUsername.text = self.apiResult.user.uppercased()
                let missingVisits = 5 - self.apiResult.visits
                self.labelNumberVisits.text = String(self.apiResult.visits)
                self.labelMissingVisits.text = "TE FALTAN " + String(missingVisits)
                self.viewLoader.stopAnimating()
            }
        }


        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
