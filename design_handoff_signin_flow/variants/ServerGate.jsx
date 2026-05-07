// ServerGate.jsx — first-launch screen.
// Spec: language and server are co-equal first-launch decisions. Both must
// be picked before Continue enables. No custom URL. No OHTK wordmark
// duplication — the logo image already carries the brand.

function ServerGate({ variant = 'A', selected = null, lang = 'th' }) {
  const servers = [
    { id: 'local',   name: 'Local public',     region: 'Open · Demo & training' },
    { id: 'th-moph', name: 'Thailand · MoPH',  region: 'กรมควบคุมโรค' },
    { id: 'la-moh',  name: 'Lao PDR · MoH',    region: 'ກະຊວງສາທາລະນະສຸກ' },
    { id: 'kh-cdc',  name: 'Cambodia · CDC',   region: 'មន្ទីរសុខាភិបាល' },
  ];

  const languages = [
    { id: 'th', label: 'ไทย',   sub: 'Thai' },
    { id: 'en', label: 'English', sub: 'EN' },
    { id: 'lo', label: 'ລາວ',   sub: 'Lao' },
    { id: 'km', label: 'ខ្មែរ',   sub: 'Khmer' },
  ];

  const isC = variant === 'C';
  const ready = !!(selected && lang);

  // Tokens that flip per variant — keeps the JSX terse and readable.
  const t = {
    bg: isC ? TEAL_DEEP : '#fff',
    fg: isC ? '#fff' : INK,
    sub: isC ? 'rgba(255,255,255,0.7)' : MUTED,
    accent: isC ? '#7fd4cc' : TEAL,
    cardBg: isC ? 'rgba(255,255,255,0.04)' : '#fff',
    cardBgSel: isC ? 'rgba(255,255,255,0.12)' : '#f0fbf9',
    cardBorder: isC ? 'rgba(255,255,255,0.12)' : HAIR,
    cardBorderSel: isC ? '#7fd4cc' : TEAL,
    iconBg: isC ? 'rgba(255,255,255,0.08)' : '#f0efea',
    footerBg: isC ? 'rgba(0,0,0,0.15)' : '#fafaf7',
    footerBorder: isC ? 'rgba(255,255,255,0.1)' : HAIR,
  };

  return (
    <div style={{
      width: '100%', height: '100%', background: t.bg, color: t.fg,
      fontFamily: 'Inter, "Noto Sans Thai", system-ui, sans-serif',
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
    }}>
      {/* Brand strip — logo only, centered. No wordmark text. */}
      <div style={{
        padding: '20px 20px 16px',
        display: 'flex', justifyContent: 'center',
      }}>
        <img src="assets/logo.png" alt="OHTK"
          style={{ height: 44, width: 'auto', display: 'block',
                   filter: isC ? 'none' : 'none' }} />
      </div>

      {/* Title */}
      <div style={{ padding: '4px 20px 14px', textAlign: 'center' }}>
        <div style={{ fontSize: 22, fontWeight: 700, letterSpacing: -0.3, color: t.fg, lineHeight: 1.2 }}>
          Welcome
        </div>
        <div style={{ fontSize: 13, color: t.sub, marginTop: 4 }}>
          Set up before signing in · ตั้งค่าก่อนเริ่ม
        </div>
      </div>

      {/* Two co-equal sections */}
      <div style={{ flex: 1, padding: '4px 16px', overflow: 'auto',
        display: 'flex', flexDirection: 'column', gap: 18 }}>

        {/* Language */}
        <Section t={t} icon={Icon.globe(16)} num="1" title="Language" sub="ภาษา">
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
            {languages.map((l) => {
              const sel = lang === l.id;
              return (
                <div key={l.id} style={{
                  ...rowStyle(t, sel),
                  padding: '10px 12px',
                  display: 'flex', alignItems: 'center', gap: 10,
                }}>
                  <Radio sel={sel} t={t} small />
                  <div style={{ minWidth: 0 }}>
                    <div style={{ fontSize: 14, fontWeight: 600, color: t.fg, lineHeight: 1.1 }}>{l.label}</div>
                    <div style={{ fontSize: 11, color: t.sub, marginTop: 2 }}>{l.sub}</div>
                  </div>
                </div>
              );
            })}
          </div>
        </Section>

        {/* Server */}
        <Section t={t} icon={Icon.server(16)} num="2" title="Server" sub="เซิร์ฟเวอร์">
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            {servers.map((s) => {
              const sel = selected === s.id;
              return (
                <div key={s.id} style={{
                  ...rowStyle(t, sel),
                  display: 'flex', alignItems: 'center', gap: 12,
                  padding: '12px 14px',
                }}>
                  <Radio sel={sel} t={t} />
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontSize: 14, fontWeight: 600, color: t.fg }}>{s.name}</div>
                    <div style={{ fontSize: 12, color: t.sub, marginTop: 2,
                      whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                      {s.region}
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </Section>
      </div>

      {/* Continue */}
      <div style={{ padding: '14px 20px 18px',
        borderTop: `1px solid ${t.footerBorder}`, background: t.footerBg }}>
        <button disabled={!ready} style={{
          width: '100%',
          background: ready ? (isC ? '#fff' : TEAL) : (isC ? 'rgba(255,255,255,0.15)' : '#e4e2dc'),
          color: ready ? (isC ? TEAL_DEEP : '#fff') : (isC ? 'rgba(255,255,255,0.4)' : '#a8aca7'),
          border: 'none', borderRadius: 12, padding: '15px',
          fontSize: 15, fontWeight: 700, fontFamily: 'inherit',
          cursor: ready ? 'pointer' : 'not-allowed',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
        }}>
          Continue
          {ready && <span style={{ display: 'inline-flex' }}>{Icon.arrowRight(16)}</span>}
        </button>
      </div>
    </div>
  );
}

// Numbered section header with title in two scripts.
function Section({ t, icon, num, title, sub, children }) {
  return (
    <div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 10, padding: '0 4px' }}>
        <div style={{
          width: 22, height: 22, borderRadius: 11,
          background: t.accent, color: t.bg,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          fontSize: 12, fontWeight: 700, flexShrink: 0,
        }}>{num}</div>
        <div style={{ fontSize: 15, fontWeight: 700, color: t.fg }}>{title}</div>
        <div style={{ fontSize: 12, color: t.sub }}>· {sub}</div>
      </div>
      {children}
    </div>
  );
}

function rowStyle(t, sel) {
  return {
    background: sel ? t.cardBgSel : t.cardBg,
    border: `1.5px solid ${sel ? t.cardBorderSel : t.cardBorder}`,
    borderRadius: 12,
  };
}

function Radio({ sel, t, small = false }) {
  const sz = small ? 18 : 20;
  return (
    <div style={{
      width: sz, height: sz, borderRadius: sz / 2,
      border: sel ? `${small ? 5 : 6}px solid ${t.cardBorderSel}`
                  : `1.5px solid ${t.isC ? 'rgba(255,255,255,0.3)' : HAIR}`,
      background: sel ? '#fff' : 'transparent',
      flexShrink: 0,
    }} />
  );
}

window.ServerGate = ServerGate;
