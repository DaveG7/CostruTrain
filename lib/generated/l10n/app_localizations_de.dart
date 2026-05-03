// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get navLibrary => 'Library';

  @override
  String get navCompose => 'Compose';

  @override
  String get navHistory => 'History';

  @override
  String get navSettings => 'Settings';

  @override
  String get seedingProgress => 'Setting up your exercise library…';

  @override
  String get seedError => 'Something went wrong. Please try again.';

  @override
  String get seedRetry => 'Retry';

  @override
  String get exercisesEmpty => 'No exercises found.';

  @override
  String get searchExercises => 'Search exercises…';

  @override
  String get noExercisesFound => 'No exercises found';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get filterExercises => 'Filter exercises';

  @override
  String get myWorkouts => 'My Workouts';

  @override
  String get newWorkout => 'New Workout';

  @override
  String get noWorkoutsYet => 'No workouts yet';

  @override
  String get noWorkoutsYetHint => 'Tap + to build your first workout';

  @override
  String workoutDeleted(String name) {
    return '$name deleted';
  }

  @override
  String workoutDuplicated(String name) {
    return '$name (copy) saved';
  }

  @override
  String get undo => 'Undo';

  @override
  String get duplicate => 'Duplicate';

  @override
  String steps(int count) {
    return '$count steps';
  }

  @override
  String get composerTitle => 'New Workout';

  @override
  String get saveWorkout => 'Save';

  @override
  String get discardChanges => 'Discard changes?';

  @override
  String get discardChangesMessage => 'You have unsaved changes. Discard them?';

  @override
  String get discard => 'Discard';

  @override
  String get addStep => 'Add step';

  @override
  String get addExercise => 'Exercise';

  @override
  String get addRest => 'Rest';

  @override
  String get addCircuit => 'Circuit';

  @override
  String get addCountdown => 'Countdown';

  @override
  String wrapInCircuit(int count) {
    return 'Wrap $count in Circuit';
  }

  @override
  String get circuitRounds => 'Rounds';

  @override
  String get selectContiguousSteps => 'Select contiguous steps only';

  @override
  String get stepModReps => 'Reps';

  @override
  String get stepModeTimed => 'Timed';

  @override
  String get stepModeAmrap => 'AMRAP';

  @override
  String get sets => 'Sets';

  @override
  String get reps => 'Reps';

  @override
  String get duration => 'Duration';

  @override
  String get rest => 'Rest';

  @override
  String get tempo => 'Tempo';

  @override
  String get tempoEccentric => 'Eccentric';

  @override
  String get tempoPause => 'Pause';

  @override
  String get tempoConcentric => 'Concentric';

  @override
  String get saveStep => 'Save';

  @override
  String get playComingSoon => 'Coming in Phase 3';

  @override
  String get workoutNameHint => 'Workout name';

  @override
  String get addTag => '+ tag';
}
