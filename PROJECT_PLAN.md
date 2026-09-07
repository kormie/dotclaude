# DotClaude Modernization Roadmap

## Product status

DotClaude is a **maintained product**. The original four implementation phases are
historical releases, not an assertion that the repository is finished. Ongoing
maintenance is tracked through the reversible milestones below. A milestone may
ship only when its acceptance criteria pass on every applicable supported target.

This document is the source of truth for platform support, tool version floors,
modernization scope, release gates, and rollback expectations. User-facing docs
should link here rather than describe the project as complete.

## Supported targets

Support means that installation and validation are expected to work and that a
regression on the target blocks the relevant milestone. Versions newer than those
listed are best-effort until CI or a recorded manual validation promotes them.

| Target | Support level | Policy |
| --- | --- | --- |
| Current generally available macOS on Apple Silicon | Tier 1 | Primary workstation and full installer target; exercise install, shell, tmux, and Neovim paths. |
| Current generally available macOS on Intel | Tier 2, conditional | Retained while an active user or CI runner requires it and Apple supports the current macOS release on Intel. Validate before each installer release; retire explicitly in this file when neither condition remains. |
| Ubuntu Server 22.04 LTS and 24.04 LTS, amd64/arm64 | Tier 1 for `--server` | Minimal, non-GUI server profile. Both releases remain supported through their standard upstream support window. |
| Debian 12 and 13, amd64/arm64 | Tier 1 for `--server` | Minimal, non-GUI server profile. A release leaves the matrix when upstream security support ends. |
| Local contributor development on macOS | Tier 1 | Current macOS, Apple Silicon; Intel follows the conditional policy above. |
| Local contributor development on Linux | Tier 1 | Ubuntu 22.04/24.04 or Debian 12/13; other distributions are best-effort. |

“Current macOS” intentionally moves with Apple's generally available release.
Before adopting a new major release, record a clean validation run; the previously
validated major remains a temporary compatibility target until that run succeeds.

## Minimum supported tool versions

These are compatibility floors, not pins. Contributor environments and CI may use
newer versions, while lockfiles and reproducible environment definitions select
exact versions where appropriate. The validation milestone will turn these floors
into executable preflight checks.

| Tool | Minimum | Rationale / scope |
| --- | ---: | --- |
| Bash | 3.2 | Preserves compatibility with the system Bash shipped on macOS; scripts must avoid newer-only syntax. |
| Zsh | 5.8 | Covers supported shell configuration and the oldest supported Linux baseline. |
| Git | 2.34 | Matches the Ubuntu 22.04 baseline and supports the repository's worktree workflows. |
| GNU Stow | 2.3.1 | Common floor across the supported Debian/Ubuntu targets. |
| tmux | 3.2a | Supports the configured key bindings and server workspace behavior. |
| Neovim | 0.10.0 | Baseline for the refreshed Lua configuration and plugin API; install a newer upstream build where distribution packages are older. |
| Bun | 1.1.0 | Runtime/package-manager floor for documentation tooling; the lockfile remains authoritative for dependencies. |
| Python | 3.10 | Contributor scripts use Python 3 only; this matches the oldest supported Ubuntu target. |
| devenv | 1.0 | Baseline for the reproducible contributor shell introduced in Milestone 1. |

Any increase to a floor requires a pull request that updates this table, preflight
validation, CI, and installation documentation together. Lower versions must fail
with an actionable message rather than failing partway through an install.

## Delivery rules

1. Implement milestones in the listed order unless a pull request documents why a
   later milestone is independent of unfinished earlier work.
2. Keep each milestone in its own merge or revert boundary. Do not combine a
   prerequisite cleanup that makes rollback impossible.
3. Capture baseline behavior before changing it and preserve user-owned files.
4. Acceptance evidence consists of automated CI where available and a recorded
   manual check for targets unavailable in CI (especially macOS hardware).
5. If an acceptance criterion fails after release, use the milestone rollback and
   open a follow-up issue before attempting a replacement design.

## Milestone 1 — Reproducible contributor tooling

**Scope:** Add a devenv definition and versioned developer commands for formatting,
linting, tests, documentation builds, and shell checks. Document the bootstrap path
for supported macOS and Linux contributor systems without altering user dotfiles.

**Acceptance criteria**

- A fresh clone can enter the development environment with the documented command.
- Tool versions meet the floors above and repeated environment activation is
  idempotent.
- One documented command runs the complete local check suite on macOS and Linux.
- Entering or leaving the environment does not write outside the clone or normal
  devenv/cache locations.

**Rollback criteria and procedure**

- Roll back if environment activation changes user configuration, cannot reproduce
  the check suite on either contributor OS, or requires undeclared global tools.
- Revert the milestone commit(s) and use the pre-existing manually installed tools;
  no generated state may be required by later milestones until this one is stable.

## Milestone 2 — Non-mutating validation

**Scope:** Separate inspection from installation. Add a validation mode that checks
platforms, version floors, Stow conflicts, configuration syntax, and expected links
without installing packages, changing defaults, or touching files in `$HOME`.

**Acceptance criteria**

- Validation has documented exit codes and actionable diagnostics.
- Tests compare filesystem state before and after successful and failing runs and
  demonstrate that neither path mutates the host.
- Checks run for all supported profiles and reject unsupported versions before any
  installer action.
- Existing mutating behavior remains confined to explicitly named install/apply
  commands.

**Rollback criteria and procedure**

- Roll back if validation creates, deletes, or rewrites user files; reports success
  for an invalid fixture; or prevents the existing installer from running.
- Revert the validation entry point and tests together. Continue using the current
  `test-config.sh`/manual checks while correcting the isolated implementation.

## Milestone 3 — CI and dependency locking

**Scope:** Run the non-mutating suite in CI across supported Linux releases and an
available current macOS runner, verify shell compatibility, and make dependency
resolution deterministic. Preserve `docs/bun.lock` and add locks/pins for any new
tooling introduced by the roadmap.

**Acceptance criteria**

- Required CI jobs cover Ubuntu 22.04, Ubuntu 24.04, Debian 12, Debian 13, and the
  current available macOS runner; architecture/hardware gaps are documented.
- CI uses frozen/locked dependency installation and fails on lockfile drift.
- Shell lint, configuration validation, tests, and documentation build are required
  checks with no writes to the runner's real home configuration.
- Dependency update procedure and automated update ownership are documented.

**Rollback criteria and procedure**

- Roll back if locks are not reproducible, required jobs are persistently flaky, or
  CI invokes mutating installer paths against an unisolated home directory.
- Revert workflow and lock changes as one boundary, restore the previous lockfile,
  and retain local checks as the release gate until CI is corrected.

## Milestone 4 — Installer hardening

**Scope:** Make installation explicitly transactional and profile-aware. Add
preflight checks, dry-run output, conflict handling, backups, resumable failure
behavior, and verified restore paths for macOS and `--server`.

**Acceptance criteria**

- Clean and preconfigured fixtures pass first install and repeat-install tests.
- A dry run accurately lists actions and makes no filesystem or system changes.
- Injected failures leave either the original state or a documented resumable state;
  backup and restore round trips preserve file content and permissions.
- Unsupported OS/tool combinations stop before mutation, and server mode installs no
  macOS or GUI-only components.

**Rollback criteria and procedure**

- Roll back if user data can be overwritten, backup/restore is lossy, idempotency
  fails, or a supported target cannot complete its profile.
- Revert to the preceding installer entry point and restore affected systems from
  the automatically created pre-install backup. Keep new behavior behind an opt-in
  flag until all gates pass.

## Milestone 5 — AI-agent integration

**Scope:** Standardize repository instructions and safe commands for AI coding
agents, including worktree isolation, non-interactive checks, bounded permissions,
and discovery of the same roadmap and contributor workflow used by humans.

**Acceptance criteria**

- Agent instructions agree with contributor docs and expose a single canonical
  setup/check workflow.
- An agent can create an isolated worktree, make and validate a change, and clean up
  without touching the primary checkout or user dotfiles.
- Automated tests cover workspace naming, existing branches, interrupted setup, and
  cleanup; secrets and machine-specific values are excluded from prompts/logs.
- Agent-specific features are optional and do not alter ordinary installs.

**Rollback criteria and procedure**

- Roll back if the workflow can modify the primary worktree, disclose secrets,
  leave unrecoverable worktrees, or make non-agent usage depend on an AI tool.
- Remove the optional integration entry points and revert instruction changes;
  existing tmux and manual `git worktree` workflows remain the fallback.

## Milestone 6 — Neovim refresh

**Scope:** Audit the Lua configuration against the minimum Neovim version, reduce
plugin overlap, lock plugin revisions, update LSP/tooling APIs, and retain existing
navigation and leader-key behavior.

**Acceptance criteria**

- Headless startup and configuration health checks pass on Neovim 0.10 and the
  current stable release with a clean data directory.
- Plugin installation is reproducible from a committed lockfile and offline startup
  works after the initial synchronized install.
- Core editing, LSP, completion, Git, Telescope, tmux navigation, and comma-leader
  workflows have documented smoke tests.
- Startup regression remains within an agreed baseline recorded in the change.

**Rollback criteria and procedure**

- Roll back if clean startup fails, plugin resolution is non-deterministic, core
  mappings regress, or startup exceeds the recorded budget without approval.
- Revert configuration and plugin lockfile together, then use
  `scripts/toggle-neovim.sh original` or restore the pre-refresh Stow package.

## Milestone 7 — Documentation consolidation

**Scope:** Make this roadmap the policy source, remove stale duplicated claims,
align README and VitePress navigation, and distinguish maintained guidance from the
historical phase references.

**Acceptance criteria**

- README, contributor/agent guidance, and the documentation site link to this file
  for support and roadmap policy.
- Documentation build and internal-link checks pass with no contradictory platform,
  version, status, install, or rollback instructions.
- Historical phase pages are clearly labeled as historical and remain accessible.
- Every supported workflow has one canonical procedure and named owner/location.

**Rollback criteria and procedure**

- Roll back if canonical installation or recovery guidance becomes inaccessible,
  links break, or consolidation removes information still required by a supported
  target.
- Revert navigation and content moves together; restore prior pages from Git while
  retaining this roadmap as the decision record.

## Roadmap maintenance

Review this plan whenever a supported OS reaches end of support, a tool floor must
move, or a milestone ships. Record milestone state as **planned**, **in progress**,
**released**, or **rolled back** in its delivery pull request; acceptance is never
inferred from elapsed time. Historical accomplishments can remain documented, but
DotClaude itself remains maintained for as long as supported targets are listed.
