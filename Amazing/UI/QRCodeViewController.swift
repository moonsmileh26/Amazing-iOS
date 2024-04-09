//
//  QRCodeViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 06/04/24.
//

import Foundation
import UIKit

class QRCodeViewController: UIViewController {
    
    @IBOutlet weak var viewQRCode: UIView!
    
    @IBOutlet weak var imageViewQRCode: UIImageView!
    
    @IBOutlet weak var buttonCloseQRView: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func generateQRCode(from data: String) -> UIImage? {
        
        if let data = data.data(using: .ascii) {
            let qrCode = QRCode(inputMessage: data)
            return BarcodeService.generateBarcode(from: qrCode)
        }

        return nil
    }
    
    @IBAction func closeView(_ sender: Any) {
    }
}
