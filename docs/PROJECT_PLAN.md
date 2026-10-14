# Mirror project plan

Current milestone: [production readiness and App Store resubmission](RELEASE_PLAN.md), authorized by the user's subsequent request. Its latest qualification is in the [release report](agent-reports/release-readiness.md). The setup plan below is historical; its original exclusions do not restrict the authorized release task.

Goal: adopt the requested repository agent system while preserving the existing camera app and user work.
Priority contract: camera privacy, permission handling, mirroring, session teardown and brightness restoration.

## Historical setup milestone

1. Consciously adapt the fourteen skill documents to Mirror and preserve existing privacy documentation.
2. Provide reproducible documentation checks and a signing-free generic iOS Simulator build with frozen-input receipts.
3. Add `agent-system` and `ios-build` GitHub Actions checks using actual compatible runners and immutable action revisions.
4. Independently review the setup, resolve material findings, and retain positive and negative check controls.
5. Publish a feature checkpoint. Activate PR/no-force protections without weakening existing rules. Activate required check contexts only after authorized integration places the workflow on `main`, then verify an ordinary main-based PR produces both checks.

Ownership: coordinator owns these setup files and GitHub integration. Planning and critique are report-only agents in distinct registered worktrees. Workers own explicitly assigned paths; no workers share a simulator, device or signing resource without a lease.

Acceptance IDs: SETUP-1, DOCS-1, CHECKS-1, BUILD-1, CI-1, REVIEW-1, ENFORCE-1 and HANDOFF-1 in [acceptance](ACCEPTANCE_STATUS.md).

## Planning decisions

Sol 6.1 xhigh planning and independent xhigh critique completed before implementation. The critique identified three qualification requirements: avoid a required-check bootstrap lockout; test failure propagation separately for both checks; distinguish PR head, synthetic merge/event commit and actual checkout in receipts. Adopted all three. Detailed evidence belongs in the [setup report](agent-reports/agent-system-setup.md).

A Python standard-library build wrapper records argv, timestamps, toolchain, source hashes and the actual exit status in one portable implementation. A shared Xcode scheme makes CLI target selection reproducible. These setup additions do not alter app behavior.

The original setup milestone excluded product features, app source changes, signing, App Store submissions, local hooks and recurring automation. The subsequent release request expands the product/signing/submission scope under its completed xhigh plan and critique; hooks and recurring automation remain outside scope. Future substantial features reopen xhigh planning and independent critique under the [framework](DELEGATION_FRAMEWORK.md).
