//
//  ViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 06/03/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var apiResult = UserModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader.startAnimating()
        
        APIFetchHandler.sharedInstance.fetchAPIData { apiData in
            self.apiResult = apiData
            DispatchQueue.main.async {
                self.loader.stopAnimating()
                self.usernameLbl.text = self.apiResult.user.uppercased()
            }
        }
        // Do any additional setup after loading the view.
    }


}

