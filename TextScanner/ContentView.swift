//
//  ContentView.swift
//  TextScanner
//
//  Created by Aiden Appleby on 2/10/23.
//

import SwiftUI
import VisionKit
import AVFoundation

struct ContentView: View {
    
    @EnvironmentObject var vm: AppViewModel
    

    private let textContentTypes: [(title: String, textContentType: DataScannerViewController.TextContentType?)] = [
        ("All", .none),
        ("URL", .URL),
        ("Phone", .telephoneNumber),
        ("Email", .emailAddress),
    ]
    
    var body: some View {
        switch vm.dataScannerAccessStatus {
        case .scannerAvailable:
            mainView
        case .cameraNotAvailable:
            Text("Could not detect a camera")
        case .scannerNotAvailable:
            Text("Your device does not have support for LiveText")
        case .cameraAccessNotGranted:
            Text("Please allow TextScanner to access your camera in settings")
        case .notDetermined:
            Text("Requesting camera access")
        }
    }
    
    private var mainView: some View {
        
        VStack {
            DataScannerView(
                recognizedItems: $vm.recognizedItems,
                recognizedDataType: $vm.recognizedDataType.wrappedValue,
                recognizesMultipleItems: $vm.recognizesMultipleItems.wrappedValue)
            .background { Color.gray.opacity(0.3) }
            .ignoresSafeArea()
            .id(vm.dataScannerViewId)
            
            VStack {
                headerView
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(vm.recognizedItems) { item in
                            switch item {
                            case .barcode(let barcode):
                                Text(barcode.payloadStringValue ?? "Unknown barcode")
                            case .text(let text):
                                let model = processModel(text: text.transcript)
                                let serial = processSerial(text: text.transcript)
                                if serial != "" {
                                    if (model != "") {
                                        Text("Model: \(model) \nSerial: \(serial)")
                                    } else {
                                        Text("Serial: \(serial)")
                                    }
                                    Button(action: {
                                    }) {
                                        Text("View Device")
                                            .foregroundColor(.white)
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            .padding()
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                }
                            @unknown default:
                                Text("Unknown")
                            }
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                }
            }
        }
        .onChange(of: vm.scanType) { _ in vm.recognizedItems = [] }
        .onChange(of: vm.textContentType) { _ in vm.recognizedItems = [] }
        .onChange(of: vm.recognizesMultipleItems) { _ in vm.recognizedItems = [] }
    }
    
    private func processModel(text: String) -> String {
        let newlineSplit = text.split(separator: "\n")
        var finalProduct = ""
        if (newlineSplit.count > 1) {
            finalProduct = String(newlineSplit[0])
            
            let modelSplit = finalProduct.split(separator: "Model")
            if (modelSplit.count > 1) {
                finalProduct = modelSplit[1].trimmingCharacters(in: .whitespaces)
                return String(finalProduct)
            }
        }
        return ""
    }

    private func processSerial(text: String) -> String {
        let serialSplit = text.split(separator: "Serial")
        var finalProduct = ""
        if (serialSplit.count > 1) {
            finalProduct = String(serialSplit[1])
            finalProduct = finalProduct.replacingOccurrences(of: ":", with: "")
            finalProduct = finalProduct.trimmingCharacters(in: .whitespaces)
            return String(finalProduct)
        }
        return ""
    }
    
    private var headerView: some View {
        VStack {
            HStack {
                Picker("Scan Type", selection: $vm.scanType) {
                    Text("Barcode").tag(ScanType.barcode)
                    Text("Text").tag(ScanType.text)
                }.pickerStyle(.segmented)
                Toggle("Scan multiple", isOn: $vm.recognizesMultipleItems)
                    .padding(.leading, 20)
            }.padding(.top)
            
            if vm.scanType == .text {
                Picker("Text content type", selection: $vm.textContentType) {
                    ForEach(textContentTypes, id: \.self.textContentType) { option in
                        Text(option.title).tag(option.textContentType)
                    }
                }.pickerStyle(.segmented)
            }
            
            Text(vm.headerText).padding(.top)
        }.padding(.horizontal)
    }
}
