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
