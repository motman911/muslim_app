import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'services/firebase_bootstrap_service.dart';
import 'services/firebase_messaging_service.dart';
import 'shared/providers/app_settings_providers.dart';
import 'shared/providers/firebase_providers.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Ignore bootstrap failures in background isolate.
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isMobilePlatform = !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  if (isMobilePlatform) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
  final prefs = await SharedPreferences.getInstance();

  final themeRaw = prefs.getString(ThemeModeController.storageKey);
  final localeRaw = prefs.getString(LocaleController.storageKey);
  final onboardingSeen =
      prefs.getBool(OnboardingController.storageKey) ?? false;
  final firebaseBootstrap = await FirebaseBootstrapService().initialize(prefs);
  if (isMobilePlatform) {
    FirebaseMessagingService().setupForegroundHandlers();
  }

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
        firebaseReadyProvider.overrideWithValue(firebaseBootstrap.isReady),
        firebaseBootstrapErrorProvider
            .overrideWithValue(firebaseBootstrap.errorMessage),
        deviceIdProvider.overrideWithValue(firebaseBootstrap.deviceId),
      ],
      child: const NoorApp(),
    ),
  );
}
