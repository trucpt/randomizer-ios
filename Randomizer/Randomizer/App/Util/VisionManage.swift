//
//  VisionManage.swift
//  Randomizer
//
//  Created by nguyen ha on 10/13/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import Foundation
import Vision

class VisionManage: BaseUseCase {
    
    class func barcodeDetection () -> String {
        var barcodeString = ""
        let barcodeRequest = VNDetectBarcodesRequest(completionHandler: {(request, error) in
            for result in request.results! {
                if let barcode = result as? VNBarcodeObservation {
                    if let desc = barcode.barcodeDescriptor as? CIQRCodeDescriptor {
                        print(desc.symbolVersion)
                        let content = String(data: desc.errorCorrectedPayload, encoding: .utf8)
                        let resultStr = """
                        Symbology: \(barcode.symbology.rawValue)\n
                        Payload: \(String(describing: content))\n
                        Error-Correction-Level:\(desc.errorCorrectionLevel)\n
                        Symbol-Version: \(desc.symbolVersion)\n
                        """
                        DispatchQueue.main.async {
                            barcodeString = resultStr
                        }
                    }
                }
            }
        })
        return barcodeString
    }
    
}
