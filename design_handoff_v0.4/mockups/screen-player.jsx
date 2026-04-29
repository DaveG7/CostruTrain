// screen-player.jsx — Workout Player (5 states)
// Single state machine drives both the live mobile player and the desktop view.

const PLAYER_STATES = ['WARMUP', 'GET READY', 'WORK', 'REST', 'FINISHED'];

function TimerRing({ size = 220, stroke = 10, progress = 0.7, color = CT.red, label, value, sub }) {
  const r = (size - stroke) / 2;
  const c = 2 * Math.PI * r;
  const dash = c * progress;
  return (
    <div style={{ position: 'relative', width: size, height: size, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
      <svg width={size} height={size} style={{ transform: 'rotate(-90deg)' }}>
        <circle cx={size/2} cy={size/2} r={r} stroke="#1F1F1F" strokeWidth={stroke} fill="none" />
        <circle cx={size/2} cy={size/2} r={r} stroke={color} strokeWidth={stroke} fill="none"
          strokeLinecap="round" strokeDasharray={`${dash} ${c - dash}`} style={{ transition: 'stroke-dasharray 200ms linear' }}/>
      </svg>
      <div style={{ position: 'absolute', textAlign: 'center', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4 }}>
        {label && <div style={{ fontFamily: CT.fontMono, fontSize: 10, color: CT.textSecondary, letterSpacing: 1.6, textTransform: 'uppercase' }}>{label}</div>}
        <div style={{ fontFamily: CT.fontMono, fontSize: size * 0.28, fontWeight: 700, lineHeight: 1, color: CT.text, letterSpacing: -1, fontVariantNumeric: 'tabular-nums' }}>{value}</div>
        {sub && <div style={{ fontFamily: CT.fontMono, fontSize: 11, color: CT.textSecondary, letterSpacing: 1 }}>{sub}</div>}
      </div>
    </div>
  );
}

const STATE_CFG = {
  WARMUP:    { color: CT.textSecondary, label: 'WARMUP',    title: 'Get the body moving', exercise: 'Easy row',           detail: 'Zone 1 · keep it loose', next: 'Get Ready · 0:10', total: 60,  remaining: 18, ring: 0.30 },
  'GET READY': { color: CT.green,       label: 'GET READY',  title: 'In 3…',                exercise: 'Barbell Thruster',   detail: 'Round 1 · 21 reps · 95 lb', next: 'Work · 21r',         total: 3,   remaining: 3,  ring: 1.00 },
  WORK:      { color: CT.red,           label: 'WORK',       title: 'Round 1 of 3',         exercise: 'Barbell Thruster',   detail: '21 reps · 95 lb',           next: 'Pull-up · 21r',      total: null, remaining: 14, elapsed: 14, ring: 0.55 },
  REST:      { color: CT.amber,         label: 'REST',       title: 'Catch your breath',    exercise: 'Pull-up',            detail: 'Up next · 21 reps strict',  next: 'Pull-up · 21r',      total: 30,  remaining: 12, ring: 0.40 },
  FINISHED:  { color: CT.green,         label: 'DONE',       title: 'Fran',                 exercise: 'Total Time',         detail: '5 / 5 steps complete',      next: '7:42',               total: null, remaining: 0,  ring: 1.00 },
};

function fmt(s) {
  const m = Math.floor(s / 60), r = Math.floor(s % 60);
  return `${m}:${String(r).padStart(2, '0')}`;
}

// Live mobile player — drives a real countdown for current state.
function PlayerMobile({ state = 'WORK', live = false }) {
  const cfg = STATE_CFG[state];
  const [secs, setSecs] = React.useState(cfg.remaining);
  const [paused, setPaused] = React.useState(false);
  const [progress, setProgress] = React.useState(cfg.ring);

  React.useEffect(() => {
    setSecs(cfg.remaining);
    setProgress(cfg.ring);
  }, [state]);

  React.useEffect(() => {
    if (!live || paused || state === 'FINISHED') return;
    const id = setInterval(() => {
      setSecs(prev => {
        if (cfg.total) {
          const next = prev <= 0 ? cfg.total : prev - 1;
          setProgress(next / cfg.total);
          return next;
        } else {
          // AMRAP-ish countup for WORK
          const next = prev + 1;
          setProgress(((next % 30) / 30));
          return next;
        }
      });
    }, 1000);
    return () => clearInterval(id);
  }, [live, paused, state]);

  const display = state === 'WORK' && !cfg.total
    ? fmt(secs)
    : state === 'GET READY'
      ? String(secs)
      : state === 'FINISHED'
        ? '7:42'
        : fmt(secs);

  return (
    <MobileFrame>
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', position: 'relative' }}>
        {/* Top: phase + round */}
        <div style={{ padding: '16px 18px 0', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <PhaseBadge phase={cfg.label} />
          <div style={{ fontFamily: CT.fontMono, fontSize: 11, color: CT.textSecondary, letterSpacing: 1.2 }}>
            {state === 'FINISHED' ? 'COMPLETE' : `ROUND ${state === 'WARMUP' ? '0' : '1'} / 3`}
          </div>
          <div style={{ width: 28, height: 28, borderRadius: 6, border: `1px solid ${CT.border}`, display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: CT.fontMono, fontSize: 14, color: CT.textSecondary }}>✕</div>
        </div>

        {/* Hero */}
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '6px 18px', gap: 14, minHeight: 0 }}>
          {state === 'FINISHED' ? (
            <>
              <div style={{ fontFamily: CT.fontMono, fontSize: 11, color: CT.green, letterSpacing: 2, marginBottom: -4 }}>WORKOUT COMPLETE</div>
              <div style={{ fontSize: 28, fontWeight: 800, letterSpacing: -0.6 }}>Fran</div>
              <div style={{ fontFamily: CT.fontMono, fontSize: 64, fontWeight: 700, color: CT.text, letterSpacing: -2, lineHeight: 1, fontVariantNumeric: 'tabular-nums' }}>7:42</div>
              <div style={{ display: 'flex', gap: 6 }}>
                <Chip color={CT.green} border={`${CT.green}55`} bg={`${CT.green}1A`}>NEW PR · −0:23</Chip>
                <Chip>5 / 5 STEPS</Chip>
              </div>
              <div style={{ width: '100%', marginTop: 10, padding: 14, background: CT.surface, border: `1px solid ${CT.border}`, borderRadius: 8, display: 'flex', flexDirection: 'column', gap: 8 }}>
                {[['Total reps', '135'], ['Avg round', '2:34'], ['Rest taken', '0:00']].map(([l, v]) => (
                  <div key={l} style={{ display: 'flex', justifyContent: 'space-between' }}>
                    <span style={{ fontSize: 12, color: CT.textSecondary }}>{l}</span>
                    <span style={{ fontFamily: CT.fontMono, fontSize: 13, fontWeight: 700 }}>{v}</span>
                  </div>
                ))}
              </div>
            </>
          ) : (
            <>
              <GifPlaceholder label={cfg.exercise.toUpperCase()} width={220} height={140} />
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: 22, fontWeight: 700, letterSpacing: -0.4 }}>{cfg.exercise}</div>
                <div style={{ fontSize: 12, color: CT.textSecondary, marginTop: 4 }}>{cfg.detail}</div>
              </div>
              <TimerRing
                size={state === 'GET READY' ? 200 : 220}
                progress={progress}
                color={cfg.color}
                label={state === 'WORK' && !cfg.total ? 'ELAPSED' : 'REMAINING'}
                value={display}
                sub={state === 'WORK' ? '21 REPS' : null}
              />
            </>
          )}
        </div>

        {/* Bottom: next-up + controls */}
        <div style={{ padding: '0 18px 22px', display: 'flex', flexDirection: 'column', gap: 12 }}>
          {state !== 'FINISHED' && (
            <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '10px 12px', background: CT.surface, border: `1px solid ${CT.border}`, borderRadius: 8 }}>
              <div style={{ flexShrink: 0 }}>
                <GifPlaceholder label="NEXT" width={42} height={42} />
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontFamily: CT.fontMono, fontSize: 9, color: CT.textSecondary, letterSpacing: 1.4 }}>NEXT UP</div>
                <div style={{ fontSize: 13, fontWeight: 600, marginTop: 2 }}>{cfg.next}</div>
              </div>
              <div style={{ fontFamily: CT.fontMono, fontSize: 18, color: CT.textDisabled }}>›</div>
            </div>
          )}
          <div style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
            <div style={{ width: 48, height: 48, borderRadius: 999, border: `1px solid ${CT.border}`, display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: CT.fontMono, fontSize: 18, color: CT.textSecondary }}>‹‹</div>
            <div onClick={() => setPaused(p => !p)} style={{ flex: 1, height: 56, borderRadius: 999, background: state === 'FINISHED' ? CT.green : CT.red, color: '#0F0F0F', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8, fontWeight: 800, fontSize: 14, letterSpacing: 1.2, cursor: 'pointer', userSelect: 'none' }}>
              {state === 'FINISHED' ? 'SAVE SESSION' : (paused ? '▶ RESUME' : '❚❚ PAUSE')}
            </div>
            <div style={{ width: 48, height: 48, borderRadius: 999, border: `1px solid ${CT.border}`, display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: CT.fontMono, fontSize: 18, color: CT.textSecondary }}>››</div>
          </div>
        </div>
      </div>
    </MobileFrame>
  );
}

// Desktop player: full immersive screen with side panel for upcoming queue
function PlayerDesktop() {
  const [state, setState] = React.useState('WORK');
  const cfg = STATE_CFG[state];
  const queue = [
    { i: 1, name: 'Get Ready', detail: 'Lead-in', duration: '0:10', done: true,  current: false },
    { i: 2, name: 'Barbell Thruster', detail: 'R1 · 21 reps · 95lb', duration: '0:42', done: false, current: true },
    { i: 3, name: 'Pull-up', detail: 'R1 · 21 reps', duration: '—', done: false, current: false },
    { i: 4, name: 'Barbell Thruster', detail: 'R2 · 15 reps', duration: '—', done: false, current: false },
    { i: 5, name: 'Pull-up', detail: 'R2 · 15 reps', duration: '—', done: false, current: false },
    { i: 6, name: 'Barbell Thruster', detail: 'R3 · 9 reps', duration: '—', done: false, current: false },
    { i: 7, name: 'Pull-up', detail: 'R3 · 9 reps', duration: '—', done: false, current: false },
    { i: 8, name: 'Cooldown Walk', detail: 'Zone 1', duration: '2:00', done: false, current: false },
  ];

  return (
    <div style={{ width: '100%', height: '100%', background: '#0A0A0A', color: CT.text, fontFamily: CT.fontUi, display: 'grid', gridTemplateColumns: '1fr 320px', overflow: 'hidden' }}>
      {/* Stage */}
      <div style={{ padding: 28, display: 'flex', flexDirection: 'column', position: 'relative', minWidth: 0 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
              <span style={{ fontFamily: CT.fontMono, fontSize: 10, color: CT.textSecondary, letterSpacing: 1.2 }}>‹ EXIT</span>
            </div>
            <div style={{ width: 1, height: 20, background: CT.border }} />
            <div style={{ fontSize: 14, fontWeight: 700 }}>Fran</div>
            <div style={{ fontFamily: CT.fontMono, fontSize: 10, color: CT.textSecondary, letterSpacing: 1.2 }}>BENCHMARK · FOR TIME</div>
          </div>
          {/* State cycler — for showing all 5 states at once */}
          <div style={{ display: 'flex', gap: 6, padding: 4, border: `1px solid ${CT.border}`, borderRadius: 6 }}>
            {PLAYER_STATES.map(s => (
              <div key={s} onClick={() => setState(s)} style={{
                padding: '5px 10px', borderRadius: 4, fontFamily: CT.fontMono, fontSize: 10, fontWeight: 700, letterSpacing: 0.8,
                color: s === state ? '#0F0F0F' : CT.textSecondary,
                background: s === state ? STATE_CFG[s].color : 'transparent',
                cursor: 'pointer',
              }}>{s}</div>
            ))}
          </div>
        </div>

        <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 40, minHeight: 0 }}>
          {state === 'FINISHED' ? (
            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 14 }}>
              <PhaseBadge phase="DONE" />
              <div style={{ fontSize: 56, fontWeight: 800, letterSpacing: -1.5 }}>Fran</div>
              <div style={{ fontFamily: CT.fontMono, fontSize: 140, fontWeight: 700, lineHeight: 1, letterSpacing: -5, fontVariantNumeric: 'tabular-nums' }}>7:42</div>
              <div style={{ display: 'flex', gap: 10 }}>
                <Chip color={CT.green} border={`${CT.green}55`} bg={`${CT.green}1A`}>NEW PR · −0:23</Chip>
                <Chip>5 / 5 STEPS</Chip>
                <Chip>135 REPS</Chip>
              </div>
            </div>
          ) : (
            <>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 18, maxWidth: 380 }}>
                <PhaseBadge phase={cfg.label} />
                <div>
                  <div style={{ fontFamily: CT.fontMono, fontSize: 11, color: CT.textSecondary, letterSpacing: 1.6, textTransform: 'uppercase' }}>{cfg.title}</div>
                  <div style={{ fontSize: 36, fontWeight: 800, letterSpacing: -0.8, marginTop: 8, lineHeight: 1.05 }}>{cfg.exercise}</div>
                  <div style={{ fontSize: 14, color: CT.textSecondary, marginTop: 8 }}>{cfg.detail}</div>
                </div>
                <GifPlaceholder label={cfg.exercise.toUpperCase()} width={380} height={220} />
              </div>
              <TimerRing
                size={340}
                stroke={14}
                progress={cfg.ring}
                color={cfg.color}
                label={state === 'WORK' && !cfg.total ? 'ELAPSED' : 'REMAINING'}
                value={state === 'GET READY' ? String(cfg.remaining) : (state === 'WORK' && !cfg.total ? fmt(cfg.elapsed) : fmt(cfg.remaining))}
                sub={state === 'WORK' ? '21 REPS' : null}
              />
            </>
          )}
        </div>

        {/* Controls */}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 12 }}>
          <div style={{ width: 52, height: 52, borderRadius: 999, border: `1px solid ${CT.border}`, display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: CT.fontMono, fontSize: 18, color: CT.textSecondary }}>‹‹</div>
          <div style={{ height: 56, padding: '0 38px', borderRadius: 999, background: state === 'FINISHED' ? CT.green : CT.red, color: '#0F0F0F', display: 'flex', alignItems: 'center', gap: 10, fontWeight: 800, fontSize: 14, letterSpacing: 1.4 }}>
            {state === 'FINISHED' ? '✓ SAVE SESSION' : '❚❚ PAUSE'}
          </div>
          <div style={{ width: 52, height: 52, borderRadius: 999, border: `1px solid ${CT.border}`, display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: CT.fontMono, fontSize: 18, color: CT.textSecondary }}>››</div>
          <div style={{ marginLeft: 20, fontFamily: CT.fontMono, fontSize: 11, color: CT.textDisabled, letterSpacing: 1.2 }}>SPACE · pause   →  · skip   ESC · exit</div>
        </div>
      </div>

      {/* Queue panel */}
      <div style={{ borderLeft: `1px solid ${CT.borderSoft}`, padding: 22, display: 'flex', flexDirection: 'column', gap: 14, minWidth: 0, overflow: 'auto' }}>
        <div>
          <MetaLabel>Workout</MetaLabel>
          <div style={{ fontSize: 18, fontWeight: 700, marginTop: 4 }}>Fran</div>
        </div>
        <div style={{ display: 'flex', gap: 8 }}>
          {[['Elapsed', '2:14'], ['Round', '1/3']].map(([l, v]) => (
            <div key={l} style={{ flex: 1, background: CT.surface, border: `1px solid ${CT.border}`, borderRadius: 6, padding: '10px 12px' }}>
              <div style={{ fontFamily: CT.fontMono, fontSize: 9, color: CT.textSecondary, letterSpacing: 1.2 }}>{l}</div>
              <div style={{ fontFamily: CT.fontMono, fontSize: 18, fontWeight: 700, marginTop: 3, fontVariantNumeric: 'tabular-nums' }}>{v}</div>
            </div>
          ))}
        </div>
        <MetaLabel>Queue</MetaLabel>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
          {queue.map(q => (
            <div key={q.i} style={{
              display: 'grid', gridTemplateColumns: '24px 1fr auto', gap: 10, alignItems: 'center',
              padding: '9px 11px', borderRadius: 6,
              background: q.current ? `${CT.red}14` : (q.done ? 'transparent' : CT.surface),
              border: `1px solid ${q.current ? CT.red : (q.done ? 'transparent' : CT.border)}`,
              opacity: q.done ? 0.5 : 1,
            }}>
              <div style={{ fontFamily: CT.fontMono, fontSize: 10, color: q.current ? CT.red : CT.textSecondary, fontWeight: 700 }}>{q.done ? '✓' : String(q.i).padStart(2,'0')}</div>
              <div style={{ minWidth: 0 }}>
                <div style={{ fontSize: 12.5, fontWeight: 600, textDecoration: q.done ? 'line-through' : 'none' }}>{q.name}</div>
                <div style={{ fontSize: 10.5, color: CT.textSecondary, marginTop: 2 }}>{q.detail}</div>
              </div>
              <div style={{ fontFamily: CT.fontMono, fontSize: 11, color: CT.textSecondary, fontVariantNumeric: 'tabular-nums' }}>{q.duration}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { PlayerMobile, PlayerDesktop, TimerRing, PLAYER_STATES });
