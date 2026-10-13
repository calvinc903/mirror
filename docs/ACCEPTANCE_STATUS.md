# Acceptance evidence

| ID | Contract | State | Candidate/environment | Receipt | Owner/next action |
| --- | --- | --- | --- | --- | --- |
| SETUP-1 | Preserve primary user work | Passed | Primary HEAD/staging and 38 original file hashes preserved; README appendix authorized | [Preservation](agent-reports/user-preservation.json) | Coordinator: keep user app/media work separate |
| DOCS-1 | Adapt all fourteen role/workflow documents | Passed | Seventeen project documents including checklist/report | [Plan](PROJECT_PLAN.md) | Coordinator: recheck links after record updates |
| CHECKS-1 | Validate documentation/build gate controls | Passed | Eleven focused regressions, including fail-closed build receipt | [Workflow](DEVELOPMENT_WORKFLOW.md) | Coordinator: rerun after relevant script changes |
| BUILD-1 | Source-bound app compile with real command | Passed | Reviewed source digest; Xcode 27.0, Simulator 27.0, signing disabled | [Hosted receipt](agent-reports/restored-build-receipt.json) | Coordinator: retain current source binding |
| CI-1 | Both hosted checks succeed and propagate failure | Passed | Ubuntu 24.04 / xcode-27; GitHub Actions app 15368 | [Controls](agent-reports/ci-controls.json) | Coordinator: rerun affected checks after changed inputs |
| REVIEW-1 | Independent implementation review and checkpoint audit | Passed | 56032c2 implementation; 366a20a supplemental records and preservation | [Audit](agent-reports/checkpoint-audit.md) | Coordinator: reopen review after material changes |
| ENFORCE-1 | Effective PR/check/no-force protection | PR protection active; required checks Pending | Main PR/admin/no-force/no-delete policy read back | [Rule](agent-reports/github-protection-current.json) | Coordinator: authorized main integration, then activate/qualify required contexts |
| HANDOFF-1 | Accurate checkpoint publication, gaps and next action | Passed | Setup installed locally and pushed in draft PR #1; current release checkpoint and results published in PR #2 | [Status](PROJECT_STATUS.md) | Coordinator: complete qualified main integration, then qualify required contexts |
| DEVICE-1 | Real-device camera and brightness behavior | Pending | Current release attempt failed before bootstrap; zero physical passes | [Device checklist](DEVICE_CHECKLIST.md) | Coordinator: verify Mac/iPhone awake, execute actual device acceptance |

Documentation validation and simulator compilation establish their named contracts only. Product behavior, human approval, server enforcement and schedules require their own evidence. Changed relevant inputs invalidate affected receipts. Keep local, committed, pushed and merged states distinct.

## Production release gates

| ID | Contract | State | Evidence / next action |
| --- | --- | --- | --- |
| PROD-PERM-1 | Denial, Settings grant/revocation and safe re-entry | Pending | 14-unit suite and actual denial UI passed; physical Settings grant/revocation required |
| PROD-CAMERA-1 | Mirrored preview, lifetime, failure/interruption recovery | Pending | Real driver/controller regression and simulator recovery UI passed; optical/device checks required |
| PROD-LIGHT-1 | Correct edge light and user brightness restoration | Pending | Brightness regression passed in full 14-unit suite; physical screen checks required |
| PROD-A11Y-1 | Accessible light/zoom controls | Pending | UI and visual checks required |
| PROD-PRIVACY-1 | Immediate preview concealment, local-only processing | Pending | Source implementation; actual app-switcher/archive checks required |
| PROD-TEST-1 | Full app tests and independent final review | Pending | 14 optimized unit tests, two simulator UI paths and independent shipping-source review passed; physical acceptance Pending |
| PROD-CI-1 | Current hosted regressions and source binding | Passed | PR 38357124662 and push 38357117809 each 14/0/0 at reviewed 3e47a5f; raw artifacts/log/source hashes verified; [CI evidence](agent-reports/release/ci-evidence.json) |
| RELEASE-1 | Matching signed App Store eligible candidate | Passed | Cloud17 from reviewed e353f43; uploaded 1.0/17 Validated / Ready to Submit; see [release evidence](agent-reports/release/evidence.json) |
| REVIEW-INFO-1 | Physical demo and six Apple information items | Pending | User authorized non-private demo; locked-device attempt failed before bootstrap. Draft response saved; actual recording required |
| SUBMIT-1 | Submitted matching qualified candidate | Pending | App Store status remains Rejected; submit only after readiness gates |

Current release evidence and private raw artifact pointers: [qualification report](agent-reports/release-readiness.md). Build readiness does not establish physical product readiness or App Store submission.
