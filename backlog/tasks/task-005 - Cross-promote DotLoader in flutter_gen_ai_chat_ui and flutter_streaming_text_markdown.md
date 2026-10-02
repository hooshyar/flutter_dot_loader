---
id: TASK-005
title: Cross-promote DotLoader in flutter_gen_ai_chat_ui and flutter_streaming_text_markdown
status: To Do
priority: medium
labels: [improvement-plan-2026-09]
created_date: '2026-09-24'
---

## Description

Sibling packages have 30-100x our traffic (gen_ai_chat_ui ~3.5k DL/30d, streaming_text_markdown ~12.9k DL/30d) and target the same AI-chat developer. Depends on TASK-003 so DotLoader looks right inline in a bubble.

Acceptance criteria:
- [ ] flutter_dot_loader README: 'Works great with' section with a ~10-line DotLoader-in-chat-bubble snippet linking both packages
- [ ] Backlog task filed in flutter_gen_ai_chat_ui to document/show DotLoader as a custom typing indicator via its builder (no hard dependency)
- [ ] Same for flutter_streaming_text_markdown example/README

See docs/IMPROVEMENT-PLAN-2026-09.md (P1-1).
