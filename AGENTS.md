# Mirror agent routing

Read only the assigned role: [main](main_agent.md), [worker](sub_agent.md), or [adversarial reviewer](adversarial_agent.md). Before authorized delegation read [framework](docs/DELEGATION_FRAMEWORK.md).

Truth: [status](docs/PROJECT_STATUS.md), [plan](docs/PROJECT_PLAN.md), [acceptance](docs/ACCEPTANCE_STATUS.md). Visual work reads [references](docs/UI_REFERENCES.md). Preserve existing stronger instructions and agreed scope.

## Repository boundaries

Mirror is an iPhone camera app using SwiftUI, AVFoundation and UIKit. Preserve camera permission handling, local preview privacy, mirroring, session teardown and restoration of the user's screen brightness. Do not infer physical-device behavior from a simulator build. No XCTest target exists yet; keep unexecuted product checks Pending.

Use `python3 scripts/check_agent_system.py` and `python3 -m unittest discover -s scripts/tests -v` for the agent documentation checks. Use `python3 scripts/build_ios.py` for a signing-free simulator compile with source-bound receipts. See the [workflow](docs/DEVELOPMENT_WORKFLOW.md).

## Long-term working guidance

- Prefer maintainable, proportional solutions. Avoid unnecessary infrastructure.
- For recurring defects, preserve a reproducer, fix the root cause and add a focused regression. Record workaround scope, unresolved cause and removal condition.
- Consult and update existing procedures, status, known issues and decisions after substantive changes.
- Use reproducible, versioned inputs and outputs, verified upgrades, resumability and rollback where useful.
- Leave an honest handoff: implemented/tested work, uncertainty and the next unfinished step. Distinguish local, committed, pushed and published state; prefer executable checks to conversational memory.

Temporary qualification control: {{project}}
