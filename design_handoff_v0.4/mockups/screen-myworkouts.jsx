// screen-myworkouts.jsx — My Workouts list

function WorkoutCard({ w, large = false }) {
  return (
    <div style={{
      background: CT.surface, border: `1px solid ${CT.border}`,
      borderRadius: CT.radiusCard, padding: large ? '16px 18px' : '14px 16px',
      display: 'flex', flexDirection: 'column', gap: 10,
    }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 10 }}>
        <div style={{ minWidth: 0 }}>
          <div style={{ fontSize: large ? 17 : 15, fontWeight: 700, letterSpacing: -0.2, lineHeight: 1.2 }}>{w.name}</div>
          <div style={{ display: 'flex', gap: 4, marginTop: 8, flexWrap: 'wrap' }}>
            {w.tags.map(t => <Chip key={t}>{t}</Chip>)}
          </div>
        </div>
        <div style={{ width: 36, height: 36, borderRadius: 999, border: `1px solid ${CT.border}`, display: 'flex', alignItems: 'center', justifyContent: 'center', color: CT.red, fontFamily: CT.fontMono, fontSize: 14 }}>▶</div>
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 8, marginTop: 4, paddingTop: 12, borderTop: `1px solid ${CT.borderSoft}` }}>
        {[['STEPS', w.steps], ['EST', w.dur], ['LAST', w.last], ['LOG', w.sessions]].map(([l, v]) => (
          <div key={l}>
            <div style={{ fontFamily: CT.fontMono, fontSize: 9, color: CT.textSecondary, letterSpacing: 1.2 }}>{l}</div>
            <div style={{ fontFamily: CT.fontMono, fontSize: 12, fontWeight: 700, marginTop: 2, color: CT.text }}>{v}</div>
          </div>
        ))}
      </div>
    </div>
  );
}

function MyWorkoutsMobile() {
  return (
    <MobileFrame>
      <MobileTopBar
        title="My Workouts"
        sub={`${MY_WORKOUTS.length} saved · 17 sessions logged`}
        right={<>
          <IconBtn glyph="⌕" />
          <IconBtn glyph="↑↓" />
        </>}
      />
      <div style={{ padding: '12px 16px 0', display: 'flex', gap: 6, flexWrap: 'wrap' }}>
        <FilterChip active>All</FilterChip>
        <FilterChip>Benchmark</FilterChip>
        <FilterChip>EMOM</FilterChip>
        <FilterChip>Tabata</FilterChip>
        <FilterChip>Strength</FilterChip>
      </div>
      <div style={{ flex: 1, overflow: 'auto', padding: '14px 16px 100px', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {MY_WORKOUTS.map((w, i) => <WorkoutCard key={i} w={w} />)}
      </div>
      <FAB>＋ New Workout</FAB>
      <MobileTabBar active="Compose" />
    </MobileFrame>
  );
}

function MyWorkoutsDesktop() {
  return (
    <DesktopFrame title="My Workouts" sub={`${MY_WORKOUTS.length} saved · 17 sessions logged`} active="My Workouts">
      <div style={{ padding: '20px 28px', height: '100%', overflow: 'auto', display: 'flex', flexDirection: 'column', gap: 16 }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
            <FilterChip active>All</FilterChip>
            <FilterChip>Benchmark</FilterChip>
            <FilterChip>EMOM</FilterChip>
            <FilterChip>Tabata</FilterChip>
            <FilterChip>Strength</FilterChip>
            <FilterChip>Conditioning</FilterChip>
          </div>
          <div style={{ display: 'flex', gap: 8 }}>
            <div style={{ padding: '8px 14px', border: `1px solid ${CT.border}`, borderRadius: 6, fontSize: 12, color: CT.textSecondary }}>Import .json</div>
            <div style={{ padding: '8px 16px', background: CT.red, color: '#0F0F0F', borderRadius: 6, fontSize: 12, fontWeight: 700 }}>+ New Workout</div>
          </div>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 14 }}>
          {MY_WORKOUTS.map((w, i) => <WorkoutCard key={i} w={w} large />)}
          <div style={{
            border: `1px dashed ${CT.border}`, borderRadius: 8, padding: 22,
            display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
            gap: 6, color: CT.textSecondary, minHeight: 160,
          }}>
            <div style={{ fontFamily: CT.fontMono, fontSize: 28, fontWeight: 700, color: CT.textDisabled }}>+</div>
            <div style={{ fontSize: 13, fontWeight: 600 }}>Build a new workout</div>
            <div style={{ fontSize: 11, color: CT.textDisabled }}>Or duplicate from a template</div>
          </div>
        </div>
      </div>
    </DesktopFrame>
  );
}

Object.assign(window, { MyWorkoutsMobile, MyWorkoutsDesktop });
