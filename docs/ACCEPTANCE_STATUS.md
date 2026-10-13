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
| HANDOFF-1 | Accurate checkpoint publication, gaps and next action | Passed | Installed locally and committed/pushed in draft PR #1 | [Status](PROJECT_STATUS.md) | Coordinator: await main-integration authorization, then qualify required contexts |
| DEVICE-1 | Real-device camera and brightness behavior | Pending | No physical-device run for this setup | [Device checklist](DEVICE_CHECKLIST.md) | Coordinator: lease device for future product changes |

Documentation validation and simulator compilation establish their named contracts only. Product behavior, human approval, server enforcement and schedules require their own evidence. Changed relevant inputs invalidate affected receipts. Keep local, committed, pushed and merged states distinct.

## Production release gates

| ID | Contract | State | Evidence / next action |
| --- | --- | --- | --- |
| PROD-PERM-1 | Denial, Settings grant/revocation and safe re-entry | Pending | Controller regression passed; actual UI/device checks required |
| PROD-CAMERA-1 | Mirrored preview, lifetime, failure/interruption recovery | Pending | Real driver/controller regression 10/10; optical/device checks required |
| PROD-LIGHT-1 | Correct edge light and user brightness restoration | Pending | Full regression and physical screen checks required |
| PROD-A11Y-1 | Accessible light/zoom controls | Pending | UI and visual checks required |
| PROD-PRIVACY-1 | Immediate preview concealment, local-only processing | Pending | Source implementation; actual app-switcher/archive checks required |
| PROD-TEST-1 | Full app tests and independent final review | Pending | Scoped 10/10 passed; full candidate execution/review required |
| RELEASE-1 | Matching signed App Store eligible candidate | Pending | Reserve 1.0 build 17; prepare candidate-bound archive/upload |
| REVIEW-INFO-1 | Physical demo and six Apple information items | Pending | User authorized non-private demo; recording and accurate notes required |
| SUBMIT-1 | Submitted matching qualified candidate | Pending | App Store status remains Rejected; submit only after readiness gates |
