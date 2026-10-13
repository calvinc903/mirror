# Acceptance evidence

| ID | Contract | State | Candidate/environment | Receipt | Owner/next action |
| --- | --- | --- | --- | --- | --- |
| SETUP-1 | Preserve primary user work | In progress | Primary main c030565, baseline hashes recorded | [Setup report](agent-reports/agent-system-setup.md) | Coordinator: compare hashes and staged diff after adoption |
| DOCS-1 | Adapt all fourteen role/workflow documents | In progress | Setup worktree based on c22a767 | [Plan](PROJECT_PLAN.md) | Coordinator: run inventory and local-link checks |
| CHECKS-1 | Validate positive and negative documentation controls | Pending | Standard-library validator and regressions | [Workflow](DEVELOPMENT_WORKFLOW.md) | Coordinator: execute focused suite |
| BUILD-1 | Source-bound app compile with real command | Baseline passed; candidate Pending | Xcode 27.0, iOS Simulator 27.0, signing disabled | [Setup report](agent-reports/agent-system-setup.md) | Coordinator: build final candidate |
| CI-1 | Both hosted checks succeed and propagate failure | Pending | Ubuntu 24.04 / xcode-27; GitHub Actions app 15368 | [Branch workflow](BRANCH_WORKFLOW.md) | Coordinator: execute and retain both controls |
| REVIEW-1 | Independent review of the final setup | Pending | Distinct registered review worktree | [Setup report](agent-reports/agent-system-setup.md) | Coordinator: freeze candidate and assign reviewer |
| ENFORCE-1 | Effective PR/check/no-force protection | Pending | Main initially unprotected, no rulesets | [Branch workflow](BRANCH_WORKFLOW.md) | Coordinator: read back rules; activate contexts after main integration |
| HANDOFF-1 | Accurate publication, gaps and next action | In progress | Local setup checkpoint | [Status](PROJECT_STATUS.md) | Coordinator: publish receipt and current handoff |
| DEVICE-1 | Real-device camera and brightness behavior | Pending | No physical-device run for this setup | [Device checklist](DEVICE_CHECKLIST.md) | Coordinator: lease device for future product changes |

Documentation validation and simulator compilation establish their named contracts only. Product behavior, human approval, server enforcement and schedules require their own evidence. Changed relevant inputs invalidate affected receipts. Keep local, committed, pushed and merged states distinct.
