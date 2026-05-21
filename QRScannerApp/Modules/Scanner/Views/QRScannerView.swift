import UIKit
import AVFoundation

class QRScannerView: UIView {

    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    private let overlayLayer = CAShapeLayer()
    private let frameLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayers() {
        backgroundColor = .black

        overlayLayer.fillColor = UIColor.black.withAlphaComponent(0.6).cgColor
        layer.addSublayer(overlayLayer)

        frameLayer.strokeColor = UIColor.systemGreen.cgColor
        frameLayer.lineWidth = 4.0
        frameLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(frameLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        videoPreviewLayer?.frame = bounds
        updateOverlay()
    }

    private func updateOverlay() {
        let overlayPath = UIBezierPath(rect: bounds)

        // Define scanning area (center square)
        let scanAreaSize: CGFloat = min(bounds.width, bounds.height) * 0.7
        let scanAreaRect = CGRect(
            x: (bounds.width - scanAreaSize) / 2,
            y: (bounds.height - scanAreaSize) / 2,
            width: scanAreaSize,
            height: scanAreaSize
        )

        let transparentPath = UIBezierPath(roundedRect: scanAreaRect, cornerRadius: 16.0)
        overlayPath.append(transparentPath)
        overlayPath.usesEvenOddFillRule = true

        overlayLayer.path = overlayPath.cgPath
        overlayLayer.fillRule = .evenOdd

        frameLayer.path = transparentPath.cgPath
    }

    func setupCamera(delegate: AVCaptureMetadataOutputObjectsDelegate) throws {
        let session = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            throw NSError(domain: "QRScannerView", code: 1, userInfo: [NSLocalizedDescriptionKey: "No video device found"])
        }

        let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)

        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        } else {
            throw NSError(domain: "QRScannerView", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not add video input"])
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417]
        } else {
            throw NSError(domain: "QRScannerView", code: 3, userInfo: [NSLocalizedDescriptionKey: "Could not add metadata output"])
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        layer.insertSublayer(previewLayer, at: 0)

        self.videoPreviewLayer = previewLayer
        self.captureSession = session
    }

    func startScanning() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }

    func stopScanning() {
        captureSession?.stopRunning()
    }
}
