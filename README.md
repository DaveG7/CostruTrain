# CostruTrain

> Build your training. Own your data.

A privacy-first, open-source workout composer and player for people who actually program their own training — CrossFit, strength, HIIT, home gym.

---

## Features

- **1300+ exercises** with GIFs, fully offline
- **Workout composer** — build workouts step by step: reps, timed, AMRAP, circuits, countdowns
- **Full-screen player** — countdown ring, audio cues, phase labels (GET READY / WORK / REST / DONE)
- **Session history** — every completed workout logged automatically
- **Bundled templates** — Fran, Cindy, Tabata, EMOM 10, 5×5 Strength to get started
- **No account required** — your data never leaves your device unless you choose to export it

---

## Install

### Android APK

Download the latest APK from [Releases](../../releases).

### Build from source

```bash
git clone https://github.com/DaveG7/CostruTrain.git
cd CostruTrain
flutter pub get
flutter run
```

Requires Flutter 3.x. Tested on Android, Web, and macOS.

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Flutter 3.x (Dart) |
| State | Riverpod (riverpod_annotation) |
| Local DB | Drift (SQLite ORM) |
| Routing | go_router |
| Media | flutter_cache_manager |

---

## License

[AGPL-3.0](LICENSE) — free to use, modify, and self-host. Closed forks that offer this as a commercial service must open-source their changes.

---

## Contributing

PRs welcome. Please open an issue first for large changes to discuss the approach.
