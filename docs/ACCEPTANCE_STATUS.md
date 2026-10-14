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
| HANDOFF-1 | Accurate checkpoint publication, gaps and next action | Passed | Setup/release integrated through reviewed PR #2 at14b929e; submission recorded; PR #1 is superseded historical setup | [Status](PROJECT_STATUS.md) | Coordinator: complete qualified main integration, then qualify required contexts |
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
| PROD-CI-1 | Current hosted regressions and source binding | Passed | Currenta7d878 PR38496795139 and push38496791159 independently verified raw compile/source/log hashes and14/0/0; [final audit](agent-reports/release-final-submission-audit.md) |
| RELEASE-1 | Matching signed App Store eligible candidate | Passed | Cloud 17 from reviewed e353f43; uploaded 1.0/17 Validated / Ready to Submit; see [release evidence](agent-reports/release/evidence.json) |
| REVIEW-INFO-1 | Physical demo and six Apple information items | Passed | User reviewed/approved complete media/text; unchanged physical video uploaded; six items saved in Notes and sent in review reply with video; reloaded persisted state |
| SUBMIT-1 | Submitted matching qualified candidate | Passed | User explicitly authorized replacement/submission;1.0(17) Waiting for Review verified after reload. [Receipt](agent-reports/release/app-store-submission.json). Apple approval/public availability Pending |

Current release evidence and private raw artifact pointers: [qualification report](agent-reports/release-readiness.md). Build readiness does not establish physical product readiness or App Store submission.
