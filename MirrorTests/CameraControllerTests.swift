import XCTest
@testable import Mirror

@MainActor final class CameraControllerTests: XCTestCase {
    func testPermissionAndActivityGateSessionStart() {
        for authorization in [CameraAuthorization.denied, .restricted, .notDetermined, .authorized] {
            let permission = PermissionFake(authorization)
            let session = SessionFake()
            let controller = CameraController(permission: permission, session: session)
            controller.refreshAuthorization()
            XCTAssertEqual(session.starts, 0, "An inactive controller must never start")
            XCTAssertFalse(controller.isPreviewVisible)
            if authorization != .notDetermined {
                controller.setActive(true)
                XCTAssertEqual(session.starts, authorization == .authorized ? 1 : 0)
                if authorization == .denied { XCTAssertEqual(controller.state, .denied) }
                if authorization == .restricted { XCTAssertEqual(controller.state, .restricted) }
            }
            controller.teardown()
        }
    }

    func testOnlyOnePermissionPromptAndLateGrantWhileInactiveDoesNotStart() async {
        let permission = PermissionFake(.notDetermined)
        let session = SessionFake()
        let controller = CameraController(permission: permission, session: session)
        controller.setActive(true)
        controller.refreshAuthorization()
        controller.retry()
        await eventually { permission.requests == 1 }
        XCTAssertEqual(session.starts, 0)
        controller.setActive(false)
        permission.complete(granted: true)
        await eventually { permission.completed }
        await Task.yield()
        XCTAssertEqual(permission.requests, 1)
        XCTAssertEqual(session.starts, 0)
        XCTAssertFalse(controller.isPreviewVisible)
        controller.setActive(true)
        XCTAssertEqual(session.starts, 1)
        controller.teardown()
    }

    func testPermissionDecisionStartsOnlyAfterAnActiveGrant() async {
        for granted in [false, true] {
            let permission = PermissionFake(.notDetermined)
            let session = SessionFake()
            let controller = CameraController(permission: permission, session: session)
            controller.setActive(true)
            await eventually { permission.requests == 1 }
            XCTAssertEqual(session.starts, 0)
            permission.complete(granted: granted)
            await eventually { granted ? session.starts == 1 : controller.state == .denied }
            XCTAssertEqual(session.starts, granted ? 1 : 0)
            XCTAssertFalse(controller.isPreviewVisible, "A grant alone does not confirm a running session")
            controller.teardown()
        }
    }

    func testSettingsGrantAndRevocationReReadAuthorization() {
        let permission = PermissionFake(.denied)
        let session = SessionFake()
        let controller = CameraController(permission: permission, session: session)
        controller.setActive(true)
        XCTAssertEqual(controller.state, .denied)
        permission.authorization = .authorized
        controller.refreshAuthorization()
        XCTAssertEqual(session.starts, 1)
        session.emit(.running)
        XCTAssertTrue(controller.isPreviewVisible)
        permission.authorization = .denied
        controller.refreshAuthorization()
        XCTAssertEqual(controller.state, .denied)
        XCTAssertFalse(controller.isPreviewVisible)
        let starts = session.starts
        session.emit(.running)
        controller.retry()
        XCTAssertFalse(controller.isPreviewVisible)
        XCTAssertEqual(session.starts, starts)
        controller.teardown()
    }

    func testInactivityConcealsSynchronouslyBeforeStopAndRejectsLateRunning() {
        let session = SessionFake()
        let controller = CameraController(permission: PermissionFake(.authorized), session: session)
        controller.setActive(true)
        session.emit(.running)
        XCTAssertTrue(controller.isPreviewVisible)
        var visibleAtStop: Bool?
        var callbackVisibleAtStop: Bool?
        var lastVisibility: Bool?
        controller.previewVisibilityHandler = { lastVisibility = $0 }
        session.onStop = { visibleAtStop = controller.isPreviewVisible; callbackVisibleAtStop = lastVisibility }
        controller.setActive(false)
        XCTAssertEqual(visibleAtStop, false)
        XCTAssertEqual(callbackVisibleAtStop, false)
        session.emit(.running)
        XCTAssertFalse(controller.isPreviewVisible)
        XCTAssertFalse(controller.isActive)
        session.onStop = nil
        controller.teardown()
    }

    func testFailuresInterruptionAndResetRecoverOnlyWhenEligible() {
        let permission = PermissionFake(.authorized)
        let session = SessionFake()
        let controller = CameraController(permission: permission, session: session)
        controller.setActive(true)
        for (event, state) in [(CameraSessionEvent.unavailable, CameraState.unavailable), (.failed, .failed), (.interrupted, .interrupted)] {
            session.emit(.running)
            session.emit(event)
            XCTAssertEqual(controller.state, state)
            XCTAssertFalse(controller.isPreviewVisible)
            session.emit(.running) // Queued success must not undo a newer failure/interruption.
            XCTAssertEqual(controller.state, state)
            XCTAssertFalse(controller.isPreviewVisible)
            let starts = session.starts
            controller.retry()
            XCTAssertEqual(session.starts, starts + 1)
        }
        for event in [CameraSessionEvent.interruptionEnded, .mediaServicesReset] {
            let starts = session.starts
            session.emit(event)
            XCTAssertEqual(session.starts, starts + 1)
        }
        controller.setActive(false)
        let starts = session.starts
        session.emit(.interruptionEnded)
        session.emit(.mediaServicesReset)
        controller.retry()
        XCTAssertEqual(session.starts, starts)
        XCTAssertFalse(controller.isPreviewVisible)
        permission.authorization = .restricted
        controller.setActive(true)
        session.emit(.mediaServicesReset)
        XCTAssertEqual(session.starts, starts)
        XCTAssertEqual(controller.state, .restricted)
        controller.teardown()
    }

    func testTeardownIsIdempotentAndRejectsCapturedLateCallbacks() async {
        let permission = PermissionFake(.notDetermined)
        let session = SessionFake()
        let controller = CameraController(permission: permission, session: session)
        let queuedHandler = session.eventHandler
        controller.setActive(true)
        await eventually { permission.requests == 1 }
        controller.teardown()
        controller.teardown()
        permission.complete(granted: true)
        await eventually { permission.completed }
        queuedHandler?(.running)
        queuedHandler?(.mediaServicesReset)
        controller.setActive(true)
        controller.retry()
        XCTAssertEqual(session.starts, 0)
        XCTAssertEqual(session.teardowns, 1)
        XCTAssertNil(session.eventHandler)
        XCTAssertFalse(controller.isPreviewVisible)
        XCTAssertFalse(controller.isActive)
    }

    private func eventually(_ predicate: @MainActor () -> Bool, file: StaticString = #filePath, line: UInt = #line) async {
        for _ in 0..<100 {
            if predicate() { return }
            try? await Task.sleep(for: .milliseconds(10))
        }
        XCTFail("Timed out waiting for asynchronous permission boundary", file: file, line: line)
    }
}

@MainActor private final class PermissionFake: CameraPermissionProviding {
    var authorization: CameraAuthorization
    var requests = 0
    var completed = false
    private var continuation: CheckedContinuation<Bool, Never>?
    init(_ authorization: CameraAuthorization) { self.authorization = authorization }
    func requestAccess() async -> Bool {
        requests += 1
        let result = await withCheckedContinuation { continuation = $0 }
        completed = true
        return result
    }
    func complete(granted: Bool) {
        authorization = granted ? .authorized : .denied
        continuation?.resume(returning: granted)
        continuation = nil
    }
}

@MainActor private final class SessionFake: CameraSessionProviding {
    var eventHandler: (@MainActor @Sendable (CameraSessionEvent) -> Void)?
    var starts = 0
    var stops = 0
    var teardowns = 0
    var onStop: (() -> Void)?
    func start() { starts += 1 }
    func stop() { onStop?(); stops += 1 }
    func teardown() { teardowns += 1 }
    func emit(_ event: CameraSessionEvent) { eventHandler?(event) }
}
