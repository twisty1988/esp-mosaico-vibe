# Codex Companion: Mac read-only bridge

[简体中文](codex-companion_CN.md) | [Documentation index](README.md)

`projects/codex_companion` is the private application repository for a Codex
status companion. The current phase contains the Mac bridge only. Device UI,
firmware creation and hardware installation are deferred until the data path
has passed its acceptance checks.

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
Snapshots, logs and acceptance evidence remain local and are not committed.
