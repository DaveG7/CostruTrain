import 'dart:async';

import 'package:audioplayers/audioplayers.dart' hide PlayerState;
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/models/session.dart';
import '../../../core/models/workout.dart';
import '../../../core/player/player_phase.dart';
import '../../../core/player/player_state.dart';
import '../../../core/player/player_state_machine.dart';
import '../../../data/repositories/drift_session_repository.dart';
import '../../history/providers/history_notifier.dart';
import '../../settings/providers/settings_notifier.dart';

part 'player_notifier.g.dart';

final _log = Logger();

@Riverpod(keepAlive: true)
class PlayerNotifier extends _$PlayerNotifier {
  final _machine = PlayerStateMachine();
  Timer? _timer;
  AudioPlayer? _beepPlayer;
  AudioPlayer? _bellPlayer;

  String? _sessionId;
  DateTime? _startedAt;
  String? _workoutId;
  String? _workoutNameSnapshot;

  @override
  PlayerState build() => PlayerState.idle();

  Future<void> start(Workout workout) async {
    _timer?.cancel();
    _beepPlayer?.dispose();
    _bellPlayer?.dispose();

    _sessionId = const Uuid().v4();
    _startedAt = DateTime.now();
    _workoutId = workout.id;
    _workoutNameSnapshot = workout.name;

    await WakelockPlus.enable();
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _beepPlayer = AudioPlayer();
    _bellPlayer = AudioPlayer();
    try {
      await _beepPlayer!.setSource(AssetSource('audio/beep.mp3'));
      await _bellPlayer!.setSource(AssetSource('audio/bell.mp3'));
    } catch (e) {
      _log.w('Audio preload failed', error: e);
    }

    state = _machine.transition(state, PlayerEvent.start, workout: workout);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  void _onTick() {
    state = _machine.transition(state, PlayerEvent.tick);
    _afterTransition();
  }

  void _afterTransition() {
    _fireAudio();
    if (state.phase == PlayerPhase.complete) _onComplete();
  }

  void skip() {
    state = _machine.transition(state, PlayerEvent.skip);
    _afterTransition();
  }

  void back() {
    state = _machine.transition(state, PlayerEvent.back);
    _afterTransition();
  }

  void pause() => state = _machine.transition(state, PlayerEvent.pause);
  void resume() => state = _machine.transition(state, PlayerEvent.resume);

  void quit() {
    _saveSession(wasCompleted: false);
    _cleanup();
    state = PlayerState.idle();
  }

  void _fireAudio() {
    final settings = ref.read(settingsNotifierProvider);
    if (!settings.audioCuesEnabled) return;
    if (state.shouldPlayBeep) {
      _beepPlayer?.play(AssetSource('audio/beep.mp3'));
    }
    if (state.ringBellThisTick) {
      _bellPlayer?.play(AssetSource('audio/bell.mp3'));
    }
  }

  void _onComplete() {
    _saveSession(wasCompleted: true);
    _cleanup();
    // state stays at PlayerPhase.complete — PlayerScreen shows FINISHED UI
  }

  void _saveSession({required bool wasCompleted}) {
    final now = DateTime.now();
    final totalSeconds =
        now.difference(_startedAt!).inSeconds.clamp(0, 999999).toInt();
    final session = Session(
      id: _sessionId!,
      workoutId: _workoutId,
      workoutNameSnapshot: _workoutNameSnapshot!,
      startedAt: _startedAt!,
      completedAt: wasCompleted ? now : null,
      totalSeconds: totalSeconds,
      stepCount: state.sequence.length,
      wasCompleted: wasCompleted,
    );
    ref
        .read(sessionRepositoryProvider)
        .save(session)
        .catchError((e) {
      _log.e('session save failed', error: e);
      return session;
    });
    ref.invalidate(historyNotifierProvider);
  }

  void _cleanup() {
    _timer?.cancel();
    _timer = null;
    _beepPlayer?.dispose();
    _bellPlayer?.dispose();
    _beepPlayer = null;
    _bellPlayer = null;
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
