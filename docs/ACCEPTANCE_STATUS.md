# Acceptance evidence

| ID | Contract | State | Candidate/environment | Receipt | Owner/next action |
| --- | --- | --- | --- | --- | --- |
| SETUP-1 | Preserve primary user work | In progress | Primary main c030565, baseline hashes recorded | [Setup report](agent-reports/agent-system-setup.md) | Coordinator: compare hashes and staged diff after adoption |
| DOCS-1 | Adapt all fourteen role/workflow documents | Passed | Seventeen project documents including checklist/report | [Plan](PROJECT_PLAN.md) | Coordinator: recheck links after record updates |
| CHECKS-1 | Validate documentation/build gate controls | Passed | Eleven focused regressions, including fail-closed build receipt | [Workflow](DEVELOPMENT_WORKFLOW.md) | Coordinator: rerun after relevant script changes |
| BUILD-1 | Source-bound app compile with real command | Passed | Reviewed source digest; Xcode 27.0, Simulator 27.0, signing disabled | [Hosted receipt](agent-reports/restored-build-receipt.json) | Coordinator: retain current source binding |
| CI-1 | Both hosted checks succeed and propagate failure | Passed | Ubuntu 24.04 / xcode-27; GitHub Actions app 15368 | [Controls](agent-reports/ci-controls.json) | Coordinator: rerun affected checks after changed inputs |
| REVIEW-1 | Independent implementation review | Passed; supplemental-record audit in progress | 56032c2 reviewed; a875a07 has identical tree | [Reviewed manifest](agent-reports/reviewed-files.json) | Coordinator: checkpoint audit supplemental records |
| ENFORCE-1 | Effective PR/check/no-force protection | PR protection active; required checks Pending | Main PR/admin/no-force/no-delete policy read back | [Rule](agent-reports/github-protection-current.json) | Coordinator: authorized main integration, then activate/qualify required contexts |
| HANDOFF-1 | Accurate publication, gaps and next action | In progress | Local setup checkpoint | [Status](PROJECT_STATUS.md) | Coordinator: publish receipt and current handoff |
| DEVICE-1 | Real-device camera and brightness behavior | Pending | No physical-device run for this setup | [Device checklist](DEVICE_CHECKLIST.md) | Coordinator: lease device for future product changes |

Documentation validation and simulator compilation establish their named contracts only. Product behavior, human approval, server enforcement and schedules require their own evidence. Changed relevant inputs invalidate affected receipts. Keep local, committed, pushed and merged states distinct.
