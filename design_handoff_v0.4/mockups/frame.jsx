// frame.jsx — chrome shared by mobile + desktop screens

function MobileFrame({ children, scrollable = false }) {
  return (
    <div style={{
      width: '100%', height: '100%',
      background: CT.bg, color: CT.text,
      fontFamily: CT.fontUi,
      display: 'flex', flexDirection: 'column',
      overflow: scrollable ? 'auto' : 'hidden',
      position: 'relative',
    }}>{children}</div>
  );
}

function MobileTopBar({ title, left, right, sub }) {
  return (
    <div style={{
      padding: '12px 16px 10px',
      borderBottom: `1px solid ${CT.borderSoft}`,
      display: 'flex', flexDirection: 'column', gap: 2,
      flexShrink: 0,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, minWidth: 0 }}>
          {left}
          <div style={{ fontSize: 22, fontWeight: 700, letterSpacing: -0.3, lineHeight: 1.1 }}>{title}</div>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>{right}</div>
      </div>
      {sub && <div style={{ fontFamily: CT.fontMono, fontSize: 10, color: CT.textSecondary, letterSpacing: 1, textTransform: 'uppercase' }}>{sub}</div>}
    </div>
  );
}

function MobileTabBar({ active = 'Library' }) {
  const tabs = [
    { k: 'Library',  g: '▦' },
    { k: 'Compose',  g: '+' },
    { k: 'History',  g: '◷' },
    { k: 'Settings', g: '⚙' },
  ];
  return (
    <div style={{
      flexShrink: 0,
      borderTop: `1px solid ${CT.border}`,
      background: '#0B0B0B',
      display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)',
      padding: '8px 4px 14px',
    }}>
      {tabs.map(t => {
        const on = t.k === active;
        return (
          <div key={t.k} style={{
            display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4,
            color: on ? CT.text : CT.textSecondary,
            padding: '6px 4px',
          }}>
            <span style={{ fontFamily: CT.fontMono, fontSize: 18, fontWeight: 700, color: on ? CT.red : CT.textSecondary }}>{t.g}</span>
            <span style={{ fontSize: 10, fontWeight: 600, letterSpacing: 0.6, textTransform: 'uppercase' }}>{t.k}</span>
          </div>
        );
      })}
    </div>
  );
}

// Desktop window chrome — title bar w/ sidebar nav + content area
function DesktopFrame({ title, active, sub, children }) {
  const navItems = [
    { k: 'Library' },
    { k: 'Compose' },
    { k: 'My Workouts' },
    { k: 'History' },
    { k: 'Settings' },
  ];
  return (
    <div style={{
      width: '100%', height: '100%',
      background: CT.bg, color: CT.text,
      fontFamily: CT.fontUi,
      display: 'grid', gridTemplateColumns: '220px 1fr',
      overflow: 'hidden',
    }}>
      {/* Sidebar */}
      <div style={{
        background: '#0A0A0A', borderRight: `1px solid ${CT.border}`,
        display: 'flex', flexDirection: 'column',
      }}>
        <div style={{ padding: '20px 18px 18px', borderBottom: `1px solid ${CT.borderSoft}` }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <div style={{ width: 24, height: 24, background: CT.red, borderRadius: 4, display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: CT.fontMono, fontWeight: 800, color: '#0F0F0F', fontSize: 14 }}>C</div>
            <div style={{ fontWeight: 700, letterSpacing: -0.3, fontSize: 15 }}>CostruTrain</div>
          </div>
          <div style={{ fontFamily: CT.fontMono, fontSize: 9, color: CT.textDisabled, marginTop: 8, letterSpacing: 1.2, textTransform: 'uppercase' }}>v0.4 · offline</div>
        </div>
        <div style={{ padding: '12px 8px', display: 'flex', flexDirection: 'column', gap: 2 }}>
          {navItems.map(n => {
            const on = n.k === active;
            return (
              <div key={n.k} style={{
                padding: '9px 12px', borderRadius: 6,
                background: on ? '#1F1F1F' : 'transparent',
                color: on ? CT.text : CT.textSecondary,
                display: 'flex', alignItems: 'center', gap: 10,
                fontSize: 13, fontWeight: on ? 600 : 500,
                borderLeft: on ? `2px solid ${CT.red}` : '2px solid transparent',
              }}>
                {n.k}
              </div>
            );
          })}
        </div>
        <div style={{ marginTop: 'auto', padding: 14, borderTop: `1px solid ${CT.borderSoft}` }}>
          <MetaLabel>Today</MetaLabel>
          <div style={{ marginTop: 8, fontFamily: CT.fontMono, fontSize: 22, fontWeight: 700, color: CT.text, letterSpacing: -0.5 }}>7:42</div>
          <div style={{ fontSize: 11, color: CT.textSecondary, marginTop: 2 }}>Last session · Fran</div>
        </div>
      </div>
      {/* Main */}
      <div style={{ display: 'flex', flexDirection: 'column', minWidth: 0 }}>
        <div style={{ padding: '16px 28px 14px', borderBottom: `1px solid ${CT.borderSoft}`, display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div>
            <div style={{ fontSize: 22, fontWeight: 700, letterSpacing: -0.4 }}>{title}</div>
            {sub && <div style={{ fontFamily: CT.fontMono, fontSize: 10, color: CT.textSecondary, marginTop: 4, letterSpacing: 1.2, textTransform: 'uppercase' }}>{sub}</div>}
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <Chip mono>⌘ K · Search</Chip>
            <div style={{ width: 30, height: 30, borderRadius: 999, background: '#222', display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: CT.fontMono, fontWeight: 700, fontSize: 12 }}>D</div>
          </div>
        </div>
        <div style={{ flex: 1, minHeight: 0, overflow: 'hidden' }}>{children}</div>
      </div>
    </div>
  );
}

function IconBtn({ glyph, badge, active }) {
  return (
    <div style={{
      width: 34, height: 34, borderRadius: 6,
      background: active ? '#1F1F1F' : 'transparent',
      border: `1px solid ${active ? CT.border : 'transparent'}`,
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
      position: 'relative',
    }}>
      <span style={{ fontFamily: CT.fontMono, fontSize: 16, color: CT.text, fontWeight: 700 }}>{glyph}</span>
      {badge != null && (
        <span style={{ position: 'absolute', top: 2, right: 2, minWidth: 14, height: 14, padding: '0 4px', borderRadius: 999, background: CT.red, color: '#0F0F0F', fontFamily: CT.fontMono, fontSize: 9, fontWeight: 800, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>{badge}</span>
      )}
    </div>
  );
}

Object.assign(window, { MobileFrame, MobileTopBar, MobileTabBar, DesktopFrame, IconBtn });
