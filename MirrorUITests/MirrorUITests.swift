import XCTest

/// These tests use the shipping camera and actual OS permission alert. They do
/// not configure permission grants or provide a synthetic camera in the app.
final class MirrorUITests: XCTestCase {
    override func setUpWithError() throws { continueAfterFailure = false }

    func testSimulatorWithoutFrontCameraShowsRecoverableFailure() throws {
        #if !targetEnvironment(simulator)
        throw XCTSkip("Missing-camera path is intended for a simulator; physical camera flows are separate")
        #else
        let app = XCUIApplication()
        app.launch()
        respondToCameraAlert(allow: true)
        let unavailable = app.staticTexts["The front camera is unavailable."]
        XCTAssertTrue(unavailable.waitForExistence(timeout: 15), "Simulator must explain why no preview is available")
        XCTAssertTrue(app.buttons["Try Again"].exists)
        XCTAssertFalse(app.buttons["Mirror light"].exists)
        XCTAssertFalse(app.sliders["Zoom"].exists)
        retainScreenshot(app, name: "Simulator camera unavailable")
        app.buttons["Try Again"].tap()
        XCTAssertTrue(unavailable.waitForExistence(timeout: 15))
        XCUIDevice.shared.press(.home)
        app.activate()
        XCTAssertTrue(unavailable.waitForExistence(timeout: 15))
        #endif
    }

    func testDeniedCameraExplainsSettingsRecovery() throws {
        let app = XCUIApplication()
        app.launch()
        let denied = app.staticTexts["Camera access is needed to use Mirror. Allow camera access in Settings."]
        if !denied.exists {
            guard respondToCameraAlert(allow: false) else {
                throw XCTSkip("Requires a fresh OS camera permission prompt or already denied permission; coordinator must reset privacy separately")
            }
        }
        XCTAssertTrue(denied.waitForExistence(timeout: 10))
        XCTAssertTrue(app.buttons["Open Settings"].isHittable)
        XCTAssertFalse(app.buttons["Mirror light"].exists)
        XCTAssertFalse(app.sliders["Zoom"].exists)
        retainScreenshot(app, name: "Camera denied with Settings recovery")
        XCUIDevice.shared.press(.home)
        app.activate()
        XCTAssertTrue(denied.waitForExistence(timeout: 10))
        XCTAssertTrue(app.buttons["Open Settings"].isHittable)
    }

    func testPhysicalCameraControlsAndReentry() throws {
        #if targetEnvironment(simulator)
        throw XCTSkip("Real front-camera UI requires a physical iPhone")
        #else
        let app = XCUIApplication()
        app.launch()
        respondToCameraAlert(allow: true)
        let light = app.buttons["Mirror light"]
        XCTAssertTrue(light.waitForExistence(timeout: 15), "Physical camera must start before controls become accessible")
        XCTAssertEqual(light.value as? String, "Off")
        retainScreenshot(app, name: "Physical mirror at 1x with light off")
        light.tap()
        XCTAssertEqual(light.value as? String, "On")
        let zoom = app.sliders["Zoom"]
        XCTAssertTrue(zoom.isHittable)
        XCTAssertEqual(zoom.value as? String, "1.0 times")
        dragZoomToEndpoint(zoom, maximum: true)
        retainScreenshot(app, name: "Physical mirror at 3x with light on")
        dragZoomToEndpoint(zoom, maximum: false)
        XCUIDevice.shared.press(.home)
        app.activate()
        XCTAssertTrue(light.waitForExistence(timeout: 15))
        XCTAssertEqual(light.value as? String, "On")
        XCTAssertTrue(zoom.isHittable, "Zoom must remain usable after camera reentry")
        XCTAssertEqual(zoom.value as? String, "1.0 times", "Reentry must preserve the selected minimum zoom")
        light.tap()
        XCTAssertEqual(light.value as? String, "Off")
        retainScreenshot(app, name: "Physical mirror after reentry")
        // Pixel mirroring, optical image quality, actual brightness restoration
        // and app-switcher privacy still require the coordinator's device QA.
        #endif
    }

    func testPhysicalCameraControlsAccessibilityAudit() throws {
        #if targetEnvironment(simulator)
        throw XCTSkip("Camera control accessibility audit requires a physical iPhone")
        #else
        let app = XCUIApplication()
        app.launch()
        respondToCameraAlert(allow: true)
        let light = app.buttons["Mirror light"]
        let zoom = app.sliders["Zoom"]
        XCTAssertTrue(light.waitForExistence(timeout: 15), "Physical camera must start before auditing controls")
        XCTAssertTrue(zoom.waitForExistence(timeout: 15), "Labelled zoom must be available for the audit")
        XCTAssertTrue(light.isHittable)
        XCTAssertTrue(zoom.isHittable)
        XCTAssertEqual(light.value as? String, "Off")
        defer {
            if light.exists && light.isHittable && light.value as? String == "On" {
                light.tap()
            }
        }

        // The action audit is macOS-only in Xcode 27; these are the requested
        // iPhone-supported types. Default handling records every audit finding.
        let auditTypes: XCUIAccessibilityAuditType = [.sufficientElementDescription, .hitRegion, .trait]
        try app.performAccessibilityAudit(for: auditTypes)
        light.tap()
        XCTAssertEqual(light.value as? String, "On")
        try app.performAccessibilityAudit(for: auditTypes)
        #endif
    }

    private func dragZoomToEndpoint(_ zoom: XCUIElement, maximum: Bool,
                                    file: StaticString = #filePath, line: UInt = #line) {
        // On iOS 27 the normalized endpoint gesture can grab the broad thumb
        // off-center and stop at 1.2x/2.9x. Center it first, then drag beyond the
        // track so the real control clamps to its endpoint despite that offset.
        zoom.adjust(toNormalizedSliderPosition: 0.5)
        let frame = zoom.frame
        let center = zoom.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let edge = zoom.coordinate(withNormalizedOffset: CGVector(dx: maximum ? 1 : 0, dy: 0.5))
        let destination = edge.withOffset(CGVector(dx: (maximum ? 1 : -1) * frame.height / 2, dy: 0))
        center.press(forDuration: 0.25, thenDragTo: destination)

        let expected = maximum ? "3.0 times" : "1.0 times"
        let settled = XCTNSPredicateExpectation(predicate: NSPredicate(format: "value == %@", expected), object: zoom)
        XCTAssertEqual(XCTWaiter.wait(for: [settled], timeout: 3), .completed,
                       "Zoom endpoint drag must reach \(expected); observed \(String(describing: zoom.value)), frame \(frame)",
                       file: file, line: line)
        XCTAssertEqual(zoom.value as? String, expected, "Zoom must remain at the exact endpoint after settling",
                       file: file, line: line)
    }

    private func retainScreenshot(_ app: XCUIApplication, name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @discardableResult private func respondToCameraAlert(allow: Bool) -> Bool {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let alert = springboard.alerts.firstMatch
        guard alert.waitForExistence(timeout: 3) else { return false }
        let names = allow ? ["Allow", "OK"] : ["Don’t Allow", "Don't Allow"]
        for name in names where alert.buttons[name].exists {
            alert.buttons[name].tap()
            return true
        }
        XCTFail("Unexpected system camera permission alert; no permission was changed")
        return false
    }
}
