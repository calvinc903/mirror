import XCTest
import UIKit
@testable import Mirror

@MainActor final class BrightnessControllerTests: XCTestCase {
    func testRepeatedLightUpdatesRetainOriginalBrightnessAndOffRestores() {
        let screen = ScreenFake(0.37)
        let controller = BrightnessController()
        controller.update(screen: screen, enabled: true, eligible: true)
        XCTAssertEqual(screen.brightness, 1)
        controller.update(screen: screen, enabled: true, eligible: true)
        controller.update(screen: screen, enabled: false, eligible: true)
        XCTAssertEqual(screen.brightness, 0.37, accuracy: 0.001)
        controller.restore()
        XCTAssertEqual(screen.brightness, 0.37, accuracy: 0.001)
    }

    func testInactivityRestoresAndReentryCapturesCurrentUserBrightness() {
        let screen = ScreenFake(0.25)
        let controller = BrightnessController()
        controller.update(screen: screen, enabled: true, eligible: true)
        controller.update(screen: screen, enabled: true, eligible: false)
        XCTAssertEqual(screen.brightness, 0.25)
        screen.brightness = 0.62
        controller.update(screen: screen, enabled: true, eligible: true)
        XCTAssertEqual(screen.brightness, 1)
        controller.restore()
        XCTAssertEqual(screen.brightness, 0.62)
    }

    func testScreenChangeRestoresOldScreenAndCapturesNewScreen() {
        let first = ScreenFake(0.2)
        let second = ScreenFake(0.7)
        let controller = BrightnessController()
        controller.update(screen: first, enabled: true, eligible: true)
        controller.update(screen: second, enabled: true, eligible: true)
        XCTAssertEqual(first.brightness, 0.2)
        XCTAssertEqual(second.brightness, 1)
        controller.update(screen: nil, enabled: true, eligible: true)
        XCTAssertEqual(second.brightness, 0.7)
    }

    func testDisabledOrIneligibleNeverChangesBrightness() {
        let screen = ScreenFake(0.4)
        let controller = BrightnessController()
        controller.update(screen: screen, enabled: false, eligible: true)
        controller.update(screen: screen, enabled: true, eligible: false)
        XCTAssertEqual(screen.brightness, 0.4)
    }
}

@MainActor private final class ScreenFake: BrightnessScreen {
    var brightness: CGFloat
    init(_ brightness: CGFloat) { self.brightness = brightness }
}
