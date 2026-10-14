# Agent-system setup report

User request: adopt Repository Agent System for Mirror. Setup scope: role/workflow documentation, reproducible verification, compatible CI and protected PR delivery. Product source, camera/device operations, signing, App Store release, hooks and scheduling are excluded.

## Baseline and planning

Primary checkout: `main` at `c030565241732e3aa591ee8ca019534ba325af73` with user changes. Setup/review worktrees start from remote `main` at `c22a76752d6e73a965e452c4f51236ca178eaef4`. Primary app source/project/privacy files were byte-identical to that remote base despite the older local HEAD. Hashes and staged-diff digest were captured before adoption.

Skill generation ran preview-first in a fresh temporary proposal, then consciously merged fourteen nonconflicting paths. Existing `docs/privacy.html` preserved. The installed skill passed `quick_validate.py` (temporary Python venv with PyYAML 6.0.3) and all twelve initializer unit tests. These validate the skill/initializer, not Mirror behavior.

Planning agent: `gpt-6.1-sol`, `xhigh`, report-only registered worktree. Independent plan critic: separate registered worktree, same model/effort. Three material recommendations adopted: defer new required contexts until workflow bootstrap on main; test both independent failure paths; distinguish actual merge checkout from PR head in receipts. No product feature inferred.

Local baseline command: `xcodebuild -project Mirror.xcodeproj -scheme Mirror -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' -configuration Debug -derivedDataPath /private/tmp/mirror-setup-evidence/baseline-derived-data -resultBundlePath /private/tmp/mirror-setup-evidence/baseline-build.xcresult CODE_SIGNING_ALLOWED=NO build`. Exit 0; Xcode 27.0 (27A266a), iOS Simulator SDK 27.0. Raw baseline log/result retained under `/private/tmp/mirror-setup-evidence/`; temporary storage is not a durable backup.

Official runner source: [GitHub runner-images Xcode 27 announcement](https://github.com/actions/runner-images/issues/14404), read October 13 UTC / October 12 America/New_York. The `xcode-27` label is a preview; normal macOS 26 images inspected had Xcode 26. Hosted availability was subsequently verified by the successful runs below.

## Candidate evidence and disposition

Implementation review passed at `56032c2f50d858a2b1e856d6e7c3b822cd01adf9` in the distinct registered reviewer worktree. One P2 was found and resolved: a post-build manifest exception after successful Xcode execution could retain exit 0. The handler now fails with exit 2; four build-gate regression controls cover that failure, changed source, Xcode failure propagation and unchanged success. Independent re-review found no remaining material findings; all seventeen documents and eleven regressions passed. Model/effort: Sol 6.1 medium. Reviewer made no edits or external mutations.

The control/restoration commit `a875a07120819ca0e829b737adc3aca127f21492` has the exact reviewed tree `fa778e7e12497444e2ce225619c5704c4b857691`; `git diff 56032c2..a875a07 --exit-code` passed. [Reviewed input manifest](reviewed-files.json) retains hashes before the supplemental status/receipt updates; those documentation updates receive a checkpoint audit and fresh link checks.

## Hosted positive and negative controls

- [Restored positive PR run 38342271037](https://github.com/calvinc903/mirror/actions/runs/38342271037): both checks succeeded. PR head `a875a07120819ca0e829b737adc3aca127f21492`; actual merge checkout/event `3427c6e68dbbf1e859ce4a7fa636b6058d5bec33`; checkout tree equals the reviewed tree. Source digest `870998da3ae02ded17b84494c233b3987f53c9c0849c12e852ec053994dd9425`. Workflow SHA-256 `d39522f3f3da4a64e603a3aa86b814a3a075f8a0a1f9f2b2f0544d0a27560655`. [Receipt](restored-build-receipt.json).
- [Documentation negative PR run 38342068840](https://github.com/calvinc903/mirror/actions/runs/38342068840): unresolved template parameter at head `a764525c5d59ede06f844ec08ddc9039324ae9d8` failed `agent-system`, while `ios-build` succeeded.
- [Build negative PR run 38342237037](https://github.com/calvinc903/mirror/actions/runs/38342237037): nonexistent scheme at head `201591e05a0ed7308e3a5f665fd2689829373cf2` failed `ios-build` with Xcode/wrapper exit 65, while `agent-system` succeeded. Actual merge checkout `6e6618e38c213f1a6e1530a0a4d0be875477d083`. [Receipt](negative-build-receipt.json).

[Control/job/check-app receipts](ci-controls.json) show actual runner labels Ubuntu 24.04 and xcode-27, with both contexts produced by GitHub Actions app 15368. The positive receipt records Xcode 27.0 (27A266a), Simulator SDK 27.0 and unchanged source inputs. Build logs and result bundles are attached as workflow artifacts, with thirty-day retention; source-bound receipts and links are committed here. Local raw evidence remains under `/private/tmp/mirror-setup-evidence/` and is not a durable backup.

One attempted negative control changed scheme target references; Xcode still compiled successfully, so it did not qualify failure propagation. Its raw local receipt is retained as `scheme-failure-control/receipt.json`; the scheme was restored and the nonexistent scheme-name control established the failure path. No workaround or product repair resulted.

## Effective protection and publication

[Draft PR #1](https://github.com/calvinc903/mirror/pull/1) is the pushed setup checkpoint. No merge or App Store release occurred. Main now requires PRs, applies the rule to administrators, disallows force pushes/deletion and requires conversation resolution. Zero human approvals is deliberate for the solo author; independent agent review remains a separate local gate.

[Before rule](github-protection-before.json) and [effective readback](github-protection-current.json) preserve the initial unprotected state and installed PR-only protection. New required contexts remain **Pending** because the workflow is only on the setup branch. The draft's mergeability does not establish check enforcement. Next: obtain authorization for main integration, then apply the [prepared required-check policy](required-check-protection.json), read it back, and qualify an ordinary main-based PR plus each independent failed-check blocking path. Coordinator owns this remaining ENFORCE-1 action. Never require absent contexts to force integration.

Primary installation completed: thirty-one setup paths were copied after conflict/symlink preflight. Thirty-eight existing file hashes, original primary HEAD and the staged-diff digest were preserved. README retains its original bytes with the authorized twelve-line workflow appendix. [Compact preservation receipt](user-preservation.json); the full original manifest stays in private temporary storage.

Fresh Sol 6.1 xhigh checkpoint audit passed with no material findings, reviewing `366a20a2eb1c11b3ec478f635003222510af8b6e` (tree `479f59a84446699925c3128a6322af9c73a21683`) plus the compact preservation receipt. The auditor independently recomputed source/receipt/preservation digests, compared scope and ran seventeen documentation checks, eleven regressions and diff whitespace checks. Commands `python3 scripts/check_agent_system.py` and `python3 -m unittest discover -s scripts/tests -v` both exited 0 between `2026-10-13T03:40:25.729857Z` and `03:40:25.906858Z` on Python 3.14.3, macOS 27 arm64. Root adopted all three follow-up actions: finalize truthful records, retain the audit timing boundary, and seek final integration authorization before required-context activation. See [audit report](checkpoint-audit.md).

The meaningful full-checkpoint boundary is `2026-10-13T03:37:26Z`, from the audited commit timestamp. Exact audit dispatch time was not instrumented and remains unavailable; subsequent clock readback was `2026-10-13T03:40:40Z`. Future coordinators must sample dispatch time before spawning. No two-hour active-work boundary was reached in this setup. Activity/utilization and avoidable waiting are Unknown.

The package is installed locally, committed and pushed in draft PR #1. [Acceptance](../ACCEPTANCE_STATUS.md) is authoritative; main integration and required-context qualification remain the next unfinished step.

No recurring automation or local hooks were installed. No physical-device/product acceptance was executed. The current single app target has no XCTest target. README iPad wording exceeds currently configured iPhone family; recorded as a future product clarification.
