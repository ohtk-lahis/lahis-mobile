# 03 — Screen redesigns (verbal mockups)

These mockups describe what the chosen direction looks like screen by screen.
They are deliberately verbal so they can be reviewed without spinning up
prototypes — and so engineering can implement against the *intent*, not a pixel
sheet.

Each section lists the source file, the keep/cut/change deltas, and the copy
direction.

---

## Home / Reports list

**Source**: `lib/ui/home/report_list_view.dart`,
`lib/ui/home/report_home_view.dart`, `lib/ui/home/home_view.dart`

- **App bar**: `teal900`, app name 20/700 *left-aligned*, bell right. Drop the
  centered title.
- **Tab strip**: change from `_TabsStrip` uppercase ("ALL REPORTS" / "MY
  REPORTS") to sentence case ("All reports" / "Mine") at 16/600 with a 3px
  animated teal underline (180ms ease-out).
- **Section labels**: drop "RECENT" / "EARLIER" eyebrows. Replace with
  **date-grouped headers**: "Today", "This week", "May 2026" at 14/600
  `ink/700`, no caps. People understand time, not "recent."
- **Card**: tighter row, bigger thumbnail (64×64 not 56×56), title at 17/600
  `ink900` (not teal — reserve teal for actions), description 14/400
  `ink/500`, timestamp tucked under title as 12/500 `ink/400` with relative
  dates ("2 hours ago" not "21/05/2026 14:32").
- **Case pill**: becomes a soft mint dot + label ("• Case taken up") inline
  with timestamp, not a separate pill row.
- **FAB**: change to **pill** "+ New report" 56px tall, label at 16/700, full
  warmth shadow. This is the most-used action — it should announce itself.
- **Empty state**: hand-painted village/clipboard scene (`CustomPainter`),
  not an outline icon in a circle. Below: "Nothing reported yet" 18/700, then
  a single sentence "When you spot something, tap the green button below."
  with an arrow pointing to the FAB.

## Profile

**Source**: `lib/ui/profile/profile_view.dart`,
`lib/ui/profile/profile_widgets.dart`

- **Identity header**: avatar at 96 (already done), name 22/700, single line
  under "Phon Saen · Ban Nong Chan" (name · village) at 14/500. Drop the
  `@username` line entirely for villagers (no one reads it; meaningful only
  to admins).
- **Consolidated card**: keep the grouped pattern but **make rows 64px tall**,
  icon left at 24px in soft mint circle (40×40, not bare), title 17/600,
  value 14/500 `ink/500` right-aligned. Chevron in `teal/600`, not muted gray
  — it's the affordance.
- **Contact info card**: drop the "CONTACT INFO" eyebrow. Use an h3 ink
  section header instead.
- **QR menu row**: this is the most important profile action for villagers.
  Promote it from a row in the menu list to a **dedicated tile at the top of
  the profile** ("Your sign-in code" with a small QR preview), tappable to
  expand.
- **Admin tools**: gate first (see the TODO at `profile_view.dart:1220`), but
  visually keep as a tiny "Admin" eyebrow with the lock icon. Only one card.
- **Sign out**: keep as last row, but in `ink/700` not `danger` red — pressing
  sign-out shouldn't feel like an alarm. The confirm dialog can use red on
  the destructive button.

## Census hub

**Source**: `lib/ui/census/census_view.dart`

- Drop "UPDATING VILLAGE" eyebrow. Replace with a quiet `Padding(top: 16)`
  showing village name as h2 ("Ban Nong Chan") and a subtle `last updated
  19/05/2026` chip beneath in sentence case.
- **Census kind cards**: replace `OhtkIconTile` mint squares with **circular**
  mint tiles, 56×56, and use hand-painted glyphs for "people" and "animals"
  instead of Material `groups_outlined` / `pets_outlined`.
- **Sticky footer**: keep but enlarge the primary button to 56px tall, label
  17/700.

## QR login dialog

**Source**: `lib/ui/profile/profile_view.dart:877–1027`

Strip to **3 elements**:

1. Large QR (260×260, white card with cream halo).
2. Name underneath at 18/600.
3. One "Save to phone" button (56px, teal, full-width).

**Drop**: eyebrow, body paragraph, shield chip, uppercase save label.

The trust message ("Keep this private") becomes a single line below the button
in 12/500 `ink/500`, with a small lock glyph — not a styled pill.

## Pending submissions banner

**Source**: `lib/ui/home/home_view.dart:472–502`

- Move from `Colors.red.shade400` slab to a **warm amber strip**
  (`warningBg` background, `warning` text) with an offline-cloud glyph.
- Copy: "2 reports waiting to send" + chevron. Tap goes to resubmit screen.
- Animate in with a 200ms slide-down on first appearance.

## Form chrome

**Source**: `lib/components/form_chrome.dart`

- **Step header** is correct in concept (bar at top, segmented progress) but
  the eyebrow caps "STEP 1 OF 3" can be lowercase "Step 1 of 3" in 13/600
  teal. Saves the caps for moments that matter.
- **Footer**: enlarge Back/Next buttons. Currently 44px — go to 56px for both.
  The "Next" button is one of the most-tapped affordances in the app.
- **Exit confirm dialog** (`showExitConfirmDialog`): the destructive button
  being a flat red bar is right; the cancel/keep button should be the
  **default** action (primary teal), not outlined. Right now both buttons
  feel equally weighted; the safer action should pull the eye.

---

## Cross-screen treatments

A few patterns deserve to be defined once and reused, rather than rebuilt per
screen:

- **Date headers**: replace every uppercase eyebrow "RECENT / EARLIER /
  YESTERDAY" with sentence-case headers ("Today / This week / May 2026") at
  14/600 `ink/700`. One helper widget.
- **"Currently editing" indicators**: replace caps "EDITED" badges
  (`census_view.dart:464`) with a soft mint pulse on the affected card border
  (300ms `celebrate` motion token from `02-direction.md`).
- **Empty states**: factor a `OhtkEmptyState` widget that takes a
  `CustomPainter`, a title, a body, and an optional action. Use hand-drawn
  illustrations matching the bottom-nav stroke vocabulary.
- **Primary buttons**: bump default minimum height from 48 to **56** for
  villager hands. The 48px target is fine for SaaS; not fine for outdoor use.
