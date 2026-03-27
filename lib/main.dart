import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'shared/providers/app_settings_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final themeRaw = prefs.getString(ThemeModeController.storageKey);
  final localeRaw = prefs.getString(LocaleController.storageKey);
  final onboardingSeen =
      prefs.getBool(OnboardingController.storageKey) ?? false;

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        initialThemeModeProvider.overrideWithValue(
          ThemeModeController.fromStorage(themeRaw),
        ),
        initialLocaleProvider.overrideWithValue(
          LocaleController.fromStorage(localeRaw),
        ),
        initialOnboardingSeenProvider.overrideWithValue(onboardingSeen),
      ],
      child: const NoorApp(),
    ),
  );
}
