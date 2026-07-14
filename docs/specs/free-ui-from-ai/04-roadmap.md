# 04 — Roadmap: sequencing the rework

The goal is to land the proposed direction *incrementally* — without a wholesale
rewrite of every screen at once. Each step below is sized to land as its own
PR, and each one delivers visible value on its own.

## Step 1 — Fix the font regression (one-line change)

The team already ships `Inter-Variable.ttf` + `NotoSansThai` + `NotoSansLao`
in `assets/fonts/` and declares them in `pubspec.yaml`. The codex theme
ignored all of that and set `OhtkType.family = 'Roboto'` (which isn't
bundled). Restore the wired-up fonts:

```dart
// lib/theme/ohtk_style_system.dart
class OhtkType {
  static const family = 'Inter';
  static const fallback = <String>['NotoSansThai', 'NotoSansLao'];
  // ...
}
```

That's the entire change for Step 1. Step 2 handles the inline-font cleanup
across screens.

Open question to settle in a follow-up (does **not** block this step):
whether to escape Inter for something more distinctive. See `02-direction.md`
§Typography pickup → Distinctive path for candidate pairings. The decision
can be made anytime after Step 1 lands — switching is a `pubspec.yaml` font
block + a one-line `OhtkType` change.

This is the **single biggest unlock**. The difference between "any Material
app" and "the OHTK app" is felt in 200ms when the screen first renders.

## Step 2 — Type ramp + inline-font cleanup

- Increase every size token in `OhtkType` by one notch (see table in
  `02-direction.md`).
- Sweep the touched files and **delete** every hard-coded `fontFamily:`,
  `fontFamilyFallback:`, and `fontSize:` that the theme now covers. Files to
  audit:
  - `lib/components/form_chrome.dart`
  - `lib/ui/home/home_view.dart`
  - `lib/ui/home/report_home_view.dart`
  - `lib/ui/home/report_list_view.dart`
  - `lib/ui/profile/profile_view.dart`
  - `lib/ui/profile/profile_widgets.dart`
  - `lib/ui/census/census_view.dart`
- Drop the `incidents_theme.dart` re-exports of `incidentsFontFamily` /
  `incidentsFontFamilyFallback`; route everything through `OhtkType` /
  `Theme.of(context).textTheme`.

After this PR, the visible feel of the app is *materially* different even
though no screens were "redesigned" yet.

## Step 3 — Strip eyebrow caps

Replace `LABEL IN CAPS` with sentence-case section headers at h3 weight, in
every place that isn't:

- "ADMIN TOOLS" (admin-only gate)
- "STEP 1 OF 3" (form chrome)

Specifically:

- `report_list_view.dart::_SectionEyebrow` → date-grouped headers.
- `census_view.dart` "UPDATING VILLAGE" → quiet h2 village name.
- `census_view.dart` "EDITED" → soft mint border pulse.
- `profile_view.dart` "CONTACT INFO" → h3 section header.
- `profile_view.dart` QR dialog eyebrow → delete.

## Step 4 — Redesign 2 hero moments

### 4a — Home FAB → pill

`report_home_view.dart:49–72`. Promote `+` icon to `+ New report` pill, 56px
tall, with halo shadow. This is the single most-used affordance in the app.

### 4b — QR dialog → minimal

`profile_view.dart:877–1027`. Strip to QR + name + Save button. See
`03-screen-redesigns.md` for the full treatment.

These two changes alone, combined with steps 1–3, visibly elevate the app
without risking a wholesale rework.

## Step 5 — Pending submissions banner

`home_view.dart:472–502`. Replace `Colors.red.shade400` slab with a warm amber
strip + offline-cloud glyph + descriptive copy. Animate in on first appearance.

## Step 6 — Role-gate admin tools, then redesign admin surfaces

The TODO at `profile_view.dart:1220–1222` is a prerequisite. The
`_AdminToolsCard` currently renders for everyone; gate behind
`user.role in (admin, author)` once the User model exposes the field, then
redesign the admin tools surface as a quietly-labeled section that doesn't
compete with villager affordances.

## Step 7 — Empty states + cross-screen treatments

- Factor `OhtkEmptyState` widget (see `03-screen-redesigns.md`).
- Hand-paint 3–4 illustrations matching the bottom-nav stroke vocabulary:
  empty reports list, empty observations, "no census configured", "loading
  failed" — distinct from each other so users can tell at a glance which
  state they're in.
- Apply the new empty state widget across `report_list_view.dart`,
  `census_view.dart`, observations.

## Step 8 — Per-screen passes against the verbal mockups

In order:

1. Reports list (highest-traffic screen).
2. Profile.
3. Census hub + form.
4. Form chrome (Back/Next sizing, exit dialog).
5. Notification list, observation list, report detail.

Each pass diffs against `03-screen-redesigns.md` and lands as its own PR.

## Step 9 — Motion pass

Once the visual layer is settled, do one focused PR for motion:

- Tab underline slide (180ms ease-out).
- Card press scale-to-0.98.
- Bottom-nav icon cross-fade (100ms).
- Dirty-state pulse (300ms `celebrate` curve).
- Submit-success micro-celebration.

Motion is the last layer — adding it earlier risks animating UI that's still
being redesigned.

---

## Out of scope for this rework

- New brand color, new logo.
- New screen flows (the IA is fine; the issues are visual/UX).
- Tablet/large-screen layouts (mobile only).
- Dark mode (deferred — villager use case is overwhelmingly daylight outdoor).
- The sign-in / first-launch flow has its own separate handoff (see auto-memory
  reference `design_system_signin_flow`). Coordinate, don't duplicate.
