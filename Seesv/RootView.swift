//
//  RootView.swift
//  TextScanner
//
//  Created by Aiden Appleby on 2/11/23.
//

import Foundation
import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

struct RootView: View {
    @EnvironmentObject var vm: AppViewModel
    
    @State var devices: [Device] = []
    @State var csvStringInput = ""
    
    enum TabItem {
        case manageSources, preview, peaches
    }
    @State var selectedItem = TabItem.preview

    var body: some View {
        TabView(selection: $selectedItem) {
            DatasetView(csvInput: $csvStringInput.onChange(handleCSVChange))
                .tabItem {
                    Image(systemName: "plus.square")
                }
                .tag(TabItem.manageSources)

            ContentView(devices: $devices)
                .environmentObject(vm)
                .tabItem {
                    Image(systemName: "camera.viewfinder")
                }
                .tag(TabItem.preview)
            Text("Manage Actions")
                .tabItem {
                    Image(systemName: "slider.horizontal.2.square.badge.arrow.down")
                }
                .tag(TabItem.peaches)
        }
    }
    
    func handleCSVChange(newValue: String) {
        devices = parseDeviceStr(input: newValue)
    }
}

struct DatasetView: View {
    
    @Binding var csvInput: String
    
    @State var showFileFinder: Bool = false
    @State var showPreview: Bool = false
    @State var fileURL: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Text("Manage Datasets").font(.largeTitle)
                Button(action: {
                    showFileFinder.toggle()
                }) {
                    Text("Import CSV")
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                if fileURL != "" {
                    Button(action: {
                        showPreview.toggle()
                    }) {
                        Text("Preview CSV")
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(10)
                    }
                }
            }
            .padding(30)
            .fileImporter(isPresented: $showFileFinder, allowedContentTypes: [.text]) { (res) in
                do {
                    let urlFromResponse = try res.get()
                    
                    fileURL = urlFromResponse.absoluteString
                    guard urlFromResponse.startAccessingSecurityScopedResource() else {
                        return
                    }
                    defer { urlFromResponse.stopAccessingSecurityScopedResource() }
                    
                    let data = try! Data(contentsOf: urlFromResponse)
                    let string = String(data: data, encoding: .utf8)!
                    csvInput = string
                } catch {
                    print("Error reading files")
                    print(error.localizedDescription)
                }
            }
            .sheet(isPresented: $showPreview) {
                PreviewCSVView(csvInput: csvInput)
            }
        }
    }
}

struct PreviewCSVView: View {
    
    @State var csvInput: String
    @State private var selection: Device.ID?
    @State private var path = [Device]()
    @State private var devices: [Device] = [Device]()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading) {
                Text("Devices")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                Table(devices, selection: $selection) {
                    TableColumn("Device Name", value: \.deviceName)
                }
            }
            .padding()
            .navigationDestination(for: Device.self) { device in
                Text("\(device.serialNumber)")
            }
            .onAppear() {
                selection = nil
            }
        }
        .onChange(of: selection) { selection in
            if let selection = selection,
               let device = parseDeviceStr(input: csvInput).first(where: {$0.id == selection}) {
                path.append(device)
            }
        }
        .onAppear {
            devices = parseDeviceStr(input: csvInput)
        }
        
    }
}

func parseDeviceStr(input: String) -> [Device] {
    let rows = input.split(separator: "\r\n")
    var json: [Device] = []

    for row in rows {
        let columns = row.split(separator: ",")
        let serialNumber = String(columns[0])
        let deviceName = String(columns[1])
        if deviceName == "Device Name" {
            continue
        }
        let model = String(columns[2])
        let checked = columns[3] == "true"

        let device = Device(serialNumber: serialNumber, deviceName: deviceName, model: model, checked: checked)
        json.append(device)
    }

    return json
}
