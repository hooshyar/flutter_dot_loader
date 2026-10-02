---
id: TASK-002
title: Honor reduced motion (MediaQuery.disableAnimations)
status: To Do
priority: high
labels: [improvement-plan-2026-09]
created_date: '2026-09-24'
---

## Description

No loader honours the OS reduce-motion setting. thinking_orbs_flutter does; spinkit/loading_animation_widget/loading_indicator do not, so this is a cheap differentiator.

Acceptance criteria:
- [ ] New `respectReducedMotion` (default true) on MatrixLoader/DotLoader/TriangleLoader
- [ ] When `MediaQuery.maybeDisableAnimationsOf(context) == true`: ticker stopped, static representative frame painted (documented behaviour)
- [ ] Reacts to the setting changing at runtime (didChangeDependencies)
- [ ] Widget tests for on/off; README a11y row + CHANGELOG updated

See docs/IMPROVEMENT-PLAN-2026-09.md (P0-2).
