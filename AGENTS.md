# ESP-Mosaico Agent Rules

Select task-relevant [skills](.agents/skills/README.md) at the task level.
User guides start at [docs](docs/README.md).

Use **Vibe Mode** for ESP-Mosaico’s retained firmware and **ROM Download Mode**
for the chip’s download program. See [device modes](docs/device-modes.md).
`Recovery` remains in existing component names, commands, protocol fields and ABI.

## Repository boundaries

- User applications belong in `projects/`; settings in `.mosaico.json`.
  Public tooling/templates belong in `submodule/esp-mosaico-utils/mosaico-tools`;
  Vibe Mode firmware and Recovery integration/ABI belong in utils'
  `esp-mosaico-vibe-mode/`, fixtures in its `tests/firmware/`.
- Product board support and peripheral examples belong in `submodule/esp-mosaico-bsp/`.
  Game runtime, complete reference games, behavior tests and native example Board
  adapters belong in `submodule/raylib-lite-engine/`. Initialize and inspect only
  needed submodules. Follow the [game guide](docs/game-development.md) for native adapters and product integration.
- Keep user documentation in `docs/`, indexed by `docs/README.md`; keep root
  English/Chinese READMEs aligned and short. Component API/protocol docs stay with owners.
- Agent guidance/tools belong in `.agents/`, shared skills in version-controlled
  `.agents/skills/`, local analysis in `.agents/analysis/`; this is not a secrecy boundary.

## Git and upstream workflow

Follow the [repository workflow](docs/repository-workflow.md) for all application,
dependency and workspace changes. These are standing instructions for this workspace:

- Keep the workspace and maintained applications in separate repositories. Register
  maintained applications under `projects/` as submodules; keep their source, assets,
  licenses, tests, design material and application-specific records in their own
  repositories. The workspace records shared configuration, guidance and exact
  submodule commits. Do not leave a delivered application as an unregistered nested repo.
- Use `twisty1988`'s personal repositories as `origin` for the workspace, applications
  and modified dependencies. Keep the official repository as `upstream` for each fork;
  original applications need no official upstream. New application repositories are
  private unless the user specifies otherwise. Unmodified dependencies may continue
  using their official origin; Utils currently follows this policy.
- Before editing, inspect the branch, status and diffs in the workspace and every
  repository being changed. Preserve unrelated user work and local-only experiments.
  Use `codex/` task branches; `main` is the workspace/application integration branch.
  Dependency maintenance branches follow the recorded repository workflow. Create a
  branch before editing a detached submodule; never force-push shared history.
- Keep dependency fixes as focused commits in their owning fork. Patch files may
  document an import but must not be the only copy of a maintained fix. Ensure each
  `.gitmodules` URL can supply the commit recorded by the workspace. Keep build outputs,
  downloaded components, logs, Gateway state and credentials out of commits; preserve
  required versioned source/generated data and application dependency locks.
- After completing and validating user-authorized changes, commit and push them to
  the configured personal origin by default. Honor explicit local-only, no-commit,
  no-push, draft or different delivery instructions. Stage only the current task's
  changes and write focused commit messages in Chinese.
- Push changed application/dependency commits first. Then commit their new workspace
  references and related workspace changes, and push the workspace with
  `git push --recurse-submodules=check origin <delivery-branch>`. Follow the requested
  branch/PR destination; otherwise integrate validated work into the relevant
  integration/maintenance branch without rewriting existing commits.
- Verify remote branch heads and that recorded submodule commits are reachable from
  their configured URLs. For initial repository setup or URL changes, verify a fresh
  checkout. Report delivered repositories/branches/commits and any remaining changes;
  uncommitted task changes in a submodule or an unpushed child commit are not a completed
  delivery. Report unrelated pre-existing changes separately without altering them.
- Receive official updates by fetching `upstream`, selecting a reviewed SDK/API-compatible
  commit and merging it into an upgrade branch containing local fixes. Resolve conflicts
  in the owning repository, check for equivalent upstream fixes, and validate affected
  applications before adopting new pins. Prefer merge for shared maintenance history.
  Ordinary `submodule update --init` restores recorded commits; use `--remote` only for
  an intentional upgrade. Keep the prescribed ESP-IDF revision unless explicitly changed.
- This Git delivery policy does not authorize deployment, device writes, releases,
  making private application contents public, or pushing to official `upstream` repositories.

## Espressif MCP services

When available, use `esp-component-registry` for components and `esp-pilot` for
multimedia and Board Manager references. Before integration, follow
[MCP guidance](docs/mcp-servers.md#services-and-when-to-use-them) for source/version
checks; remote recommendations do not override this repository's workflows.

## Engineering rules

- Keep modules focused, with explicit responsibilities, ownership and data flow.
  Keep public interfaces small and implementation details private; avoid circular dependencies.
- Keep functions reviewable and source files under 1500 lines where practical.
  Split by responsibility rather than adding deeply nested branches or meeting a line limit.
- Use named constants, enums or shared configuration for domain values and resource limits.
- Check fallible operations, handle allocation failures and roll back partial initialization.
  Give mutable state and resources explicit owners and lifetimes; synchronize cross-task
  access or document a single-owner design. Document shared services and singletons.
- Follow owning-component conventions; do not rewrite upstream code solely for style.
  ESP-IDF application conventions are scoped to [projects/AGENTS.md](projects/AGENTS.md).

## Environment and builds

- Use Python **3.10+** and Git **2.28+** for project creation, target **esp32s31**, and ESP-IDF at exactly
  **`7b9cc1ac79f865983f59bb8ff3ff43eb74ff1dbe`**, not the latest `master`.
- Before ESP-IDF work, verify the actual checkout against the pinned SHA and load
  [build doctor/build workflow](.agents/skills/idf-low-noise-build/SKILL.md) for environment checks and builds.
- If the pinned checkout is missing, use [environment setup](.agents/skills/espressif-env-setup/SKILL.md)
  and verify a first build. This repository authorizes that fresh installation without
  another request, overriding the skill's explicit-install trigger. Use standard paths
  when unspecified and preserve other SDK checkouts.

## Application development

- Before creating an app, read the [project guide](docs/project-init.md) and use
  `python mosaico.py project init <name>` with utils' Hello World template.
  For games, follow the [game guide](docs/game-development.md) and use
  `python mosaico.py game create <name> --template ...`.
- For device UI, prefer GSP and load [mosaico-ui](.agents/skills/mosaico-ui/SKILL.md);
  for GSP also load [gsp-sim](.agents/skills/gsp-sim/SKILL.md).
- For games, prefer Raylib Lite Engine and load
  [mosaico-game-development](.agents/skills/mosaico-game-development/SKILL.md).
- Confirm unsettled UI designs before implementation; reuse existing confirmation.
  Validate shared native UI/game behavior in the simulator before device validation.
  Start on hardware only for hardware-dependent issues or unavailable simulator coverage,
  and state remaining validation gaps. Follow the selected skills for validation steps.

## Retained Recovery contract

Unless the developer approves another architecture, every application must:

- Preserve the retained firmware's immutable partition prefix and keep the OTA writer
  only in Vibe Mode. Before application integration changes, read and follow the
  [public integration contract](submodule/esp-mosaico-utils/mosaico-tools/docs/application-integration.md).
- Before installation or update, follow [update selection](docs/mosaico-cli.md#select-an-update-method);
  never reshape the partition layout to bypass compatibility checks.
- Vibe Mode always assigns High-Speed USB to ESP-Iris; normal applications follow
  the [transport rules](docs/mosaico-cli.md#debugging-and-recovery-entry-points), including documented product exceptions.

## Device operations and acceptance

- Treat requests to “flash/burn firmware”, “烧录”, “刷机” or “下载固件” as device
  installation/update tasks; these words do not select ROM Download Mode.
  Before device work, load [mosaico-device-operations](.agents/skills/mosaico-device-operations/SKILL.md)
  and follow its ownership, target selection, evidence and acceptance workflow.
- Use only `python mosaico.py` for device operations. Do not invoke `idf.py flash`,
  `idf.py app-flash`, `esptool` writes or ESP-Iris device-write commands directly,
  guess flash offsets or bypass compatibility checks. Public integration docs, BSP
  flash/monitor instructions and build output do not override this workspace restriction.
- Coordinate ownership before connecting; follow active operation/takeover records before new writes.
  Never change boards after failed explicit selection or while awaiting reconnection.
- Never stop another client's Gateway to obtain a device or open USB/serial directly
  while Gateway owns it.
- Require live identity/state evidence and intended product behavior for acceptance;
  follow [evidence checks](docs/project-gateway.md#live-evidence-and-next-steps).
- Preserve structured evidence/raw logs and let `mosaico.py` save valid core dumps
  before destructive operations. Upload, reconnect or reachable Vibe Mode is not acceptance.
- For provisioning and recovery, follow the device skill and
  [update selection](docs/mosaico-cli.md#select-an-update-method). Manual ROM entry is the last resort.
- Never erase the whole flash merely to restore connectivity, or overwrite credentials,
  identity, Vibe Mode data or partitions without explicit user authorization.
