import SwiftUI
import AVFoundation
import UIKit
import Playgrounds

@main struct MyApp: App {
    init() {
        UIWindow.appearance().backgroundColor = .black
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .presentationBackground(.black)
        }
    }
}

struct ContentView: View {
    @State private var cameraAccess: CameraAccess = .checking
    @State private var lightIsOn = false
    @State private var cameraZoom = 1.0

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            switch cameraAccess {
            case .checking:
                ProgressView()
                    .tint(.white)
            case .authorized:
                GeometryReader { geometry in
                    let lightBarThickness = lightIsOn ? lightThickness(for: geometry.size) : 0

                    ZStack {
                        SelfieCameraView()
                            .ignoresSafeArea()
                            .scaleEffect(cameraZoom)
                            .clipped()

                        MirrorLightOverlay(isOn: lightIsOn, thickness: lightBarThickness)
                            .ignoresSafeArea()
                            .allowsHitTesting(false)

                        ScreenBrightnessView(isOn: lightIsOn)
                            .frame(width: 0, height: 0)
                            .allowsHitTesting(false)

                        VStack {
                            Spacer()

                            MirrorControlBar(
                                lightIsOn: $lightIsOn,
                                cameraZoom: $cameraZoom
                            )
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 18)
                    }
                }
                .ignoresSafeArea()
            case .denied:
                Text("Camera access is needed to use Mirror.")
                    .font(.body)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .task {
            cameraAccess = await CameraAccess.requestCurrent()
        }
    }

    private func lightThickness(for size: CGSize) -> CGFloat {
        min(max(min(size.width, size.height) * 0.08, 34), 64)
    }
}

private struct MirrorControlBar: View {
    @Binding var lightIsOn: Bool
    @Binding var cameraZoom: Double

    var body: some View {
        HStack(spacing: 14) {
            LightButton(isOn: $lightIsOn)

            ControlSlider(
                leadingSystemName: "minus.magnifyingglass",
                trailingSystemName: "plus.magnifyingglass",
                value: $cameraZoom,
                range: 1.0...3.0
            )
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.black.opacity(0.35), in: Capsule())
    }
}

private struct ControlSlider: View {
    let leadingSystemName: String
    let trailingSystemName: String
    @Binding var value: Double
    let range: ClosedRange<Double>

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: leadingSystemName)
                .foregroundStyle(.white.opacity(0.85))
                .frame(width: 24)

            Slider(value: $value, in: range)
                .tint(.white)

            Image(systemName: trailingSystemName)
                .foregroundStyle(.white)
                .frame(width: 24)
        }
    }
}

private struct LightButton: View {
    @Binding var isOn: Bool

    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            isOn.toggle()
        } label: {
            Image(systemName: isOn ? "sun.max.fill" : "sun.min.fill")
                .foregroundStyle(isOn ? .yellow : .white)
                .frame(width: 44, height: 44)
                .background(isOn ? .yellow.opacity(0.24) : .white.opacity(0.1), in: Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Mirror light")
        .accessibilityValue(isOn ? "On" : "Off")
    }
}

private struct MirrorLightOverlay: View {
    let isOn: Bool
    let thickness: CGFloat

    var body: some View {
        if isOn {
            GeometryReader { geometry in
                let innerCornerRadius = thickness * 1.8
                let bounds = CGRect(origin: .zero, size: geometry.size)
                let innerBounds = bounds.insetBy(dx: thickness, dy: thickness)

                Path { path in
                    path.addRect(bounds)
                    path.addRoundedRect(
                        in: innerBounds,
                        cornerSize: CGSize(width: innerCornerRadius, height: innerCornerRadius)
                    )
                }
                .fill(.white, style: FillStyle(eoFill: true))
                .animation(.easeInOut(duration: 0.2), value: isOn)
            }
        }
    }
}

private struct ScreenBrightnessView: UIViewRepresentable {
    let isOn: Bool

    func makeUIView(context: Context) -> ScreenBrightnessHostView {
        let view = ScreenBrightnessHostView()
        view.update(isOn: isOn)
        return view
    }

    func updateUIView(_ uiView: ScreenBrightnessHostView, context: Context) {
        uiView.update(isOn: isOn)
    }

    static func dismantleUIView(_ uiView: ScreenBrightnessHostView, coordinator: ()) {
        uiView.restoreScreenBrightness()
    }
}

private final class ScreenBrightnessHostView: UIView {
    private var isOn = false
    private var originalScreenBrightness: CGFloat?
    private weak var brightnessScreen: UIScreen?

    override func didMoveToWindow() {
        super.didMoveToWindow()
        applyScreenBrightness()
    }

    func update(isOn: Bool) {
        self.isOn = isOn
        applyScreenBrightness()
    }

    func restoreScreenBrightness() {
        guard let originalScreenBrightness else { return }
        brightnessScreen?.brightness = originalScreenBrightness
        self.originalScreenBrightness = nil
        brightnessScreen = nil
    }

    private func applyScreenBrightness() {
        guard let screen = window?.windowScene?.screen else { return }

        guard isOn else {
            restoreScreenBrightness()
            return
        }

        if originalScreenBrightness == nil {
            originalScreenBrightness = screen.brightness
            brightnessScreen = screen
        }

        screen.brightness = 1.0
    }
}

private enum CameraAccess {
    case checking
    case authorized
    case denied

    static func requestCurrent() async -> CameraAccess {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return .authorized
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            return granted ? .authorized : .denied
        case .denied, .restricted:
            return .denied
        @unknown default:
            return .denied
        }
    }
}

private struct SelfieCameraView: UIViewRepresentable {
    func makeUIView(context: Context) -> CameraPreviewView {
        let view = CameraPreviewView()
        view.configure(with: context.coordinator.session)
        context.coordinator.startSession()
        return view
    }

    func updateUIView(_ uiView: CameraPreviewView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    static func dismantleUIView(_ uiView: CameraPreviewView, coordinator: Coordinator) {
        coordinator.stopSession()
    }

    final class Coordinator {
        let session = AVCaptureSession()
        private let sessionQueue = DispatchQueue(label: "Mirror.camera.session")

        init() {
            configureSession()
        }

        func startSession() {
            sessionQueue.async { [session] in
                guard !session.isRunning else { return }
                session.startRunning()
            }
        }

        func stopSession() {
            sessionQueue.async { [session] in
                guard session.isRunning else { return }
                session.stopRunning()
            }
        }

        private func configureSession() {
            sessionQueue.async { [session] in
                session.beginConfiguration()
                session.sessionPreset = .high

                defer {
                    session.commitConfiguration()
                }

                guard
                    let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
                    let input = try? AVCaptureDeviceInput(device: camera),
                    session.canAddInput(input)
                else {
                    return
                }

                session.addInput(input)
            }
        }
    }
}

private final class CameraPreviewView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .black
    }

    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    private var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }

    func configure(with session: AVCaptureSession) {
        previewLayer.backgroundColor = UIColor.black.cgColor
        previewLayer.session = session
        previewLayer.videoGravity = .resizeAspectFill

        if let connection = previewLayer.connection {
            connection.automaticallyAdjustsVideoMirroring = false
            connection.isVideoMirrored = true
        }
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
