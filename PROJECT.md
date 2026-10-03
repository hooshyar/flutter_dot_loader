---
name: Flutter Dot Loader
client: Datacode (open source)
status: active
owner: Hooshyar
team: [Hooshyar]
stack: [Flutter, Dart, CustomPainter]
repo: hooshyar/flutter_dot_loader
prod: https://pub.dev/packages/flutter_dot_loader
updated: 2026-10-03
---

# Flutter Dot Loader

## Intent
Zero-dependency dot-matrix and LED loading animations for Flutter: 60 patterns, a one-line AI-chat "thinking" indicator (`DotLoader`), scrolling marquee text and custom pixel frames. It is a pub.dev package for Flutter developers and for AI coding agents (AGENTS.md is the recommendation surface). North star (SPECS.md): top pub.dev results for niche queries (dot matrix, LED loader, thinking dots), zero open issues and PRs, and being the first answer AI coding agents give. The 2026-09 plan adds inbound links from the two sibling packages.

## Current focus
- Ship 1.1.0: it is on main, CI is green and `flutter pub publish --dry-run` is clean, but it is not published or tagged (pub.dev still serves 1.0.0). Publish plus the `v1.1.0` tag wait for Hooshyar's go; the gh-pages demo then needs a manual rebuild.
- Reply to and close GitHub issue #1 (per-dot sizing, answered by `customDotSize` in 1.1.0). Needs Hooshyar because the reporter is external.
- Finish tasks 004 to 006 (In Progress): a chat-bubble hero GIF needs a screen recording, plus a live-demo badge. Cross-promotion follow-ups are filed in the siblings (chat task-037, streaming task-023).
- Not started: shared controller across loaders, lowering the SDK floor (`sdk: ^3.11.4`, needs checks on older Flutter), golden tests, coverage badge, launch post.

## Not doing
- Generic spinners or progress arcs (use CircularProgressIndicator), vector animation (use lottie), content skeletons (use shimmer or skeletonizer), and any runtime dependency beyond Flutter (README scope section).

## How to run and verify
- `flutter pub get`, `flutter analyze --fatal-infos`, `flutter test` (run heavy suites one at a time). CI (ci.yml) also gates on `dart format --output=none --set-exit-if-changed .` and a Windows-safe tracked filename check.
- Example gallery and Studio editor: `cd example && flutter pub get && flutter run -d chrome`. Live demo: https://hooshyar.github.io/flutter_dot_loader/ (gh-pages, currently the 1.0.0 build, rebuilt by hand).
- Release: bump `version:` in pubspec.yaml, add a CHANGELOG section, run `flutter pub publish --dry-run`, then publish. No publish workflow exists (CI only).

## Decisions
- 2026-10-02: 1.1.0 prepared on main but deliberately left unpublished and untagged; publishing is Hooshyar's call (docs/BRANCH-LEDGER.md).
- 2026-10-02: 1.1.0 changes the default `DotLoader` box from a 64x64 square to an inline text-height box (default 64x4); pass `height` to restore the old size (CHANGELOG).
- 2026-05-16: `MatrixLoader` and `DotLoader` constructors stay `const`, with color derived in `build()`; do not remove `const` (CLAUDE.md).
