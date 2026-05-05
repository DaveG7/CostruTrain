// lib/core/player/player_phase.dart

enum PlayerPhase { idle, countdown, working, resting, complete }

enum PlayerEvent { start, tick, skip, back, pause, resume, quit }
