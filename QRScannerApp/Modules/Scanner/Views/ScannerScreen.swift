import SwiftUI

struct ScannerScreen: View {
    @EnvironmentObject var viewModel: ScannerViewModel
    @Environment(\.colorScheme) var colorScheme
    
    // We will use NavigationPath for navigation in iOS 16+
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            if viewModel.hasCameraPermission {
                CameraPreview(viewModel: viewModel)
                    .ignoresSafeArea(edges: .top)
                
                VStack {
                    Spacer()
                    
                    instructionsCard
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                }
            } else {
                permissionDeniedView
            }
        }
        .navigationTitle("Scan QR")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.checkCameraPermission()
            viewModel.resumeScanning()
        }
        .onChange(of: viewModel.state) { newValue in
            if case .success(let code) = newValue {
                navigationPath.append(code)
            }
        }
    }
    
    private var instructionsCard: some View {
        VStack(spacing: 8) {
            Image(systemName: "qrcode.viewfinder")
                .font(.system(size: 32))
                .foregroundColor(Theme.primary)
                .padding(.bottom, 4)
            
            Text("Align QR Code")
                .font(.headline)
                .foregroundColor(Theme.text)
            
            Text("Place the QR code inside the frame to scan")
                .font(.subheadline)
                .foregroundColor(Theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(Theme.cornerRadius)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private var permissionDeniedView: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.slash")
                .font(.system(size: 64))
                .foregroundColor(Theme.error)
            
            Text("Camera Access Required")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("We need camera permission to scan product QR codes.")
                .multilineTextAlignment(.center)
                .foregroundColor(Theme.secondaryText)
                .padding(.horizontal, 32)
            
            Button(action: {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Open Settings")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: Theme.buttonHeight)
                    .frame(maxWidth: .infinity)
                    .background(Theme.accentGradient)
                    .cornerRadius(Theme.cornerRadius)
                    .shadow(color: Theme.primary.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.horizontal, 32)
            .padding(.top, 16)
            
            // Debug: Simulate QR scan
            Button("Simulate Scan") {
                viewModel.processQRCode("VALID123")
            }
            .padding()
            .background(Color.green.opacity(0.2))
            .cornerRadius(8)
        }
    }
}
