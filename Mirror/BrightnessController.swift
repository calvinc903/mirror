import UIKit

@MainActor protocol BrightnessScreen: AnyObject {
    var brightness: CGFloat { get set }
}
extension UIScreen: BrightnessScreen {}

@MainActor final class BrightnessController {
    private var saved: CGFloat?
    private var screen: (any BrightnessScreen)?

    func update(screen newScreen: (any BrightnessScreen)?, enabled: Bool, eligible: Bool) {
        guard enabled, eligible, let newScreen else { restore(); return }
        if let screen, screen !== newScreen { restore() }
        if saved == nil {
            screen = newScreen
            saved = newScreen.brightness
        }
        newScreen.brightness = 1
    }
    func restore() {
        if let saved { screen?.brightness = saved }
        saved = nil; screen = nil
    }
}

struct ScreenBrightnessView: UIViewRepresentable {
    let enabled: Bool
    let eligible: Bool
    func makeUIView(context: Context) -> ScreenBrightnessHostView { ScreenBrightnessHostView() }
    func updateUIView(_ view: ScreenBrightnessHostView, context: Context) {
        view.update(enabled: enabled, eligible: eligible)
    }
    static func dismantleUIView(_ view: ScreenBrightnessHostView, coordinator: ()) { view.restore() }
}

import SwiftUI
final class ScreenBrightnessHostView: UIView {
    private let controller = BrightnessController()
    private var enabled = false
    private var eligible = false
    private var inactivityObserver: NSObjectProtocol?
    override init(frame: CGRect) {
        super.init(frame: frame)
        inactivityObserver = NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] _ in
            MainActor.assumeIsolated { self?.restore() }
        }
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    deinit { if let inactivityObserver { NotificationCenter.default.removeObserver(inactivityObserver) } }
    override func didMoveToWindow() { super.didMoveToWindow(); apply() }
    func update(enabled: Bool, eligible: Bool) { self.enabled = enabled; self.eligible = eligible; apply() }
    func restore() { controller.restore() }
    private func apply() {
        controller.update(screen: window?.windowScene?.screen, enabled: enabled, eligible: eligible && UIApplication.shared.applicationState == .active)
    }
}
