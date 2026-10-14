# Mirror release qualification — in progress

App: Just a Mirror!, com.calvincheah.mirror, version 1.0/build 17. Overall production readiness and App Store resubmission are **Pending**. No publication request has been sent to Apple for this candidate.

## Implemented and reviewed

Camera authorization is refreshed on re-entry; denial offers Settings recovery. Active/inactive lifetime controls capture, immediately conceals the preview, restores screen brightness, and rejects stale camera events. Mirroring is configured after a preview connection exists. Failures and interruptions have recovery paths; digital zoom has accessible labels/values. Shipping defaults use real local Apple services, with no accounts, storage, analytics, network services, purchases or third-party SDKs.

Independent medium review cleared shipping commit `e353f43c858b12e0c45f34ead2340f01cfb34c3a`, tree `abc835d1af1f88a03a43bbeac405d5d1141721d1`. Its notification-race P2 and missing-results-receipt P2 were fixed with focused reproductions/regressions. Optimized unit invocations enable testability only for internal test imports; normal shipping Release archives retain their default settings.

## Executed evidence

See [machine-readable evidence](release/evidence.json) for timestamps, actual exits, source hashes, redacted argv, log hashes and private raw artifact locations.

| Check | Result | Environment / limit |
| --- | --- | --- |
| Full local camera/brightness unit suite | 14 passed, 0 failed, 0 skipped | Optimized Release/testability, iOS 27.0 simulator build 24A434, Xcode 27.0 build 27A266a; later hosted companion run exposed a startup synchronization failure |
| Denied-camera UI / re-entry | 1 passed, 0 failed, 0 skipped | Actual OS permission prompt; fresh consent state; screenshot retained |
| Granted / unavailable-camera / retry / re-entry UI | 1 passed, 0 failed, 0 skipped | Actual simulator camera service; screenshot retained; no synthetic preview |
| Python receipt/document regressions | 15 passed | Includes stalled Git metadata and missing result-bundle failure controls |
| Normal signed device Release build | Passed; strict signature verification passed | Apple Development provisioning; bundle 1.0/17, iPhone/portrait/iOS27, privacy manifest included |
| Physical UI attempt | Failed to bootstrap; 0 passed | iPhone 13 Pro, actual iOS 27.2 build 24B5089g; passcode required then testmanagerd connection lost; no camera acceptance established |
| Xcode Cloud build 17 | Succeeded | Exact shipping commit e353f43; stable Xcode27; App Store Connect preparation |
| Uploaded build 17 | Validated; Ready to Submit | iPhone, min iOS27.0, SDK24A430, no non-exempt encryption, get-task-allow false |
| Hosted PR checks at 870bdf2 | Both passed; unit 14/0/0 | Run 38352795085; synthetic checkout tree matches reviewed candidate |
| Companion hosted push at 870bdf2 | Failed; unit 13 passed, 1 failed, 0 skipped | Run 38352790911; two assertions in the co-queued interruption test after initial startup exceeded its polling allowance |
| Corrected hosted PR and push at 3e47a5f | Both passed; each unit 14/0/0 | Runs 38357124662 and 38357117809; actual artifacts and all source/log hashes inspected |

Local signed build evidence: `/private/tmp/mirror-release-device-1`. Raw physical diagnostics remain local and are not uploaded as review evidence. The original optimized unit receipt qualifies the e353f43 shipping source; it predates the later missing-results guard, retained UI screenshots and CameraSessionDriverTests startup-barrier correction. Current corrected Debug and cold optimized Release each passed 14/0/0 with source/log hashes matching integrated 3e47a5f; see [CI evidence](release/ci-evidence.json). Shipping source remains identical to build17; later changes affect tests, CI and records.

## Inspected visuals

These are actual iPhone 18 Pro simulator screenshots, captured by XCTest, retained unchanged and inspected on October 13. The explanations and recovery controls are visible and legible. They establish these fallback states only; they do not satisfy Apple's physical-device recording request.

<img src="release/denied-camera.png" width="260" alt="Actual denied-camera UI with Open Settings">
<img src="release/unavailable-camera.png" width="260" alt="Actual simulator camera-unavailable UI with Try Again">

## Remaining gates and next actions

- Coordinator: unlock/read actual readiness of both the Mac and iPhone, keep them awake, then rerun the physical UI test with a fresh artifact path. Inspect live mirroring, light/zoom, Settings grant/revocation, portrait behavior and app-switcher concealment; verify actual brightness restoration against the device checklist.
- Coordinator: create and inspect a genuine non-private physical-device recording from launch through typical flow. The user authorized this demo to Apple. Preserve exact device OS, source/build and recording provenance. No simulator/mock recording is acceptable. The available phone runs iOS27.2; do not call that public/stable OS coverage.
- Coordinator: verify product-page screenshots against current app behavior, publish the corrected support/privacy documents through reviewed main integration, and activate/qualify prepared required-check protection. PR #2 remains draft; PR #1 remains unmerged.
- Coordinator: send the [prepared App Review response](../APP_REVIEW_RESPONSE.md) with the genuine recording, select the matching validated build17 and verify resubmission in App Store Connect. Current rejected version still selects build1; no Notes/reply/submission changes were sent. Automatic release after Apple approval is already selected.
- Completed automated correction qualification: test synchronization correction 7c221bb. Removing explicit pre-metadata simulator boot fixed the original 45-second metadata failure for PR run 38352795085 (14/0/0). Companion push 38352790911 exposed slow cold capture-session setup: the initial readiness assertion failed, then the test posted notifications without confirmed startup. Source trace supports a delayed terminal event invalidating those notifications; the exact event was not logged. Fresh high-effort test-only correction now waits for actual terminal startup and aborts failed setup, retaining interval assertions; independent review is clear and Debug/cold optimized Release each passed 14/0/0. Focused optimized Release verification passed 20/20 across 20 distinct app processes with no source drift. Current hosted PR 38357124662 and push 38357117809 both passed; each actual downloaded result shows 14/0/0 and matching source/log hashes. Original failed/passing evidence is preserved in [CI evidence](release/ci-evidence.json). No shipping source changed.

Strict signature trust reconciliation: the auditor's sandboxed recheck returned `CSSMERR_TP_NOT_TRUSTED`. A fresh check of the same executable/Info.plist with normal host trust access exited 0 at 05:35:42 UTC, preserving the exact argv, context and binary hashes in [verification](release/signature-verification.json). Validation was not weakened. This local development signature is separate from the validated Cloud distribution binary.

## Local recovery and preservation

Original Documents-backed Git metadata became iCloud dataless and read operations stalled. Directory and per-reference download requests did not immediately restore it. A fully local clone at `/private/tmp/mirror-release-local` was created from published setup `d9ca65f`, preserving the original checkout/index/app/media. Worker changes were copied from committed, owned files and integrated into the release commit; source-bound raw receipts remain available. The committed candidate is backed up on `codex/app-store-release` and [draft PR #2](https://github.com/calvinc903/mirror/pull/2). Private raw evidence was archived locally in the primary repository at `.artifacts/release-20261013/qualification-evidence-0600.tar.gz`; its preservation manifest records SHA-256 `7654808e17bde7133c7b4c965ec32a3da2ef044185aa33bd89af804349a63f6f` and 1,577 files. DerivedData was excluded; independent cloud backup is not established.

Distribution scope: $0 pricing across all 175 offered regions was inspected. Mac and Vision Pro availability checkboxes were unchecked, saved and read back because those platforms are outside qualified scope. Rollback is to re-enable each checkbox only after its device behavior is qualified. Proof: `/private/tmp/mirror-release-evidence/platform-availability-saved.png`, also included in the private archive. The rejected version still selects build1; automatic release after approval remains selected.

Cloud workflow rollback: change Default → Archive iOS → Distribution Preparation from App Store Connect back to TestFlight (Internal Testing Only). This is separate from reverting app source. Do not reuse builds8–16 for App Store submission; they are internal-only. Build17 is the validated eligible candidate.

Private interruption-correction evidence was preserved in primary `.artifacts/release-20261013/interruption-fix-evidence.tar.gz`; its manifest records SHA-256 `ca14a8754072a250b325df5eb88cb68f934fd9f4d5bf39fc30154793b034b0b9` and 452 files. This includes cold baseline/fixed full suites, actual 20-relaunch results and simulator cleanup; DerivedData was excluded.

Current corrected hosted qualification: PR and push at 3e47a5f both passed documentation/build/app-test checks. Actual downloaded artifacts each contain 14 passes, zero failures/skips and matching source/log hashes. Full audit/review and both hosted artifacts are preserved privately in `current-hosted-and-audit-evidence.tar.gz`, 142 files, SHA-256 `4e64a07baec716bd17e870b5b5579eda5ee07cfbbda95225f0755007ac367117`. Physical qualification and submission remain Pending.
