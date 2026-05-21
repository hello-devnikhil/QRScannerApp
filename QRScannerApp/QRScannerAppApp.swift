//
//  QRScannerAppApp.swift
//  QRScannerApp
//
//  Created by Nikhil Kumar on 21/05/26.
//

import SwiftUI

@main
struct QRScannerAppApp: App {
    // Shared view‑model instances
    @StateObject private var scannerViewModel = ScannerViewModel()
    @StateObject private var errorViewModel = ErrorViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(scannerViewModel)
                .environmentObject(errorViewModel)
        }
    }
}
