---
id: TASK-003
title: Non-square sizing and fix grid overflow when rows > columns
status: To Do
priority: high
labels: [improvement-plan-2026-09]
created_date: '2026-09-24'
---

## Description

The loader box is always size x size, so a 3x1 DotLoader wastes ~60px of height in a chat bubble (dot_matrix_loader supports inline sizing). Bug: auto spacing is derived from columns only and reused vertically, so columns:1 rows:5 size:64 paints a 260px-tall grid outside the box; _handleTap shares the bad math. Triangle mask divides by zero for 1-row/1-column grids.

Acceptance criteria:
- [ ] Optional `width`/`height`; `size` kept as square shorthand (non-breaking)
- [ ] Per-axis auto-spacing that fits both dimensions; tap hit-test uses the same geometry
- [ ] DotLoader default box is inline/text-height friendly
- [ ] Triangle mask safe for rows==1 / columns==1
- [ ] Tests: rows>columns, 1xN, Nx1, triangle 1-row -- painted bounds stay inside the widget
- [ ] Ship in 1.1.0

See docs/IMPROVEMENT-PLAN-2026-09.md (P0-3, B2, B3).
