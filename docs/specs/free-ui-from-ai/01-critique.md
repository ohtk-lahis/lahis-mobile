# 01 — Critique of the codex-applied theme

What codex shipped is a **structurally correct visual system that has no point
of view**. It's a competent SaaS shell — cream + teal + Roboto + hairlines +
eyebrow caps — and it's been applied uniformly to every screen. For a community
health app whose primary users are village volunteers (older, possibly
low-literacy, often outdoors, using Thai/Lao), that uniformity is the problem,
not the symptom.

## What's working — keep these

- The token system itself (`lib/theme/ohtk_style_system.dart`) — colors,
  spacing scale, radii, shadow ramp are sane and worth keeping as the
  *foundation*.
- The choice to deepen the app header to `teal900` and keep `cream` as the page
  background — gives the chrome real ground.
- The grouped profile card (one card containing 5 rows) — that's the right
  *information design* call, codex got this right.
- The custom-painted bottom-nav stroke icons
  (`lib/ui/home/home_view.dart::_NavStrokeIconPainter`) — first hint of
  personality. Extend this approach, don't abandon it.
- `OhtkShadow.sticky` on footers — subtle, correct.

## What's hurting the UX

### 1. Type is too small and too uniform for the actual audience

| Surface | Current | Audience reality |
|---|---|---|
| Body text | 13–15px / 400 | Villagers, often 40+, reading in bright sunlight |
| Eyebrow caps | **10.5px** (`profile_widgets.dart:42`, `report_home_view.dart:152`) | Microcopy that no villager will read |
| Action row title | 14.5px | Should be the most legible thing on screen |
| Helper text | 11.5–12.5px | Below WCAG comfort for the demographic |

Codex inherited webapp density. Phone density for this audience should start at
**16px body, 18px action titles, no text below 13px ever**, and eyebrow caps
used sparingly — not on every section.

### 2. Roboto is the AI-default trap — and it's actually a regression

`OhtkType.family = 'Roboto'` in `lib/theme/ohtk_style_system.dart:38`. **Roboto
is not bundled in `assets/fonts/`** — `pubspec.yaml` ships only `Inter`,
`NotoSansThai`, and `NotoSansLao`. So the codex theme references a font the
app doesn't carry: on Android it falls through to the system Roboto, on iOS
it falls through to SF/Helvetica, and on neither does it use the **Inter**
that the team already bundled and declared.

This is a regression, not a taste call. Before codex, someone chose Inter
deliberately and paid the asset-weight cost (`Inter-Variable.ttf` is ~860KB).
That work is sitting unused.

Two paths forward, in priority order:

1. **Cheap, immediate**: restore `family = 'Inter'` and
   `fallback = ['NotoSansThai', 'NotoSansLao']`. Zero new assets, zero new
   licensing, instant visual improvement (Inter has materially better screen
   legibility than fallback-Roboto/Helvetica). Inter is *also* on the
   "AI-default font" list in frontend design guidance, so it's not the most
   distinctive choice — but it's an order of magnitude better than what's
   shipping today.
2. **Distinctive, later**: if the team wants to escape the Inter/Roboto
   default look entirely, swap to a Thai/Lao-first typeface (e.g.
   **IBM Plex Sans Thai Looped**, **Anuphan**, **Sarabun**, or **Noto Sans
   Thai Looped**) paired with a sturdier Latin display face. Looped Thai (vs.
   loopless) reads as friendlier and more village-appropriate than the
   slightly corporate Noto Sans Thai default. This is a separate decision
   from fixing the regression and shouldn't block it.

### 3. "Eyebrow caps everywhere" is corporate cosplay

Almost every screen has `LABEL IN 1.2-LETTERSPACE UPPERCASE`. On a villager's
phone:

- "UPDATING VILLAGE" (`census_view.dart:390`) — they don't think in section headers.
- "ADMIN TOOLS" (`profile_view.dart:1232`) — fine, this is for admins.
- "RECENT" / "EARLIER" (`report_list_view.dart`) — should be `Today · This week · May` in sentence case.
- "EDITED" badge in census (`census_view.dart:464`) — engineering jargon. Should be a soft mint pulse or "Saved when you submit" inline.

Cut eyebrow caps to **one or two places per app** (e.g. "ADMIN TOOLS" gate,
"STEP 2 OF 3"). Replace the rest with sentence-case section labels at h3
weight.

### 4. The empty states are weak

`_EmptyState` in `report_list_view.dart:348` and the `_FullState` in
`census_view.dart:676` follow the exact same SaaS recipe: circle + outline icon
+ title + helper. For villagers, an empty state is a *moment of doubt* — "is
this thing broken?" These need illustration or atmosphere, not iconography.
Right now they look indistinguishable from "loading failed."

### 5. The "pending submissions" red bar is a holdover and breaks the system

`home_view.dart:481`:

```dart
color: Colors.red.shade400,
```

Hard-coded Material red, no shadow, no system colors. In a teal-warm UI this
jumps out as a bug, not a feature. It should be a **warm amber pulse** at the
top of the scaffold, with the actual offline/pending state explained, not just
a count.

### 6. The QR dialog is over-engineered

(`profile_view.dart:877–1027`)

This is the one moment villagers actually *will* visit — to print/save their
login QR. The dialog has: eyebrow + title + body + QR + dashed-border loading
state + shield chip + uppercase-letterspaced download button. That's 5 vertical
zones of text wrapping around the one thing they care about. For this audience,
it should be: **giant QR, name underneath, one big "Save" button.** Nothing
else. The eyebrow + title + body trio is for a SaaS user inspecting a feature,
not a villager about to scan into their next phone.

### 7. The QR scanner button in profile breaks the villager mental model

(`profile_view.dart:528`)

From memory: the QR icon is admin-only form-testing — but the profile now has
*two* QR concepts side-by-side: "Get login QR code" and "Test draft form (scan
QR)" in `_AdminToolsCard`. Currently the admin tools card renders for everyone
(the TODO at line 1220–1222 confirms it). For a villager, two QR features is
one too many. **Role-gate first, then visual-design second.**

### 8. No motion design at all

Codex added shadows but no transitions, no haptics, no micro-feedback. The
bottom-nav tap, the FAB press, the card tap, the "Edited" indicator — all
instant. Adding **120–180ms ease-out** to underline movement, card press scale
(0.98), and bottom-nav icon weight change would make the app feel alive
without adding code complexity.

### 9. The FAB on report home is the most important affordance, treated generically

(`report_home_view.dart:53–68`)

This is the action — "make a new report." It's a 64×64 teal circle with a `+`
icon and a `raised` shadow. For villagers, this is *the* primary purpose of
the entire app. It deserves a distinctive treatment: a soft drop-shadow halo,
a label tucked underneath ("Report"), or a slightly elongated pill ("+ New
report") that's unmissable on a 5" screen in bright daylight. Right now it
could be any Android app's FAB.

### 10. Inconsistencies between codex-installed theme and one-off styling

- `app_theme.dart` still mirrors the old API surface, but only as pass-throughs.
  Half the app reads `incidentsTeal` constants; half reads `OhtkColor.teal700`.
  Pick one (the `OhtkColor.*` path is cleaner). The `incidents_theme.dart`
  constants are vestigial.
- Most text in views hard-codes `fontFamily` + `fontFamilyFallback` per-widget
  (`form_chrome.dart:57–58`, `home_view.dart:46–48`, repeated **dozens** of
  times). This is exactly what the `ThemeData.textTheme` in
  `OhtkTheme.build()` is supposed to absorb. Right now the theme is
  half-applied: defined globally, but every screen re-specifies it inline,
  which means changing the family later means a 200-edit refactor.
