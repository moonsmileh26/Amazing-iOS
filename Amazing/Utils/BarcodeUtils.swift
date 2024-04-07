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

    /// QR Code correction level L, M, Q, or H.
    let inputCorrectionLevel: QRCorrectionLevel = .h

    /// The message to encode in the QR Code
    let inputMessage: Data

    var properties: [String: Any] {
        [
            "inputCorrectionLevel": inputCorrectionLevel.rawValue.uppercased(),
            "inputMessage": NSData(data: inputMessage)
        ]
    }
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
