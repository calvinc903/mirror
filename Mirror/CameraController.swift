import AVFoundation
import Combine
import UIKit
import Synchronization

nonisolated enum CameraAuthorization: Sendable { case notDetermined, authorized, denied, restricted }
nonisolated enum CameraState: Equatable, Sendable {
    case checking, denied, restricted, starting, running, unavailable, failed, interrupted
}
nonisolated enum CameraSessionEvent: Sendable {
    case running, stopped, unavailable, failed, interrupted, interruptionEnded, mediaServicesReset
}

@MainActor protocol CameraPermissionProviding {
    var authorization: CameraAuthorization { get }
    func requestAccess() async -> Bool
}
@MainActor protocol CameraSessionProviding: AnyObject {
    var eventHandler: (@MainActor @Sendable (CameraSessionEvent) -> Void)? { get set }
    func start()
    func stop()
    func teardown()
}

@MainActor final class SystemCameraPermission: CameraPermissionProviding {
    var authorization: CameraAuthorization {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: .authorized
        case .notDetermined: .notDetermined
        case .denied: .denied
        case .restricted: .restricted
        @unknown default: .restricted
        }
    }
    func requestAccess() async -> Bool { await AVCaptureDevice.requestAccess(for: .video) }
}

@MainActor final class CameraController: ObservableObject {
    @Published private(set) var state: CameraState = .checking
    @Published private(set) var isPreviewVisible = false
    private(set) var isActive = false
    private var isTornDown = false
    private var permissionRequest: Task<Void, Never>?
    private let permission: any CameraPermissionProviding
    private let driver: any CameraSessionProviding
    // UIKit uses this synchronously, before the queued capture stop or SwiftUI rendering.
    var previewVisibilityHandler: ((Bool) -> Void)?

    init(permission: (any CameraPermissionProviding)? = nil,
         session: (any CameraSessionProviding)? = nil) {
        self.permission = permission ?? SystemCameraPermission()
        driver = session ?? CameraSessionDriver()
        driver.eventHandler = { [weak self] event in self?.receive(event) }
    }

    deinit {
        let driver = driver
        Task { @MainActor in driver.teardown() }
    }

    var captureSession: AVCaptureSession? { (driver as? CameraSessionDriver)?.session }

    func setActive(_ active: Bool) {
        guard !isTornDown else { return }
        isActive = active
        if active { refreshAuthorization() }
        else { conceal(); driver.stop() }
    }

    func refreshAuthorization() {
        guard !isTornDown else { return }
        switch permission.authorization {
        case .authorized:
            guard isActive else { conceal(); driver.stop(); return }
            state = .starting
            conceal()
            driver.start()
        case .denied:
            state = .denied; conceal(); driver.stop()
        case .restricted:
            state = .restricted; conceal(); driver.stop()
        case .notDetermined:
            state = .checking; conceal(); driver.stop()
            guard isActive, permissionRequest == nil else { return }
            permissionRequest = Task { [weak self, permission] in
                _ = await permission.requestAccess()
                guard let self else { return }
                self.permissionRequest = nil
                // Re-read status and eligibility: a grant may arrive after background or teardown.
                self.refreshAuthorization()
            }
        }
    }

    func retry() { refreshAuthorization() }
    func teardown() {
        guard !isTornDown else { return }
        isTornDown = true; isActive = false; conceal()
        permissionRequest?.cancel(); permissionRequest = nil
        driver.eventHandler = nil
        driver.teardown()
    }

    private func conceal() {
        isPreviewVisible = false
        previewVisibilityHandler?(false)
    }

    private func receive(_ event: CameraSessionEvent) {
        guard !isTornDown else { return }
        switch event {
        case .running:
            guard isActive, permission.authorization == .authorized, state == .starting else {
                conceal(); driver.stop(); return
            }
            state = .running; isPreviewVisible = true
            previewVisibilityHandler?(true)
        case .stopped:
            conceal()
        case .unavailable:
            state = .unavailable; conceal(); driver.stop()
        case .failed:
            state = .failed; conceal(); driver.stop()
        case .interrupted:
            // AVFoundation has already interrupted capture. Keep the interval alive
            // so an interruption-ended notification queued beside this one can recover.
            state = .interrupted; conceal()
        case .interruptionEnded, .mediaServicesReset:
            refreshAuthorization()
        }
    }
}

// Only this boundary is unchecked Sendable: session and mutable configuration/observers
// are confined to queue. The main actor only attaches the session to its preview layer.
nonisolated final class CameraSessionDriver: @unchecked Sendable, CameraSessionProviding {
    let session = AVCaptureSession()
    private let queue = DispatchQueue(label: "Mirror.camera.session")
    private var configured = false
    private var observers: [NSObjectProtocol] = []
    private var disposed = false
    // Notification callbacks run on arbitrary posting threads. Snapshot the interval
    // synchronously, before scheduling work, so a delayed task cannot adopt a new run.
    private let revision = Mutex(0)
    private let notificationCenter: NotificationCenter
    @MainActor var eventHandler: (@MainActor @Sendable (CameraSessionEvent) -> Void)?

    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }

    @MainActor func start() {
        let currentRevision = advanceRevision()
        let handler = notificationHandler(for: currentRevision)
        queue.async { [self] in
            guard !disposed else { return }
            installObservers()
            guard configure(handler) else { return }
            if !session.isRunning { session.startRunning() }
            emit(session.isRunning ? .running : .failed, handler)
        }
    }
    @MainActor func stop() {
        let currentRevision = advanceRevision()
        let handler = notificationHandler(for: currentRevision)
        queue.async { [self] in
            if session.isRunning { session.stopRunning() }
            emit(.stopped, handler)
        }
    }
    @MainActor func teardown() {
        _ = advanceRevision()
        eventHandler = nil
        queue.async { [self] in
            disposed = true
            observers.forEach(notificationCenter.removeObserver)
            observers.removeAll()
            if session.isRunning { session.stopRunning() }
        }
    }
    private func emit(_ event: CameraSessionEvent, _ handler: (@MainActor @Sendable (CameraSessionEvent) -> Void)?) {
        Task { @MainActor in handler?(event) }
    }
    private func configure(_ handler: (@MainActor @Sendable (CameraSessionEvent) -> Void)?) -> Bool {
        if configured { return true }
        session.beginConfiguration()
        defer { session.commitConfiguration() }
        session.sessionPreset = .high
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            emit(.unavailable, handler); return false
        }
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            guard session.canAddInput(input) else { emit(.failed, handler); return false }
            session.addInput(input)
            configured = true
            return true
        } catch { emit(.failed, handler); return false }
    }
    @MainActor private func advanceRevision() -> Int {
        revision.withLock { value in
            value += 1
            return value
        }
    }

    private func notificationHandler(for currentRevision: Int) -> @MainActor @Sendable (CameraSessionEvent) -> Void {
        { [weak self] event in
            guard let self, self.revision.withLock({ $0 == currentRevision }) else { return }
            self.eventHandler?(event)
        }
    }

    private func installObservers() {
        guard observers.isEmpty else { return }
        let center = notificationCenter
        observers.append(center.addObserver(forName: AVCaptureSession.wasInterruptedNotification, object: session, queue: nil) { [weak self] _ in
            guard let self else { return }
            let currentRevision = self.revision.withLock { $0 }
            self.emit(.interrupted, self.notificationHandler(for: currentRevision))
        })
        observers.append(center.addObserver(forName: AVCaptureSession.interruptionEndedNotification, object: session, queue: nil) { [weak self] _ in
            guard let self else { return }
            let currentRevision = self.revision.withLock { $0 }
            self.emit(.interruptionEnded, self.notificationHandler(for: currentRevision))
        })
        observers.append(center.addObserver(forName: AVCaptureSession.runtimeErrorNotification, object: session, queue: nil) { [weak self] notification in
            guard let self else { return }
            let currentRevision = self.revision.withLock { $0 }
            let reset = (notification.userInfo?[AVCaptureSessionErrorKey] as? AVError)?.code == .mediaServicesWereReset
            self.queue.async { [self] in
                guard !self.disposed, self.revision.withLock({ $0 == currentRevision }) else { return }
                if reset {
                    self.configured = false
                    self.session.beginConfiguration()
                    self.session.inputs.forEach(self.session.removeInput)
                    self.session.commitConfiguration()
                }
                self.emit(reset ? .mediaServicesReset : .failed, self.notificationHandler(for: currentRevision))
            }
        })
    }
}
