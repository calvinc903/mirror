"""Focused positive/negative controls for the documentation gate."""

import importlib.util
from pathlib import Path
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / "check_agent_system.py"
SPEC = importlib.util.spec_from_file_location("agent_system", SCRIPT)
CHECK = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(CHECK)


class DocumentationGateTests(unittest.TestCase):
    def setUp(self):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        self.root = Path(directory.name)
        for relative in CHECK.DOCUMENTS:
            path = self.root / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text("# Reviewed project document\n", encoding="utf-8")

    def write_agents(self, text):
        (self.root / "AGENTS.md").write_text(text, encoding="utf-8")

    def test_valid_documents_and_relative_links(self):
        self.write_agents("[role](main_agent.md) [external](https://example.com) [anchor](#role)\n")
        self.assertEqual(CHECK.validate(self.root), [])

    def test_missing_required_role_fails(self):
        (self.root / "adversarial_agent.md").unlink()
        self.assertIn("adversarial_agent.md: missing required document", CHECK.validate(self.root))

    def test_empty_record_fails(self):
        self.write_agents(" \n")
        self.assertIn("AGENTS.md: empty document", CHECK.validate(self.root))

    def test_unresolved_template_fails(self):
        self.write_agents("# {{project}}\n")
        self.assertIn("AGENTS.md: unresolved template parameter", CHECK.validate(self.root))

    def test_missing_local_target_fails(self):
        self.write_agents("[missing](docs/missing.md)\n")
        self.assertIn("AGENTS.md: broken local file link: docs/missing.md", CHECK.validate(self.root))

    def test_escaping_link_fails(self):
        self.write_agents("[outside](../outside.md)\n")
        self.assertIn("AGENTS.md: local link escapes repository: ../outside.md", CHECK.validate(self.root))

    def test_url_encoded_path_with_spaces(self):
        (self.root / "a file.md").write_text("# File\n", encoding="utf-8")
        self.write_agents("[file](a%20file.md) [file](<a file.md>)\n")
        self.assertEqual(CHECK.validate(self.root), [])


if __name__ == "__main__":
    unittest.main()
