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
| DEVICE-1 | Real-device camera and brightness behavior | Passed for exercised configuration | Actual physical UI attempt4 and normal Release17 demo each1/0/0; user confirmed four physical checks; selected accessibility audits passed | [Physical evidence](agent-reports/release/physical-ui-evidence.json) | Coordinator: extended manual VoiceOver remains Pending; keep evidence boundaries |

Documentation validation and simulator compilation establish their named contracts only. Product behavior, human approval, server enforcement and schedules require their own evidence. Changed relevant inputs invalidate affected receipts. Keep local, committed, pushed and merged states distinct.

## Production release gates

| ID | Contract | State | Evidence / next action |
| --- | --- | --- | --- |
| PROD-PERM-1 | Denial, Settings grant/revocation and safe re-entry | Passed | Automated denial/controller checks plus user-confirmed physical Settings revoke/regrant and preview recovery |
| PROD-CAMERA-1 | Mirrored preview, lifetime, failure/interruption recovery | Passed for exercised configuration | Live captures and actual UI reentry; unit interruption/recovery checks; user-confirmed physical written-text reversal. Remote-viewing conflict preserved; no shipping camera defect established |
| PROD-LIGHT-1 | Correct edge light and user brightness restoration | Passed | Unit and actual UI checks; user confirmed physical screen brightening and restoration on light-off/leaving |
| PROD-A11Y-1 | Accessible light/zoom controls | Passed for bounded audits | Real-device labels/touch plus default description, hit-region and trait audits passed in light Off/On states1/0/0; manual VoiceOver and extended checks remain Pending |
| PROD-PRIVACY-1 | Immediate preview concealment, local-only processing | Passed | Source/archive checks and user-confirmed opaque physical app-switcher card; camera frames remain local |
| PROD-TEST-1 | App tests and independent source review | Passed for bounded candidate | 14 optimized units, two simulator UI paths, physical UI1/0/0, physical accessibility audit1/0/0 and independent reviews passed; four direct physical checks confirmed by user |
| PROD-CI-1 | Current hosted regressions and source binding | New test checkpoint Pending | Historical reviewed3e47a5f PR38357124662 and push38357117809 each14/0/0; new physical test additions compiled/executed locally but need current hosted result. [CI evidence](agent-reports/release/ci-evidence.json) |
| RELEASE-1 | Matching signed App Store eligible candidate | Passed | Cloud 17 from reviewed e353f43; uploaded 1.0/17 Validated / Ready to Submit; see [release evidence](agent-reports/release/evidence.json) |
| REVIEW-INFO-1 | Physical demo and six Apple information items | Pending; user review required | Genuine normal Release 17 device recording produced locally. User reviews recording; dock permitted and other apps outside dock forbidden. Show all proposed media/text, finish physical checklist and obtain user approval before uploading or submitting |
| SUBMIT-1 | Submitted matching qualified candidate | Pending; explicit user hold | App Store remains Rejected with build 1 selected. User must review and approve final media/update before submission; qualified build 17 remains available |

Current release evidence and private raw artifact pointers: [qualification report](agent-reports/release-readiness.md). Build readiness does not establish physical product readiness or App Store submission.

## October21 developer correction

- ORIENT-18: Passed for the exercised iPhone18Pro path. Developer build18 installed; user confirmed upright portrait preview before and after Home/reentry. This does not establish old-phone or broader-device regression coverage.
- REVIEW-ORIENT: Fresh independent source review passed for c2547260; signed build/strict signature and installation verification passed. Seventeen document checks and fifteen tooling regressions passed.
- Optical screenshots/new media: not captured; private local fix only. No visual proof or new App Store release is claimed. Simulator unit execution and hosted checks are recorded separately in the correction report; do not infer them from compilation or the user's orientation check.
