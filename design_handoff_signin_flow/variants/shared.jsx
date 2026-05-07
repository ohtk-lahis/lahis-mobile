// shared.jsx — small UI primitives + brand mark used across all 3 variants.
// We deliberately do NOT recreate the One Health Toolkit branded logo —
// instead we render a neutral "OHT" wordmark placeholder so the variants
// communicate brand placement without copying the protected mark.

const TEAL = '#0F8A82';
const TEAL_DARK = '#0a5f5a';
const TEAL_DEEP = '#08423f';
const SAND = '#f7f5f1';
const INK = '#1a1f1d';
const MUTED = '#6b7370';
const HAIR = '#e4e2dc';

// OHTK brand mark — uses the supplied logo glyph + wordmark.
function BrandMark({ size = 36, color = '#fff', label = true, tagline = false }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 10, color }}>
      <img src="assets/logo.png" alt="OHTK"
        style={{ height: size, width: 'auto', display: 'block' }} />
      {label && (
        <div style={{ lineHeight: 1, fontFamily: 'Inter, system-ui, sans-serif' }}>
          <div style={{ fontSize: Math.round(size * 0.48), fontWeight: 800, letterSpacing: 1.5, color }}>OHTK</div>
          {tagline && (
            <div style={{ fontSize: Math.round(size * 0.26), fontWeight: 500, letterSpacing: 2, color, opacity: 0.75, marginTop: 3 }}>
              ONE HEALTH TOOLKIT
            </div>
          )}
        </div>
      )}
    </div>
  );
}

// Minimal inline icons — stroke-based, currentColor.
const Icon = {
  globe: (s = 18) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="9" />
      <path d="M3 12h18M12 3a14 14 0 010 18M12 3a14 14 0 000 18" />
    </svg>
  ),
  qr: (s = 22) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round">
      <rect x="3" y="3" width="7" height="7" rx="1" />
      <rect x="14" y="3" width="7" height="7" rx="1" />
      <rect x="3" y="14" width="7" height="7" rx="1" />
      <path d="M14 14h3v3M21 14v3M14 21h3M17 17v4M21 17v4" />
    </svg>
  ),
  user: (s = 22) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="8" r="4" />
      <path d="M4 21c0-4 4-7 8-7s8 3 8 7" />
    </svg>
  ),
  lock: (s = 18) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
      <rect x="4" y="11" width="16" height="10" rx="2" />
      <path d="M8 11V7a4 4 0 018 0v4" />
    </svg>
  ),
  eye: (s = 18) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
      <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z" />
      <circle cx="12" cy="12" r="3" />
    </svg>
  ),
  add: (s = 22) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
      <path d="M12 5v14M5 12h14" />
    </svg>
  ),
  chevron: (s = 18) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
      <path d="M6 9l6 6 6-6" />
    </svg>
  ),
  arrowRight: (s = 18) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <path d="M5 12h14M13 5l7 7-7 7" />
    </svg>
  ),
  server: (s = 18) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
      <rect x="3" y="4" width="18" height="6" rx="1.5" />
      <rect x="3" y="14" width="18" height="6" rx="1.5" />
      <path d="M7 7h.01M7 17h.01" />
    </svg>
  ),
  shield: (s = 18) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
      <path d="M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6l8-3z" />
    </svg>
  ),
  help: (s = 18) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="9" />
      <path d="M9.5 9.5a2.5 2.5 0 015 0c0 1.5-2.5 2-2.5 4M12 17.5h.01" />
    </svg>
  ),
};

// Mini "QR pattern" — decorative; not a real scannable code.
function FakeQR({ size = 120, color = INK }) {
  // Deterministic pseudo-random pattern
  const cells = 12;
  const px = size / cells;
  const pattern = [];
  // Reproducible seed based on index
  for (let r = 0; r < cells; r++) {
    for (let c = 0; c < cells; c++) {
      const v = (r * 7 + c * 13 + r * c * 3) % 5;
      if (v < 2) pattern.push([r, c]);
    }
  }
  // Position squares (corners)
  const Pos = ({ r, c }) => (
    <g>
      <rect x={c * px} y={r * px} width={px * 3} height={px * 3} fill={color} />
      <rect x={c * px + px * 0.5} y={r * px + px * 0.5} width={px * 2} height={px * 2} fill="#fff" />
      <rect x={c * px + px} y={r * px + px} width={px} height={px} fill={color} />
    </g>
  );
  return (
    <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}>
      <rect width={size} height={size} fill="#fff" />
      {pattern.map(([r, c], i) => {
        // Skip cells inside the position-square zones
        if ((r < 4 && c < 4) || (r < 4 && c > cells - 5) || (r > cells - 5 && c < 4)) return null;
        return <rect key={i} x={c * px} y={r * px} width={px} height={px} fill={color} />;
      })}
      <Pos r={0} c={0} />
      <Pos r={0} c={cells - 3} />
      <Pos r={cells - 3} c={0} />
    </svg>
  );
}

Object.assign(window, {
  TEAL, TEAL_DARK, TEAL_DEEP, SAND, INK, MUTED, HAIR,
  BrandMark, Icon, FakeQR,
});
