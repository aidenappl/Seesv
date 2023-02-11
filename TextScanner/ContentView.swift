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
    @State private var showModal = false
    @State private var isScanningPaused: Bool = false
    @State private var showDataScanner: Bool = true
    
    var csvString = "Serial Number,Device Name,Model,Checked\nDMPZTE6RKD6L,Aiden’s iPad,A1980,FALSE\nMZX6DQAZ8AYF,iPad,A1980,FALSE\nXZMXUEXYKER9,iPad,A1980,FALSE\nJLPRH2P2ESQ7,iPad,A1980,FALSE\nJB6VPKMB2V47,iPad,A1980,FALSE\nHLX9YQDT7NYF,iPad,A1980,FALSE\nZLC5U2SZXUQU,iPad,A1980,FALSE\nHPC3HASX47FD,iPad,A1980,FALSE\n4PJFLLLN5CCL,iPad,A1980,FALSE\nE8KCLZM9Q4L9,iPad,A1980,FALSE\nERV2J8T6KW2L,iPad,A1980,FALSE\n4NTPRUC8DAJF,iPad,A1980,FALSE\nSBTTP2GMCSD7,iPad,A1980,FALSE\nUYY338C99FUC,iPad,A1980,FALSE\nF5289HVQ33BX,iPad,A1980,FALSE\n5UW6M4ZJCJGG,iPad,A1980,FALSE\n9GV27AWH3JTR,iPad,A1980,FALSE\nPDVVN9YHVSE6,iPad,A1980,FALSE\nWNC5TCMXR8TB,iPad,A1980,FALSE\nZM7MJEKC9BCJ,iPad,A1980,FALSE\nGEGHC87NJRR2,iPad,A1980,FALSE\n8YLUB7TXX74D,iPad,A1980,FALSE\nY4LE5BTYYQMF,iPad,A1980,FALSE\nH2BKWBTCLPLL,iPad,A1980,FALSE\n3D5U6KKWMQXA,iPad,A1980,FALSE\nTFTD43SVNM2E,iPad,A1980,FALSE\nATJRLU2KSN59,iPad,A1980,FALSE\n8SWJUBECJAHB,iPad,A1980,FALSE\nSVVLL5HYH2BL,iPad,A1980,FALSE\n7RQ96Q5667YY,iPad,A1980,FALSE\nL934WPUZTLQG,iPad,A1980,FALSE\n2VXRADKM32TN,iPad,A1980,FALSE\nHH8B2Z5FJDLN,iPad,A1980,FALSE\nXQ4G9XGRB9SF,iPad,A1980,FALSE\n6GE66KKJTJW5,iPad,A1980,FALSE\n4NDAYHPDLKYZ,iPad,A1980,FALSE\nX7K4A9NMVCGM,iPad,A1980,FALSE\n7P2VEEYCPK4X,iPad,A1980,FALSE\nQVT35HKPJ43H,iPad,A1980,FALSE\nNBM89CQTAU45,iPad,A1980,FALSE\nTWDWRC86CRY2,iPad,A1980,FALSE\n7MWAQMBQVELG,iPad,A1980,FALSE\nMV23W7ASDNCT,iPad,A1980,FALSE\nAW5XLPAJJSAH,iPad,A1980,FALSE\nL83MT9JALMFT,iPad,A1980,FALSE\nH5FEYYM2W83M,iPad,A1980,FALSE\n4X8DTAEEF53S,iPad,A1980,FALSE\nG297BXKCTHN6,iPad,A1980,FALSE\n3YET73K6HG8S,iPad,A1980,FALSE\n87TS5JGUQWFN,iPad,A1980,FALSE\n6F76CKHPC5SP,iPad,A1980,FALSE\nW8US5W59SB9U,iPad,A1980,FALSE\nYCYG658TMTVW,iPad,A1980,FALSE\nJFGKXN6UQ835,iPad,A1980,FALSE\n3R3PLP4LFQLZ,iPad,A1980,FALSE\nYEZUFPJKL5PE,iPad,A1980,FALSE\nT4FSJ7KM6RSV,iPad,A1980,FALSE\n6U4HRM9V4FSA,iPad,A1980,FALSE\n9RB456YSWY42,iPad,A1980,FALSE\nPEN4S72ULF2M,iPad,A1980,FALSE\nJCR7TSSP2A3B,iPad,A1980,FALSE\n27EZK8MK3BKL,iPad,A1980,FALSE\nVN5MMRB7PDT8,iPad,A1980,FALSE\nUTW2QV75JQAC,iPad,A1980,FALSE\nB8HAWSUWQVFZ,iPad,A1980,FALSE\n8RHG2LNLGKQF,iPad,A1980,FALSE\nR66LAZG5Q9YB,iPad,A1980,FALSE\n5T28LAY7XVEW,iPad,A1980,FALSE\nZRRPC8WURR28,iPad,A1980,FALSE\n2VELJJ6GMVA7,iPad,A1980,FALSE\n7TTRAYSHWL5A,iPad,A1980,FALSE\nJAAA3ZLSWY86,iPad,A1980,FALSE\n43F6DYHV7MES,iPad,A1980,FALSE\nY7ECTN5QKXT3,iPad,A1980,FALSE\nVPSFMN88JQUB,iPad,A1980,FALSE\nE26E48BBPYKW,iPad,A1980,FALSE\nTT5M7L24R33R,iPad,A1980,FALSE\nVNGSVGNJ5JAH,iPad,A1980,FALSE\n6YX7ZRD4YQVX,iPad,A1980,FALSE\nKDYYAHUFPUZV,iPad,A1980,FALSE\nGLLMCQ524EJE,iPad,A1980,FALSE\nF7533XWAUS6J,iPad,A1980,FALSE\n66K42772NP6S,iPad,A1980,FALSE\n8R9FYQ2QALQN,iPad,A1980,FALSE\n4NXCYDAR4PF3,iPad,A1980,FALSE\nT8WJZYAR95PK,iPad,A1980,FALSE\nKSEYDJJ5C6QK,iPad,A1980,FALSE\nMNWPL4GA5YF8,iPad,A1980,FALSE\nKNBUJYXRYVA5,iPad,A1980,FALSE\nC2TSGR6A6NCB,iPad,A1980,FALSE\nZRD3WPZMD8NP,iPad,A1980,FALSE\nDQKGSZNY72N3,iPad,A1980,FALSE\nW8S4YJZ88XXQ,iPad,A1980,FALSE\nM9R7JCSAA84E,iPad,A1980,FALSE\n7Z25DJHW5LHM,iPad,A1980,FALSE\nRXS6BMNDRJV7,iPad,A1980,FALSE\nRJBJSMDF4LCE,iPad,A1980,FALSE\n3WMWCLVY5JT3,iPad,A1980,FALSE\nE6N6BMJ4EP9B,iPad,A1980,FALSE\nZ3HRS992RJCL,iPad,A1980,FALSE"
    
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
    
    func searchCSV(csv: String, columnHeader: String, searchValue: String) -> [String] {
        let rows = csv.split(separator: "\n")
        let header = rows.first!.split(separator: ",")
        
        guard let columnIndex = header.firstIndex(where: { String($0) == columnHeader }) else {
            return []
        }
        
        let filteredRows = rows.filter { row in
            let columns = row.split(separator: ",")
            return columns[columnIndex] == searchValue
        }
        
        return filteredRows.map { String($0) }
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
    
    private var resultView: some View {
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
                            let deviceFound = searchCSV(csv: csvString, columnHeader: "Serial Number", searchValue: serial)
                            
                            if (model != "") {
                                Text("Model: \(model) \nSerial: \(serial)")
                            } else {
                                Text("Serial: \(serial)")
                            }
                            
                            if deviceFound.count > 0 {
                                Button(action: {
                                    self.showModal = true;
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
                ModalView()
                    .onDisappear {
                        self.isScanningPaused = false;
                        self.showDataScanner = true;
                        vm.recognizedItems = []
                    }
            }
        }

    }
}

struct ModalView: View {
    var body: some View {
        Text("This is a modal")
    }
}
