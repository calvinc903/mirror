#!/usr/bin/env python3
"""Compile Mirror with fresh artifacts and frozen-source execution receipts."""

import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import platform
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def utc_now():
    return datetime.now(timezone.utc).isoformat()


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def source_manifest():
    paths = list((ROOT / "Mirror").rglob("*"))
    paths.extend((ROOT / "Mirror.xcodeproj").rglob("*"))
    paths.extend([Path(__file__).resolve(), ROOT / ".github/workflows/verify.yml"])
    return {
        str(path.relative_to(ROOT)): digest(path)
        for path in sorted(set(paths))
        if path.is_file() and "xcuserdata" not in path.parts and path.name != ".DS_Store"
    }


def capture(argv):
    return subprocess.check_output(argv, cwd=ROOT, text=True, stderr=subprocess.STDOUT, timeout=45).strip()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, help="Fresh, nonexistent artifact directory")
    parser.add_argument("--configuration", choices=("Debug", "Release"), default="Debug")
    args = parser.parse_args()
    if args.output:
        output = args.output.resolve()
        # An explicit output must be new so previous receipts cannot be reused.
        output.parent.mkdir(parents=True, exist_ok=True)
        output.mkdir()
    else:
        parent = ROOT / ".artifacts"
        parent.mkdir(exist_ok=True)
        output = Path(tempfile.mkdtemp(prefix="ios-build-", dir=parent)).resolve()
    print(f"Build artifacts: {output}", flush=True)
    argv = [
        "xcodebuild", "-project", "Mirror.xcodeproj", "-scheme", "Mirror",
        "-sdk", "iphonesimulator", "-destination", "generic/platform=iOS Simulator",
        "-configuration", args.configuration,
        "-derivedDataPath", str(output / "DerivedData"),
        "-resultBundlePath", str(output / "build.xcresult"),
        "CODE_SIGNING_ALLOWED=NO", "build",
    ]
    before = source_manifest()
    receipt = {
        "schema_version": 1, "started_at_utc": utc_now(), "argv": argv,
        "event_sha": os.environ.get("GITHUB_SHA"),
        "pr_head_sha": os.environ.get("MIRROR_PR_HEAD_SHA"),
        "workflow_sha256": before[".github/workflows/verify.yml"],
        "platform": platform.platform(), "source_files_sha256": before,
        "source_digest": hashlib.sha256(json.dumps(before, sort_keys=True).encode()).hexdigest(),
    }
    code = 2
    log_path = output / "build.log"
    with log_path.open("w", encoding="utf-8") as log:
        try:
            receipt["checkout_commit"] = capture(["git", "rev-parse", "HEAD"])
            receipt["checkout_tree"] = capture(["git", "rev-parse", "HEAD^{tree}"])
            receipt["xcode"] = capture(["xcodebuild", "-version"])
            receipt["sdks"] = capture(["xcodebuild", "-showsdks"])
            receipt["developer_dir"] = capture(["xcode-select", "-p"])
            log.write(receipt["xcode"] + "\n" + receipt["sdks"] + "\n")
            log.flush()
            major = int(receipt["xcode"].splitlines()[0].split()[1].split(".")[0])
            if major < 27:
                raise RuntimeError("Mirror requires Xcode 27 or newer; do not lower the app deployment target for CI")
            process = subprocess.run(argv, cwd=ROOT, stdout=log, stderr=subprocess.STDOUT)
            receipt["xcodebuild_exit_code"] = process.returncode
            code = process.returncode
            receipt["source_changed_during_build"] = before != source_manifest()
            if receipt["source_changed_during_build"]:
                log.write("\nSource inputs changed during build; verification refused.\n")
                code = 2
        except (OSError, ValueError, RuntimeError, subprocess.CalledProcessError, subprocess.TimeoutExpired) as error:
            code = 2
            log.write(f"\nVerification error: {error}\n")
            receipt["error"] = str(error)
    receipt.update({"finished_at_utc": utc_now(), "exit_code": code, "log_sha256": digest(log_path)})
    (output / "receipt.json").write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
    print("\n".join(log_path.read_text(encoding="utf-8").splitlines()[-20:]))
    print(f"Build exit: {code}; receipt: {output / 'receipt.json'}", flush=True)
    return code


if __name__ == "__main__":
    sys.exit(main())
