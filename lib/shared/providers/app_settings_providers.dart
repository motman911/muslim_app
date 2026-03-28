import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences override is required in main().');
});

final initialThemeModeProvider = Provider<ThemeMode>((ref) => ThemeMode.system);
final initialLocaleProvider = Provider<Locale>((ref) => const Locale('ar'));
final initialOnboardingSeenProvider = Provider<bool>((ref) => false);
final initialTextScaleProvider = Provider<double>((ref) => 1.0);
final initialLineHeightProvider = Provider<double>((ref) => 1.5);
final initialHighContrastProvider = Provider<bool>((ref) => false);
final initialAccessibilityGuideShownProvider = Provider<bool>((ref) => false);
final initialAccessibilityGuideDisabledProvider =
    Provider<bool>((ref) => false);

final themeModeControllerProvider =
    StateNotifierProvider<ThemeModeController, ThemeMode>(
  (ref) => ThemeModeController(
    prefs: ref.watch(sharedPreferencesProvider),
    initialMode: ref.watch(initialThemeModeProvider),
  ),
);

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>(
  (ref) => LocaleController(
    prefs: ref.watch(sharedPreferencesProvider),
    initialLocale: ref.watch(initialLocaleProvider),
  ),
);

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, bool>(
  (ref) => OnboardingController(
    prefs: ref.watch(sharedPreferencesProvider),
    initialSeen: ref.watch(initialOnboardingSeenProvider),
  ),
);

final textScaleControllerProvider =
    StateNotifierProvider<TextScaleController, double>(
  (ref) => TextScaleController(
    prefs: ref.watch(sharedPreferencesProvider),
    initialScale: ref.watch(initialTextScaleProvider),
  ),
);

final lineHeightControllerProvider =
    StateNotifierProvider<LineHeightController, double>(
  (ref) => LineHeightController(
    prefs: ref.watch(sharedPreferencesProvider),
    initialHeight: ref.watch(initialLineHeightProvider),
  ),
);

final highContrastControllerProvider =
    StateNotifierProvider<HighContrastController, bool>(
  (ref) => HighContrastController(
    prefs: ref.watch(sharedPreferencesProvider),
    initialValue: ref.watch(initialHighContrastProvider),
  ),
);

final accessibilityGuideShownControllerProvider =
    StateNotifierProvider<AccessibilityGuideShownController, bool>(
  (ref) => AccessibilityGuideShownController(
    prefs: ref.watch(sharedPreferencesProvider),
    initialValue: ref.watch(initialAccessibilityGuideShownProvider),
  ),
);

final accessibilityGuideDisabledControllerProvider =
    StateNotifierProvider<AccessibilityGuideDisabledController, bool>(
  (ref) => AccessibilityGuideDisabledController(
    prefs: ref.watch(sharedPreferencesProvider),
    initialValue: ref.watch(initialAccessibilityGuideDisabledProvider),
  ),
);

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController(
      {required SharedPreferences prefs, required ThemeMode initialMode})
      : _prefs = prefs,
        super(initialMode);

  static const storageKey = 'app_theme_mode';
  final SharedPreferences _prefs;

  static ThemeMode fromStorage(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(storageKey, mode.name);
  }
}

class LocaleController extends StateNotifier<Locale> {
  LocaleController(
      {required SharedPreferences prefs, required Locale initialLocale})
      : _prefs = prefs,
        super(initialLocale);

  static const storageKey = 'app_locale_code';
  final SharedPreferences _prefs;

  static Locale fromStorage(String? code) {
    if (code == 'en' || code == 'fr' || code == 'ar') {
      return Locale(code!);
    }
    return const Locale('ar');
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _prefs.setString(storageKey, locale.languageCode);
  }
}

class OnboardingController extends StateNotifier<bool> {
  OnboardingController(
      {required SharedPreferences prefs, required bool initialSeen})
      : _prefs = prefs,
        super(initialSeen);

  static const storageKey = 'onboarding_seen';
  final SharedPreferences _prefs;

  Future<void> complete() async {
    state = true;
    await _prefs.setBool(storageKey, true);
  }
}

class TextScaleController extends StateNotifier<double> {
  TextScaleController({
    required SharedPreferences prefs,
    required double initialScale,
  })  : _prefs = prefs,
        super(initialScale);

  static const storageKey = 'app_text_scale';
  final SharedPreferences _prefs;

  static double fromStorage(double? value) {
    if (value == null) {
      return 1.0;
    }
    return value.clamp(0.9, 1.3);
  }

  Future<void> setScale(double scale) async {
    final next = scale.clamp(0.9, 1.3);
    state = next;
    await _prefs.setDouble(storageKey, next);
  }
}

class LineHeightController extends StateNotifier<double> {
  LineHeightController({
    required SharedPreferences prefs,
    required double initialHeight,
  })  : _prefs = prefs,
        super(initialHeight);

  static const storageKey = 'app_line_height';
  final SharedPreferences _prefs;

  static double fromStorage(double? value) {
    if (value == null) {
      return 1.5;
    }
    return value.clamp(1.2, 2.0);
  }

  Future<void> setHeight(double height) async {
    final next = height.clamp(1.2, 2.0);
    state = next;
    await _prefs.setDouble(storageKey, next);
  }
}

class HighContrastController extends StateNotifier<bool> {
  HighContrastController({
    required SharedPreferences prefs,
    required bool initialValue,
  })  : _prefs = prefs,
        super(initialValue);

  static const storageKey = 'app_high_contrast';
  final SharedPreferences _prefs;

  static bool fromStorage(bool? value) => value ?? false;

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await _prefs.setBool(storageKey, enabled);
  }
}

class AccessibilityGuideShownController extends StateNotifier<bool> {
  AccessibilityGuideShownController({
    required SharedPreferences prefs,
    required bool initialValue,
  })  : _prefs = prefs,
        super(initialValue);

  static const storageKey = 'accessibility_guide_shown_once';
  final SharedPreferences _prefs;

  static bool fromStorage(bool? value) => value ?? false;

  Future<void> markShown() async {
    if (state) {
      return;
    }
    state = true;
    await _prefs.setBool(storageKey, true);
  }
}

class AccessibilityGuideDisabledController extends StateNotifier<bool> {
  AccessibilityGuideDisabledController({
    required SharedPreferences prefs,
    required bool initialValue,
  })  : _prefs = prefs,
        super(initialValue);

  static const storageKey = 'accessibility_guide_disabled';
  final SharedPreferences _prefs;

  static bool fromStorage(bool? value) => value ?? false;

  Future<void> setDisabled(bool disabled) async {
    state = disabled;
    await _prefs.setBool(storageKey, disabled);
  }
}
