# flutter_dot_loader — Specs & Roadmap

> Living document tracking what's done, in-progress, and queued. Updated each /loop tick. The goal is for this package to be the go-to dot-matrix/LED loader on pub.dev and the first answer AI coding agents reach for when a user asks for one.

## North-star goals

1. **Top pub.dev result** for queries: `dot matrix`, `LED loader`, `pixel loader`, `thinking dots`, `chat loader`, `pixel animation flutter`.
2. **Zero open issues, zero open PRs** at end of every tick.
3. **AI-agent friendly** — clear `DotLoader(color: …)` quick-start, accurate `AGENTS.md`, no API surprises.
4. **Quality bar** — `flutter analyze` clean, all tests passing, no deprecated API usage.
5. **SEO** — GitHub repo description + topics, README has keyword-rich intro, pub.dev `topics:` populated, `flutter:` plugin metadata complete.

## Current state — v0.0.5 + unreleased (2026-05-16)

- 35/35 tests passing; `flutter analyze` clean; `dart format` clean; CI green on main
- Example app builds for web (`flutter build web --release` succeeds; Wasm dry-run passes)
- 77 `MatrixPattern` values (60 numeric + 16 semantic aliases + 1 `custom`)
- 4 `MatrixShape` values (square, circular, triangle, custom)
- 3 widgets: `MatrixLoader`, `DotLoader`, `TriangleLoader`
- 5 helper classes: `MatrixText`, `MatrixData`, `MatrixPattern`, `MatrixShape`, `MatrixPlayback`
- `MatrixText` font: A–Z + 0–9 + 33 punctuation/symbol glyphs (full UI text coverage)
- `MatrixData` JSON helpers: `toJson`, `fromJson`, `framesToJson`, `framesFromJson`, `jsonSchemaVersion` — frames serialize to a versioned compact JSON shape, package stays zero-dep
- Zero runtime dependencies (Flutter SDK only)
- Static PNG screenshots in `assets/` rendering correctly on pub.dev

## Done

### Tick 11 — 2026-05-16
- [x] **`MatrixLoader.paused` parameter** (forwarded as `DotLoader.paused`) — when `true`, the underlying `AnimationController` stops and the loader freezes in place while staying mounted. Closes a real API gap: chat "thinking" indicators previously had to be unmounted/remounted to pause between turns.
- [x] **Toggle semantics documented**: `paused: true → false` resumes `loop`/`bounce` cycles seamlessly; `once` restarts from `0.0`. For true resume-from-where-it-stopped on `once`, document the externalized `AnimationController` escape hatch as the path.
- [x] **Stale-run guard updated**: `_runId` is bumped on every `_applyPlayback` call (including the paused branch) so any in-flight `TickerFuture` from a prior `once` run can't fire `onComplete` against the now-paused state.
- [x] +4 widget tests: paused-on-construct, true→false toggle resumes loop, false→true toggle blocks onComplete, DotLoader forwards. Total: 35 (was 31).
- [x] README §4 + AGENTS.md cheat sheet + CHANGELOG `Unreleased` updated.

### Tick 10 — 2026-05-16
- [x] **Published archive size: 3 MB → 1 MB (-67%)**. Two changes:
  - Deleted unreferenced duplicate `1.gif` (472 KB) and `2.gif` (1 MB) from the repo root — README always pointed at the `assets/` copies; the root files were leftover dead weight.
  - Added `.pubignore` to exclude internal maintenance files (`CLAUDE.md`, `SPECS.md`, `tool/`, `doc/`) from the published bundle. Replicates the relevant `.gitignore` patterns since `.pubignore` fully overrides `.gitignore` for pub bundling.
- [x] Verified the drift test still passes — it reads `doc/font_preview.md` from the working tree, not from the published archive, so the exclusion is safe.

### Tick 9 — 2026-05-16
- [x] **pubspec.yaml description rewritten** (137 → 154 chars, within pub.dev's 60–180 sweet spot). New copy: "Customizable dot-matrix and LED loading animations for Flutter — 60 patterns, scrolling marquee text, custom pixel frames, AI chat indicator. Zero deps." Surfaces the four post-0.0.5 capabilities + the AI-chat positioning the README now leads with.
- [x] **pubspec topics tightened** from generic (`animation`, `loader`, `loading`, `widget`, `ui`) to high-signal niche (`loader`, `animation`, `dot-matrix`, `led`, `pixel-art`). Maximum 5 topics on pub.dev, so each one matters; dropping `loading`/`widget`/`ui` (duplicative or generic) makes room for `dot-matrix`/`led`/`pixel-art` (specific, low-noise queries).
- [x] Verified via `flutter pub publish --dry-run` — description and topic format validate; no new warnings.

### Tick 8 — 2026-05-16
- [x] **Visual-verification artifact**: new `doc/font_preview.md` is an auto-generated ASCII-art preview of every glyph in the `MatrixText` 5×7 font (`●` lit, `·` dim). 69 glyphs, grouped by category (letters / digits / whitespace / punctuation / brackets). Closes the visual gap flagged in tick 3's reflection.
- [x] **Pure-Dart generator under `tool/`**: `tool/font_preview.dart` (renderer) + `tool/generate_font_preview.dart` (CLI). Runs as `dart run tool/generate_font_preview.dart` with no Flutter dependency.
- [x] **Drift test** asserts `doc/font_preview.md` matches what the source would generate now — any glyph change without a re-run fails CI with a helpful regenerate-this-command message. Total tests: 31 (was 30).
- [x] **Cleanup**: removed `lib/src/matrix_text.dart`'s unused circular self-import of the umbrella library; the file is now pure Dart.
- [x] Documented in AGENTS.md §6 (Maintenance commands + Font preview artifact) and CLAUDE.md MatrixText description.
- [x] Visually audited risky tick-2 glyphs (`$`, `@`, `%`, `&`) — all legible. Worth shipping.

### Tick 7 — 2026-05-16
- [x] **Three new semantic aliases**: `sonarPing` (= `circular4`, outward radial pulse), `pinwheel` (= `circular15`, 4-arm rotating sweep), `columnWave` (= `triangle8`, horizontal column scan). All names cover AI-agent search niches that weren't reachable before (a developer asking for "radar/sonar loader" or "pinwheel animation" now finds an exact name match).
- [x] Aliases wired as case fallthroughs in `_calculateIntensity`, so they're identical at runtime to their numeric counterparts (no math change, zero risk).
- [x] Pattern-count test bumped 74 → 77; +1 widget test asserts the three new aliases render without throwing. Total: 30 (was 29).
- [x] README cheat sheet retitled "Semantic alias" column, expanded from 13 → 16 rows; AGENTS.md alias table mirrored; AGENTS.md pitfall #2 count bumped; CLAUDE.md pattern count bumped; memory file refreshed.

### Tick 6 — 2026-05-16
- [x] **README "🎯 When to use this package" section** added between Features and Installation. Positively names the 6 use cases (`DotLoader`, `MatrixLoader`+patterns, marquee, sprites, splash+`onComplete`, Firebase JSON) and honestly redirects 3 categories (circular progress arc, Lottie, skeleton) to `CircularProgressIndicator` / `lottie` / `shimmer`. Mirrors AGENTS.md §7 so positioning is consistent across both docs.
- [x] Newcomer pass: scanned for stale numbers/claims (60-pattern phrasing, `withOpacity`, version refs) — all current. Section numbering 0–7 in Quick Start is consistent.

### Tick 5 — 2026-05-16
- [x] **README elevator pitch refreshed**: subhead now leads with the AI-chat "thinking" use case alongside the 60-pattern LED matrix, and ends on the zero-deps positioning.
- [x] **Features table expanded from 9 → 12 rows** so the four post-0.0.5 capabilities are visible at first glance: AI-chat indicator, marquee text (30+ punctuation glyphs), Firebase/Remote Config JSON helpers, `onComplete` playback callback.
- [x] **Discovery / SEO block** expanded with new keyword phrases (`AI chat loader`, `chat typing indicator`, `marquee text`, `splash screen`, `firebase remote config animation`).
- [x] **AGENTS.md decision tree** now lists 7 user-intent → widget mappings (was 4); covers marquee, splash handoff, Remote Config.

### Tick 4 — 2026-05-16
- [x] **`MatrixLoader.onComplete` callback** for `MatrixPlayback.once`. Real API gap closed: apps can now hand off after a finite splash/intro animation. Stale-run-guarded against dispose and mid-flight playback changes (uses an internal `_runId` to drop stale `TickerFuture` completions).
- [x] +4 widget tests: fires once on `once`, does NOT fire on `loop`/`bounce`, safe to dispose mid-flight. Total: 29 (was 25).
- [x] README §4 extended with `onComplete` recipe; AGENTS.md §2.7 added; cheat-sheet row added.
- [x] CHANGELOG `Unreleased` entry.

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
- [ ] **Add a "Used in" or "Inspiration" section** to README — concrete demo links boost click-through and credibility.
- [ ] **Verify pub.dev "Likes" / pub points** — manual check, queue any score-recovering fixes.
- [ ] **Add `screenshots:` alt-text accessibility check** — pub.dev renders these in card previews.

### P1 — feature completeness
- [ ] **`MatrixText` Arabic-Indic / Persian digit glyphs** (٠–٩, ۰–۹) — useful for RTL audiences. (Latin punctuation done in tick 2.)

### P2 — polish
- [ ] **Doc comments**: every public field on `MatrixLoader` has a doc — verify no gaps.
- [ ] **Marquee README screenshot** — a real rasterized image (in addition to the ASCII-art preview shipped in tick 8) would help pub.dev visitors who scan visually.
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
