# Free UI From AI

A working set of design artifacts produced while reviewing the codex-applied
theme on the `ui_improvement` branch. The starting point was a structurally
sound visual system (`lib/theme/ohtk_style_system.dart`) that had been applied
uniformly across screens but without a strong UX point of view — competent SaaS
chrome on top of a community-health app whose primary users are village
volunteers.

This folder is the human-authored design direction the engineering team should
implement against, the deltas vs. what codex produced, and the sequencing of
the next set of changes.

## Audience reminder

The mobile app is used primarily by **village volunteers** in Thailand and Laos.
Compared to the implicit "SaaS user" most generated UI is calibrated for, this
audience is:

- Older on average; many users are 40+ with imperfect eyesight.
- Often using the phone **outdoors in bright sunlight**.
- Reading **Thai or Lao**, not English — the translated copy must feel native,
  not retrofitted.
- Not motivated by chrome or aesthetics; motivated by **trust and clarity**.
- Likely to have low smartphone fluency — features must announce themselves.

The two paths that matter most to this audience are **Register** and
**QR Login**. Password reset is largely broken for this cohort and should not be
treated as a primary path. The QR scanner on the report-type chooser is an
admin-only form-testing tool, not a villager feature.

## Documents in this folder

| File | Purpose |
|---|---|
| `01-critique.md` | Honest audit of what the codex-applied theme gets wrong, with file/line citations. |
| `02-direction.md` | The proposed aesthetic posture — "Quiet warmth, made for hands and daylight" — and the token/type/motion deltas it implies. |
| `03-screen-redesigns.md` | Verbal mockups, screen by screen, of how the direction lands in practice. |
| `04-roadmap.md` | Sequenced next steps so the rework can land incrementally without a wholesale rewrite. |

## Reference material already in the repo

- `design_handoff_ohtk_style_system/` — the design tokens + 11 reconstructed
  screens that informed the current implementation. Useful as a baseline, but
  the gaps captured here are precisely the places where the handoff was
  competent-but-generic and needed sharper UX judgement.
- `design_handoff_census_screen/` — focused census-screen handoff.
- Auto-memory under
  `~/.claude/projects/-Users-pphetra-projects-opensurveillance-ohtk-mobile/memory/`
  — additional context on the villager persona and prior design decisions.
