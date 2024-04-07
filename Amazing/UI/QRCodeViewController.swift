//
//  QRCodeViewController.swift
//  Amazing
//
//  Created by Humberto Solano on 06/04/24.
//

import Foundation
import UIKit

class QRCodeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view = QRCodeView()
        self.view.addSubview(view)
    }
}
