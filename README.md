# Mirror

Mirror is a simple iOS app that turns the home screen into a full-screen selfie camera preview.

## Features

- Front-facing camera opens by default
- Mirrored preview for a natural mirror feel
- White edge lighting to brighten your face
- Adjustable light intensity slider

## Requirements

- Xcode
- iPhone or iPad with a front-facing camera

The app requires camera permission. The permission prompt uses `NSCameraUsageDescription` in `Info.plist`.

## Running

1. Open `Mirror.xcodeproj` in Xcode.
2. Select the `Mirror` scheme.
3. Choose a real iPhone or iPad for the best camera behavior.
4. Build and run.

Simulator camera behavior may not match a physical device.

## Agent workflow

Start with [AGENTS.md](AGENTS.md) and read the assigned coordinator, worker or reviewer role. Current work and evidence live in [project status](docs/PROJECT_STATUS.md) and [acceptance](docs/ACCEPTANCE_STATUS.md).

```sh
python3 scripts/check_agent_system.py
python3 -m unittest discover -s scripts/tests -v
python3 scripts/build_ios.py
```

These commands validate agent documentation and compile the app for a generic iOS Simulator. The [verification workflow](docs/DEVELOPMENT_WORKFLOW.md) distinguishes those checks from physical-device camera acceptance.
