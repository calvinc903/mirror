# Verification workflow

Run from the repository root:

```sh
python3 scripts/check_agent_system.py
python3 -m unittest discover -s scripts/tests -v
python3 scripts/build_ios.py
```

The first two commands validate agent documentation and its validator. They require Python 3.10 or newer and no third-party packages. They do not execute app tests. The build requires macOS, Xcode 27 or newer with iOS Simulator SDK 27 or newer, the shared `Mirror` scheme and no signing credentials. It builds Debug for `generic/platform=iOS Simulator` with `CODE_SIGNING_ALLOWED=NO`.

The wrapper creates a fresh `.artifacts/ios-build-*` directory (or a fresh directory supplied by `--output`), prints its location, and preserves `build.log`, `build.xcresult` and `receipt.json`. Existing output directories are refused to avoid mixing evidence. Receipts include UTC times, actual argv/exit, checkout commit/tree, PR head and event SHA when available, workflow hash, source-file hashes, selected toolchain/SDK and log hash. A source change during compilation fails verification even if Xcode succeeds. Output directories are outside the hashed inputs.

GitHub runs [the workflow](../.github/workflows/verify.yml) for PRs targeting `main`, pushes to `main` or `codex/**`, and manual dispatch once available on the default branch. There are no path filters. PR jobs build the checkout of the event's merge commit; record it separately from the PR head. `agent-system` runs on Ubuntu 24.04, `ios-build` on the actual `xcode-27` image, with read-only repository permission and immutable action revisions. The preview image may change; use each execution receipt, not the label, as toolchain evidence. Existing Pages and Xcode Cloud remain separate checks.

Bound each task and finish line. For iteration compile affected targets, reproduce the defect and run focused regressions. At integration run applicable safety/integration checks and independent review. Visible product changes need [screenshots](UI_REFERENCES.md) and relevant [device checks](DEVICE_CHECKLIST.md). Release requires all applicable product acceptance, signed archive/distribution checks and physical-device evidence; a green simulator build does not authorize App Store publication.

Freeze source/config/toolchain/destination inputs. Retain actual commands, UTC times, exits, raw logs and hashes. Rebuild/retest affected checks after relevant inputs change. Preserve original failures; after repeated unsuccessful hypotheses collect targeted measurements. Reports use the [template](agent-reports/task-report-template.md), with unrun gates Pending and an owner/next action.

## App regression execution

Compile both test targets with `python3 scripts/test_ios.py --build-only`. Execute an explicit coordinator-leased destination with `python3 scripts/test_ios.py --destination 'platform=iOS Simulator,id=UUID' --only-testing MirrorTests`; use `--configuration Release` to exercise optimized code. Release test invocations explicitly enable testability for internal unit-test imports; shipping archives retain normal Release defaults. The coordinator prepares/leases the device; the wrapper never boots, erases or changes permission state. Receipts include frozen app/test/script hashes, actual argv, test counts, logs and xcresult summary. A run with no passing tests fails; inspect skips against the intended acceptance contract. Generic build-for-testing executes no tests.

CI creates a dedicated iPhone 18 Pro / iOS 27 simulator, executes MirrorTests, and removes only that created device. It retains the app-test receipt, counts, raw logs and xcresult. UI permission paths and optical/brightness/app-switcher acceptance remain coordinator-owned; simulator skips cannot satisfy physical acceptance. Metadata/toolchain commands time out after 45 seconds and fail with a receipt, including stalled Git reads caused by unavailable cloud-backed metadata.
