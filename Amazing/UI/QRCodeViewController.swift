//
//  QRCodeViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 09/04/24.
//

import UIKit

class QRCodeViewController: UIViewController {

    @IBOutlet weak var viewBackground: UIView!
    init() {
        super.init(nibName: "QRCodeViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
                   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    private func configView() {
        self.view.backgroundColor = .clear
        self.viewBackground.backgroundColor = .black.withAlphaComponent(0.75)
        self.viewBackground.alpha = 0
    }
    
    @IBAction func closeQRCodeView(_ sender: Any) {
    }
    
    func appear(sender: UIViewController) {
        
        sender.present(self, animated: false){
            self.show()
        }
    }
    
    private func show() {
        UIView.animate(withDuration: 1.0, delay: 0.0){
            self.viewBackground.alpha = 1
        }
    }
}
