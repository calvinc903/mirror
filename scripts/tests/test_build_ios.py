"""Verify build gate failures cannot become successful execution receipts."""

from contextlib import redirect_stdout
import importlib.util
import io
import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

SCRIPT = Path(__file__).resolve().parents[1] / "build_ios.py"
SPEC = importlib.util.spec_from_file_location("build_ios", SCRIPT)
BUILD = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BUILD)


class BuildGateTests(unittest.TestCase):
    def run_fixture(self, post_manifest, build_exit=0, capture_error=None):
        before = {".github/workflows/verify.yml": "workflow-hash", "Mirror/ContentView.swift": "source-hash"}
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "output"
            def capture(argv):
                if capture_error is not None:
                    raise capture_error
                return "Xcode 27.0\nBuild version fixture" if argv == ["xcodebuild", "-version"] else "fixture"
            with (
                patch.object(BUILD, "source_manifest", side_effect=[before, post_manifest]),
                patch.object(BUILD, "capture", side_effect=capture),
                patch.object(BUILD.platform, "platform", return_value="fixture"),
                patch.object(BUILD.subprocess, "run", return_value=subprocess.CompletedProcess([], build_exit)),
                patch.object(BUILD.sys, "argv", [str(SCRIPT), "--output", str(output)]),
                redirect_stdout(io.StringIO()),
            ):
                code = BUILD.main()
            return code, json.loads((output / "receipt.json").read_text(encoding="utf-8"))

    def test_post_build_manifest_error_fails_closed(self):
        code, receipt = self.run_fixture(OSError("source became unreadable"))
        self.assertEqual(code, 2)
        self.assertEqual(receipt["exit_code"], 2)
        self.assertEqual(receipt["xcodebuild_exit_code"], 0)
        self.assertEqual(receipt["error"], "source became unreadable")

    def test_stalled_git_metadata_produces_failure_receipt(self):
        code, receipt = self.run_fixture({}, capture_error=subprocess.TimeoutExpired(["git", "rev-parse", "HEAD"], 45))
        self.assertEqual(code, 2)
        self.assertIn("timed out", receipt["error"])
        self.assertNotIn("xcodebuild_exit_code", receipt)

    def test_changed_source_fails_despite_successful_compile(self):
        code, receipt = self.run_fixture({".github/workflows/verify.yml": "workflow-hash", "Mirror/ContentView.swift": "changed"})
        self.assertEqual(code, 2)
        self.assertTrue(receipt["source_changed_during_build"])

    def test_xcode_failure_propagates(self):
        manifest = {".github/workflows/verify.yml": "workflow-hash", "Mirror/ContentView.swift": "source-hash"}
        code, receipt = self.run_fixture(manifest, build_exit=65)
        self.assertEqual(code, 65)
        self.assertEqual(receipt["exit_code"], 65)

    def test_unchanged_success_has_successful_receipt(self):
        manifest = {".github/workflows/verify.yml": "workflow-hash", "Mirror/ContentView.swift": "source-hash"}
        code, receipt = self.run_fixture(manifest)
        self.assertEqual(code, 0)
        self.assertFalse(receipt["source_changed_during_build"])


if __name__ == "__main__":
    unittest.main()
