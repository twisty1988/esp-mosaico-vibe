# Codex Companion: Mac bridge and Mosaico display

[简体中文](codex-companion_CN.md) | [Documentation index](README.md)

`projects/codex_companion` is the private application repository for a Codex
status companion. It includes the read-only Mac bridge and a native GSP application
for Mosaico's fixed 480×480 screen, with overview, task detail, quota and the user's
Peace animations. The native simulator and device share the C UI and scene.

```sh
git submodule update --init projects/codex_companion
projects/codex_companion/bridge serve
```

Open the printed loopback URL. Python 3.10+ and an installed, signed-in Codex
desktop application are required; no third-party Python packages are needed.
`bridge snapshot` emits a one-shot JSON snapshot.

Quota comes from the official Codex CLI App Server. Current desktop task and
unread state use a version-scoped, read-only adapter for local state files.
This is not a stable public desktop API. The application documents the verified
version, coverage limits, stale/unknown behavior and its strict read-only boundary.

See the application's [README](../projects/codex_companion/README.md),
[protocol](../projects/codex_companion/docs/protocol.md) and
[acceptance record](../projects/codex_companion/docs/acceptance.md).
Pairing, builds and installation are documented in the application's
[device guide](../projects/codex_companion/docs/device.md). Devices use a separately
paired TLS endpoint; the diagnostic page stays on loopback. The Mac bridge must
remain running. The application saves two Wi-Fi networks and selects an available
one automatically. Bonjour follows the Mac's LAN address, so changing between
home and work does not require pairing again. Snapshots, raw logs and pairing credentials remain local.
Application-specific design and validation records belong to its private repository.
