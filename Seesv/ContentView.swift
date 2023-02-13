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
    
    @Binding var devices: [Device]
    @EnvironmentObject var vm: AppViewModel
    
    @State private var showModal = false
    @State private var isScanningPaused: Bool = false
    @State private var showDataScanner: Bool = true
    
    @State private var foundDevice: Device = Device(serialNumber: "", deviceName: "", model: "", checked: false)
    @State private var permanentDevices: [Device] = []
    
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
        GeometryReader { geometry in
            VStack {
                if showDataScanner {
                    DataScannerView(
                        recognizedItems: $vm.recognizedItems,
                        recognizedDataType: $vm.recognizedDataType.wrappedValue,
                        recognizesMultipleItems: $vm.recognizesMultipleItems.wrappedValue,
                        isScanningPaused: isScanningPaused)
                    .background { Color.gray.opacity(0.3) }
                    .ignoresSafeArea()
                    .id(vm.dataScannerViewId)
                } else {
                        VStack(spacing: 0) {
                            Text("Scanner Hidden")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .frame(height: geometry.size.height * 0.50)
                        }
                }
                
                VStack {
                    headerView
                    resultView
                }.background { Color.gray.opacity(0.15) }
            }
            .onChange(of: vm.scanType) { _ in vm.recognizedItems = [] }
            .onChange(of: vm.textContentType) { _ in vm.recognizedItems = [] }
            .onChange(of: vm.recognizesMultipleItems) { _ in vm.recognizedItems = [] }
        }
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
        let textIn = "check \(text)"
        let serialSplit = textIn.split(separator: "Serial")
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
        VStack(alignment: .leading) {
            HStack {
                Picker("Scan Type", selection: $vm.scanType) {
                    Text("Barcode").tag(ScanType.barcode)
                    Text("Text").tag(ScanType.text)
                }.pickerStyle(.segmented)
                Toggle("Scan multiple", isOn: $vm.recognizesMultipleItems)
                    .padding(.leading, 20)
            }.padding(.top)
            
            if permanentDevices.count > 0 {
                Button(action: {
                    permanentDevices = []
                }) {
                    Text("Clear History")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                }
            }
            
            Text(vm.headerText).padding(.top)
        }.padding(.horizontal)
    }
    
    private var resultView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(permanentDevices) { device in
                    Text("Model: \(device.model) \nSerial: \(device.serialNumber)")
                    Button(action: {
                        self.showModal = true;
                        self.foundDevice = device;
                        self.isScanningPaused = true;
                        self.showDataScanner = false;
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
                ForEach(vm.recognizedItems) { item in
                    switch item {
                    case .barcode(let barcode):
                        Text(barcode.payloadStringValue ?? "Unknown barcode")
                    case .text(let text):
                        let model = processModel(text: text.transcript)
                        let serial = processSerial(text: text.transcript)
                        if serial != "" {
                            let targetDevice = findDevice(serial: serial)
                            
                            if (model != "") {
                                Text("Model: \(model) \nSerial: \(serial)")
                            } else {
                                Text("Serial: \(serial)")
                            }
                            
                            if targetDevice != nil {
                                Button(action: {
                                    self.showModal = true;
                                    self.foundDevice = targetDevice!;
                                    self.isScanningPaused = true;
                                    self.showDataScanner = false;
                                }) {
                                    Text("View Device")
                                    
                                        .foregroundColor(.white)
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                            } else {
                                Button(action: {
                                    // do something
                                }) {
                                    Text("No Devices Found...")
                                        .foregroundColor(.white)
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .padding()
                                        .background(Color.gray)
                                        .cornerRadius(10)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                            }
                        }
                    @unknown default:
                        Text("Unknown")
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .sheet(isPresented: $showModal) {
                ModalView(device: $foundDevice)
                    .onDisappear {
                        self.isScanningPaused = false;
                        self.showDataScanner = true;
                        vm.recognizedItems = []
                }
            }
        }

    }
    
    func findDevice(serial: String) -> Device? {
        print("finding device")
        let foundDevice: Device? = devices.first(where: { $0.serialNumber == serial })
        let anyDevice: Any? = foundDevice
        if anyDevice == nil {
            return foundDevice
        }
        
        if permanentDevices.firstIndex(where: {$0.serialNumber == foundDevice!.serialNumber}) != nil {
            return foundDevice
        }
        permanentDevices.append(Device(serialNumber: foundDevice!.serialNumber, deviceName: foundDevice!.deviceName, model: foundDevice!.model, checked: foundDevice!.checked))
        return foundDevice
    }
}

struct ModalView: View {
    
    @Binding var device: Device
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text("Device: \(device.deviceName)").font(.largeTitle)
                    
                }
            }
        }
    }
}

struct Device: Codable, Identifiable, Hashable {
    var id: String { serialNumber }
    let serialNumber: String
    let deviceName: String
    let model: String
    let checked: Bool
}
