import SwiftUI
import AVFoundation
import UIKit

struct SelfieCameraView: UIViewRepresentable {
    @ObservedObject var controller: CameraController
    func makeUIView(context: Context) -> CameraPreviewView {
        let view = CameraPreviewView()
        view.configure(session: controller.captureSession)
        controller.previewVisibilityHandler = { [weak view] visible in view?.setVisible(visible) }
        view.setVisible(controller.isPreviewVisible)
        return view
    }
    func updateUIView(_ view: CameraPreviewView, context: Context) { view.setVisible(controller.isPreviewVisible) }
    static func dismantleUIView(_ view: CameraPreviewView, coordinator: ()) {
        view.setVisible(false)
        view.disconnect()
    }
}

final class CameraPreviewView: UIView {
    private let privacyCover = UIView()
    private var inactivityObserver: NSObjectProtocol?
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    private var previewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        privacyCover.backgroundColor = .black
        privacyCover.isUserInteractionEnabled = false
        addSubview(privacyCover)
        inactivityObserver = NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] _ in
            // Do not wait for SwiftUI or stopRunning before hiding a retained video frame.
            MainActor.assumeIsolated { self?.setVisible(false) }
        }
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    deinit { if let inactivityObserver { NotificationCenter.default.removeObserver(inactivityObserver) } }
    override func layoutSubviews() {
        super.layoutSubviews()
        privacyCover.frame = bounds
        applyConnection()
    }
    func configure(session: AVCaptureSession?) {
        previewLayer.backgroundColor = UIColor.black.cgColor
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.session = session
        applyConnection()
    }
    func setVisible(_ visible: Bool) {
        applyConnection()
        privacyCover.isHidden = visible && UIApplication.shared.applicationState == .active
    }
    func disconnect() { previewLayer.session = nil }
    private func applyConnection() {
        // Configuration is asynchronous; reapply after running/update/layout when it exists.
        guard let connection = previewLayer.connection else { return }
        if connection.isVideoMirroringSupported {
            connection.automaticallyAdjustsVideoMirroring = false
            connection.isVideoMirrored = true
        }
        if connection.isVideoRotationAngleSupported(90) { connection.videoRotationAngle = 90 }
    }
}
