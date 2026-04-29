// screen-library.jsx — Exercise Library

function FilterChip({ children, active, dismissible }) {
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 6,
      padding: '6px 10px', borderRadius: 999,
      fontSize: 11, fontWeight: 600, letterSpacing: 0.4,
      background: active ? CT.red : 'transparent',
      color: active ? '#0F0F0F' : CT.text,
      border: `1px solid ${active ? CT.red : CT.border}`,
      whiteSpace: 'nowrap',
    }}>
      {children}
      {dismissible && <span style={{ fontFamily: CT.fontMono, opacity: 0.7, fontSize: 12 }}>✕</span>}
    </span>
  );
}

function SearchBar({ placeholder = 'Search 1,300 exercises…' }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 10,
      background: CT.surface, border: `1px solid ${CT.border}`,
      borderRadius: 8, padding: '10px 12px',
    }}>
      <span style={{ fontFamily: CT.fontMono, color: CT.textSecondary, fontSize: 14 }}>⌕</span>
      <span style={{ flex: 1, color: CT.textSecondary, fontSize: 13 }}>{placeholder}</span>
      <Chip mono style={{ borderColor: CT.borderSoft }}>⌘K</Chip>
    </div>
  );
}

function ExerciseCard({ ex, size = 'md' }) {
  const cardW = size === 'lg' ? 200 : (size === 'sm' ? 140 : 160);
  return (
    <div style={{
      background: CT.surface, border: `1px solid ${CT.border}`,
      borderRadius: CT.radiusCard, overflow: 'hidden',
      display: 'flex', flexDirection: 'column',
    }}>
      <GifPlaceholder label={ex.name.toUpperCase()} width="100%" height={cardW * 0.85} style={{ borderRadius: 0, border: 'none', borderBottom: `1px solid ${CT.borderSoft}` }} />
      <div style={{ padding: '10px 11px 11px', display: 'flex', flexDirection: 'column', gap: 7 }}>
        <div style={{ fontSize: 13, fontWeight: 600, letterSpacing: -0.1, lineHeight: 1.2 }}>{ex.name}</div>
        <div style={{ display: 'flex', gap: 4, flexWrap: 'wrap' }}>
          <Chip>{ex.body}</Chip>
          <Chip>{ex.equip}</Chip>
        </div>
      </div>
    </div>
  );
}

// ── Mobile (390 × 844) ────────────────────────────────────
function LibraryMobile() {
  return (
    <MobileFrame>
      <MobileTopBar
        title="Library"
        sub="1,304 exercises · offline"
        right={<>
          <IconBtn glyph="⌕" />
          <IconBtn glyph="≡" badge="3" />
        </>}
      />
      <div style={{ padding: '12px 16px 0' }}>
        <SearchBar />
        <div style={{ display: 'flex', gap: 6, marginTop: 12, flexWrap: 'wrap' }}>
          <FilterChip active dismissible>Full Body</FilterChip>
          <FilterChip dismissible>Barbell</FilterChip>
          <FilterChip dismissible>Quads</FilterChip>
          <FilterChip>+ Filter</FilterChip>
        </div>
      </div>
      <div style={{ flex: 1, overflow: 'hidden', padding: '14px 16px 14px', display: 'flex', flexDirection: 'column', gap: 12 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
          <MetaLabel>Showing 86 results</MetaLabel>
          <MetaLabel style={{ color: CT.textDisabled }}>Sorted A–Z</MetaLabel>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
          {EXERCISES.slice(0, 6).map((e, i) => <ExerciseCard key={i} ex={e} />)}
        </div>
      </div>
      <MobileTabBar active="Library" />
    </MobileFrame>
  );
}

// ── Desktop (1280 × 820) ─────────────────────────────────
function LibraryDesktop() {
  return (
    <DesktopFrame title="Exercise Library" sub="1,304 exercises · 86 matching" active="Library">
      <div style={{ display: 'grid', gridTemplateColumns: '240px 1fr 320px', height: '100%', minHeight: 0 }}>
        {/* Filter rail */}
        <div style={{ borderRight: `1px solid ${CT.borderSoft}`, padding: '20px 18px', overflow: 'auto', display: 'flex', flexDirection: 'column', gap: 18 }}>
          <div>
            <MetaLabel>Body Part</MetaLabel>
            <div style={{ marginTop: 10, display: 'flex', flexDirection: 'column', gap: 6 }}>
              {['Full Body', 'Back', 'Chest', 'Legs', 'Shoulders', 'Core', 'Cardio'].map((b, i) => (
                <div key={b} style={{ display: 'flex', alignItems: 'center', gap: 9, fontSize: 12.5, color: i === 0 ? CT.text : CT.textSecondary }}>
                  <span style={{ width: 12, height: 12, border: `1.5px solid ${i === 0 ? CT.red : CT.border}`, background: i === 0 ? CT.red : 'transparent', borderRadius: 3 }}/>
                  {b}
                  <span style={{ marginLeft: 'auto', fontFamily: CT.fontMono, fontSize: 10, color: CT.textDisabled }}>{[238,182,166,210,144,98,76][i]}</span>
                </div>
              ))}
            </div>
          </div>
          <div>
            <MetaLabel>Equipment</MetaLabel>
            <div style={{ marginTop: 10, display: 'flex', flexDirection: 'column', gap: 6 }}>
              {['Barbell', 'Dumbbell', 'Kettlebell', 'Bodyweight', 'Pull-bar', 'Box'].map((b, i) => (
                <div key={b} style={{ display: 'flex', alignItems: 'center', gap: 9, fontSize: 12.5, color: i === 0 ? CT.text : CT.textSecondary }}>
                  <span style={{ width: 12, height: 12, border: `1.5px solid ${i === 0 ? CT.red : CT.border}`, background: i === 0 ? CT.red : 'transparent', borderRadius: 3 }}/>
                  {b}
                </div>
              ))}
            </div>
          </div>
          <div>
            <MetaLabel>Target Muscle</MetaLabel>
            <div style={{ marginTop: 10, display: 'flex', flexDirection: 'column', gap: 6 }}>
              {['Quads', 'Hamstrings', 'Glutes', 'Lats', 'Pecs', 'Delts'].map((b, i) => (
                <div key={b} style={{ display: 'flex', alignItems: 'center', gap: 9, fontSize: 12.5, color: i === 0 ? CT.text : CT.textSecondary }}>
                  <span style={{ width: 12, height: 12, border: `1.5px solid ${i === 0 ? CT.red : CT.border}`, background: i === 0 ? CT.red : 'transparent', borderRadius: 3 }}/>
                  {b}
                </div>
              ))}
            </div>
          </div>
        </div>
        {/* Grid */}
        <div style={{ padding: 20, overflow: 'auto', display: 'flex', flexDirection: 'column', gap: 14 }}>
          <SearchBar />
          <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
            <FilterChip active dismissible>Full Body</FilterChip>
            <FilterChip dismissible>Barbell</FilterChip>
            <FilterChip dismissible>Quads</FilterChip>
            <FilterChip>+ Add filter</FilterChip>
            <span style={{ marginLeft: 'auto', alignSelf: 'center' }}><MetaLabel>86 results</MetaLabel></span>
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 12 }}>
            {EXERCISES.slice(0, 12).map((e, i) => <ExerciseCard key={i} ex={e} />)}
          </div>
        </div>
        {/* Detail panel */}
        <div style={{ borderLeft: `1px solid ${CT.borderSoft}`, padding: 20, overflow: 'auto', display: 'flex', flexDirection: 'column', gap: 14 }}>
          <MetaLabel>Selected · 1 of 86</MetaLabel>
          <GifPlaceholder label="BARBELL THRUSTER" width="100%" height={260} />
          <div>
            <div style={{ fontSize: 18, fontWeight: 700, letterSpacing: -0.3 }}>Barbell Thruster</div>
            <div style={{ fontSize: 12, color: CT.textSecondary, marginTop: 4 }}>Compound · CrossFit benchmark</div>
          </div>
          <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
            <Chip>Full Body</Chip>
            <Chip>Barbell</Chip>
            <Chip color={CT.red} border={CT.redDim}>Quads · primary</Chip>
            <Chip>Glutes</Chip>
            <Chip>Delts</Chip>
          </div>
          <div style={{ borderTop: `1px solid ${CT.borderSoft}`, paddingTop: 14, display: 'flex', flexDirection: 'column', gap: 10 }}>
            <MetaLabel>Performance · last 30d</MetaLabel>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
              {[['Sessions', '12'], ['Total reps', '420'], ['Best set', '15 × 95lb'], ['1RM est.', '155 lb']].map(([l, v]) => (
                <div key={l} style={{ background: CT.surface, border: `1px solid ${CT.border}`, borderRadius: 6, padding: 10 }}>
                  <div style={{ fontFamily: CT.fontMono, fontSize: 9, color: CT.textSecondary, letterSpacing: 1.2, textTransform: 'uppercase' }}>{l}</div>
                  <div style={{ fontFamily: CT.fontMono, fontSize: 18, fontWeight: 700, marginTop: 4 }}>{v}</div>
                </div>
              ))}
            </div>
          </div>
          <div style={{ marginTop: 'auto', display: 'flex', gap: 8 }}>
            <div style={{ flex: 1, padding: '11px 14px', borderRadius: 6, background: CT.red, color: '#0F0F0F', fontWeight: 700, fontSize: 13, textAlign: 'center' }}>+ Add to workout</div>
            <div style={{ padding: '11px 14px', borderRadius: 6, border: `1px solid ${CT.border}`, fontSize: 13, color: CT.text }}>★</div>
          </div>
        </div>
      </div>
    </DesktopFrame>
  );
}

Object.assign(window, { LibraryMobile, LibraryDesktop, ExerciseCard, FilterChip, SearchBar });
