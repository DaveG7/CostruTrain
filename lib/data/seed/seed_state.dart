import 'package:flutter/foundation.dart';

@immutable
class SeedState {
  const SeedState({required this.done, required this.total});

  final int done;
  final int total;

  bool get isDone => done >= total;

  @override
  bool operator ==(Object other) =>
      other is SeedState && other.done == done && other.total == total;

  @override
  int get hashCode => Object.hash(done, total);
}
