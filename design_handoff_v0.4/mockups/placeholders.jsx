// placeholders.jsx — striped SVG placeholders for exercise GIFs

function GifPlaceholder({ label = 'EXERCISE GIF', size, width, height, dim = false, style = {} }) {
  const w = width ?? size ?? 160;
  const h = height ?? size ?? 160;
  const stripe = dim ? 'rgba(232,64,64,0.05)' : 'rgba(232,64,64,0.10)';
  const stripeAlt = dim ? 'rgba(255,255,255,0.02)' : 'rgba(255,255,255,0.03)';
  const stripeId = `stripe-${Math.random().toString(36).slice(2, 8)}`;
  return (
    <div style={{
      width: w, height: h, position: 'relative', overflow: 'hidden',
      background: '#161616', border: `1px solid ${CT.border}`,
      borderRadius: CT.radiusCard,
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      ...style,
    }}>
      <svg width="100%" height="100%" style={{ position: 'absolute', inset: 0 }}>
        <defs>
          <pattern id={stripeId} width="14" height="14" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
            <rect width="14" height="14" fill={stripeAlt}/>
            <rect width="7" height="14" fill={stripe}/>
          </pattern>
        </defs>
        <rect width="100%" height="100%" fill={`url(#${stripeId})`}/>
      </svg>
      <div style={{
        position: 'relative', textAlign: 'center',
        fontFamily: CT.fontMono, fontSize: 9, fontWeight: 600,
        letterSpacing: 1.4, color: 'rgba(232,64,64,0.55)',
        textTransform: 'uppercase', padding: '0 8px',
      }}>{label}</div>
    </div>
  );
}

Object.assign(window, { GifPlaceholder });
