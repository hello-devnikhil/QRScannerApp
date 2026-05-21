import Foundation
import AVFoundation

enum ScanState: Equatable {
    case idle
    case scanning
    case processing
    case success(String)
    case error(String)
}

@MainActor
class ScannerViewModel: ObservableObject {
    
    @Published var state: ScanState = .idle
    @Published var hasCameraPermission: Bool = false
    
    func processQRCode(_ code: String) {
        guard state != .processing, state != .success(code) else { return }
        
        state = .processing
        // Add a slight delay to avoid rapid repeated scans of the same code
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.state = .success(code)
        }
    }
    
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            hasCameraPermission = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                Task { @MainActor in
                    self?.hasCameraPermission = granted
                }
            }
        default:
            hasCameraPermission = false
        }
    }
    
    func resumeScanning() {
        state = .scanning
    }
}
