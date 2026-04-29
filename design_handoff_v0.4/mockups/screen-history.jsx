// screen-history.jsx — Session History

function SessionRow({ s, large = false }) {
  return (
    <div style={{
      display: 'grid',
      gridTemplateColumns: large ? '60px 1fr auto auto auto' : '54px 1fr auto auto',
      gap: 12, alignItems: 'center',
      padding: large ? '14px 16px' : '12px 14px',
      background: CT.surface, border: `1px solid ${CT.border}`,
      borderRadius: 6,
    }}>
      <div style={{ fontFamily: CT.fontMono, fontSize: 11, color: CT.textSecondary, letterSpacing: 0.6, fontVariantNumeric: 'tabular-nums' }}>{s.time}</div>
      <div style={{ minWidth: 0 }}>
        <div style={{ fontSize: 13.5, fontWeight: 600, lineHeight: 1.25, display: 'flex', alignItems: 'center', gap: 8 }}>
          {s.workout}
          {s.pr && <Chip color={CT.green} border={`${CT.green}55`} bg={`${CT.green}1A`}>PR</Chip>}
        </div>
        <div style={{ fontFamily: CT.fontMono, fontSize: 10, color: CT.textSecondary, marginTop: 4, letterSpacing: 0.8, textTransform: 'uppercase' }}>
          {s.done} steps · auto-saved
        </div>
      </div>
      {large && (
        <div style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
          {Array.from({ length: 8 }).map((_, i) => (
            <div key={i} style={{
              width: 4, height: 14 + (i % 4) * 6,
              background: i < 6 ? CT.red : CT.borderSoft,
              borderRadius: 1,
            }} />
          ))}
        </div>
      )}
      <div style={{ fontFamily: CT.fontMono, fontSize: 15, fontWeight: 700, fontVariantNumeric: 'tabular-nums', color: CT.text }}>{s.dur}</div>
      <div style={{ color: CT.textDisabled, fontSize: 14 }}>›</div>
    </div>
  );
}

function HistoryMobile() {
  // Group by date (already sorted)
  const groups = {};
  HISTORY.forEach(h => { (groups[h.date] = groups[h.date] || []).push(h); });

  return (
    <MobileFrame>
      <MobileTopBar
        title="History"
        sub="6 sessions · April"
        right={<IconBtn glyph="◷" />}
      />
      <div style={{ padding: '12px 16px 0' }}>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8 }}>
          {[['THIS WEEK', '4'], ['STREAK', '3 d'], ['VOLUME', '8.4k']].map(([l, v]) => (
            <div key={l} style={{ background: CT.surface, border: `1px solid ${CT.border}`, borderRadius: 6, padding: '10px 12px' }}>
              <div style={{ fontFamily: CT.fontMono, fontSize: 9, color: CT.textSecondary, letterSpacing: 1.2 }}>{l}</div>
              <div style={{ fontFamily: CT.fontMono, fontSize: 18, fontWeight: 700, marginTop: 2 }}>{v}</div>
            </div>
          ))}
        </div>
      </div>
      <div style={{ flex: 1, overflow: 'auto', padding: '14px 16px 14px', display: 'flex', flexDirection: 'column', gap: 16 }}>
        {Object.entries(groups).map(([date, items]) => (
          <div key={date} style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            <MetaLabel>{date}</MetaLabel>
            {items.map((s, i) => <SessionRow key={i} s={s} />)}
          </div>
        ))}
      </div>
      <MobileTabBar active="History" />
    </MobileFrame>
  );
}

function HistoryDesktop() {
  const groups = {};
  HISTORY.forEach(h => { (groups[h.date] = groups[h.date] || []).push(h); });

  return (
    <DesktopFrame title="Session History" sub="6 sessions · last 30 days" active="History">
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 320px', height: '100%', minHeight: 0 }}>
        <div style={{ padding: '20px 28px', overflow: 'auto', display: 'flex', flexDirection: 'column', gap: 16 }}>
          {/* Stats strip */}
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 12 }}>
            {[['Sessions · 30d', '17'], ['Total time', '4h 28m'], ['Avg per session', '15:48'], ['Streak', '3 days']].map(([l, v]) => (
              <div key={l} style={{ background: CT.surface, border: `1px solid ${CT.border}`, borderRadius: 6, padding: '12px 14px' }}>
                <div style={{ fontFamily: CT.fontMono, fontSize: 9, color: CT.textSecondary, letterSpacing: 1.2 }}>{l}</div>
                <div style={{ fontFamily: CT.fontMono, fontSize: 22, fontWeight: 700, marginTop: 4 }}>{v}</div>
              </div>
            ))}
          </div>

          {/* Heatmap-ish month grid */}
          <div style={{ background: CT.surface, border: `1px solid ${CT.border}`, borderRadius: 6, padding: 16 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 12 }}>
              <MetaLabel>April 2026 · activity</MetaLabel>
              <span style={{ fontFamily: CT.fontMono, fontSize: 10, color: CT.textDisabled, letterSpacing: 1 }}>17 / 30 active</span>
            </div>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(30, 1fr)', gap: 4 }}>
              {Array.from({ length: 30 }).map((_, i) => {
                const intensity = [0, 0.3, 0.6, 1, 0.6, 0, 0, 0.3, 0, 0.6, 0.6, 0, 0.6, 0, 0, 0.3, 0, 0.6, 0.6, 0.6, 0, 0.6, 0, 0.3, 0.6, 0, 0.6, 0.6, 0, 1][i];
                return (
                  <div key={i} title={`Apr ${i+1}`} style={{
                    aspectRatio: '1',
                    background: intensity ? `rgba(232,64,64,${intensity})` : '#181818',
                    border: `1px solid ${CT.borderSoft}`,
                    borderRadius: 2,
                  }} />
                );
              })}
            </div>
          </div>

          {Object.entries(groups).map(([date, items]) => (
            <div key={date} style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
              <MetaLabel>{date}</MetaLabel>
              {items.map((s, i) => <SessionRow key={i} s={s} large />)}
            </div>
          ))}
        </div>

        {/* Detail */}
        <div style={{ borderLeft: `1px solid ${CT.borderSoft}`, padding: 22, overflow: 'auto', display: 'flex', flexDirection: 'column', gap: 14 }}>
          <MetaLabel>Selected session</MetaLabel>
          <div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
              <div style={{ fontSize: 22, fontWeight: 700, letterSpacing: -0.4 }}>Fran</div>
              <Chip color={CT.green} border={`${CT.green}55`} bg={`${CT.green}1A`}>PR · −0:23</Chip>
            </div>
            <div style={{ fontFamily: CT.fontMono, fontSize: 11, color: CT.textSecondary, marginTop: 4, letterSpacing: 1 }}>TODAY · 07:14</div>
          </div>
          <div style={{ background: CT.surface, border: `1px solid ${CT.border}`, borderRadius: 8, padding: '18px 18px 16px', textAlign: 'center' }}>
            <div style={{ fontFamily: CT.fontMono, fontSize: 9, color: CT.textSecondary, letterSpacing: 1.4 }}>FINAL TIME</div>
            <div style={{ fontFamily: CT.fontMono, fontSize: 56, fontWeight: 700, marginTop: 4, letterSpacing: -2, fontVariantNumeric: 'tabular-nums' }}>7:42</div>
            <div style={{ fontFamily: CT.fontMono, fontSize: 11, color: CT.green, marginTop: 6, letterSpacing: 1 }}>↓ 23s vs last attempt</div>
          </div>
          <MetaLabel>Round splits</MetaLabel>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
            {[['R1 · 21–21', '2:48'], ['R2 · 15–15', '2:34'], ['R3 · 9–9', '2:20']].map(([l, v]) => (
              <div key={l} style={{ display: 'flex', justifyContent: 'space-between', padding: '10px 12px', background: CT.surface, border: `1px solid ${CT.border}`, borderRadius: 6 }}>
                <span style={{ fontSize: 12, color: CT.textSecondary }}>{l}</span>
                <span style={{ fontFamily: CT.fontMono, fontSize: 13, fontWeight: 700, fontVariantNumeric: 'tabular-nums' }}>{v}</span>
              </div>
            ))}
          </div>
          <div style={{ marginTop: 'auto', display: 'flex', gap: 8 }}>
            <div style={{ flex: 1, padding: '10px 14px', borderRadius: 6, border: `1px solid ${CT.border}`, fontSize: 12, textAlign: 'center', color: CT.text }}>↻ Repeat</div>
            <div style={{ flex: 1, padding: '10px 14px', borderRadius: 6, background: CT.red, color: '#0F0F0F', fontWeight: 700, fontSize: 12, textAlign: 'center' }}>Compare</div>
          </div>
        </div>
      </div>
    </DesktopFrame>
  );
}

Object.assign(window, { HistoryMobile, HistoryDesktop });
