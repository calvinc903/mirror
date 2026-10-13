# Mirror current status

Goal: maintain the iPhone mirror camera app with coordinated agents, independent review and verified PR delivery.
Stack: SwiftUI, AVFoundation, UIKit; Xcode 27; iOS 27. App plus XCTest and UI test targets.
Priority: camera privacy, permission handling, mirrored preview, session teardown and screen-brightness restoration.
Repository: `calvinc903/mirror`; default branch: `main`.

## Setup checkpoint

The user requested adoption of Repository Agent System on October 12, 2026. Setup is isolated on `codex/repository-agent-system`, based on remote `main` at `c22a76752d6e73a965e452c4f51236ca178eaef4`. The primary checkout starts at `c030565241732e3aa591ee8ca019534ba325af73` with staged, unstaged and untracked user work; preserve it.

State: role/workflow documentation and executable checks implemented, independently reviewed and pushed in [draft PR #1](https://github.com/calvinc903/mirror/pull/1). All seventeen documentation checks and eleven regressions passed; both hosted checks passed with Xcode 27.0 (27A266a), and each independent failure control behaved correctly. See [acceptance](ACCEPTANCE_STATUS.md) and [setup report](agent-reports/agent-system-setup.md) for current receipts.

Shared-resource owner: coordinator owns integration, GitHub settings and build execution; coordinator owns the connected iPhone and dedicated Mirror Release QA simulator. No schedules or hooks installed.

Local installation/preservation and the independent checkpoint audit passed. The primary checkout keeps its original HEAD/staging and app/media content; the README received a workflow appendix.

The user subsequently authorized production readiness and an App Store publishing request. Release work includes the setup changes; PR #1 remains unmerged. Next: qualify and publish the release candidate through a reviewed PR. PR/no-force/admin protection is active. Required new check contexts remain Pending until the workflow is on `main`; activate the prepared policy and verify an ordinary main-based PR and both failure-blocking paths afterward.

## Product gaps

- Physical-device permission, mirroring, lighting, zoom and brightness-restoration checks are Pending; owner: coordinator; next: assign the [device checklist](DEVICE_CHECKLIST.md) with a device lease when product changes require it.
- Focused XCTest and UI test targets now exist. Product qualification still requires actual executed checks.
- README now correctly states iPhone support. iPad is outside release scope.

## Release in progress — October 13, 2026

App Store record: Just a Mirror!, app 6812883052, version 1.0 rejected for information needed (2.1). No release candidate has been submitted. Build 17 is reserved; Cloud Default archive preparation was changed from internal-only to App Store Connect at 04:25 UTC and read back as saved. Revert that preparation selection to internal-only to roll back the workflow change; no build was started from old source.

Implemented: Settings permission recovery, active/inactive camera lifetime, synchronous opaque preview concealment, connection mirroring, recoverable failures/interruption, actual-screen brightness capture/restoration and accessible digital zoom. Shipping services remain real, local AVFoundation/UIKit services. Privacy manifest declares no tracking/data collection; non-exempt encryption is false.

Focused real session-driver and controller regression: 10/10 passed, no skips, on iPhone 18 Pro simulator iOS 27.0 build 24A434 / Xcode 27.0 build 27A266a. Worker commit ff7f4f964b92f096c80de96e278ed6de53393f07; full optimized unit suite (14/14), independent final source review, both actual simulator UI paths, normal signed Release build and validated Cloud upload have since passed. Physical QA, recording and submission remain Pending. See the release report and acceptance records as gates finish.

Environment recovery: original Documents-backed Git metadata became iCloud dataless; Git reads blocked. Requests to download the directory and two release references did not immediately restore them. Release contents were copied into a fully local clone at /private/tmp/mirror-release-local, based on published setup d9ca65f, with the two worker-owned files copied exactly from ff7f4f9. Original primary HEAD/index/app/media were not rewritten. The release checkpoint is now pushed in PR #2; /private/tmp itself remains temporary storage. Build metadata commands now time out and retain a failure receipt rather than waiting indefinitely.

Release checkpoint: [qualification report](agent-reports/release-readiness.md), [evidence](agent-reports/release/evidence.json), [draft App Review response](APP_REVIEW_RESPONSE.md). Published draft PR #2 checkpoint 3e47a5f includes test correction 7c221bb; its shipping inputs still match e353f43. Cloud build17 succeeded from that exact shipping commit and the uploaded binary is Validated / Ready to Submit with no compliance gap. This is build availability, not a submitted publishing request. Pricing is $0 in all 175 offered regions. Unqualified Mac and Vision Pro distribution was disabled, saved and read back; iPhone is the supported release scope.

Physical attempt failed before test bootstrap: phone passcode required, then testmanagerd connection lost; zero physical tests passed. Subsequent host checks still report the iPhone passcode required and Mac native controls locked despite the user's unlock replies. User keep-awake/USB readiness request is pending. Resume with actual readiness verified before a fresh physical test and recording; do not reuse the failed attempt as acceptance.

Hosted iOS regression run 38349732937 failed before app tests: compile passed, but post-boot `xcodebuild -version` exceeded the 45-second metadata timeout. Startup-order correction 870bdf2 passed both PR checks in run 38352795085 with 14 tests passed, zero failed/skipped. Its companion push run 38352790911 compiled and executed 14 tests but failed one test with two readiness/recovery assertions (13 passed, one failed, zero skipped). The initial real-session startup exceeded the test's two-second polling allowance; the test then posted notifications without confirmed startup. The exact delayed terminal event was not logged. Fresh high-effort worker correction c1aa7da is integrated locally as 7c221bb: the test awaits actual terminal startup, bounds that setup with a 30-second watchdog, aborts failed setup, and retains the interruption/recovery assertions. Debug and cold optimized Release each passed 14/0/0; independent medium review found no material issues. Only the test changed; shipping inputs still match build17. Focused optimized Release verification also passed 20/20 across 20 distinct app processes with no source drift; worker simulator was deleted. Hosted runs 38357124662 (PR) and 38357117809 (push) both completed successfully; actual downloaded artifacts each show 14/0/0 with all source/log hashes verified. Current automated qualification is Passed; physical/product/submission gates remain Pending. See [CI evidence](agent-reports/release/ci-evidence.json). Original primary Git metadata still needs restoration before any synchronization of the original checkout.

Private raw receipts/logs/result bundles and saved App Store proof were preserved under `.artifacts/release-20261013/qualification-evidence-0600.tar.gz` in the primary repository at 06:20 UTC; manifest records SHA-256 and 1,577 files. DerivedData trees were excluded. Current Git history is also in `repository-checkpoint-3e47a5f.bundle`; `git bundle verify` confirms complete history. These are local recovery copies, not an independently verified cloud backup; no private diagnostics were published.

The independent xhigh release [checkpoint audit](agent-reports/release-checkpoint-ecaa.md) checked ecaa1ef receipts and preservation. Its stale-CI and historical-plan findings were corrected; strict host signature evidence reconciles the auditor's sandbox trust limitation. Later changes require current review/audit; this does not close physical or submission gates.

The fresh independent xhigh [current checkpoint audit](agent-reports/release-audit-current.md) verified source/evidence/recovery copies and found no new shipping blocker. Its two handoff wording findings were corrected. Current CI artifacts and the full audit/review reports are also preserved privately in `current-hosted-and-audit-evidence.tar.gz`; see the CI evidence manifest. Final handoff record edits do not change qualified app/test inputs.

Final device-access recheck still reports the Mac locked and iPhone passcode required. Next unfinished step: bring the Mac to its desktop and the USB-connected iPhone to its home screen, keep both awake, verify actual readiness, execute the device checklist, then record and inspect the authorized non-private demo. Reinstall the normal signed 1.0/17 Release app before the genuine demo. Only after those gates can the coordinator complete reviewed main integration/protection, select matching build17, attach the recording/response and verify App Store resubmission. No new publishing approval is needed; actual device access and missing evidence are the blocker.
