//
//  BarcodeUtils.swift
//  Amazing
//
//  Created by Humberto Solano on 05/04/24.
//

import Foundation
import UIKit

protocol Barcodable {
    var name: String { get }
    var properties: [String: Any] { get }
}

struct QRCode: Barcodable {
    enum QRCorrectionLevel: String {
        case l
        case m
        case q
        case h
    }

    let name = "CIQRCodeGenerator"

    let inputCorrectionLevel: QRCorrectionLevel = .h

    let inputMessage: Data

    var properties: [String: Any] {
        [
            "inputCorrectionLevel": inputCorrectionLevel.rawValue.uppercased(),
            "inputMessage": NSData(data: inputMessage)
        ]
    }
}

func generateQRCode(from data: String) -> UIImage? {
    
    if let data = data.data(using: .ascii) {
        let qrCode = QRCode(inputMessage: data)
        return BarcodeService.generateBarcode(from: qrCode)
    }

    return nil
}

struct BarcodeService {
    static func generateBarcode(from barcode: Barcodable, scalar: CGFloat = 10.0) -> UIImage? {
        if let filter = CIFilter(name: barcode.name) {
            filter.setValuesForKeys(barcode.properties)

            let transform = CGAffineTransform(scaleX: scalar, y: scalar)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}
