"""Focused safety checks for candidate-bound app-test receipts."""
from pathlib import Path
from contextlib import redirect_stdout
import io
import json
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

SCRIPTS = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SCRIPTS))
import test_ios


class TestReceiptInputs(unittest.TestCase):
    def test_manifest_includes_test_sources_and_detects_changes(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory).resolve()
            unit = root / "MirrorTests" / "LifecycleTests.swift"
            ui = root / "MirrorUITests" / "Flows.swift"
            unit.parent.mkdir()
            ui.parent.mkdir()
            unit.write_text("first")
            ui.write_text("ui")
            wrapper = root / "scripts" / "test_ios.py"
            wrapper.parent.mkdir()
            wrapper.write_text("wrapper")
            # Production returns a fresh mapping; shared mock state would rewrite the before snapshot.
            with patch.object(test_ios, "ROOT", root), patch.object(test_ios, "source_manifest", side_effect=lambda: {"app": "hash"}), patch.object(test_ios, "__file__", str(wrapper)):
                before = test_ios.test_manifest()
                self.assertIn("MirrorTests/LifecycleTests.swift", before)
                self.assertIn("MirrorUITests/Flows.swift", before)
                self.assertIn("scripts/test_ios.py", before)
                unit.write_text("second")
                self.assertNotEqual(before, test_ios.test_manifest())

    def test_execution_requires_explicit_destination_before_creating_artifacts(self):
        with patch.object(sys, "argv", ["test_ios.py"]), patch.object(test_ios.tempfile, "mkdtemp") as create_output:
            with self.assertRaises(SystemExit) as raised:
                test_ios.main()
            self.assertEqual(raised.exception.code, 2)
            create_output.assert_not_called()

    def test_missing_results_bundle_cannot_qualify_success(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "output"
            def capture(argv):
                return "Xcode 27.0\nBuild version fixture" if argv == ["xcodebuild", "-version"] else "fixture"
            with (
                patch.object(test_ios, "test_manifest", return_value={"app": "hash"}),
                patch.object(test_ios, "capture", side_effect=capture),
                patch.object(test_ios.subprocess, "run", return_value=subprocess.CompletedProcess([], 0)),
                patch.object(sys, "argv", ["test_ios.py", "--destination", "platform=iOS Simulator,id=fixture", "--output", str(output)]),
                redirect_stdout(io.StringIO()),
            ):
                code = test_ios.main()
            receipt = json.loads((output / "receipt.json").read_text())
            self.assertEqual(code, 2)
            self.assertEqual(receipt["xcodebuild_exit_code"], 0)
            self.assertIn("without a test results bundle", receipt["error"])


if __name__ == "__main__":
    unittest.main()
