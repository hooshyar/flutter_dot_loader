# Branch ledger (flutter_dot_loader)

Written 2026-10-02 during the fleet consolidation (Hooshyar: merge all work to main, lose nothing).

## State of main
- Version 1.1.0 is prepared on `main` (sizing, reduced motion, `customDotSize`, AI-state presets, green CI, `pub publish --dry-run` clean). It is NOT published: pub.dev publish and the `v1.1.0` tag are Hooshyar's call.
- `agent/improvement-plan-2026-09` (docs plan, PR #2) and `agent/dot-finish/s1` (implementation, PR #3) are merged and their branches deleted.
- `gh-pages` is the live demo branch (v1.0.0 build); rebuilding it for 1.1.0 is a deploy step left for the release.

## Archive tags (kept, never deleted)
| Tag | What it holds | Decision |
|---|---|---|
| `archive/2026-10-02/backup/wip-2026-10-02/development_flutter_dot_loader` | `build/**` analyzer excludes, example analyzer excludes, example `pubspec.lock` churn | LAND (the root `build/**` exclude is on main; the example excludes and lockfile churn are local noise: DROP) |
| `archive/2026-10-02/backup/wip-agent-improvement-plan-2026-09-2026-09-27` | same WIP snapshot as above | DROP (duplicate) |
| `archive/2026-10-02/claude/flutter-package-audit-fs2rpz` | June 2026 audit branch, 0.0.6 era (a11y semantics, lean archive) | DROP: superseded by 1.0.0 and 1.1.0 (semantics, pubignore and constraints are all on main) |

## Backlog after this pass
- TASK-001/002/003: Done. TASK-004: `customDotSize` done; replying to and closing GitHub issue #1 needs Hooshyar (external reporter) after 1.1.0 is published.
- TASK-005: README recipe done; sibling-repo follow-ups filed (chat task-037, STM task-023).
- TASK-006: presets and GIF URL change done; a new chat-bubble hero GIF needs a screen recording, plus a live-demo badge.
- Not started (plan P1-4/P1-5, P2): shared controller, lowering the SDK floor (needs verification on older Flutter), golden tests, coverage badge.
