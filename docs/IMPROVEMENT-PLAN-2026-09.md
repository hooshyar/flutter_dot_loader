# flutter_dot_loader — Improvement Plan (2026-09)

Written 2026-09-24. Scope: research and planning only. No library code was changed.
The package is small and low-traffic, so this plan is mostly about discoverability
and adoption, plus a few real bugs found while reading the code.

## 1. Snapshot

| Metric | Value (2026-09-24) |
|---|---|
| Latest version | 1.0.0 (published 2026-07-11) |
| Pub points | 160 / 160 |
| Likes | 22 |
| Downloads (30d) | ~110 |
| GitHub | 6 stars, 0 forks, live demo at https://hooshyar.github.io/flutter_dot_loader/ |
| Open issues / PRs | 1 issue (#1, per-dot size, from WD-J, 2026-05-31, no reply yet) / 0 PRs |
| CI on `main` | **Red since the 1.0.0 commit.** `dart format --set-exit-if-changed` fails on `test/flutter_dot_loader_test.dart` |
| Analyzer | `flutter analyze`: no issues (Flutter 3.47.5 stable) |
| Tests | 39 tests, all passing (one 670-line file). Line coverage 74.3% overall; `matrix_loader.dart` 61% (painter/pattern math, hover and tap paths mostly unexercised); the other files are 92-100% |
| Runtime deps | none (Flutter SDK only) |
| Dev deps | `flutter_lints ^6.0.0` (latest 6.0.0). `flutter pub outdated`: all direct deps current. Only transitive SDK-pinned packages lag (`material_color_utilities`, `test_api`), which nobody can fix from here |
| Example app | `flutter_lints ^5.0.0`, one major behind (6.0.0 is latest) |
| SDK constraint | `sdk: ^3.11.4`, `flutter: ">=1.17.0"`. The Dart floor is much higher than the code needs, and the Flutter floor doesn't match it |

### Search ranking on pub.dev (queried 2026-09-24)

| Query | Position |
|---|---|
| `typing indicator` | **#1** |
| `dot matrix` | **#1** (direct rival `dot_matrix_loader` at #2) |
| `led loader` | #2 |
| `dot loader` | #3 |
| `thinking indicator` | #6 (behind four "thinking orbs" packages) |
| `loading` / `loader` / `spinner` | not in the top results. These generic queries are owned by spinkit, loading_animation_widget, and loading_indicator |

Ranking isn't the problem. The package already wins its niche queries. With 110
downloads a month, the problem is that niche queries have little traffic and the
package has no inbound links from the bigger sibling packages.

## 2. Competitor matrix

| Package | Likes | DL/30d | Points | Last release | Variety | Custom frames | Non-square / inline sizing | Reduced motion | Semantics | Live demo |
|---|---|---|---|---|---|---|---|---|---|---|
| **flutter_dot_loader** | 22 | 110 | 160 | 2026-07 | 60 patterns + 16 aliases, marquee text | Yes (`customIntensity`, JSON frames) | **No** (box is always `size × size`) | **No** | Yes (opt-in) | Yes (GH Pages) |
| flutter_spinkit | 4,647 | 493k | 140 | 2025-08 | ~30 spinners | No | Yes | No | No | No (GIFs only) |
| loading_animation_widget | 2,030 | 119k | 150 | 2024-10 | ~20 | No | Yes | No | No | No (GIFs) |
| loading_indicator | 695 | 51k | 160 | 2026-08 | ~30 (loaders.css) | No | Yes | No | No | No |
| dot_matrix_loader | 10 | 69 | 160 | 2026-06 | 61 presets | Yes (`CustomDotAnimation`, `SequenceAnimation`) | **Yes, inline `size` next to text** | No | No | Yes (dots.luisportal.com) |
| thinking_orbs_flutter | 0 | 161 | 150 | 2026-07 | 6 AI "thinking" states | No | 2 fixed sizes | **Yes** | Yes | Yes |
| agent_orbs | 0 | 56 | 160 | 2026-08 | 9 AI states | No | 2 sizes | ? | ? | — |
| simple_typing_indicator | 4 | 142 | 160 | 2025-02 | 1 | No | Yes | No | No | No |

(Competitor a11y columns come from grepping each package's latest published
`lib/` for `disableAnimations`, `Semantics`, and `RepaintBoundary`.)

### What competitors offer that we don't

1. **Inline / non-square sizing.** `dot_matrix_loader` fits a loader next to text in a `Row`.
   Our `DotLoader` (a 3×1 row) always takes a 64×64 box, which leaves about 60 px of empty
   height inside a chat bubble. This is the biggest DX gap for the AI typing-indicator use case.
2. **Shared controller.** `dot_matrix_loader` can drive N loaders from one `AnimationController`,
   which matters for galleries and long chat lists.
3. **Reduced motion.** `thinking_orbs_flutter` honours `MediaQuery.disableAnimations`.
   None of the big three do, so this is cheap to add and a real differentiator.
4. **AI-state vocabulary.** The orb packages name states such as thinking, searching, and
   generating. We have the patterns but not the names or a preset API for them.
5. **Reach.** spinkit and loading_animation_widget win generic "loading" traffic through age
   and back-links, not features. Our lever is cross-promotion from our own packages
   (`flutter_gen_ai_chat_ui`: 101 likes, 3.5k DL/30d; `flutter_streaming_text_markdown`: 52 likes, 12.9k DL/30d).

### What we have that nobody else has

A marquee text font, JSON/Remote Config frame delivery, `once` + `onComplete` splash
handoff, tap-to-dot interactivity, opt-in semantics, and a `RepaintBoundary`.

## 3. Bugs found while reading (not yet reported)

| # | Bug | Evidence |
|---|---|---|
| B1 | **CI red on main since 1.0.0.** The formatter in current stable reformats `test/flutter_dot_loader_test.dart` | GH Actions run 29142043830; reproduced locally with Flutter 3.47.5 |
| B2 | **Grid overflows its box when `rows > columns`.** Auto spacing is `(size - dotSize*columns)/(columns-1)` and is also used vertically. With `columns: 1, rows: 5, size: 64` the spacing is 60 and the grid is 260 px tall, painted outside the 64 px box (CustomPaint doesn't clip). `_handleTap` uses the same math | `matrix_loader.dart` ~L504, L563, L628 |
| B3 | **Triangle mask divides by zero** when `rows == 1` or `columns == 1` (`r/(rows-1)`), so NaN comparisons render no dots | `_isInMask` ~L684 |
| B4 | `MouseRegion` calls `setState` on every enter/exit even when `hoverAnimated: false`, which rebuilds for no reason | `build()` ~L535 |
| B5 | README drift: the features table says "13 semantic aliases", but there are 16 | README L26 |
| B6 | `pubspec.yaml` still carries the ~35-line `flutter create` boilerplate comment block, and `flutter: ">=1.17.0"` contradicts `sdk: ^3.11.4` | pubspec |

## 4. Prioritized plan

### P0 — do next (small, and they unblock everything else)

**P0-1. Fix red CI and pin a formatter-stable workflow** — Effort **S**
- Why: a red badge and a failing `main` hurt trust. Every future PR, including issue #1's, would fail CI.
- Acceptance: `dart format` has been run; CI is green on `main`; the workflow keeps `--set-exit-if-changed`; a CI status badge is added to the README.

**P0-2. Reduced-motion support** — Effort **S**
- Why: a11y is a stated feature, and only one tiny competitor does this. It matters for OS "reduce motion" users and for WCAG 2.3.3.
- Acceptance: new `respectReducedMotion` (default `true`). When `MediaQuery.maybeDisableAnimationsOf(context) == true`, the loader renders a static mid-intensity frame (or a slow, low-amplitude pulse, whichever the team documents) and the ticker is stopped. Covered by widget tests for both states. README a11y row updated.

**P0-3. Non-square sizing and fixed grid-overflow math (B2, B3)** — Effort **M**
- Why: this is the biggest DX gap for the AI typing-indicator positioning. A 3×1 `DotLoader` should be about 24×8 inline next to text, not a 64×64 box. It also fixes an actual overflow bug.
- Acceptance: optional `width`/`height` (with `size` kept as the square shorthand, so no breaking change). Auto-spacing is computed per axis and fits both dimensions. `DotLoader` defaults to an intrinsic, text-height-friendly box. Triangle mask is safe for 1-row and 1-column grids. Tap hit-testing uses the same geometry. Tests cover `rows > columns`, `1×N`, `N×1`, and a triangle with 1 row, asserting painted bounds stay inside the widget. Minor version bump (1.1.0).

**P0-4. Reply to and triage issue #1 (per-dot size)** — Effort **S** to reply, **M** to build
- Why: it's the only external issue, it has been open about four months with no reply, and a quick response costs nothing.
- Acceptance: reply on the issue. Implement `customDotSize: double Function(int row, int col)?` (a scale factor, 0 = hidden, returning to `dotSize` when null), mirroring the `customMask` API. Tests plus a README row. Close #1 citing the release.

### P1 — adoption and discoverability

**P1-1. Cross-promotion with our own AI chat packages** — Effort **S–M**
- Why: `flutter_gen_ai_chat_ui` (3.5k DL/30d) and `flutter_streaming_text_markdown` (12.9k DL/30d) have 30–100× our traffic and target the exact same user.
- Acceptance: the `flutter_gen_ai_chat_ui` README and example show `DotLoader` as the recommended custom typing indicator, via an optional builder so the chat UI takes no hard dependency. `flutter_dot_loader`'s README has a "Works great with" section linking both packages, with a 10-line snippet of `DotLoader` inside a chat bubble. Tracked as cross-repo tasks.

**P1-2. AI-state presets** — Effort **S**
- Why: this competes directly with the orb packages on vocabulary, which is what developers and AI agents search for.
- Acceptance: `DotLoader.thinking()`, `.typing()`, `.searching()`, and `.generating()` named constructors (or a `DotLoaderPreset` enum) that map to curated pattern, grid, and duration combos. Documented in the README, AGENTS.md, and the dartdoc of each preset. Tested.

**P1-3. README hero refresh** — Effort **S**
- Why: the two hero GIFs are 472 KB and 1 MB, portrait, gallery-oriented, and ship inside the package archive. The first screen should show the chat use case.
- Acceptance: a small GIF of `DotLoader` in a chat bubble goes first. GIFs are referenced by absolute `raw.githubusercontent.com` URLs and `*.gif` is added to `.pubignore` (archive under 300 KB). "13 aliases" becomes "16" (B5). Live demo link gets a badge.

**P1-4. Shared-controller / `TickerMode` friendliness** — Effort **M**
- Why: galleries and long chat lists create one ticker per loader. `dot_matrix_loader` advertises a shared controller.
- Acceptance: optional `controller: Animation<double>?`. When provided, no internal ticker is created. Driven by `CustomPainter(repaint:)` instead of `AnimatedBuilder` rebuilding the widget each frame. Fix B4. Test: 50 loaders sharing one controller build and pump without error.

**P1-5. Broaden the SDK floor** — Effort **S**
- Why: `sdk: ^3.11.4` locks out apps on anything older than early-2026 Flutter. The code needs only `Color.withValues` (Flutter 3.27 / Dart 3.6). Lowering the floor means more users can resolve the package.
- Acceptance: `sdk: ">=3.6.0 <4.0.0"`, `flutter: ">=3.27.0"`. CI matrix runs the floor version plus stable. pana is still 160. Remove the pubspec boilerplate (B6). Bump the example to `flutter_lints ^6.0.0`.

### P2 — nice to have

| Item | Effort | Why | Acceptance |
|---|---|---|---|
| P2-1. Golden tests for the 16 aliases and the marquee font | M | Catch visual regressions that the "renders without throwing" tests miss | `matchesGoldenFile` per alias at a fixed progress, CI on Linux only |
| P2-2. Coverage report + badge | S | Signal quality | `flutter test --coverage` in CI, uploaded to Codecov, badge in the README |
| P2-3. Split the 670-line test file | S | Maintainability | One test file per widget/helper |
| P2-4. Perf: cache per-dot geometry, avoid `math.pow` in the hover path | S | Large grids (for example 32×8 marquees) | Benchmark at 32×32 shows no regression. Painter allocations are hoisted |
| P2-5. Additional pub.dev topic swap | S | `thinking-indicator` / `typing-indicator` are what AI-chat devs search | Swap `pixel-art` → `typing-indicator` (max 5 topics), then re-check rankings a month later |
| P2-6. Launch post | S | Adoption is driven by being seen | Short post (dev.to, r/FlutterDev, Flutter Discord #showcase) with the chat-bubble GIF plus the live demo link, after 1.1.0 ships |

## 5. Release sequencing

1. **1.0.1**: P0-1 (CI), B5, B6. Docs and hygiene only.
2. **1.1.0**: P0-2 reduced motion, P0-3 width/height plus overflow fix, P0-4 `customDotSize`, P1-5 SDK floor. All additive, no breaking changes.
3. **1.2.0**: P1-2 presets, P1-4 shared controller, P1-3 README hero.
4. Cross-repo P1-1 lands in `flutter_gen_ai_chat_ui` right after 1.1.0 (it needs the inline sizing to look right in a bubble).

## 6. Verification notes (this research pass)

- `flutter pub outdated`: all direct and dev deps current, and `flutter_lints` 6.0.0 is the latest stable on pub.dev.
- `flutter analyze`: no issues.
- `dart format --set-exit-if-changed .`: **fails** (1 file), matching the red CI run.
- `flutter test --coverage`: 39/39 pass; line coverage 74.3% (378/509). The weakest file is `matrix_loader.dart` at 61%.
- P2-2 target: raise `matrix_loader.dart` coverage to 85% or more with tests for the tap hit-test, hover, and per-pattern intensity bounds (0..1).
