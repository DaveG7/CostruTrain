import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/local/shared_prefs_provider.dart';
import 'shared/widgets/db_error_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await runCostruTrainApp();
  } catch (e) {
    // DB failed to open — show error screen with nuclear option.
    runApp(MaterialApp(
      home: DbErrorScreen(onRetry: () => main()),
    ));
  }
}

Future<void> runCostruTrainApp() async {
  final prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
    child: const CostruTrainApp(),
  ));
}
