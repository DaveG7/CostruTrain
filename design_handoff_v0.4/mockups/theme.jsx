// theme.jsx — CostruTrain shared tokens
// Dark-first; all numeric values reusable across screens.

const CT = {
  // Backgrounds
  bg: '#0F0F0F',
  surface: '#1A1A1A',
  elevated: '#242424',
  elevatedHi: '#2E2E2E',

  // Borders / dividers
  border: '#2E2E2E',
  borderSoft: '#222',

  // Text
  text: '#F0F0F0',
  textSecondary: '#9E9E9E',
  textDisabled: '#555555',

  // Accents
  red: '#E84040',
  redDim: '#7A1A1A',
  amber: '#F5A623',
  amberDim: '#7A4F00',
  green: '#4CAF50',
  greenDim: '#1F4D22',
  blue: '#3D8BFF',

  // Typography
  fontUi: '"Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", system-ui, sans-serif',
  fontMono: '"JetBrains Mono", "Roboto Mono", ui-monospace, "SF Mono", Menlo, monospace',

  // Shape
  radiusCard: 8,
  radiusChip: 4,
  radiusPill: 24,
};

// ── Generic primitives ──────────────────────────────────────
function Chip({ children, color, bg, border, mono = false, style = {}, ...rest }) {
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 4,
      padding: '3px 8px', borderRadius: CT.radiusChip,
      fontSize: 10, fontWeight: 600, letterSpacing: 0.6,
      textTransform: 'uppercase',
      fontFamily: mono ? CT.fontMono : CT.fontUi,
      color: color || CT.textSecondary,
      background: bg || 'transparent',
      border: border ? `1px solid ${border}` : `1px solid ${CT.border}`,
      lineHeight: 1.2,
      ...style,
    }} {...rest}>{children}</span>
  );
}

function PhaseBadge({ phase }) {
  const map = {
    WORK:    { fg: CT.red,   bg: 'rgba(232,64,64,0.12)',   br: 'rgba(232,64,64,0.4)' },
    REST:    { fg: CT.amber, bg: 'rgba(245,166,35,0.12)',  br: 'rgba(245,166,35,0.4)' },
    'GET READY': { fg: CT.green, bg: 'rgba(76,175,80,0.12)', br: 'rgba(76,175,80,0.4)' },
    WARMUP:  { fg: CT.textSecondary, bg: 'rgba(158,158,158,0.08)', br: '#3a3a3a' },
    DONE:    { fg: CT.green, bg: 'rgba(76,175,80,0.12)', br: 'rgba(76,175,80,0.4)' },
  };
  const s = map[phase] || map.WORK;
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 6,
      padding: '4px 10px', borderRadius: 3,
      fontFamily: CT.fontMono,
      fontSize: 11, fontWeight: 700, letterSpacing: 1.2,
      color: s.fg, background: s.bg, border: `1px solid ${s.br}`,
      lineHeight: 1,
    }}>
      <span style={{ width: 6, height: 6, borderRadius: 999, background: s.fg }} />
      {phase}
    </span>
  );
}

// Tiny single-glyph placeholder in upcase mono — used for icons we'd otherwise SVG.
function Glyph({ char, size = 18, color = CT.textSecondary }) {
  return (
    <span style={{
      fontFamily: CT.fontMono, fontSize: size, fontWeight: 700,
      color, lineHeight: 1, display: 'inline-block', width: size, textAlign: 'center',
    }}>{char}</span>
  );
}

// Section / page header label (uppercase tracking)
function MetaLabel({ children, color, style = {} }) {
  return (
    <div style={{
      fontFamily: CT.fontMono, fontSize: 10, fontWeight: 600,
      letterSpacing: 1.4, textTransform: 'uppercase',
      color: color || CT.textSecondary, ...style,
    }}>{children}</div>
  );
}

Object.assign(window, { CT, Chip, PhaseBadge, Glyph, MetaLabel });
