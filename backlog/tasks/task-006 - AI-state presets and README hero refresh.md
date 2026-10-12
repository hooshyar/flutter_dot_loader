---
id: TASK-006
title: AI-state presets and README hero refresh
status: In Progress
priority: medium
labels: [improvement-plan-2026-09]
created_date: '2026-09-24'
---

## Description

Orb packages win on vocabulary (thinking/searching/generating). Hero GIFs are 1.5MB, gallery-focused, and ship in the archive.

Acceptance criteria:
- [ ] DotLoader.thinking()/.typing()/.searching()/.generating() (or DotLoaderPreset enum) with curated pattern/grid/duration; tested; in README + AGENTS.md
- [ ] New first-screen GIF of DotLoader in a chat bubble
- [ ] GIFs referenced by absolute raw.githubusercontent.com URLs; *.gif in .pubignore; archive < 300 KB
- [ ] Live-demo badge in README

See docs/IMPROVEMENT-PLAN-2026-09.md (P1-2, P1-3).

## Final Summary

DotLoader.typing/thinking/searching/generating presets added and tested; hero GIFs now use absolute raw URLs and `*.gif` is excluded from the pub archive. Open: record a new first-screen GIF of DotLoader in a chat bubble (needs a screen recording) and a live-demo badge.
