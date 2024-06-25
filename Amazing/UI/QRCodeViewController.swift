//
//  QRCodeViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 09/04/24.
//

import UIKit

protocol QRCodeDelegate {
    func didQRCodeReaded()
}

class QRCodeViewController: UIViewController {

    var qrCodeImage: UIImage? = nil
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewQRCode: UIImageView!
    
    @IBOutlet weak var buttonClose: UIButton!
    
    var delegate: QRCodeDelegate?
    
    init() {
        super.init(nibName: "QRCodeView", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
                   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewQRCode.image = qrCodeImage
        configView()
        
    }
    private func configView() {
        
        buttonClose.setTitle("CERRAR", for: .normal)
        buttonClose.setTitleColor(.white, for: .normal)
        
        view.backgroundColor = .clear
        viewBackground.backgroundColor = .black.withAlphaComponent(0.75)
        viewBackground.alpha = 0
        viewContent.alpha = 0
        viewContent.layer.cornerRadius = 12

    }
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false){
            self.show()
        }
    }
    
    private func show() {
        UIView.animate(withDuration: 0.5, animations: {
            self.viewBackground.alpha = 1
            self.viewContent.alpha = 1
        })
    }
    
    func hide(){
        self.dismiss(animated: true)
        self.removeFromParent()
    }
    
    @IBAction func closeQRCodeView(_ sender: Any) {
        hide()
        delegate?.didQRCodeReaded()
    }
}
