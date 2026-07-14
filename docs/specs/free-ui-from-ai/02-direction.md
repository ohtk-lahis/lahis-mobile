# 02 — Proposed direction: "Quiet warmth, made for hands and daylight"

Pick one and commit. The recommended direction is **"Quiet warmth, made for
hands and daylight"** — a deliberate move away from generic-NGO into something
that feels like it was made *for* this audience.

## The aesthetic posture

- **Bigger, calmer type.** Body 16, h3 18, action rows 17/600. No text below 13.
  Eyebrow caps banished from anywhere a non-admin will see.
- **Fix the font regression first** (see `01-critique.md` §2). The codex theme
  references Roboto, which isn't bundled; the team already ships
  `Inter-Variable.ttf` + `NotoSansThai` + `NotoSansLao` in `assets/fonts/`.
  Restoring `family = 'Inter'` with `fallback = ['NotoSansThai',
  'NotoSansLao']` is a one-line change and reclaims work that's already been
  paid for in asset weight. If/when the team wants to escape the Inter
  default look entirely, that's a separate, later decision — candidates
  include **IBM Plex Sans Thai Looped + Public Sans**, both libre and both
  more hand-set than corporate.
- **Warmer cream, deeper teal contrast.** The current `#F5F1EA` cream against
  `#0F7B5A` teal works, but the teal feels institutional. Push primary to a
  slightly more saturated forest (`#1F8362`) and reserve `teal900` strictly for
  the app header — never on body controls.
- **Atmosphere over chrome.** Replace hairline-bordered cards with subtle
  **cream-on-cream** elevation (cards as `#FAF7F1` floating on `#F5F1EA` with a
  1px `lineSoft` border *only on the bottom*, mimicking paper stacked on
  paper). Hairline-everywhere is the spreadsheet aesthetic.
- **Hand-painted iconography across the app**, not just bottom nav. The 4 nav
  icons codex painted are good; extend the same stroke vocabulary to the
  avatar fallback, empty states, and the QR dialog illustration. Material
  outline icons inside ListRows can stay (different context), but anywhere an
  icon is "the hero of the screen" it should be custom.
- **Motion as confirmation, not decoration.** Tab underline slides (180ms
  ease-out). Card press scales to 0.98. Bottom-nav icon switches with a 100ms
  cross-fade. "Edited" state pulses once (300ms) instead of standing as a
  chip. Submit button micro-celebrates on success.

## Token deltas vs. what codex shipped

Apply these as edits to `lib/theme/ohtk_style_system.dart`:

### Type ramp — push everything up one notch

| Token | Current | Proposed |
|---|---|---|
| `h1` | 22 / 700 | **24 / 700** |
| `h2` | 18 / 700 | **20 / 700** |
| `h3` | 16 / 600 | **18 / 600** |
| `body` | 15 / 400 | **16 / 400** |
| `bodyStrong` | 15 / 600 | **16 / 600** |
| `small` | 13 / 400 | **14 / 500** |
| `eyebrow` | 12 / 700 / 1.2ls UPPER | **13 / 700 / 1.0ls UPPER** (use sparingly) |
| `button` | 15 / 700 / 0.5ls UPPER | **16 / 700 / 0.3ls** *(sentence case)* |

Audit every hard-coded `fontSize:` in the touched screens and remove them —
let the theme do its job.

### Color refinements

- `teal700` (primary): `#0F7B5A` → `#1F8362`. Slightly warmer/brighter primary
  reads better on warm cream background and improves contrast for outdoor use.
- `teal900` (header): keep `#063A2E`. Reserve **only** for app header chrome.
- `cream` (page bg): keep `#F5F1EA`.
- `creamHi` (raised surfaces): keep `#FAF7F1`. Promote this as the default
  card surface in the redesign — paper-on-paper instead of paper-on-cream.
- Pending/sync color: introduce `amber700 = #B45309` and `amber50 = #FEF3C7`
  to replace `Colors.red.shade400` in the pending-submissions banner.

### Card shape

Default `OhtkCard` should switch to:

```
background:  creamHi (#FAF7F1) when on cream page
border:      bottom-only 1px lineSoft (#F0EADE)
border-radius: 16
shadow:      none for resting; card-shadow only on tap/hover
padding:     16
```

The "hairline border on all four sides" treatment moves to an opt-in `outlined`
tone for inputs only.

### Motion

Add to the theme builder (or a `OhtkMotion` constants class):

```
fastIn:   120ms easeOut    // taps, chips
medIn:    180ms easeOut    // tabs, underlines
celebrate: 300ms easeOutBack // submit success, dirty-pulse
```

## Typography pickup

### Cheap path (recommended first move)

The fonts are already bundled. `pubspec.yaml` already declares `Inter`,
`NotoSansThai`, and `NotoSansLao`. The only change needed is in
`lib/theme/ohtk_style_system.dart`:

```dart
class OhtkType {
  static const family = 'Inter';
  static const fallback = <String>['NotoSansThai', 'NotoSansLao'];
  // ...rest unchanged
}
```

Then strip the inline `fontFamily: 'Roboto'` and `fontFamilyFallback:`
references across the touched screens so the theme is the single source.

For the Thai/Lao users (most of them), Flutter's fallback chain renders Thai
glyphs via NotoSansThai and Lao glyphs via NotoSansLao while Latin glyphs use
Inter. Inter's variable file is already in the repo, so there's no new asset
weight.

### Distinctive path (later, if desired)

If the team decides Inter still feels too "AI-default" (it appears on every
modern app and is explicitly flagged in design guidance), swap to a more
characterful pair. Candidates:

- **IBM Plex Sans Thai Looped** (body + UI) + **Public Sans** (Latin) — both
  libre under OFL, both look hand-set rather than corporate, and looped Thai
  reads as friendlier and more village-appropriate than Noto Sans Thai's
  slightly corporate default.
- **Anuphan** or **Sarabun** for Thai with **Manrope** or **Söhne** for Latin
  if licensing allows.

Switching is mechanical once Step 1 of the roadmap is done — it's a
`pubspec.yaml` font block + a one-line change in `OhtkType`. Don't block the
regression fix on this decision.

## What this direction is NOT

- Not maximalist — restraint is the whole point.
- Not "let's add a brand color." The shift is calm/warmth/legibility, not
  visual novelty.
- Not a rebrand. The OHTK teal stays. The tokens stay. We're sharpening, not
  replacing.
- Not a justification for new components. The
  `design_handoff_ohtk_style_system` primitives are correct — we're
  re-tuning their *defaults* and stripping inline overrides.
