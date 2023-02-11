//
//  ContentView.swift
//  TextScanner
//
//  Created by Aiden Appleby on 2/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        switch vm.dataScannerAccessStatus {
        case .scannerAvailable:
            Text("Scanner is available")
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
