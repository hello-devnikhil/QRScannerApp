//
//  ContentView.swift
//  QRScannerApp
//
//  Created by Nikhil Kumar on 21/05/26.
//

import SwiftUI

struct ContentView: View {
    @State private var scannerPath = NavigationPath()
    
    var body: some View {
        TabView {
            NavigationStack(path: $scannerPath) {
                ScannerScreen(navigationPath: $scannerPath)
                    .navigationDestination(for: String.self) { barcode in
                        ProductDetailScreen(barcode: barcode)
                    }
            }
            .tabItem {
                Label("Scan", systemImage: "qrcode.viewfinder")
            }
            
            NavigationStack {
                HistoryScreen()
            }
            .tabItem {
                Label("History", systemImage: "clock.fill")
            }
        }
        .tint(Theme.primary)
    }
}

#Preview {
    ContentView()
}
