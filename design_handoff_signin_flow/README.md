# Handoff: OHTK Sign-in & First-launch flow

## Overview
Redesign of the OHTK (One Health Toolkit) Android app's first-launch and sign-in experience. OHTK is a disease-surveillance reporting app for borderland village volunteers ("reporters"). Most users register once after training, then rarely re-authenticate; QR sign-in is the realistic recovery path because volunteers typically don't use email and password reset is unreliable.

## About the Design Files
The HTML files in this bundle are **design references** — React prototypes rendered in HTML to show intended look, hierarchy, and behavior. They are NOT production code to copy directly. Recreate these designs in the OHTK codebase's existing environment (the live app appears to be React Native / Material 3 Android based on the source screenshot), using its established components, theming, and i18n patterns. If no environment is settled, pick the framework already used by the rest of OHTK.

## Fidelity
**High-fidelity.** Final colors, typography scale, spacing, copy, and interaction states are decided. Recreate pixel-faithfully using the app's existing component library — match values, not the raw markup.

## Screens / Views

### 1 · First-launch gate (3 states)
**Purpose:** On first install, force the user to set Language and Server before any other action becomes available. Both are co-equal decisions.

**Layout (top→bottom, single column, 360 × ~720 dp):**
- **Hero band** — full-width teal background `#08423f`. Centered OHTK logo image only, height ≈ 44 dp, with 20 dp top/16 dp bottom padding. No wordmark text below the logo (the logo image already contains it).
- **Title block** — centered, 4 dp top / 14 dp bottom padding, 20 dp horizontal.
  - "Welcome" — 22 / 700 / -0.3 letterspacing / `#fff`
  - "Set up before signing in · ตั้งค่าก่อนเริ่ม" — 13 / 400 / `rgba(255,255,255,0.7)` / 4 dp gap above
- **Section 1 · Language** — numbered teal badge (22 dp circle, accent `#7fd4cc` on dark, dark fg) labelled "1", followed by "Language · ภาษา" header. 2-column grid (8 dp gap) of 4 language cards: ไทย / English / ລາວ / ខ្មែរ. Each card is 1.5 dp border, 12 dp radius, 10×12 padding, with a small radio (18 dp) on the left and label + romanization stacked on the right.
- **Section 2 · Server** — same numbered-header pattern, vertical list (8 dp gap) of 4 server cards: Local public, Thailand · MoPH, Lao PDR · MoH, Cambodia · CDC. 1.5 dp border, 12 dp radius, 12×14 padding. Each row: 20 dp radio + name (14/600) + region (12/400 muted, ellipsized).
- **Footer** — 14×20×18 dp padding, 1 dp top border `rgba(255,255,255,0.1)`, background `rgba(0,0,0,0.15)`. Full-width Continue button: 12 dp radius, 15 dp padding, 15/700 text. **Disabled** until both language and server are picked. When ready, button becomes white with `#08423f` text, plus right-arrow icon.

**Three states to implement:**
1. Locked — neither picked, Continue disabled.
2. Language picked — Continue still disabled.
3. Both picked — Continue enabled.

**Selection styling:**
- Unselected card: bg `rgba(255,255,255,0.04)`, border `rgba(255,255,255,0.12)`.
- Selected card: bg `rgba(255,255,255,0.12)`, border `#7fd4cc` (1.5 dp).
- Radio when selected: 5–6 dp solid ring `#7fd4cc`, white center.

**Removed from previous design:**
- "Custom server URL" — do not include.
- "OHTK" wordmark text below logo — do not include (logo carries it).

### 2 · Sign-in entry (post-gate)
**Purpose:** Returning user lands here. Register is the most common arrival action (most users come once, after training); QR Sign In is the real recovery path; password sign-in is third.

**Layout (full-bleed teal hero + bottom sheet):**
- **Hero** — radial gradient `radial-gradient(circle at 80% 0%, #0F8A82 0%, #0a5f5a 40%, #08423f 100%)`. Padding 20×24×36. White-on-teal.
  - **Top row:** language pill on the right only (no top-left brand). Pill: `rgba(255,255,255,0.15)` bg, `rgba(255,255,255,0.2)` border, 100 dp radius, 6×12 padding, globe icon + "ไทย".
  - **Decorative connected-dots SVG** at top, opacity 0.15, network/community metaphor.
  - **Logo** centered, 110 dp tall, 28 dp top margin from row.
  - **Primary CTA — "Register as reporter ›"** — 28 dp top margin. White button, `#08423f` text, 14 dp radius, 16×18 padding, 16/700, shadow `0 6px 24px rgba(0,0,0,0.18)`.
- **Returning-user sheet** — `#f7f5f1` background, top radius 20 dp, overlaps hero by -16 dp, padding 20×20×12, shadow `0 -8px 24px rgba(0,0,0,0.06)`, internal gap 14 dp.
  - **Drag handle** — 40×4 dp pill, `#e4e2dc`, top-centered.
  - **Section label:** "RETURNING REPORTER" — 11/700/1.5 spacing, muted `#6b7370`, uppercase.
  - **Username field** — 1.5 dp `#e4e2dc` border, white bg, 12 dp radius, 12×14 padding, user icon + "Username · ชื่อผู้ใช้" placeholder (14/`#a8aca7`).
  - **Password field** — same, lock icon + "Password" placeholder + eye toggle on right.
  - **"Sign in" button** — solid `#0F8A82`, white, 12 dp radius, 14 dp padding, 15/700.
  - **"QRCode Sign In" button** — full-width white card, 1.5 dp `#e4e2dc` border, 12 dp radius, 12 dp padding, QR icon (teal) + label, 13/600 `#1a1f1d`. (Label is exactly **"QRCode Sign In"** — not "QR from coordinator".)
  - **Footer row** — 1 dp top border, 12 dp top padding. Left: "Server: **Local public**" (11/muted with bold value). Right: "Change ›" link in `#0F8A82` 600.

**Removed from current production:**
- "Forgot Password" link — do not show on this surface. Reveal it only AFTER a failed sign-in attempt (out of scope for this handoff but flagged for follow-up).

## Interactions & Behavior

### Gate
- Tapping a language card sets language; tapping a server card sets server; both single-select within their group.
- Continue button:
  - Disabled state: bg `rgba(255,255,255,0.15)`, fg `rgba(255,255,255,0.4)`, cursor `not-allowed`, no arrow icon.
  - Enabled: white bg, deep-teal fg, right-arrow icon shown, full press feedback.
- Tapping any element other than language card, server card, or the language switcher must be a no-op until Continue is enabled.
- Persist both choices (`language`, `serverId`) on Continue and never show the gate again unless the user clears them from Settings.

### Sign-in
- Register CTA → push the registration flow (out of scope here).
- Sign in button → submit credentials; on failure, surface inline error AND reveal a "Forgot password? Ask your coordinator for a QR code" affordance.
- QRCode Sign In → open camera scanner.
- "Change" in footer → bottom-sheet to re-pick server (same list as gate, minus required-state).
- Language pill (top-right) → bottom-sheet to re-pick language.

## State Management

```
firstLaunchGate: {
  language: 'th' | 'en' | 'lo' | 'km' | null
  serverId: 'local' | 'th-moph' | 'la-moh' | 'kh-cdc' | null
  continueEnabled: language && serverId
}

signInScreen: {
  username: string
  password: string
  passwordVisible: boolean
  submitting: boolean
  lastError: 'invalid' | 'network' | null   // surfaces forgot-password help
}
```

Both `language` and `serverId` persist to device storage and are read on every app launch — gate is shown only when either is null.

## Design Tokens

### Colors
| Token | Value | Use |
|---|---|---|
| `teal/500` | `#0F8A82` | Primary action, accents on light surfaces |
| `teal/700` | `#0a5f5a` | Mid-hero gradient stop |
| `teal/900` | `#08423f` | Deep hero, text on white-button |
| `teal/200` | `#7fd4cc` | Accent on dark surfaces, selection rings |
| `sand/50` | `#f7f5f1` | Sheet background |
| `ink/900` | `#1a1f1d` | Body text on light |
| `muted/500` | `#6b7370` | Secondary text |
| `hair` | `#e4e2dc` | 1.5 dp borders, dividers |
| Disabled bg (light) | `#e4e2dc` | Continue when disabled on light |
| Disabled fg (light) | `#a8aca7` | |

### Typography
- Family: **Inter** for Latin, **Noto Sans Thai** for Thai (fall back to system Thai/Lao/Khmer fonts already in the app).
- Weights used: 400 / 500 / 600 / 700 / 800.
- Sizes (dp): 11 (eyebrow / micro), 12 (caption), 13 (secondary), 14 (body), 15 (button / row title), 16 (primary CTA), 22 (gate title), 30 (hero title — unused after copy trim, keep for future).
- Letter-spacing: -0.3 to -0.4 on titles; +1.5 to +2.5 on uppercase eyebrows.

### Spacing scale
4 / 8 / 10 / 12 / 14 / 16 / 18 / 20 / 24 / 28 / 32 / 36 dp.

### Radii
6 / 11 / 12 / 14 / 18 / 20 / 100 (pill).

### Shadows
- Sheet lift: `0 -8px 24px rgba(0,0,0,0.06)`
- Primary CTA: `0 6px 24px rgba(0,0,0,0.18)`
- Card lift (light surfaces): `0 1px 3px rgba(0,0,0,0.08), 0 4px 16px rgba(0,0,0,0.06)`

## Assets
- `assets/logo.png` — OHTK logo. Provided by client; the image already contains the "ONE HEALTH TOOLKIT" wordmark, so do **not** render an additional "OHTK" text label next to or below it.
- All other iconography is inline SVG — re-implement using the app's existing icon library (Material Symbols on Android is the natural choice). Icons used: globe, qr_code_scanner, person, lock, visibility, add, chevron_down, arrow_forward, dns/server, shield, help.

## Internationalization
- All user-facing strings must be keyed for translation (Thai default, English, Lao, Khmer required).
- Bilingual subtitle pattern in copy (e.g. "Welcome / ตั้งค่าก่อนเริ่ม") is part of the design — preserve it where shown, but route both halves through i18n keys, not hard-coded.
- The romanized labels next to each language ("EN", "Lao", "Khmer", "Thai") are intentional — they're the universal fallback for users who can't read their own script reliably. Keep them.

## Files in this bundle
- `Sign-in redesign.html` — entry point, mounts the design canvas.
- `variants/shared.jsx` — color tokens, BrandMark, icon set.
- `variants/VariantC.jsx` — sign-in screen.
- `variants/ServerGate.jsx` — first-launch gate.
- `assets/logo.png` — OHTK logo asset (use this verbatim).
- `design-canvas.jsx` — Figma-style canvas wrapper used purely for presenting the artboards. Do not port.

## Out of scope (next iterations)
- Registration flow itself.
- Failed-login error state + revealed Forgot-password affordance.
- Settings → Change server / language re-pickers.
- QR scanner screen.
