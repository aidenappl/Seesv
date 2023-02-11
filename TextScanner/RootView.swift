//
//  RootView.swift
//  TextScanner
//
//  Created by Aiden Appleby on 2/11/23.
//

import Foundation
import SwiftUI

struct RootView: View {
    @EnvironmentObject var vm: AppViewModel
    
    enum TabItem {
        case manageSources, preview, peaches
    }
    @State var selectedItem = TabItem.preview

    var body: some View {
        TabView(selection: $selectedItem) {
            Text("Bananas 🍌🍌")
                .tabItem {
                    Image(systemName: "plus.square")
                }
                .tag(TabItem.manageSources)

            ContentView()
                .environmentObject(vm)
                .tabItem {
                    Image(systemName: "camera.viewfinder")
                }
                .tag(TabItem.preview)

            Text("Peaches 🍑🍑")
                .tabItem {
                    Image(systemName: "slider.horizontal.2.square.badge.arrow.down")
                }
                .tag(TabItem.peaches)
        }
    }
}

