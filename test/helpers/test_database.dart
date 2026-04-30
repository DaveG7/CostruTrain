import 'package:drift/native.dart';
import 'package:costrutrain/data/local/app_database.dart';

/// Creates an in-memory AppDatabase for use in tests.
/// Lives in test/ to keep dart:ffi out of the web build.
AppDatabase createTestDatabase() => AppDatabase(NativeDatabase.memory());
