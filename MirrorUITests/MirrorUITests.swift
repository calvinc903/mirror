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
        zoom.adjust(toNormalizedSliderPosition: 1)
        XCTAssertEqual(zoom.value as? String, "3.0 times")
        retainScreenshot(app, name: "Physical mirror at 3x with light on")
        zoom.adjust(toNormalizedSliderPosition: 0)
        XCTAssertEqual(zoom.value as? String, "1.0 times")
        XCUIDevice.shared.press(.home)
        app.activate()
        XCTAssertTrue(light.waitForExistence(timeout: 15))
        XCTAssertEqual(light.value as? String, "On")
        light.tap()
        XCTAssertEqual(light.value as? String, "Off")
        retainScreenshot(app, name: "Physical mirror after reentry")
        // Pixel mirroring, optical image quality, actual brightness restoration
        // and app-switcher privacy still require the coordinator's device QA.
        #endif
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
