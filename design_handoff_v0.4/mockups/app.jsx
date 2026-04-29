// app.jsx — assembles the design canvas

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "showDesktop": true,
  "showMobile": true,
  "playerState": "WORK",
  "livePlayer": true,
  "accent": "red"
}/*EDITMODE-END*/;

const ACCENTS = {
  red:    '#E84040',
  amber:  '#F5A623',
  green:  '#4CAF50',
  blue:   '#3D8BFF',
};

function App() {
  const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);

  // Apply accent override at runtime
  React.useEffect(() => {
    CT.red = ACCENTS[t.accent] || ACCENTS.red;
  }, [t.accent]);

  const M_W = 390, M_H = 844;          // iPhone 14 Pro
  const D_W = 1280, D_H = 820;         // Desktop
  const PLAYER_D_W = 1280, PLAYER_D_H = 760;

  return (
    <>
      <DesignCanvas>
        {/* INTRO */}
        <DCSection id="intro" title="CostruTrain" subtitle="Build your training. Own your data. — High-fidelity Flutter mockups (mobile + desktop)">
          <DCArtboard id="brief" label="Design Brief" width={520} height={520}>
            <div style={{ width: '100%', height: '100%', background: CT.bg, color: CT.text, fontFamily: CT.fontUi, padding: 32, display: 'flex', flexDirection: 'column', gap: 14, overflow: 'hidden' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                <div style={{ width: 36, height: 36, background: CT.red, borderRadius: 6, display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: CT.fontMono, fontWeight: 800, color: '#0F0F0F', fontSize: 20 }}>C</div>
                <div>
                  <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.4 }}>CostruTrain</div>
                  <div style={{ fontFamily: CT.fontMono, fontSize: 10, color: CT.textSecondary, letterSpacing: 1.2, textTransform: 'uppercase', marginTop: 2 }}>v0.4 · offline-first · AGPL-3.0</div>
                </div>
              </div>
              <div style={{ fontSize: 14, color: CT.textSecondary, lineHeight: 1.5, textWrap: 'pretty' }}>
                Privacy-first workout composer + player. Dark, dense, no-BS. Inspired by Zwift, CrossFit competition scoreboards, and terminal data tools.
              </div>
              <div style={{ borderTop: `1px solid ${CT.borderSoft}`, paddingTop: 14 }}>
                <MetaLabel>System</MetaLabel>
                <div style={{ marginTop: 10, display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
                  {[
                    ['Type', 'Inter + JetBrains Mono'],
                    ['Bg', '#0F0F0F'],
                    ['Surface', '#1A1A1A'],
                    ['Accent', 'Red #E84040'],
                    ['Phase', 'Amber · Green'],
                    ['Radius', '8 / 4 / 24 / 0'],
                  ].map(([l, v]) => (
                    <div key={l} style={{ background: CT.surface, border: `1px solid ${CT.border}`, borderRadius: 6, padding: 10 }}>
                      <div style={{ fontFamily: CT.fontMono, fontSize: 9, color: CT.textSecondary, letterSpacing: 1.2, textTransform: 'uppercase' }}>{l}</div>
                      <div style={{ fontFamily: CT.fontMono, fontSize: 12, fontWeight: 700, marginTop: 3 }}>{v}</div>
                    </div>
                  ))}
                </div>
              </div>
              <div style={{ marginTop: 'auto', display: 'flex', gap: 6, flexWrap: 'wrap' }}>
                <Chip>Offline-first</Chip>
                <Chip>Flutter</Chip>
                <Chip>Riverpod</Chip>
                <Chip>Drift / SQLite</Chip>
                <Chip color={CT.red} border={CT.redDim} bg="rgba(232,64,64,0.1)">No telemetry · ever</Chip>
              </div>
            </div>
          </DCArtboard>
          <DCArtboard id="palette" label="Color & Type" width={520} height={520}>
            <div style={{ width: '100%', height: '100%', background: CT.bg, color: CT.text, fontFamily: CT.fontUi, padding: 28, display: 'flex', flexDirection: 'column', gap: 18, overflow: 'hidden' }}>
              <MetaLabel>Palette</MetaLabel>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 8 }}>
                {[
                  ['BG',       CT.bg,       '#0F0F0F'],
                  ['SURFACE',  CT.surface,  '#1A1A1A'],
                  ['ELEVATED', CT.elevated, '#242424'],
                  ['BORDER',   CT.border,   '#2E2E2E'],
                  ['RED',      CT.red,      '#E84040'],
                  ['AMBER',    CT.amber,    '#F5A623'],
                  ['GREEN',    CT.green,    '#4CAF50'],
                  ['BLUE',     CT.blue,     '#3D8BFF'],
                ].map(([l, c, hex]) => (
                  <div key={l}>
                    <div style={{ height: 56, background: c, borderRadius: 4, border: `1px solid ${CT.borderSoft}` }} />
                    <div style={{ fontFamily: CT.fontMono, fontSize: 9, color: CT.textSecondary, letterSpacing: 1, marginTop: 6 }}>{l}</div>
                    <div style={{ fontFamily: CT.fontMono, fontSize: 10, color: CT.text, marginTop: 1 }}>{hex}</div>
                  </div>
                ))}
              </div>
              <MetaLabel>Type</MetaLabel>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 6, borderLeft: `2px solid ${CT.red}`, paddingLeft: 14 }}>
                <div style={{ fontFamily: CT.fontMono, fontSize: 56, fontWeight: 700, lineHeight: 1, letterSpacing: -2, fontVariantNumeric: 'tabular-nums' }}>7:42</div>
                <div style={{ fontFamily: CT.fontMono, fontSize: 10, color: CT.textSecondary, letterSpacing: 1.4 }}>JETBRAINS MONO · 56 / 700 · TIMER</div>
                <div style={{ fontSize: 22, fontWeight: 700, marginTop: 8, letterSpacing: -0.4 }}>Barbell Thruster</div>
                <div style={{ fontFamily: CT.fontMono, fontSize: 10, color: CT.textSecondary, letterSpacing: 1.4 }}>INTER · 22 / 700 · HEADING</div>
                <div style={{ fontSize: 13, fontWeight: 400, marginTop: 8, color: CT.textSecondary }}>21 reps at 95 lb · full ROM · scale: 65 lb</div>
                <div style={{ fontFamily: CT.fontMono, fontSize: 10, color: CT.textSecondary, letterSpacing: 1.4 }}>INTER · 13 / 400 · BODY</div>
              </div>
              <div style={{ marginTop: 'auto', display: 'flex', gap: 6 }}>
                <PhaseBadge phase="WORK" />
                <PhaseBadge phase="REST" />
                <PhaseBadge phase="GET READY" />
                <PhaseBadge phase="DONE" />
              </div>
            </div>
          </DCArtboard>
        </DCSection>

        {/* PLAYER — most important, all 5 states */}
        <DCSection id="player" title="01 · Workout Player" subtitle="Full-screen, immersive — 5 states. Mobile player is live (real countdown). Desktop has state-cycler.">
          {t.showMobile && PLAYER_STATES.map(s => (
            <DCArtboard key={s} id={`pm-${s}`} label={`Mobile · ${s}`} width={M_W} height={M_H}>
              <PlayerMobile state={s} live={t.livePlayer && s === t.playerState} />
            </DCArtboard>
          ))}
          {t.showDesktop && (
            <DCArtboard id="pd" label="Desktop · cycler" width={PLAYER_D_W} height={PLAYER_D_H}>
              <PlayerDesktop />
            </DCArtboard>
          )}
        </DCSection>

        {/* LIBRARY */}
        <DCSection id="library" title="02 · Exercise Library" subtitle="GIF reference grid + filters. 1,304 exercises offline.">
          {t.showMobile && (
            <DCArtboard id="lm" label="Mobile · 2-up grid" width={M_W} height={M_H}>
              <LibraryMobile />
            </DCArtboard>
          )}
          {t.showDesktop && (
            <DCArtboard id="ld" label="Desktop · 3-panel" width={D_W} height={D_H}>
              <LibraryDesktop />
            </DCArtboard>
          )}
        </DCSection>

        {/* COMPOSER */}
        <DCSection id="composer" title="03 · Workout Composer" subtitle="Timeline editor with circuits, rest, countdown blocks. Drag to reorder, swipe to delete.">
          {t.showMobile && (
            <DCArtboard id="cm" label="Mobile · timeline" width={M_W} height={M_H}>
              <ComposerMobile />
            </DCArtboard>
          )}
          {t.showDesktop && (
            <DCArtboard id="cd" label="Desktop · 3-panel" width={D_W} height={D_H}>
              <ComposerDesktop />
            </DCArtboard>
          )}
        </DCSection>

        {/* MY WORKOUTS */}
        <DCSection id="myworkouts" title="04 · My Workouts" subtitle="Saved workouts list with metadata.">
          {t.showMobile && (
            <DCArtboard id="mwm" label="Mobile · cards" width={M_W} height={M_H}>
              <MyWorkoutsMobile />
            </DCArtboard>
          )}
          {t.showDesktop && (
            <DCArtboard id="mwd" label="Desktop · grid" width={D_W} height={D_H}>
              <MyWorkoutsDesktop />
            </DCArtboard>
          )}
        </DCSection>

        {/* HISTORY */}
        <DCSection id="history" title="05 · Session History" subtitle="Grouped by date with heatmap & splits detail.">
          {t.showMobile && (
            <DCArtboard id="hm" label="Mobile · grouped" width={M_W} height={M_H}>
              <HistoryMobile />
            </DCArtboard>
          )}
          {t.showDesktop && (
            <DCArtboard id="hd" label="Desktop · heatmap + detail" width={D_W} height={D_H}>
              <HistoryDesktop />
            </DCArtboard>
          )}
        </DCSection>
      </DesignCanvas>

      <TweaksPanel title="Tweaks">
        <TweakSection label="Display" />
        <TweakToggle label="Show desktop artboards" value={t.showDesktop} onChange={v => setTweak('showDesktop', v)} />
        <TweakToggle label="Show mobile artboards"  value={t.showMobile}  onChange={v => setTweak('showMobile', v)} />
        <TweakSection label="Player" />
        <TweakRadio label="Live state" value={t.playerState} options={PLAYER_STATES} onChange={v => setTweak('playerState', v)} />
        <TweakToggle label="Animate live state" value={t.livePlayer} onChange={v => setTweak('livePlayer', v)} />
        <TweakSection label="Brand" />
        <TweakSelect label="Accent color" value={t.accent}
          options={[
            { value: 'red',   label: 'Athletic Red (default)' },
            { value: 'amber', label: 'Amber' },
            { value: 'green', label: 'Green' },
            { value: 'blue',  label: 'Cyclo Blue' },
          ]}
          onChange={v => setTweak('accent', v)} />
      </TweaksPanel>
    </>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
