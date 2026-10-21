# Physical-device acceptance

Owner: coordinator assigns a named device/session owner before execution. Record candidate SHA/source digest, Xcode/signing environment, device model, iOS version, steps, actual outcomes and authorized screenshots. Current state: Pending; no device run belongs to the setup checkpoint.

For camera/lifecycle/lighting product changes, check these contracts on an actual supported iPhone:

1. Fresh permission grant opens a live mirrored front-camera preview. Denial/restriction displays a usable explanation and Settings route without hanging.
2. Re-enter after changing permission in Settings; document observed lifecycle behavior and failures.
3. Mirror orientation and aspect-fill remain appropriate in supported orientations. The app's device-family setting currently selects iPhone; iPad support is unverified.
4. Light toggle, edge coverage and zoom control behave as specified. Brightness restores the prior value after light-off and view teardown; include background/foreground transitions when lifecycle code changes.
5. Camera sessions stop on teardown and resume safely on the supported re-entry path. Verify interruptions/absent-camera behavior relevant to the change.
6. Camera preview stays local: inspect applicable capture/network/storage paths; record any new data flows. Do not capture or publish private faces without authorization.
7. Check control accessibility labels, touch interaction and relevant VoiceOver behavior for visible UI changes.

A simulator build checks compilation. A signed archive checks distribution inputs. Neither establishes these device outcomes. Mark each unrun item Pending with an owner and next step; preserve reproducers and failures.

## Camera troubleshooting preflight

Before evaluating a black preview, stop screen sharing in every running Device Hub instance, including separate stable and beta Xcode installations. Each instance's More Actions menu may independently offer Stop Screen Sharing. Verify that the selected physical phone shows View Screen and no live stream in each instance, then close/reopen Mirror directly on the phone. Do not turn viewing back on to judge the camera; it can recreate the conflict. The October21 new-phone report recovered after both streams stopped. This is an environment preflight, not a replacement for investigating failures that persist with all sharing off.

For sideways preview, hold the phone upright, check upright framing and reversed text, go Home, and reopen. Keep the interface portrait-only; use the actual camera's portrait rotation rather than a model-specific constant. Record the installed build and direct device outcome. Additional device models and unexecuted checks remain Pending.
