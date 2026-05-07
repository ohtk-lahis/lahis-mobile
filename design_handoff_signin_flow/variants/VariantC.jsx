// VariantC.jsx — "Branded full-bleed with action sheet"
// Full-bleed teal hero with the brand reading as warm/community.
// Register is a primary CTA on the hero. A bottom "card" sheet contains
// the secondary returning-user actions. Forgot-password is intentionally
// absent — surfaced only after a failed login attempt.

function VariantC() {
  return (
    <div style={{
      width: '100%', height: '100%',
      fontFamily: 'Inter, "Noto Sans Thai", "Noto Sans Lao", system-ui, sans-serif',
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
      background: TEAL_DEEP, color: INK,
    }}>
      {/* Hero — full-bleed gradient with subtle organic shapes */}
      <div style={{
        position: 'relative',
        background: `radial-gradient(circle at 80% 0%, ${TEAL} 0%, ${TEAL_DARK} 40%, ${TEAL_DEEP} 100%)`,
        padding: '20px 24px 36px', color: '#fff',
        flex: '0 0 auto',
      }}>
        {/* Decorative dots — community/network metaphor */}
        <svg width="100%" height="60" viewBox="0 0 360 60" style={{ position: 'absolute', top: 60, left: 0, opacity: 0.15 }}>
          <circle cx="40" cy="20" r="3" fill="#fff" />
          <circle cx="100" cy="40" r="2" fill="#fff" />
          <circle cx="180" cy="15" r="2.5" fill="#fff" />
          <circle cx="260" cy="35" r="3" fill="#fff" />
          <circle cx="320" cy="20" r="2" fill="#fff" />
          <line x1="40" y1="20" x2="100" y2="40" stroke="#fff" strokeWidth="0.5" />
          <line x1="100" y1="40" x2="180" y2="15" stroke="#fff" strokeWidth="0.5" />
          <line x1="180" y1="15" x2="260" y2="35" stroke="#fff" strokeWidth="0.5" />
          <line x1="260" y1="35" x2="320" y2="20" stroke="#fff" strokeWidth="0.5" />
        </svg>

        <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
          <button style={{
            display: 'flex', alignItems: 'center', gap: 6,
            background: 'rgba(255,255,255,0.15)',
            border: '1px solid rgba(255,255,255,0.2)',
            borderRadius: 100, padding: '6px 12px',
            color: '#fff', fontSize: 13, fontWeight: 600,
            fontFamily: 'inherit', cursor: 'pointer',
          }}>
            <span style={{ display: 'inline-flex' }}>{Icon.globe(14)}</span>
            ไทย
          </button>
        </div>

        <div style={{ marginTop: 28, display: 'flex', justifyContent: 'center' }}>
          <img src="assets/logo.png" alt="OHTK · One Health Toolkit"
            style={{ height: 110, width: 'auto', display: 'block' }} />
        </div>

        {/* Primary register CTA on the hero */}
        <button style={{
          marginTop: 28, width: '100%',
          background: '#fff', color: TEAL_DEEP,
          border: 'none', borderRadius: 14,
          padding: '16px 18px', fontFamily: 'inherit', cursor: 'pointer',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
          fontSize: 16, fontWeight: 700,
          boxShadow: '0 6px 24px rgba(0,0,0,0.18)',
        }}>
          Register as reporter
          <span style={{ display: 'inline-flex' }}>{Icon.arrowRight(18)}</span>
        </button>
      </div>

      {/* Returning-user sheet */}
      <div style={{
        background: SAND, borderRadius: '20px 20px 0 0',
        marginTop: -16, padding: '20px 20px 12px',
        flex: 1, display: 'flex', flexDirection: 'column', gap: 14,
        boxShadow: '0 -8px 24px rgba(0,0,0,0.06)',
      }}>
        {/* drag handle */}
        <div style={{
          width: 40, height: 4, borderRadius: 2, background: HAIR,
          margin: '0 auto 4px',
        }} />

        <div style={{
          fontSize: 11, fontWeight: 700, letterSpacing: 1.5,
          color: MUTED, textTransform: 'uppercase',
        }}>
          Returning reporter
        </div>

        {/* Username field, compact */}
        <div>
          <div style={{
            display: 'flex', alignItems: 'center', gap: 10,
            border: `1.5px solid ${HAIR}`, background: '#fff',
            borderRadius: 12, padding: '12px 14px',
          }}>
            <span style={{ display: 'inline-flex', color: MUTED }}>{Icon.user(18)}</span>
            <span style={{ fontSize: 14, color: '#a8aca7', flex: 1 }}>
              Username · ชื่อผู้ใช้
            </span>
          </div>
          <div style={{
            display: 'flex', alignItems: 'center', gap: 10,
            border: `1.5px solid ${HAIR}`, background: '#fff',
            borderRadius: 12, padding: '12px 14px', marginTop: 10,
          }}>
            <span style={{ display: 'inline-flex', color: MUTED }}>{Icon.lock(18)}</span>
            <span style={{ fontSize: 14, color: '#a8aca7', flex: 1 }}>
              Password
            </span>
            <span style={{ display: 'inline-flex', color: MUTED }}>{Icon.eye(18)}</span>
          </div>
        </div>

        <button style={{
          width: '100%', background: TEAL, border: 'none',
          borderRadius: 12, padding: '14px',
          color: '#fff', fontSize: 15, fontWeight: 700,
          fontFamily: 'inherit', cursor: 'pointer',
        }}>
          Sign in
        </button>

        {/* QR + server line */}
        <div style={{ display: 'flex', gap: 10 }}>
          <button style={{
            flex: 1, background: '#fff', border: `1.5px solid ${HAIR}`,
            borderRadius: 12, padding: '12px',
            fontFamily: 'inherit', cursor: 'pointer',
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
            fontSize: 13, fontWeight: 600, color: INK,
          }}>
            <span style={{ display: 'inline-flex', color: TEAL }}>{Icon.qr(18)}</span>
            QRCode Sign In
          </button>
        </div>

        <div style={{
          marginTop: 'auto', paddingTop: 8,
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
          fontSize: 11, color: MUTED, borderTop: `1px solid ${HAIR}`, paddingBlock: '12px 0',
        }}>
          <span>Server: <span style={{ color: INK, fontWeight: 600 }}>Local public</span></span>
          <span style={{ color: TEAL, fontWeight: 600 }}>Change ›</span>
        </div>
      </div>
    </div>
  );
}

window.VariantC = VariantC;
