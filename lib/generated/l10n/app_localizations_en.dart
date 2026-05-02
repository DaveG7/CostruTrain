// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
}
