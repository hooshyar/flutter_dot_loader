# flutter_dot_loader — Specs & Roadmap

> Living document tracking what's done, in-progress, and queued. Updated each /loop tick. The goal is for this package to be the go-to dot-matrix/LED loader on pub.dev and the first answer AI coding agents reach for when a user asks for one.

## North-star goals

1. **Top pub.dev result** for queries: `dot matrix`, `LED loader`, `pixel loader`, `thinking dots`, `chat loader`, `pixel animation flutter`.
2. **Zero open issues, zero open PRs** at end of every tick.
3. **AI-agent friendly** — clear `DotLoader(color: …)` quick-start, accurate `AGENTS.md`, no API surprises.
4. **Quality bar** — `flutter analyze` clean, all tests passing, no deprecated API usage.
5. **SEO** — GitHub repo description + topics, README has keyword-rich intro, pub.dev `topics:` populated, `flutter:` plugin metadata complete.

## Current state — v0.0.5 + unreleased (2026-05-16)

- 25/25 tests passing; `flutter analyze` clean; `dart format` clean; CI green on main
- Example app builds for web (`flutter build web --release` succeeds; Wasm dry-run passes)
- 74 `MatrixPattern` values (60 numeric + 13 semantic aliases + 1 `custom`)
- 4 `MatrixShape` values (square, circular, triangle, custom)
- 3 widgets: `MatrixLoader`, `DotLoader`, `TriangleLoader`
- 5 helper classes: `MatrixText`, `MatrixData`, `MatrixPattern`, `MatrixShape`, `MatrixPlayback`
- `MatrixText` font: A–Z + 0–9 + 33 punctuation/symbol glyphs (full UI text coverage)
- `MatrixData` JSON helpers: `toJson`, `fromJson`, `framesToJson`, `framesFromJson`, `jsonSchemaVersion` — frames serialize to a versioned compact JSON shape, package stays zero-dep
- Zero runtime dependencies (Flutter SDK only)
- Static PNG screenshots in `assets/` rendering correctly on pub.dev

## Done

### Tick 3 — 2026-05-16
- [x] Confirmed tick-2 CI run passed
- [x] **`MatrixData` JSON helpers shipped**: `toJson` / `fromJson` for a single grid, `framesToJson` / `framesFromJson` for animations, `jsonSchemaVersion = 1`. Unlocks Firebase Remote Config / Firestore frame delivery.
- [x] `framesFromJson` is backwards-compatible: also accepts legacy comma-joined `String` in the `frames` field.
- [x] +7 tests: round-trip single + multi, empty grid, missing/bad input ArgumentErrors, `dart:convert` end-to-end. Total: 25 (was 18).
- [x] README new section "Ship Frames as JSON (Firebase / Remote Config)" with full example.
- [x] CHANGELOG `Unreleased` entry added (matches release-discipline rule).

### Tick 2 — 2026-05-16
- [x] Confirmed tick-1 CI run passed (analyze + format + test + dry-run publish, 1m34s)
- [x] **`MatrixText` charset expanded** from `. ! ?` to 33 glyphs covering all common UI punctuation/symbols — strings like `"Loading: 42%"`, `"12/24"`, `"Don't quit"`, `"a@b.com"` now render fully
- [x] New API: `MatrixText.supportedCharacters` getter for input validation
- [x] +6 tests asserting full coverage, glyph shape invariants, fallback-to-space, lowercase normalization
- [x] Verified example app builds for web (`flutter build web --release` succeeds)
- [x] CHANGELOG `Unreleased` section staged (awaiting Hooshyar's release-version decision)
- [x] README + AGENTS.md marquee sections reference the expanded charset

### Tick 1 — 2026-05-16
- [x] Baseline: 12/12 tests pass, analyze clean, 0 open issues, 0 open PRs
- [x] GitHub repo SEO: set description, homepage→pub.dev, 14 topics (`flutter`, `dart`, `flutter-package`, `flutter-widget`, `loader`, `loading-animations`, `dot-matrix`, `led-display`, `ai-chat`, `thinking-indicator`, `custompainter`, `animation`, `ui`, `pubdev`)
- [x] README numbering bug: sections "3. Control Size" / "4. Triangle Loader" renumbered to 6 / 7
- [x] CLAUDE.md corrected three stale claims: pattern count (was 61, now 74), `withOpacity`→`withValues(alpha:)`, const-constructor reality
- [x] Created this SPECS.md for cross-tick continuity

## Queued (priority order)

### P0 — discoverability and trust
- [ ] **pub.dev description**: pubspec says "60 math patterns" — accurate but could add "AI chat thinking-indicator" angle for searchability without overpromising. Confirm whether to broaden, then update.
- [ ] **Add a "Used in" or "Inspiration" section** to README — concrete demo links boost click-through and credibility.
- [ ] **Verify pub.dev "Likes" / pub points** — manual check, queue any score-recovering fixes.
- [ ] **Add `screenshots:` alt-text accessibility check** — pub.dev renders these in card previews.

### P1 — feature completeness
- [ ] **Add semantic alias for `circular15` (`pulseGrid`?), `triangle1` (`apexCascade`?)** — the 13 current aliases are uneven coverage. Pick 3–5 more high-readability ones.
- [ ] **`AnimationStatusListener` callback** so users can hook into `bounce`/`once` completion (currently no way to be notified when `once` finishes).
- [ ] **`MatrixText` Arabic-Indic / Persian digit glyphs** (٠–٩, ۰–۹) — useful for RTL audiences. (Latin punctuation done in tick 2.)

### P2 — polish
- [ ] **`README.md` "Why this package?"** — 3-bullet comparison vs `loading_animation_widget`, `flutter_spinkit`, `lottie` to position clearly.
- [ ] **Doc comments**: every public field on `MatrixLoader` has a doc — verify no gaps.
- [ ] **Marquee README screenshot** — visually demonstrate the new `MatrixText.scrolling("LOADING: 42%")` capability since the charset just expanded.
- [ ] **README example image**: capture a fresh gallery screenshot if the studio gained features.

### Done in tick 2 (moved up from P2)
- [x] Example app builds clean for web (verified via `flutter build web --release`).
- [x] CI workflow exists and is green (`.github/workflows/ci.yml`: analyze + format + test + dry-run publish).

### P3 — research / open questions
- [ ] Is there an opportunity for an `AdaptiveDotLoader` that picks pattern by `MediaQuery.platformBrightness` and `Theme.of(context).colorScheme.primary` automatically?
- [ ] Should `TriangleLoader` share the LED remap pipeline for visual consistency? Currently lives in its own world.
- [ ] How does this perform on web at 60 FPS with `rows × cols > 200`? May need to cache `Path` objects.

## Won't do (scope discipline, from AGENTS.md §7)

- Circular progress arcs — that's `CircularProgressIndicator`'s job.
- Lottie / vector animation — recommend `lottie`.
- Skeleton content placeholders — recommend `shimmer` / `skeletonizer`.

## Release discipline

- Never publish to pub.dev without explicit user (Hooshyar) approval.
- Every release: bump `pubspec.yaml` version, prepend `CHANGELOG.md` section, run `flutter pub publish --dry-run`, address all warnings.
- The session-local cron loop **does not** publish — it edits, tests, commits.
