import SwiftUI
import AVFoundation
import UIKit

/// A SwiftUI wrapper around `QRScannerView` which handles the camera preview and QR‑code detection.
/// It forwards scanner events to `ScannerViewModel`.
struct CameraPreview: UIViewRepresentable {
    // MARK: - Types
    typealias UIViewType = QRScannerView

    // MARK: - Properties
    @ObservedObject var viewModel: ScannerViewModel

    // MARK: - UIViewRepresentable
    func makeUIView(context: Context) -> UIViewType {
        let scannerView = QRScannerView()
        // Configure camera and delegate
        do {
            try scannerView.setupCamera(delegate: context.coordinator)
            // Start scanning only when the view model is in a scanning state.
            if viewModel.state == .idle || viewModel.state == .scanning {
                scannerView.startScanning()
            }
        } catch {
            print("Camera setup failed: \(error)")
            DispatchQueue.main.async {
                viewModel.state = .error("Failed to initialize camera")
            }
        }
        return scannerView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // React to view‑model state changes.
        switch viewModel.state {
        case .scanning:
            uiView.startScanning()
        case .processing, .idle, .error:
            uiView.stopScanning()
        case .success:
            // Keep running – navigation will happen in the parent view.
            break
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    // MARK: - Coordinator
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var viewModel: ScannerViewModel
        init(viewModel: ScannerViewModel) { self.viewModel = viewModel }
        func metadataOutput(_ output: AVCaptureMetadataOutput,
                          didOutput metadataObjects: [AVMetadataObject],
                          from connection: AVCaptureConnection) {
            guard let metadataObject = metadataObjects.first,
                  let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue else { return }
            // Haptic feedback
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            // Forward to view model on the main actor.
            Task { @MainActor in
                viewModel.processQRCode(stringValue)
            }
        }
    }
}
