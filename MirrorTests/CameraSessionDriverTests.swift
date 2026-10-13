import AVFoundation
import XCTest
@testable import Mirror

@MainActor final class CameraSessionDriverTests: XCTestCase {
    func testQueuedNotificationsCannotCrossStopAndRestart() async {
        let resetError = NSError(domain: AVFoundationErrorDomain,
                                 code: AVError.Code.mediaServicesWereReset.rawValue)
        let cases: [(Notification.Name, [AnyHashable: Any]?)] = [
            (AVCaptureSession.wasInterruptedNotification, nil),
            (AVCaptureSession.interruptionEndedNotification, nil),
            (AVCaptureSession.runtimeErrorNotification, nil),
            (AVCaptureSession.runtimeErrorNotification, [AVCaptureSessionErrorKey: resetError])
        ]
        for (name, userInfo) in cases {
            let center = NotificationCenter()
            let driver = CameraSessionDriver(notificationCenter: center)
            var notifications = 0
            var completions = 0
            driver.eventHandler = { event in
                switch event {
                case .interrupted, .interruptionEnded, .failed, .mediaServicesReset:
                    notifications += 1
                case .running, .unavailable: completions += 1
                case .stopped: break
                }
            }
            driver.start()
            await eventually { completions == 1 }
            let originalNotifications = notifications
            // Posting synchronously enqueues delivery while this actor is occupied.
            center.post(name: name, object: driver.session, userInfo: userInfo)
            driver.stop()
            driver.start()
            await eventually { completions == 2 }
            await settle()
            XCTAssertEqual(notifications, originalNotifications, "Stale \(name) crossed a new start")
            driver.teardown()
        }
    }

    func testObserversContinueDeliveringAfterRestartAndStopForRecovery() async {
        let center = NotificationCenter()
        let driver = CameraSessionDriver(notificationCenter: center)
        var completions = 0
        var interrupted = 0
        var recovered = 0
        var stopped = 0
        var resets = 0
        var failures = 0
        driver.eventHandler = { event in
            switch event {
            case .running, .unavailable: completions += 1
            case .interrupted: interrupted += 1
            case .interruptionEnded: recovered += 1
            case .stopped: stopped += 1
            case .mediaServicesReset: resets += 1
            case .failed: failures += 1
            default: break
            }
        }
        driver.start()
        await eventually { completions == 1 }
        driver.stop()
        driver.start()
        await eventually { completions == 2 }
        center.post(name: AVCaptureSession.wasInterruptedNotification, object: driver.session)
        await eventually { interrupted == 1 }
        driver.stop()
        await eventually { stopped == 1 }
        center.post(name: AVCaptureSession.interruptionEndedNotification, object: driver.session)
        await eventually { recovered == 1 }
        center.post(name: AVCaptureSession.runtimeErrorNotification, object: driver.session)
        await eventually { failures == 1 }
        let resetError = NSError(domain: AVFoundationErrorDomain,
                                 code: AVError.Code.mediaServicesWereReset.rawValue)
        center.post(name: AVCaptureSession.runtimeErrorNotification, object: driver.session,
                    userInfo: [AVCaptureSessionErrorKey: resetError])
        await eventually { resets == 1 }
        // A queued callback must also expire at teardown, before observer removal.
        center.post(name: AVCaptureSession.wasInterruptedNotification, object: driver.session)
        driver.teardown()
        center.post(name: AVCaptureSession.wasInterruptedNotification, object: driver.session)
        await settle()
        XCTAssertEqual(interrupted, 1)
    }

    func testCoQueuedInterruptionAndEndRecoverWithoutInvalidatingInterval() async {
        let center = NotificationCenter()
        let driver = CameraSessionDriver(notificationCenter: center)
        let controller = CameraController(permission: AuthorizedPermission(), session: driver)
        controller.setActive(true)
        await eventually { controller.state != .starting }
        var observedInterruption = false
        controller.previewVisibilityHandler = { _ in
            if controller.state == .interrupted {
                observedInterruption = true
                XCTAssertFalse(controller.isPreviewVisible)
            }
        }
        // Both notifications enqueue before the controller handles the interruption.
        center.post(name: AVCaptureSession.wasInterruptedNotification, object: driver.session)
        center.post(name: AVCaptureSession.interruptionEndedNotification, object: driver.session)
        await eventually { observedInterruption }
        await eventually { controller.state != .interrupted }
        XCTAssertTrue(controller.isActive)
        controller.teardown()
        controller.previewVisibilityHandler = nil
    }

    private func settle() async {
        try? await Task.sleep(for: .milliseconds(100))
    }

    private func eventually(_ predicate: @MainActor () -> Bool, file: StaticString = #filePath, line: UInt = #line) async {
        for _ in 0..<200 {
            if predicate() { return }
            try? await Task.sleep(for: .milliseconds(10))
        }
        XCTFail("Timed out waiting for the real capture-session queue", file: file, line: line)
    }
}

@MainActor private final class AuthorizedPermission: CameraPermissionProviding {
    var authorization: CameraAuthorization { .authorized }
    func requestAccess() async -> Bool { true }
}
