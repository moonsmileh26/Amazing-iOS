//
//  QRCodeView.swift
//  Amazing
//
//  Created by Humberto Solano on 06/04/24.
//

import Foundation
import UIKit

class QRCodeView: UIView {
    
    @IBOutlet weak var viewQRCode: UIView!
    
    @IBOutlet weak var imageViewQRCode: UIImageView!
    
    @IBOutlet weak var buttonCloseQRView: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    private func initViews(){
        Bundle.main.loadNibNamed("QRCodeView", owner: self)
        addSubview(viewQRCode)
        viewQRCode.frame = self.bounds
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
