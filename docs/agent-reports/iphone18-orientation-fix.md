# Camera-specific portrait rotation correction

Problem and behavior: On a new iPhone18Pro, build17 showed a live but sideways preview with the phone upright. A fixed90-degree rotation assumed the camera sensor's mounting. The preview now obtains its static portrait correction from AVFoundation for the actual connected camera. The app remains portrait-only, mirrored and local; privacy cover and teardown behavior are preserved. The cached coordinator refreshes when the input device changes and is cleared on disconnect.

Implementation: fresh gpt-6.1-sol medium worker commit2372073, integrated as c2547260 on the reviewed main baseline14b929e. Fresh independent gpt-6.1-sol medium reviewer found no material source issues. These profiles are coordinator dispatch records; the reviewer did not introspect runtime settings.

Reference: [Apple RotationCoordinator documentation](https://developer.apple.com/documentation/avfoundation/avcapturedevice/rotationcoordinator). The installed iOS27 SDK header documents videoRotationAngleRelative(toDeviceOrientation:) as camera-specific and independent of the current gravity orientation. The minimum supported OS is27, and the app's interface is locked to portrait.

Validation: normal signed Release developer build18 passed with unchanged frozen source inputs; strict code-signature verification passed. Installation plus a separate bundle-specific query confirmed1.0/18. The user directly confirmed upright preview and upright recovery after Home/reentry. Documentation17/17, tooling regressions15/15 and focused source typecheck passed. New imagery was not captured; visual-media and old-phone checks remain unexecuted. No new App Store submission was made.

Distinct environment issue: Two Device Hub screen streams were active. Stopping both and reopening restored live preview according to the user. Future optical checks must inspect every running stable/beta instance and keep sharing off. Failures that persist without sharing need separate investigation.

Preserved failed checks: worker's sandboxed full compile failed in existing Swift macro-server startup; root's authorized normal signed build succeeded. The first simulator regression attempt compiled but failed during simulator service bootstrap before executing tests; logs/receipt remain private. A matching stable Xcode retry was started. Its actual outcome must be recorded before promoting the current unit gate.

State: code committed locally; developer build installed. User-confirmed orientation fix passed for the new phone. Publication/hosted CI and broader production qualification are separate.
