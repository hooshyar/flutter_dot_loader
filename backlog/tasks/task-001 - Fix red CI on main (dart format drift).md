---
id: TASK-001
title: Fix red CI on main (dart format drift)
status: To Do
priority: high
labels: [improvement-plan-2026-09]
created_date: '2026-09-24'
---

## Description

CI has been failing on main since the 1.0.0 commit (run 29142043830): `dart format --set-exit-if-changed` reformats test/flutter_dot_loader_test.dart on current stable (3.47.5). Also fix README alias-count drift (13 -> 16) and strip the flutter-create boilerplate from pubspec.yaml.

Acceptance criteria:
- [ ] `dart format .` applied; CI green on main
- [ ] CI status badge added to README
- [ ] README says 16 semantic aliases
- [ ] pubspec boilerplate comment block removed; pana still 160/160
- [ ] Ship as 1.0.1

See docs/IMPROVEMENT-PLAN-2026-09.md (P0-1, B1, B5, B6).
