//
//  ViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 06/03/24.
//

import UIKit
import FirebaseAuth

class InitialViewController: UIViewController {
    
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var imageViewIsotype: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        let imageFrame = self.imageViewLogo.frame
        let isotypeFrame = self.imageViewIsotype.frame
        
        UIView.animate(withDuration: 0.9) {
            self.imageViewLogo.frame = CGRect(x: (self.imageViewLogo.frame.width)/2, y: (self.view.frame.height)-300, width:imageFrame.width, height: imageFrame.height)
            self.imageViewLogo.alpha = 1.0
        }
        
        UIView.animate(withDuration: 1.3, delay: 1.5,animations: {
            self.imageViewIsotype.frame = CGRect(x: (self.imageViewIsotype.frame.minX),
                                                 y: (self.view.frame.height)/2,
                                                 width:isotypeFrame.width, height: isotypeFrame.height)
            self.imageViewIsotype.alpha = 1.0
            
        }, completion: { _ in
            
            let defaults = UserDefaults.standard
            let userEmail = defaults.string(forKey: "user_email") ?? ""
            
            self.modalPresentationStyle = .fullScreen
            
            if(userEmail.isEmpty) {
                if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    self.present(loginVC, animated: true)
                    
                }
            } else {
                if let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
                    
                    var user = Auth.auth().currentUser
                    if(user != nil) {
                        profileVC.user = user
                    } else {
                        profileVC.userEmail = userEmail
                    }
                    
                    self.present(profileVC, animated: true)
                }
            }
        })
    }
}

