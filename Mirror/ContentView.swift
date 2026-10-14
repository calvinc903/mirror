import SwiftUI
import AVFoundation
import UIKit

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
    @StateObject private var camera = CameraController()
    @Environment(\.scenePhase) private var scenePhase
    @State private var lightIsOn = false
    @State private var cameraZoom = 1.0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            GeometryReader { geometry in
                ZStack {
                    SelfieCameraView(controller: camera)
                        .ignoresSafeArea()
                        .scaleEffect(cameraZoom)
                        .clipped()
                    if camera.isPreviewVisible {
                        MirrorLightOverlay(isOn: lightIsOn, thickness: lightThickness(for: geometry.size))
                            .ignoresSafeArea().allowsHitTesting(false)
                        VStack {
                            Spacer()
                            MirrorControlBar(lightIsOn: $lightIsOn, cameraZoom: $cameraZoom)
                        }
                        .padding(.horizontal, 28).padding(.bottom, 18)
                    } else {
                        Color.black.ignoresSafeArea()
                        if scenePhase == .active { cameraStatus }
                    }
                    ScreenBrightnessView(enabled: lightIsOn, eligible: camera.isPreviewVisible && scenePhase == .active)
                        .frame(width: 0, height: 0).allowsHitTesting(false)
                }
            }.ignoresSafeArea()
        }
        .onAppear { camera.setActive(scenePhase == .active) }
        .onChange(of: scenePhase) { _, phase in camera.setActive(phase == .active) }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            camera.setActive(false)
        }
        .onDisappear { camera.setActive(false) }
    }

    @ViewBuilder private var cameraStatus: some View {
        VStack(spacing: 16) {
            switch camera.state {
            case .checking, .starting:
                ProgressView().tint(.white).accessibilityLabel("Starting camera")
            case .denied:
                Text("Camera access is needed to use Mirror. Allow camera access in Settings.")
                Button("Open Settings") {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url)
                }.buttonStyle(.bordered)
            case .restricted:
                Text("Camera access is restricted on this iPhone. Check Screen Time or contact the person who manages this device.")
            case .unavailable:
                Text("The front camera is unavailable.")
                retryButton
            case .failed:
                Text("The camera could not start. Try again.")
                retryButton
            case .interrupted:
                Text("The camera is temporarily unavailable. Close other camera apps and try again.")
                retryButton
            case .running:
                EmptyView()
            }
        }
        .font(.body).foregroundStyle(.white).multilineTextAlignment(.center).padding(28)
    }
    private var retryButton: some View {
        Button("Try Again") { camera.retry() }.buttonStyle(.bordered)
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
                .accessibilityHidden(true)

            Slider(value: $value, in: range)
                .tint(.white)
                .accessibilityLabel("Zoom")
                .accessibilityValue(String(format: "%.1f times", value))

            Image(systemName: trailingSystemName)
                .foregroundStyle(.white)
                .frame(width: 24)
                .accessibilityHidden(true)
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
                let innerCornerRadius = thickness * 0.9
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

#Preview {
    ContentView()
}
