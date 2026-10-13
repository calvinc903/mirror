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

Environment recovery: original Documents-backed Git metadata became iCloud dataless; Git reads blocked. Requests to download the directory and two release references did not immediately restore them. Release contents were copied into a fully local clone at /private/tmp/mirror-release-local, based on published setup d9ca65f, with the two worker-owned files copied exactly from ff7f4f9. Original primary HEAD/index/app/media were not rewritten. Checkpoint branch publication remains necessary; /private/tmp is temporary storage, not a backup. Build metadata commands now time out and retain a failure receipt rather than waiting indefinitely.

Release checkpoint: [qualification report](agent-reports/release-readiness.md), [evidence](agent-reports/release/evidence.json), [draft App Review response](APP_REVIEW_RESPONSE.md). Draft PR #2 is open at shipping commit e353f43. Cloud build17 succeeded from that exact commit and the uploaded binary is Validated / Ready to Submit with no compliance gap. This is build availability, not a submitted publishing request.

Physical attempt failed before test bootstrap: phone passcode required, then testmanagerd connection lost; zero physical tests passed. Mac native controls also reported a locked screen. User unlock/keep-awake request is pending. Resume with actual readiness verified before a fresh physical test and recording; do not reuse the failed attempt as acceptance. Hosted iOS regression step remains running; its compile step passed. Original primary Git metadata still needs restoration before any synchronization of the original checkout.
