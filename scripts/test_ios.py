#!/usr/bin/env python3
"""Build or execute Mirror XCTest with candidate-bound, fresh execution artifacts.

Execution requires an explicit destination leased by the coordinator. This script
never boots, erases, grants permissions to, or otherwise prepares a device.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

from build_ios import ROOT, capture, digest, source_manifest, utc_now


def test_manifest():
    manifest = source_manifest()
    for folder in ("MirrorTests", "MirrorUITests"):
        for path in sorted((ROOT / folder).rglob("*")):
            if path.is_file() and path.name != ".DS_Store":
                manifest[str(path.relative_to(ROOT))] = digest(path)
    manifest[str(Path(__file__).resolve().relative_to(ROOT))] = digest(Path(__file__))
    return manifest


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--build-only", action="store_true", help="Compile for generic simulator without running tests")
    parser.add_argument("--destination", help="Explicit xcodebuild destination, e.g. platform=iOS Simulator,id=UUID")
    parser.add_argument("--configuration", choices=("Debug", "Release"), default="Debug")
    parser.add_argument("--only-testing", action="append", default=[], help="Xcode test target or target/class/method; repeat to select more")
    parser.add_argument("--output", type=Path, help="Fresh nonexistent artifact directory")
    args = parser.parse_args()
    if not args.build_only and not args.destination:
        parser.error("test execution requires --destination for a coordinator-leased device")
    if args.build_only and args.destination:
        parser.error("--build-only uses the generic simulator destination")
    if args.output:
        output = args.output.resolve()
        output.parent.mkdir(parents=True, exist_ok=True)
        output.mkdir()
    else:
        parent = ROOT / ".artifacts"
        parent.mkdir(exist_ok=True)
        output = Path(tempfile.mkdtemp(prefix="ios-tests-", dir=parent)).resolve()
    action = "build-for-testing" if args.build_only else "test"
    destination = "generic/platform=iOS Simulator" if args.build_only else args.destination
    argv = ["xcodebuild", "-project", "Mirror.xcodeproj", "-scheme", "Mirror", "-configuration", args.configuration,
            "-destination", destination, "-derivedDataPath", str(output / "DerivedData"),
            "-resultBundlePath", str(output / "tests.xcresult"), "-parallel-testing-enabled", "NO"]
    if args.build_only or "Simulator" in destination:
        argv.append("CODE_SIGNING_ALLOWED=NO")
    # @testable requires this only for the test invocation. Shipping Release
    # archives keep the project's default, without testability enabled.
    if args.configuration == "Release":
        argv.append("ENABLE_TESTABILITY=YES")
    argv.extend(f"-only-testing:{selection}" for selection in args.only_testing)
    argv.append(action)
    before = test_manifest()
    receipt = {"schema_version": 1, "started_at_utc": utc_now(), "argv": argv,
               "source_files_sha256": before,
               "source_digest": hashlib.sha256(json.dumps(before, sort_keys=True).encode()).hexdigest(),
               "test_execution_requested": not args.build_only, "destination": destination}
    print(f"Test artifacts: {output}", flush=True)
    code = 2
    log_path = output / "tests.log"
    with log_path.open("w", encoding="utf-8") as log:
        try:
            receipt["checkout_commit"] = capture(["git", "rev-parse", "HEAD"])
            receipt["checkout_tree"] = capture(["git", "rev-parse", "HEAD^{tree}"])
            receipt["xcode"] = capture(["xcodebuild", "-version"])
            receipt["sdks"] = capture(["xcodebuild", "-showsdks"])
            receipt["developer_dir"] = capture(["xcode-select", "-p"])
            if int(receipt["xcode"].splitlines()[0].split()[1].split(".")[0]) < 27:
                raise RuntimeError("Mirror requires Xcode 27 or newer")
            log.write(receipt["xcode"] + "\n" + receipt["sdks"] + "\n")
            log.flush()
            code = subprocess.run(argv, cwd=ROOT, stdout=log, stderr=subprocess.STDOUT).returncode
            receipt["xcodebuild_exit_code"] = code
            if not args.build_only and code == 0 and not (output / "tests.xcresult").exists():
                raise RuntimeError("xcodebuild reported success without a test results bundle")
            if not args.build_only and (output / "tests.xcresult").exists():
                summary = json.loads(capture(["xcrun", "xcresulttool", "get", "test-results", "summary",
                                              "--path", str(output / "tests.xcresult"), "--compact"]))
                (output / "test-summary.json").write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
                receipt["test_counts"] = {key: summary[key] for key in
                                          ("passedTests", "failedTests", "skippedTests", "totalTestCount")}
                if code == 0 and (summary["passedTests"] == 0 or summary["failedTests"] != 0):
                    log.write("\nNo passing test execution or unexpected test failures; evidence refused.\n")
                    code = 2
            receipt["source_changed_during_tests"] = before != test_manifest()
            if receipt["source_changed_during_tests"]:
                log.write("\nSource changed during verification; evidence refused.\n")
                code = 2
        except (OSError, ValueError, KeyError, RuntimeError, subprocess.CalledProcessError, subprocess.TimeoutExpired) as error:
            receipt["error"] = str(error)
            log.write(f"\nVerification error: {error}\n")
            code = 2
    receipt.update(finished_at_utc=utc_now(), exit_code=code, log_sha256=digest(log_path))
    (output / "receipt.json").write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
    print("\n".join(log_path.read_text().splitlines()[-20:]))
    print(f"Test exit: {code}; receipt: {output / 'receipt.json'}", flush=True)
    return code


if __name__ == "__main__":
    sys.exit(main())
