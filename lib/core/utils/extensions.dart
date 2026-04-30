import 'package:flutter/widgets.dart';
import 'package:costrutrain/generated/l10n/app_localizations.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

