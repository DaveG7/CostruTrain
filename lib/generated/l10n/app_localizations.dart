import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// Bottom nav label — Exercise Library tab
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// Bottom nav label — Workout Composer tab
  ///
  /// In en, this message translates to:
  /// **'Compose'**
  String get navCompose;

  /// Bottom nav label — Session History tab
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// Bottom nav label — Settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Progress message during first-launch seeding
  ///
  /// In en, this message translates to:
  /// **'Setting up your exercise library…'**
  String get seedingProgress;

  /// Error message when seeding fails
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get seedError;

  /// Retry button label after seed failure
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get seedRetry;

  /// Empty state label on exercise list screen
  ///
  /// In en, this message translates to:
  /// **'No exercises found.'**
  String get exercisesEmpty;

  /// Placeholder text in the exercise search bar
  ///
  /// In en, this message translates to:
  /// **'Search exercises…'**
  String get searchExercises;

  /// Empty state when search/filter returns nothing
  ///
  /// In en, this message translates to:
  /// **'No exercises found'**
  String get noExercisesFound;

  /// Button to reset all active filters
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// Tooltip for the filter FAB
  ///
  /// In en, this message translates to:
  /// **'Filter exercises'**
  String get filterExercises;

  /// No description provided for @myWorkouts.
  ///
  /// In en, this message translates to:
  /// **'My Workouts'**
  String get myWorkouts;

  /// No description provided for @newWorkout.
  ///
  /// In en, this message translates to:
  /// **'New Workout'**
  String get newWorkout;

  /// No description provided for @noWorkoutsYet.
  ///
  /// In en, this message translates to:
  /// **'No workouts yet'**
  String get noWorkoutsYet;

  /// No description provided for @noWorkoutsYetHint.
  ///
  /// In en, this message translates to:
  /// **'Tap + to build your first workout'**
  String get noWorkoutsYetHint;

  /// No description provided for @workoutDeleted.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String workoutDeleted(String name);

  /// No description provided for @workoutDuplicated.
  ///
  /// In en, this message translates to:
  /// **'{name} (copy) saved'**
  String workoutDuplicated(String name);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'{count} steps'**
  String steps(int count);

  /// No description provided for @composerTitle.
  ///
  /// In en, this message translates to:
  /// **'New Workout'**
  String get composerTitle;

  /// No description provided for @saveWorkout.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveWorkout;

  /// No description provided for @discardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardChanges;

  /// No description provided for @discardChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Discard them?'**
  String get discardChangesMessage;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @addStep.
  ///
  /// In en, this message translates to:
  /// **'Add step'**
  String get addStep;

  /// No description provided for @addExercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get addExercise;

  /// No description provided for @addRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get addRest;

  /// No description provided for @addCircuit.
  ///
  /// In en, this message translates to:
  /// **'Circuit'**
  String get addCircuit;

  /// No description provided for @addCountdown.
  ///
  /// In en, this message translates to:
  /// **'Countdown'**
  String get addCountdown;

  /// No description provided for @wrapInCircuit.
  ///
  /// In en, this message translates to:
  /// **'Wrap {count} in Circuit'**
  String wrapInCircuit(int count);

  /// No description provided for @cancelCircuitSelect.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelCircuitSelect;

  /// No description provided for @circuitRounds.
  ///
  /// In en, this message translates to:
  /// **'Rounds'**
  String get circuitRounds;

  /// No description provided for @selectContiguousSteps.
  ///
  /// In en, this message translates to:
  /// **'Select contiguous steps only'**
  String get selectContiguousSteps;

  /// No description provided for @stepModReps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get stepModReps;

  /// No description provided for @stepModeTimed.
  ///
  /// In en, this message translates to:
  /// **'Timed'**
  String get stepModeTimed;

  /// No description provided for @stepModeAmrap.
  ///
  /// In en, this message translates to:
  /// **'AMRAP'**
  String get stepModeAmrap;

  /// No description provided for @sets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get sets;

  /// No description provided for @reps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get reps;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @rest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get rest;

  /// No description provided for @tempo.
  ///
  /// In en, this message translates to:
  /// **'Tempo'**
  String get tempo;

  /// No description provided for @tempoEccentric.
  ///
  /// In en, this message translates to:
  /// **'Eccentric'**
  String get tempoEccentric;

  /// No description provided for @tempoPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get tempoPause;

  /// No description provided for @tempoConcentric.
  ///
  /// In en, this message translates to:
  /// **'Concentric'**
  String get tempoConcentric;

  /// No description provided for @saveStep.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveStep;

  /// No description provided for @workoutNameHint.
  ///
  /// In en, this message translates to:
  /// **'Workout name'**
  String get workoutNameHint;

  /// No description provided for @addTag.
  ///
  /// In en, this message translates to:
  /// **'+ tag'**
  String get addTag;

  /// No description provided for @playerPhaseCountdown.
  ///
  /// In en, this message translates to:
  /// **'GET READY'**
  String get playerPhaseCountdown;

  /// No description provided for @playerPhaseWork.
  ///
  /// In en, this message translates to:
  /// **'WORK'**
  String get playerPhaseWork;

  /// No description provided for @playerPhaseRest.
  ///
  /// In en, this message translates to:
  /// **'REST'**
  String get playerPhaseRest;

  /// No description provided for @playerPhaseDone.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get playerPhaseDone;

  /// No description provided for @playerRound.
  ///
  /// In en, this message translates to:
  /// **'ROUND {current} / {total}'**
  String playerRound(int current, int total);

  /// No description provided for @playerComplete.
  ///
  /// In en, this message translates to:
  /// **'WORKOUT COMPLETE'**
  String get playerComplete;

  /// No description provided for @playerNextUp.
  ///
  /// In en, this message translates to:
  /// **'NEXT UP'**
  String get playerNextUp;

  /// No description provided for @playerPause.
  ///
  /// In en, this message translates to:
  /// **'PAUSE'**
  String get playerPause;

  /// No description provided for @playerResume.
  ///
  /// In en, this message translates to:
  /// **'RESUME'**
  String get playerResume;

  /// No description provided for @playerSaveSession.
  ///
  /// In en, this message translates to:
  /// **'SAVE SESSION'**
  String get playerSaveSession;

  /// No description provided for @playerTimerRemaining.
  ///
  /// In en, this message translates to:
  /// **'REMAINING'**
  String get playerTimerRemaining;

  /// No description provided for @playerTimerElapsed.
  ///
  /// In en, this message translates to:
  /// **'ELAPSED'**
  String get playerTimerElapsed;

  /// No description provided for @playerGetReadyLabel.
  ///
  /// In en, this message translates to:
  /// **'Get Ready'**
  String get playerGetReadyLabel;

  /// No description provided for @playerRestLabel.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get playerRestLabel;

  /// No description provided for @playerCountdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Countdown'**
  String get playerCountdownLabel;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet.\nStart a workout to see your history.'**
  String get historyEmpty;

  /// No description provided for @historyGroupThisWeek.
  ///
  /// In en, this message translates to:
  /// **'THIS WEEK'**
  String get historyGroupThisWeek;

  /// No description provided for @historyGroupLastWeek.
  ///
  /// In en, this message translates to:
  /// **'LAST WEEK'**
  String get historyGroupLastWeek;

  /// No description provided for @sessionCompleted.
  ///
  /// In en, this message translates to:
  /// **'COMPLETED'**
  String get sessionCompleted;

  /// No description provided for @sessionAbandoned.
  ///
  /// In en, this message translates to:
  /// **'ABANDONED'**
  String get sessionAbandoned;

  /// No description provided for @sessionSteps.
  ///
  /// In en, this message translates to:
  /// **'{count} steps'**
  String sessionSteps(int count);

  /// No description provided for @sessionDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get sessionDetailTitle;

  /// No description provided for @sessionDetailDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get sessionDetailDuration;

  /// No description provided for @sessionDetailStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get sessionDetailStarted;

  /// No description provided for @sessionDetailSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get sessionDetailSteps;

  /// No description provided for @sessionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Session not found'**
  String get sessionNotFound;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAudioCues.
  ///
  /// In en, this message translates to:
  /// **'Audio cues during workout'**
  String get settingsAudioCues;

  /// Settings toggle label for haptic feedback
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get settingsHaptics;

  /// Settings slider label for default rest time
  ///
  /// In en, this message translates to:
  /// **'Default rest time'**
  String get settingsDefaultRestTime;

  /// Live label on the default rest time slider
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String settingsDefaultRestTimeValue(int seconds);

  /// Settings tile to export the SQLite database file
  ///
  /// In en, this message translates to:
  /// **'Export app data'**
  String get settingsExportData;

  /// SnackBar shown after successful DB export
  ///
  /// In en, this message translates to:
  /// **'Database exported.'**
  String get settingsExportSuccess;

  /// SnackBar shown when Export app data is tapped on the web platform
  ///
  /// In en, this message translates to:
  /// **'Export isn\'t available in the web version yet — try the desktop or mobile app.'**
  String get settingsExportNotSupportedOnWeb;

  /// SnackBar shown when the native DB export throws
  ///
  /// In en, this message translates to:
  /// **'Export failed. Please try again.'**
  String get settingsExportFailed;

  /// Onboarding screen 1 headline
  ///
  /// In en, this message translates to:
  /// **'Build your training.'**
  String get onboardingHeadline1;

  /// Onboarding screen 1 body text
  ///
  /// In en, this message translates to:
  /// **'No account needed. No cloud. Your data stays on your device.'**
  String get onboardingBody1;

  /// Onboarding screen 1 CTA
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// Onboarding screen 2 headline
  ///
  /// In en, this message translates to:
  /// **'Start with a template or build from scratch.'**
  String get onboardingHeadline2;

  /// Onboarding screen 2 — start with blank composer
  ///
  /// In en, this message translates to:
  /// **'Start empty'**
  String get onboardingStartEmpty;

  /// Empty state headline on My Workouts screen
  ///
  /// In en, this message translates to:
  /// **'No workouts yet.'**
  String get emptyWorkouts;

  /// CTA button on My Workouts empty state
  ///
  /// In en, this message translates to:
  /// **'Create your first workout'**
  String get emptyWorkoutsCta;

  /// Empty state headline on History screen
  ///
  /// In en, this message translates to:
  /// **'No sessions yet.'**
  String get emptySessions;

  /// CTA button on History empty state
  ///
  /// In en, this message translates to:
  /// **'Start a workout'**
  String get emptySessionsCta;

  /// CTA button on Library no-results empty state
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get emptySearchResultsCta;

  /// DB error screen headline
  ///
  /// In en, this message translates to:
  /// **'Something went wrong loading your data.'**
  String get errorDbHeadline;

  /// ExpansionTile label hiding the nuclear option
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get errorDbAdvanced;

  /// Nuclear option button inside Advanced tile
  ///
  /// In en, this message translates to:
  /// **'Reset app data'**
  String get errorDbReset;

  /// Confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Reset app data?'**
  String get errorDbResetTitle;

  /// Confirmation dialog body
  ///
  /// In en, this message translates to:
  /// **'This will delete all your workouts and session history. This cannot be undone.'**
  String get errorDbResetBody;

  /// Destructive confirm button
  ///
  /// In en, this message translates to:
  /// **'Reset everything'**
  String get errorDbResetConfirm;

  /// Cancel button in reset dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get errorDbResetCancel;

  /// Chip shown on WorkoutCard for seeded template workouts
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get templateChipLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
