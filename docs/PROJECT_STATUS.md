# Mirror current status

Goal: maintain the iPhone mirror camera app with coordinated agents, independent review and verified PR delivery.
Stack: SwiftUI, AVFoundation, UIKit; Xcode 27; iOS 27. Single app target; no XCTest target.
Priority: camera privacy, permission handling, mirrored preview, session teardown and screen-brightness restoration.
Repository: `calvinc903/mirror`; default branch: `main`.

## Setup checkpoint

The user requested adoption of Repository Agent System on October 12, 2026. Setup is isolated on `codex/repository-agent-system`, based on remote `main` at `c22a76752d6e73a965e452c4f51236ca178eaef4`. The primary checkout starts at `c030565241732e3aa591ee8ca019534ba325af73` with staged, unstaged and untracked user work; preserve it.

State: role/workflow documentation and executable checks implemented, independently reviewed and pushed in [draft PR #1](https://github.com/calvinc903/mirror/pull/1). All seventeen documentation checks and eleven regressions passed; both hosted checks passed with Xcode 27.0 (27A266a), and each independent failure control behaved correctly. See [acceptance](ACCEPTANCE_STATUS.md) and [setup report](agent-reports/agent-system-setup.md) for current receipts.

Shared-resource owner: coordinator owns integration, GitHub settings and build execution; no camera/device lease assigned. No schedules or hooks installed.

Next: finish local installation/preservation checks and checkpoint audit, then obtain authorization to integrate PR #1 on `main`. PR/no-force/admin protection is active. Required new check contexts remain Pending until the workflow is on `main`; activate the prepared policy and verify an ordinary main-based PR and both failure-blocking paths afterward.

## Product gaps

- Physical-device permission, mirroring, lighting, zoom and brightness-restoration checks are Pending; owner: coordinator; next: assign the [device checklist](DEVICE_CHECKLIST.md) with a device lease when product changes require it.
- No XCTest target exists. Add focused product tests with the first suitable behavior change; do not relabel documentation tests as app tests.
- The README mentions iPad, while `TARGETED_DEVICE_FAMILY = 1` currently selects iPhone. iPad support is unverified; revisit only with an explicit product task.
