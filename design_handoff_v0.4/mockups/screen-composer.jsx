// screen-composer.jsx — Workout Composer

function StepRow({ kind, name, detail, duration, mode, idx, active, indent = false }) {
  const colorMap = {
    EXERCISE: CT.red,
    REST:     CT.amber,
    COUNTDOWN: CT.green,
    CIRCUIT:  CT.blue,
  };
  const fg = colorMap[kind] || CT.textSecondary;
  return (
    <div style={{
      display: 'grid',
      gridTemplateColumns: '24px 36px 1fr auto 16px',
      gap: 10, alignItems: 'center',
      padding: '11px 12px',
      background: active ? '#1F1F1F' : CT.surface,
      border: `1px solid ${active ? CT.red : CT.border}`,
      borderRadius: 6,
      marginLeft: indent ? 24 : 0,
      position: 'relative',
    }}>
      <div style={{ fontFamily: CT.fontMono, color: CT.textDisabled, fontSize: 11, textAlign: 'center' }}>::</div>
      <div style={{
        width: 32, height: 32, borderRadius: 4,
        background: `${fg}1F`, border: `1px solid ${fg}55`,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        fontFamily: CT.fontMono, fontWeight: 700, fontSize: 11, color: fg,
        letterSpacing: 0.5,
      }}>{idx}</div>
      <div style={{ minWidth: 0 }}>
        <div style={{ fontSize: 13.5, fontWeight: 600, lineHeight: 1.25 }}>{name}</div>
        <div style={{ display: 'flex', gap: 6, alignItems: 'center', marginTop: 4 }}>
          <Chip color={fg} border={`${fg}55`} bg={`${fg}1A`}>{kind}</Chip>
          {mode && <Chip>{mode}</Chip>}
          {detail && <span style={{ fontSize: 11, color: CT.textSecondary }}>{detail}</span>}
        </div>
      </div>
      <div style={{ fontFamily: CT.fontMono, fontSize: 13, fontWeight: 600, color: CT.text }}>{duration}</div>
      <div style={{ color: CT.textDisabled, fontSize: 14 }}>›</div>
    </div>
  );
}

function CircuitWrap({ rounds, label, children }) {
  return (
    <div style={{
      border: `1px dashed ${CT.blue}55`,
      borderRadius: 8, padding: '10px 10px 12px',
      background: 'rgba(61,139,255,0.04)',
      display: 'flex', flexDirection: 'column', gap: 8,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '0 4px' }}>
        <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
          <Chip color={CT.blue} border={`${CT.blue}55`} bg={`${CT.blue}1A`}>CIRCUIT</Chip>
          <span style={{ fontSize: 12, fontWeight: 600 }}>{label}</span>
        </div>
        <span style={{ fontFamily: CT.fontMono, fontSize: 11, color: CT.textSecondary }}>× {rounds}</span>
      </div>
      {children}
    </div>
  );
}

function FAB({ children }) {
  return (
    <div style={{
      position: 'absolute', right: 16, bottom: 80,
      height: 56, padding: '0 22px', borderRadius: 999,
      background: CT.red, color: '#0F0F0F', fontWeight: 700, fontSize: 14,
      display: 'flex', alignItems: 'center', gap: 8,
      boxShadow: '0 8px 24px rgba(232,64,64,0.35)',
    }}>{children}</div>
  );
}

function ComposerMobile() {
  return (
    <MobileFrame>
      <MobileTopBar
        title="Fran"
        sub="3 rounds · 21–15–9 · for time"
        left={<span style={{ fontFamily: CT.fontMono, color: CT.textSecondary, fontSize: 16 }}>‹</span>}
        right={<>
          <div style={{ padding: '7px 10px', border: `1px solid ${CT.border}`, borderRadius: 6, fontSize: 11, fontWeight: 600, color: CT.textSecondary, letterSpacing: 0.4 }}>SAVE</div>
          <div style={{ padding: '7px 14px', background: CT.red, color: '#0F0F0F', borderRadius: 6, fontSize: 11, fontWeight: 700, letterSpacing: 0.6, textTransform: 'uppercase' }}>▶ Play</div>
        </>}
      />
      <div style={{ padding: '12px 16px 0', display: 'flex', gap: 6, flexWrap: 'wrap' }}>
        <Chip>CrossFit</Chip>
        <Chip>Benchmark</Chip>
        <Chip>For Time</Chip>
        <Chip color={CT.textDisabled} style={{ borderStyle: 'dashed' }}>+ tag</Chip>
      </div>
      <div style={{ flex: 1, overflow: 'auto', padding: '14px 16px 100px', display: 'flex', flexDirection: 'column', gap: 8 }}>
        <MetaLabel>Timeline · 5 steps</MetaLabel>
        <StepRow idx="01" kind="COUNTDOWN" name="Get Ready" detail="lead-in" duration="0:10" />
        <CircuitWrap rounds={3} label="Main · 21-15-9">
          <StepRow idx="02" kind="EXERCISE" name="Barbell Thruster" mode="REPS" detail="95 / 65 lb" duration="21r" indent />
          <StepRow idx="03" kind="EXERCISE" name="Pull-up" mode="REPS" detail="strict · scale: band" duration="21r" indent active />
        </CircuitWrap>
        <StepRow idx="04" kind="REST" name="Rest" duration="0:30" />
        <StepRow idx="05" kind="EXERCISE" name="Cooldown Walk" mode="TIMED" detail="zone 1" duration="2:00" />
      </div>
      <FAB>＋ Add Step</FAB>
      <MobileTabBar active="Compose" />
    </MobileFrame>
  );
}

function ComposerDesktop() {
  return (
    <DesktopFrame title="Fran" sub="Composer · 5 steps · 6–9 min · for time" active="Compose">
      <div style={{ display: 'grid', gridTemplateColumns: '300px 1fr 320px', height: '100%', minHeight: 0 }}>
        {/* Library mini */}
        <div style={{ borderRight: `1px solid ${CT.borderSoft}`, padding: 18, overflow: 'auto', display: 'flex', flexDirection: 'column', gap: 12 }}>
          <MetaLabel>Library · drag to add</MetaLabel>
          <SearchBar placeholder="Search exercises…" />
          <div style={{ display: 'flex', gap: 4, flexWrap: 'wrap' }}>
            <FilterChip active>All</FilterChip>
            <FilterChip>Barbell</FilterChip>
            <FilterChip>BW</FilterChip>
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
            {EXERCISES.slice(0, 8).map((e, i) => <ExerciseCard key={i} ex={e} size="sm" />)}
          </div>
        </div>
        {/* Timeline */}
        <div style={{ padding: 22, overflow: 'auto', display: 'flex', flexDirection: 'column', gap: 12, position: 'relative' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div style={{ display: 'flex', gap: 6 }}>
              <Chip>CrossFit</Chip>
              <Chip>Benchmark</Chip>
              <Chip>For Time</Chip>
              <Chip color={CT.textDisabled} style={{ borderStyle: 'dashed' }}>+ tag</Chip>
            </div>
            <div style={{ display: 'flex', gap: 8 }}>
              <div style={{ padding: '8px 14px', border: `1px solid ${CT.border}`, borderRadius: 6, fontSize: 12, fontWeight: 600, color: CT.text }}>Save</div>
              <div style={{ padding: '8px 16px', background: CT.red, color: '#0F0F0F', borderRadius: 6, fontSize: 12, fontWeight: 700, letterSpacing: 0.6, textTransform: 'uppercase' }}>▶ Play</div>
            </div>
          </div>
          <div style={{ display: 'flex', gap: 10, marginTop: 4 }}>
            {[['Steps', '5'], ['Est. duration', '6–9 min'], ['Rounds', '3'], ['Total reps', '135']].map(([l, v]) => (
              <div key={l} style={{ flex: 1, background: CT.surface, border: `1px solid ${CT.border}`, borderRadius: 6, padding: '10px 12px' }}>
                <div style={{ fontFamily: CT.fontMono, fontSize: 9, color: CT.textSecondary, letterSpacing: 1.2, textTransform: 'uppercase' }}>{l}</div>
                <div style={{ fontFamily: CT.fontMono, fontSize: 18, fontWeight: 700, marginTop: 3 }}>{v}</div>
              </div>
            ))}
          </div>
          <div style={{ marginTop: 4 }}><MetaLabel>Timeline</MetaLabel></div>
          <StepRow idx="01" kind="COUNTDOWN" name="Get Ready" detail="lead-in countdown" duration="0:10" />
          <CircuitWrap rounds={3} label="Main set · 21-15-9 (descending reps)">
            <StepRow idx="02" kind="EXERCISE" name="Barbell Thruster" mode="REPS" detail="95 / 65 lb · full ROM" duration="21r" indent />
            <StepRow idx="03" kind="EXERCISE" name="Pull-up" mode="REPS" detail="strict · scale: band" duration="21r" indent active />
          </CircuitWrap>
          <StepRow idx="04" kind="REST" name="Rest" detail="optional between rounds" duration="0:30" />
          <StepRow idx="05" kind="EXERCISE" name="Cooldown Walk" mode="TIMED" detail="zone 1" duration="2:00" />
          <div style={{ display: 'flex', gap: 8, marginTop: 6 }}>
            {['+ Exercise', '+ Rest', '+ Circuit', '+ Countdown'].map(b => (
              <div key={b} style={{ padding: '9px 14px', border: `1px dashed ${CT.border}`, borderRadius: 6, fontSize: 12, color: CT.textSecondary }}>{b}</div>
            ))}
          </div>
        </div>
        {/* Step editor */}
        <div style={{ borderLeft: `1px solid ${CT.borderSoft}`, padding: 18, overflow: 'auto', display: 'flex', flexDirection: 'column', gap: 14 }}>
          <MetaLabel>Editing · Step 03</MetaLabel>
          <GifPlaceholder label="PULL-UP" width="100%" height={180} />
          <div>
            <div style={{ fontSize: 16, fontWeight: 700 }}>Pull-up</div>
            <div style={{ fontSize: 11, color: CT.textSecondary, marginTop: 4 }}>Back · Pull-bar · Lats</div>
          </div>
          <div>
            <MetaLabel>Mode</MetaLabel>
            <div style={{ display: 'flex', gap: 6, marginTop: 8 }}>
              {['REPS', 'TIMED', 'AMRAP'].map((m, i) => (
                <div key={m} style={{ flex: 1, textAlign: 'center', padding: '7px 0', borderRadius: 4, background: i === 0 ? CT.red : 'transparent', color: i === 0 ? '#0F0F0F' : CT.textSecondary, border: `1px solid ${i === 0 ? CT.red : CT.border}`, fontFamily: CT.fontMono, fontSize: 11, fontWeight: 700, letterSpacing: 0.6 }}>{m}</div>
              ))}
            </div>
          </div>
          {[['Reps', '21'], ['Rest after', '0s'], ['Tempo', '—'], ['Scale', 'band']].map(([l, v]) => (
            <div key={l} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '10px 12px', background: CT.surface, border: `1px solid ${CT.border}`, borderRadius: 6 }}>
              <span style={{ fontSize: 12, color: CT.textSecondary }}>{l}</span>
              <span style={{ fontFamily: CT.fontMono, fontSize: 14, fontWeight: 700 }}>{v}</span>
            </div>
          ))}
          <div style={{ marginTop: 'auto', display: 'flex', gap: 8 }}>
            <div style={{ padding: '10px 14px', border: `1px solid ${CT.border}`, borderRadius: 6, fontSize: 12, color: CT.textSecondary }}>Duplicate</div>
            <div style={{ padding: '10px 14px', border: `1px solid ${CT.redDim}`, color: CT.red, borderRadius: 6, fontSize: 12 }}>Delete</div>
          </div>
        </div>
      </div>
    </DesktopFrame>
  );
}

Object.assign(window, { ComposerMobile, ComposerDesktop });
