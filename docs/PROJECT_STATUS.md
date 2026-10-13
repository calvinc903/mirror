# Mirror current status

Goal: maintain the iPhone mirror camera app with coordinated agents, independent review and verified PR delivery.
Stack: SwiftUI, AVFoundation, UIKit; Xcode 27; iOS 27. Single app target; no XCTest target.
Priority: camera privacy, permission handling, mirrored preview, session teardown and screen-brightness restoration.
Repository: `calvinc903/mirror`; default branch: `main`.

## Setup checkpoint

The user requested adoption of Repository Agent System on October 12, 2026. Setup is isolated on `codex/repository-agent-system`, based on remote `main` at `c22a76752d6e73a965e452c4f51236ca178eaef4`. The primary checkout starts at `c030565241732e3aa591ee8ca019534ba325af73` with staged, unstaged and untracked user work; preserve it.

State: role/workflow documentation and executable checks implemented locally; publication and final independent review Pending. The baseline signing-free simulator build passed on Xcode 27.0 (27A266a). See [acceptance](ACCEPTANCE_STATUS.md) and [setup report](agent-reports/agent-system-setup.md) for current receipts.

Shared-resource owner: coordinator owns integration, GitHub settings and build execution; no camera/device lease assigned. No schedules or hooks installed.

Next: verify the hosted positive/negative controls, complete independent review, publish the setup checkpoint and qualify GitHub protection. Required new checks remain Pending activation until the workflow exists on `main` and an ordinary main-based PR can run it.

## Product gaps

- Physical-device permission, mirroring, lighting, zoom and brightness-restoration checks are Pending; owner: coordinator; next: assign the [device checklist](DEVICE_CHECKLIST.md) with a device lease when product changes require it.
- No XCTest target exists. Add focused product tests with the first suitable behavior change; do not relabel documentation tests as app tests.
- The README mentions iPad, while `TARGETED_DEVICE_FAMILY = 1` currently selects iPhone. iPad support is unverified; revisit only with an explicit product task.
