# Production readiness and App Store resubmission

User request on October 12, 2026: ensure Mirror is production ready, then request publication on the App Store. This expands the earlier setup-only scope; coordinator owns device, signing, metadata and App Store actions. Preserve primary user work.

Baseline: setup commit d9ca65ff66207a467ac664a5a16b94542e459b64, app bundle com.calvincheah.mirror, iPhone portrait support, iOS 27. Current App Store Connect record is Just a Mirror!, app 6812883052, version 1.0/build 1, rejected September 17 for 2.1 Information Needed. Apple asks for physical-device QA and a genuine physical-device screen recording from launch, plus purpose/audience, feature access, external services, region differences and regulated/protected content information.

## Bounded changes

Preserve a local mirrored front-camera preview, white edge light and 1–3× digital view zoom. Add no accounts, storage, analytics, purchases, third-party SDKs or iPad support.

Fix permission Settings recovery/re-entry, active/inactive session lifetime, brightness restoration, missing-camera/runtime/interruption recovery, the async preview-connection mirroring race, and zoom accessibility. Immediately conceal the camera preview with an opaque cover on inactivity, loss of permission, interruption or unavailability, before queued capture stop completes; test visibility state and inspect actual app-switcher privacy. Remove the unused Playground example. Use a small observable camera controller with injected permission/session boundaries for tests and one serial session queue; keep UI updates on the main actor. A small brightness controller captures/restores the actual window screen once per eligible light interval, recapturing current user brightness on re-entry. Shipping defaults always use real services; fakes stay in tests.

Add focused app XCTest and real simulator failure-path UI tests. Root performs actual simulator and connected iPhone checks, captures/inspects screenshots and preserves candidate-bound receipts. Check delayed permission grants, re-entry/revocation, inactive/teardown callbacks, recoverable errors, and brightness off/background/restoration.

Validate Debug/Release builds and meaningful app tests, independently review the candidate, archive/export or candidate-bound Xcode Cloud upload, inspect bundle/icon/signing/privacy/version inputs, and select the matching processed build. Review metadata/screenshots/privacy/support URLs against the actual app. Reply to Apple's specific information request and submit only after actual readiness evidence, including its genuine physical-device recording.

## Acceptance gates

PROD-PERM-1, PROD-CAMERA-1, PROD-LIGHT-1, PROD-A11Y-1, PROD-PRIVACY-1 and PROD-TEST-1 qualify product behavior. RELEASE-1 qualifies the signed release/upload. REVIEW-INFO-1 qualifies Apple's requested real-device recording and six information items. SUBMIT-1 requires App Store Connect confirmation of the submitted candidate; approval/publication remain Apple's subsequent outcomes.

All release gates start Pending. Sol 6.1 xhigh plan and independent xhigh critique completed before implementation. Adopted the critic's P2 immediate opaque-preview concealment requirement; no remaining plan blockers. Device available: iPhone 13 Pro on iOS 27.2; public latest OS was listed as 27.0.1, so report the actual environment and do not disguise prerelease/stable coverage. The user confirmed the phone is ready for a non-private physical demo to Apple; private face/personal information remains outside authorized uploads. No simulator/mock recording can satisfy Apple's physical-device request.

Build preparation: App Store Connect contains builds through 16; builds 8–16 are internal-only. Reserve build 17 before candidate QA. Existing Cloud Default archive preparation is TestFlight (Internal Testing Only); prepare the release for App Store Connect without treating an internal-only build as submission eligible.
