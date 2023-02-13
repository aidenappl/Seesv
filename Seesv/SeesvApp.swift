//
//  TextScannerApp.swift
//  TextScanner
//
//  Created by Aiden Appleby on 2/10/23.
//

import SwiftUI

@main
struct SeesvApp: App {
    
    @StateObject private var vm = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(vm)
                .task {
                    await vm.requestDataScannerAccessStats()
                }
        }
    }
}
