// data.jsx — sample exercise + workout content for the mockups

const EXERCISES = [
  { name: 'Barbell Thruster',     body: 'Full Body', equip: 'Barbell',    primary: 'Quads',     mode: 'REPS' },
  { name: 'Pull-up',              body: 'Back',      equip: 'Pull-bar',   primary: 'Lats',      mode: 'REPS' },
  { name: 'Kettlebell Swing',     body: 'Full Body', equip: 'Kettlebell', primary: 'Glutes',    mode: 'REPS' },
  { name: 'Box Jump',             body: 'Legs',      equip: 'Box',        primary: 'Quads',     mode: 'REPS' },
  { name: 'Wall Ball',            body: 'Full Body', equip: 'Med Ball',   primary: 'Shoulders', mode: 'REPS' },
  { name: 'Toes-to-Bar',          body: 'Core',      equip: 'Pull-bar',   primary: 'Abs',       mode: 'REPS' },
  { name: 'Burpee',               body: 'Full Body', equip: 'Bodyweight', primary: 'Chest',     mode: 'TIMED' },
  { name: 'Double-Under',         body: 'Cardio',    equip: 'Jump Rope',  primary: 'Calves',    mode: 'REPS' },
  { name: 'Dumbbell Snatch',      body: 'Full Body', equip: 'Dumbbell',   primary: 'Shoulders', mode: 'REPS' },
  { name: 'Front Squat',          body: 'Legs',      equip: 'Barbell',    primary: 'Quads',     mode: 'REPS' },
  { name: 'Power Clean',          body: 'Full Body', equip: 'Barbell',    primary: 'Posterior', mode: 'REPS' },
  { name: 'Push Press',           body: 'Shoulders', equip: 'Barbell',    primary: 'Delts',     mode: 'REPS' },
  { name: 'Ring Dip',             body: 'Chest',     equip: 'Rings',      primary: 'Triceps',   mode: 'REPS' },
  { name: 'Rower (500m)',         body: 'Cardio',    equip: 'Rower',      primary: 'Posterior', mode: 'TIMED' },
  { name: 'Assault Bike',         body: 'Cardio',    equip: 'Bike',       primary: 'Quads',     mode: 'TIMED' },
  { name: 'Handstand Push-up',    body: 'Shoulders', equip: 'Bodyweight', primary: 'Delts',     mode: 'REPS' },
];

// Fran-style sample workout
const SAMPLE_WORKOUT = {
  name: 'Fran',
  tags: ['CrossFit', 'Benchmark', 'For Time'],
  estDuration: '6–9 min',
  steps: [
    { kind: 'COUNTDOWN', label: 'Get Ready', dur: 10 },
    { kind: 'CIRCUIT', rounds: 3, label: '21–15–9', steps: [
      { kind: 'EXERCISE', name: 'Barbell Thruster', mode: 'REPS', detail: '21 reps · 95/65 lb' },
      { kind: 'EXERCISE', name: 'Pull-up',          mode: 'REPS', detail: '21 reps · strict' },
    ]},
    { kind: 'EXERCISE',  name: 'Cooldown Walk', mode: 'TIMED', detail: '2:00' },
  ],
};

const MY_WORKOUTS = [
  { name: 'Fran',           tags: ['Benchmark', 'For Time'],  steps: 5, dur: '6–9 min',  last: '2 days ago',   sessions: 4 },
  { name: 'Helen',          tags: ['Benchmark', '3 Rounds'],  steps: 4, dur: '8–12 min', last: '5 days ago',   sessions: 2 },
  { name: 'EMOM 12 — Squat Clean', tags: ['EMOM', 'Strength'], steps: 13, dur: '12:00', last: 'Last week', sessions: 3 },
  { name: 'Tabata — 8 Round Burpee', tags: ['Tabata', 'Conditioning'], steps: 17, dur: '4:00', last: '2 weeks ago', sessions: 7 },
  { name: 'Dave\'s Saturday Hybrid', tags: ['Strength', 'Metcon'], steps: 9, dur: '38–45 min', last: '3 weeks ago', sessions: 1 },
];

const HISTORY = [
  { date: 'Today',          time: '07:14',  workout: 'Fran',                   dur: '7:42',  done: '5 / 5', pr: true },
  { date: 'Yesterday',      time: '06:45',  workout: 'EMOM 12 — Squat Clean',  dur: '12:00', done: '13 / 13', pr: false },
  { date: 'Apr 26',         time: '17:02',  workout: 'Tabata — 8 Round Burpee',dur: '4:00',  done: '17 / 17', pr: false },
  { date: 'Apr 24',         time: '06:50',  workout: 'Helen',                  dur: '11:38', done: '4 / 4',  pr: false },
  { date: 'Apr 22',         time: '18:30',  workout: 'Fran',                   dur: '8:05',  done: '5 / 5',  pr: false },
  { date: 'Apr 20',         time: '07:15',  workout: 'Dave\'s Saturday Hybrid',dur: '41:22', done: '9 / 9',  pr: false },
];

Object.assign(window, { EXERCISES, SAMPLE_WORKOUT, MY_WORKOUTS, HISTORY });
