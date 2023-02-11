//
//  DataScannerView.swift
//  TextScanner
//
//  Created by Aiden Appleby on 2/11/23.
//

import Foundation
import SwiftUI
import VisionKit

struct DataScannerView: UIViewControllerRepresentable {
    
    let recognizedDataType: DataScannerViewController.RecognizedDataType
    
    func makeUIViewController(context: Context) -> some DataScannerViewController {
        let vc = DataScannerViewController(
            recognizedDataTypes: [.])
    }
    
}
