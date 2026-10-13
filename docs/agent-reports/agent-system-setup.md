# Agent-system setup report

User request: adopt Repository Agent System for Mirror. Setup scope: role/workflow documentation, reproducible verification, compatible CI and protected PR delivery. Product source, camera/device operations, signing, App Store release, hooks and scheduling are excluded.

## Baseline and planning

Primary checkout: `main` at `c030565241732e3aa591ee8ca019534ba325af73` with user changes. Setup/review worktrees start from remote `main` at `c22a76752d6e73a965e452c4f51236ca178eaef4`. Primary app source/project/privacy files were byte-identical to that remote base despite the older local HEAD. Hashes and staged-diff digest were captured before adoption.

Skill generation ran preview-first in a fresh temporary proposal, then consciously merged fourteen nonconflicting paths. Existing `docs/privacy.html` preserved. The installed skill passed `quick_validate.py` (temporary Python venv with PyYAML 6.0.3) and all twelve initializer unit tests. These validate the skill/initializer, not Mirror behavior.

Planning agent: `gpt-6.1-sol`, `xhigh`, report-only registered worktree. Independent plan critic: separate registered worktree, same model/effort. Three material recommendations adopted: defer new required contexts until workflow bootstrap on main; test both independent failure paths; distinguish actual merge checkout from PR head in receipts. No product feature inferred.

Local baseline command: `xcodebuild -project Mirror.xcodeproj -scheme Mirror -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' -configuration Debug -derivedDataPath /private/tmp/mirror-setup-evidence/baseline-derived-data -resultBundlePath /private/tmp/mirror-setup-evidence/baseline-build.xcresult CODE_SIGNING_ALLOWED=NO build`. Exit 0; Xcode 27.0 (27A266a), iOS Simulator SDK 27.0. Raw baseline log/result retained under `/private/tmp/mirror-setup-evidence/`; temporary storage is not a durable backup.

Official runner source: [GitHub runner-images Xcode 27 announcement](https://github.com/actions/runner-images/issues/14404), read October 13 UTC / October 12 America/New_York. The `xcode-27` label is a preview; normal macOS 26 images inspected had Xcode 26. Actual hosted availability remains Pending until executed.

## Candidate evidence and disposition

Implementation review, candidate build, hosted controls, PR publication and effective rules: Pending. Coordinator owns next actions in [acceptance](../ACCEPTANCE_STATUS.md).

No recurring automation or local hooks were installed. No physical-device/product acceptance was executed. The current single app target has no XCTest target. README iPad wording exceeds currently configured iPhone family; recorded as a future product clarification.
