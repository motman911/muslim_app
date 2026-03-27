import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final instance =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(instance != null, 'AppLocalizations was not found in widget tree.');
    return instance!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'appName': 'نور',
      'continue': 'متابعة',
      'startNow': 'ابدأ الآن',
      'onboardingTitle': 'نور - تطبيقك الإسلامي الشامل',
      'onboardingBody':
          'قرآن، أذكار، مواقيت صلاة، قبلة، ووضع Offline من أول تشغيل.',
      'quran': 'القرآن',
      'searchSurah': 'ابحث عن سورة',
      'noResults': 'لا توجد نتائج',
      'prayerTimes': 'مواقيت الصلاة',
      'azkar': 'الأذكار',
      'qibla': 'القبلة',
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'theme': 'المظهر',
      'light': 'فاتح',
      'dark': 'داكن',
      'system': 'تلقائي',
      'morningEveningAzkar': 'أذكار الصباح والمساء',
      'counter': 'العداد',
      'nextPrayer': 'الصلاة القادمة',
      'noRemainingPrayer': 'لا توجد صلاة متبقية اليوم',
      'qiblaHint': 'ضع الهاتف على سطح مستوٍ لمعايرة اتجاه القبلة.',
      'offlineReady': 'جاهز للعمل بدون إنترنت',
    },
    'en': {
      'appName': 'Noor',
      'continue': 'Continue',
      'startNow': 'Start now',
      'onboardingTitle': 'Noor - Your Complete Islamic App',
      'onboardingBody':
          'Quran, Azkar, Prayer Times, Qibla, and offline support from day one.',
      'quran': 'Quran',
      'searchSurah': 'Search surah',
      'noResults': 'No results found',
      'prayerTimes': 'Prayer Times',
      'azkar': 'Azkar',
      'qibla': 'Qibla',
      'settings': 'Settings',
      'language': 'Language',
      'theme': 'Theme',
      'light': 'Light',
      'dark': 'Dark',
      'system': 'System',
      'morningEveningAzkar': 'Morning & Evening Azkar',
      'counter': 'Counter',
      'nextPrayer': 'Next Prayer',
      'noRemainingPrayer': 'No remaining prayer today',
      'qiblaHint':
          'Place your phone on a flat surface to calibrate Qibla direction.',
      'offlineReady': 'Offline ready',
    },
    'fr': {
      'appName': 'Noor',
      'continue': 'Continuer',
      'startNow': 'Commencer',
      'onboardingTitle': 'Noor - Votre application islamique complete',
      'onboardingBody':
          'Coran, Azkar, horaires de priere, Qibla et mode hors ligne des le premier lancement.',
      'quran': 'Coran',
      'searchSurah': 'Rechercher une sourate',
      'noResults': 'Aucun resultat',
      'prayerTimes': 'Horaires de priere',
      'azkar': 'Azkar',
      'qibla': 'Qibla',
      'settings': 'Parametres',
      'language': 'Langue',
      'theme': 'Theme',
      'light': 'Clair',
      'dark': 'Sombre',
      'system': 'Systeme',
      'morningEveningAzkar': 'Azkar du matin et du soir',
      'counter': 'Compteur',
      'nextPrayer': 'Prochaine priere',
      'noRemainingPrayer': 'Aucune priere restante aujourd\'hui',
      'qiblaHint':
          'Posez le telephone sur une surface plane pour calibrer la direction Qibla.',
      'offlineReady': 'Pret hors ligne',
    },
  };

  String tr(String key) {
    final lang = locale.languageCode;
    return _localizedValues[lang]?[key] ?? _localizedValues['en']![key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
        (supported) => supported.languageCode == locale.languageCode,
      );

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

extension LocalizationX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
