# Protected publication

Repository: [calvinc903/mirror](https://github.com/calvinc903/mirror). Default branch: `main`.

Root owns integration and authorized feature-branch checkpoint publication. Use `codex/` branches. Workers never push, merge, alter rules/hooks or bypass gates; commits require explicit assignment. Preserve pre-existing staged, unstaged and untracked user changes. Distinguish a pushed checkpoint from merged setup and qualified product release.

## Intended effective policy

- Changes to `main` use PRs. No force pushes or branch deletion; apply the rule to administrators.
- Require `agent-system` and `ios-build`, strictly up to date with the base, bound to GitHub Actions app ID `15368`, only after their workflow is on `main` and hosted execution is proven.
- Independent agent plan/code review remains a coordinator gate with candidate-bound reports. The metadata validator does not prove independent review occurred.
- Zero required human approvals is a deliberate solo-author policy. Agent review is distinct from human/server approval; do not falsely claim a solo author provided independent human approval.

## Bootstrap and qualification

Initial observed state: `main` unprotected (API 404), no rulesets; Pages and Xcode Cloud active. The existing archive check is `Mirror | Default | Archive - iOS` from `xcode-cloud` app `117084`; do not make it newly required without proving its PR trigger and candidate execution.

Keep new required contexts Pending until the workflow is available to ordinary main-based PRs. A green setup PR proves that branch's execution only. Qualify `agent-system` with a temporary unresolved-template defect, and `ios-build` separately with a reversible invalid scheme/build input. Restore the exact valid files and retain run IDs, check conclusions, checkout/head SHAs and mergeability readbacks. Use disposable branches/PRs for server controls; never mutate `main` as a negative control or merge an invalid candidate.

Read back effective rules and save before/after receipts in the [setup report](agent-reports/agent-system-setup.md). If runner/account access is unavailable, keep a named gap. Never require a check that cannot run, weaken stronger existing rules, or claim a draft PR's blocked merge state proves check enforcement. Temporarily ready reviewable control PRs only for the qualification, then restore their checkpoint disposition.

## Recovery

No hooks or `core.hooksPath` changes are installed. Hooks remain optional, bypassable accident guards; preserve existing hooks and test compatibility/rollback before future adoption.

Before any rule change save effective protection/ruleset JSON. For this initial adoption the prior policy was unprotected with no rulesets: an explicitly authorized rollback can delete the newly installed main branch-protection rule with `gh api --method DELETE repos/calvinc903/mirror/branches/main/protection`. Do not run rollback to bypass a failing gate. Revert repository setup through a reviewed PR; preserve app/user files. Record every rule change and retain the failed evidence.
