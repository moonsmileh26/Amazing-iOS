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
        super.init(nibName: "QRCodeViewController", bundle: nil)
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
        self.buttonClose.titleLabel?.font = UIFont(name: "BebasNeue-Regular", size: 24.0)
        self.view.backgroundColor = .clear
        self.viewBackground.backgroundColor = .black.withAlphaComponent(0.75)
        self.viewBackground.alpha = 0
        self.viewContent.alpha = 0
        self.viewContent.layer.cornerRadius = 12
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
