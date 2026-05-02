// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_search_results_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exerciseSearchResultsHash() =>
    r'8cf4c004eb3dbf1d165b5ace96f2fdf3d85ff428';

/// Drives the exercise list. autoDispose tears it down on tab switch.
/// Debounce lives in LibraryFilterNotifier.setQuery() — no Future.delayed here.
///
/// Copied from [exerciseSearchResults].
@ProviderFor(exerciseSearchResults)
final exerciseSearchResultsProvider =
    AutoDisposeFutureProvider<List<Exercise>>.internal(
  exerciseSearchResults,
  name: r'exerciseSearchResultsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$exerciseSearchResultsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExerciseSearchResultsRef = AutoDisposeFutureProviderRef<List<Exercise>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
