import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_filter_notifier.g.dart';

class LibraryFilterState {
  const LibraryFilterState({
    this.query = '',
    this.bodyPart,
    this.equipment,
    this.muscleGroup,
  });

  final String query;
  final String? bodyPart;
  final String? equipment;
  final String? muscleGroup;

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      bodyPart != null ||
      equipment != null ||
      muscleGroup != null;

  LibraryFilterState copyWith({
    String? query,
    Object? bodyPart = _sentinel,
    Object? equipment = _sentinel,
    Object? muscleGroup = _sentinel,
  }) =>
      LibraryFilterState(
        query: query ?? this.query,
        bodyPart: bodyPart == _sentinel ? this.bodyPart : bodyPart as String?,
        equipment: equipment == _sentinel ? this.equipment : equipment as String?,
        muscleGroup: muscleGroup == _sentinel ? this.muscleGroup : muscleGroup as String?,
      );
}

const _sentinel = Object();

@Riverpod(keepAlive: true)
class LibraryFilter extends _$LibraryFilter {
  Timer? _debounce;

  @override
  LibraryFilterState build() {
    ref.onDispose(() => _debounce?.cancel());
    return const LibraryFilterState();
  }

  /// Debounced — state.query updates 300ms after the last call.
  void setQuery(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      state = state.copyWith(query: value);
    });
  }

  void setBodyPart(String? value) => state = state.copyWith(bodyPart: value);
  void setEquipment(String? value) => state = state.copyWith(equipment: value);
  void setMuscleGroup(String? value) => state = state.copyWith(muscleGroup: value);

  void clearAll() {
    _debounce?.cancel();
    state = const LibraryFilterState();
  }
}
