---
id: TASK-004
title: Per-dot size callback (GitHub issue 1)
status: To Do
priority: high
labels: [improvement-plan-2026-09]
created_date: '2026-09-24'
---

## Description

Issue #1 (WD-J, 2026-05-31) requests per-dot sizing, unanswered for ~4 months. Reply on the issue first, then implement.

Acceptance criteria:
- [ ] Reply posted on issue #1 acknowledging and linking the plan
- [ ] `customDotSize: double Function(int row, int col)?` returning a scale factor (1.0 = dotSize, 0 = hidden), mirroring customMask
- [ ] Hit-testing unaffected for scaled dots (documented)
- [ ] Tests + README API table row + CHANGELOG
- [ ] Issue closed referencing the release

See docs/IMPROVEMENT-PLAN-2026-09.md (P0-4).
