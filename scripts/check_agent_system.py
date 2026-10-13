#!/usr/bin/env python3
"""Validate the agent documents; this does not attest review or app behavior."""

from pathlib import Path
import re
import sys
from urllib.parse import unquote, urlsplit

DOCUMENTS = (
    "AGENTS.md", "main_agent.md", "sub_agent.md", "adversarial_agent.md",
    "docs/PROJECT_STATUS.md", "docs/PROJECT_PLAN.md", "docs/ACCEPTANCE_STATUS.md",
    "docs/BACKLOG.md", "docs/UI_REFERENCES.md", "docs/DELEGATION_FRAMEWORK.md",
    "docs/DEVELOPMENT_WORKFLOW.md", "docs/BRANCH_WORKFLOW.md",
    "docs/FEEDBACK_LOOP.md", "docs/agent-reports/task-report-template.md",
    "docs/DEVICE_CHECKLIST.md", "docs/agent-reports/agent-system-setup.md", "README.md",
)
LINK = re.compile(r"\[[^\]\n]*\]\((<[^>]+>|[^\s)]+)(?:\s+\"[^\"]*\")?\)")
PLACEHOLDER = re.compile(r"\{\{[a-z_]+\}\}")


def validate(root: Path) -> list[str]:
    root = root.resolve()
    errors = []
    for relative in DOCUMENTS:
        path = root / relative
        if not path.is_file():
            errors.append(f"{relative}: missing required document")
            continue
        content = path.read_text(encoding="utf-8")
        if not content.strip():
            errors.append(f"{relative}: empty document")
        if PLACEHOLDER.search(content):
            errors.append(f"{relative}: unresolved template parameter")
        for match in LINK.finditer(content):
            target = match.group(1).strip("<>")
            parsed = urlsplit(target)
            if parsed.scheme or parsed.netloc or not parsed.path:
                continue
            linked = (path.parent / unquote(parsed.path)).resolve()
            if not linked.is_relative_to(root):
                errors.append(f"{relative}: local link escapes repository: {target}")
            elif not linked.is_file():
                errors.append(f"{relative}: broken local file link: {target}")
    return errors


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    errors = validate(root)
    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1
    print(f"Agent documentation checks passed ({len(DOCUMENTS)} documents).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
