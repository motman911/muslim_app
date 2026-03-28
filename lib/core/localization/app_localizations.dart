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
      'audio': 'التلاوات',
      'reciter': 'القارئ',
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'theme': 'المظهر',
      'textSize': 'حجم النص',
      'textSizeSmall': 'صغير',
      'textSizeLarge': 'كبير',
      'lineHeight': 'تباعد السطور',
      'lineHeightCompact': 'مضغوط',
      'lineHeightRelaxed': 'مريح',
      'highContrast': 'تباين عالٍ',
      'highContrastEnabled': 'مفعّل',
      'highContrastDisabled': 'غير مفعّل',
      'accessibilityPresets': 'إعدادات جاهزة للقراءة',
      'presetBalanced': 'متوازن',
      'presetComfort': 'مريح للقراءة',
      'presetCompact': 'مضغوط',
      'resetAccessibility': 'إعادة ضبط الإتاحة',
      'preview': 'معاينة مباشرة',
      'previewBody':
          'بسم الله الرحمن الرحيم. هذا مثال يوضح شكل النص الحالي حسب إعداداتك.',
      'light': 'فاتح',
      'dark': 'داكن',
      'system': 'تلقائي',
      'morning': 'الصباح',
      'evening': 'المساء',
      'morningEveningAzkar': 'أذكار الصباح والمساء',
      'counter': 'العداد',
      'resetCounter': 'تصفير العداد',
      'cancel': 'إلغاء',
      'nextPrayer': 'الصلاة القادمة',
      'noRemainingPrayer': 'لا توجد صلاة متبقية اليوم',
      'qiblaHint': 'ضع الهاتف على سطح مستوٍ لمعايرة اتجاه القبلة.',
      'qiblaAngle': 'زاوية القبلة',
      'qiblaSensorNotSupported': 'هذا الجهاز لا يدعم حساس البوصلة.',
      'openLocationSettings': 'فتح إعدادات الموقع',
      'qiblaAligned': 'الاتجاه مضبوط نحو القبلة',
      'qiblaAdjust': 'عدّل الاتجاه',
      'offlineReady': 'جاهز للعمل بدون إنترنت',
      'nowPlaying': 'قيد التشغيل',
      'audioError': 'تعذر تشغيل التلاوة. تحقق من اتصال الإنترنت.',
      'account': 'الحساب',
      'signedInAs': 'مسجل كـ',
      'anonymousUser': 'مستخدم ضيف',
      'signInGoogle': 'تسجيل عبر Google',
      'signInApple': 'تسجيل عبر Apple',
      'signInEmail': 'تسجيل بالبريد',
      'createAccountEmail': 'إنشاء حساب بالبريد',
      'signOut': 'تسجيل الخروج',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'bookmarkSaved': 'تم حفظ الإشارة المرجعية',
      'bookmarks': 'الإشارات المرجعية',
      'noBookmarks': 'لا توجد إشارات مرجعية بعد',
      'bookmarkDeleted': 'تم حذف الإشارة المرجعية',
      'surah': 'السورة',
      'ayah': 'الآية',
      'juz': 'الجزء',
      'page': 'الصفحة',
      'refreshQuran': 'تحديث بيانات القرآن',
      'quranRefreshed': 'تم تحديث قائمة السور',
      'readSurah': 'قراءة السورة',
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
      'audio': 'Audio',
      'reciter': 'Reciter',
      'settings': 'Settings',
      'language': 'Language',
      'theme': 'Theme',
      'textSize': 'Text size',
      'textSizeSmall': 'Small',
      'textSizeLarge': 'Large',
      'lineHeight': 'Line height',
      'lineHeightCompact': 'Compact',
      'lineHeightRelaxed': 'Relaxed',
      'highContrast': 'High contrast',
      'highContrastEnabled': 'Enabled',
      'highContrastDisabled': 'Disabled',
      'accessibilityPresets': 'Reading presets',
      'presetBalanced': 'Balanced',
      'presetComfort': 'Comfort',
      'presetCompact': 'Compact',
      'resetAccessibility': 'Reset accessibility',
      'preview': 'Live preview',
      'previewBody':
          'In the name of Allah, the Most Merciful. This sample reflects your current reading settings.',
      'light': 'Light',
      'dark': 'Dark',
      'system': 'System',
      'morning': 'Morning',
      'evening': 'Evening',
      'morningEveningAzkar': 'Morning & Evening Azkar',
      'counter': 'Counter',
      'resetCounter': 'Reset counter',
      'cancel': 'Cancel',
      'nextPrayer': 'Next Prayer',
      'noRemainingPrayer': 'No remaining prayer today',
      'qiblaHint':
          'Place your phone on a flat surface to calibrate Qibla direction.',
      'qiblaAngle': 'Qibla angle',
      'qiblaSensorNotSupported':
          'This device does not support a compass sensor.',
      'openLocationSettings': 'Open location settings',
      'qiblaAligned': 'You are aligned with Qibla',
      'qiblaAdjust': 'Adjust direction',
      'offlineReady': 'Offline ready',
      'nowPlaying': 'Now playing',
      'audioError': 'Unable to play recitation. Check internet connection.',
      'account': 'Account',
      'signedInAs': 'Signed in as',
      'anonymousUser': 'Guest user',
      'signInGoogle': 'Sign in with Google',
      'signInApple': 'Sign in with Apple',
      'signInEmail': 'Sign in with Email',
      'createAccountEmail': 'Create account with Email',
      'signOut': 'Sign out',
      'email': 'Email',
      'password': 'Password',
      'bookmarkSaved': 'Bookmark saved',
      'bookmarks': 'Bookmarks',
      'noBookmarks': 'No bookmarks yet',
      'bookmarkDeleted': 'Bookmark deleted',
      'surah': 'Surah',
      'ayah': 'Ayah',
      'juz': 'Juz',
      'page': 'Page',
      'refreshQuran': 'Refresh Quran data',
      'quranRefreshed': 'Surahs list refreshed',
      'readSurah': 'Read surah',
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
      'audio': 'Recitations',
      'reciter': 'Recitateur',
      'settings': 'Parametres',
      'language': 'Langue',
      'theme': 'Theme',
      'textSize': 'Taille du texte',
      'textSizeSmall': 'Petit',
      'textSizeLarge': 'Grand',
      'lineHeight': 'Interligne',
      'lineHeightCompact': 'Compact',
      'lineHeightRelaxed': 'Aere',
      'highContrast': 'Contraste eleve',
      'highContrastEnabled': 'Active',
      'highContrastDisabled': 'Desactive',
      'accessibilityPresets': 'Profils de lecture',
      'presetBalanced': 'Equilibre',
      'presetComfort': 'Confort',
      'presetCompact': 'Compact',
      'resetAccessibility': 'Reinitialiser l acces',
      'preview': 'Apercu en direct',
      'previewBody':
          'Au nom d Allah, le Tout Misericordieux. Cet exemple montre vos reglages de lecture actuels.',
      'light': 'Clair',
      'dark': 'Sombre',
      'system': 'Systeme',
      'morning': 'Matin',
      'evening': 'Soir',
      'morningEveningAzkar': 'Azkar du matin et du soir',
      'counter': 'Compteur',
      'resetCounter': 'Reinitialiser le compteur',
      'cancel': 'Annuler',
      'nextPrayer': 'Prochaine priere',
      'noRemainingPrayer': 'Aucune priere restante aujourd\'hui',
      'qiblaHint':
          'Posez le telephone sur une surface plane pour calibrer la direction Qibla.',
      'qiblaAngle': 'Angle de la Qibla',
      'qiblaSensorNotSupported':
          'Cet appareil ne prend pas en charge le capteur de boussole.',
      'openLocationSettings': 'Ouvrir les parametres de localisation',
      'qiblaAligned': 'Vous etes aligne vers la Qibla',
      'qiblaAdjust': 'Ajustez la direction',
      'offlineReady': 'Pret hors ligne',
      'nowPlaying': 'Lecture en cours',
      'audioError':
          'Impossible de lire la recitation. Verifiez la connexion internet.',
      'account': 'Compte',
      'signedInAs': 'Connecte en tant que',
      'anonymousUser': 'Utilisateur invite',
      'signInGoogle': 'Connexion avec Google',
      'signInApple': 'Connexion avec Apple',
      'signInEmail': 'Connexion avec email',
      'createAccountEmail': 'Creer un compte par email',
      'signOut': 'Se deconnecter',
      'email': 'Email',
      'password': 'Mot de passe',
      'bookmarkSaved': 'Signet enregistre',
      'bookmarks': 'Signets',
      'noBookmarks': 'Aucun signet pour le moment',
      'bookmarkDeleted': 'Signet supprime',
      'surah': 'Sourate',
      'ayah': 'Verset',
      'juz': 'Juz',
      'page': 'Page',
      'refreshQuran': 'Actualiser les donnees du Coran',
      'quranRefreshed': 'Liste des sourates mise a jour',
      'readSurah': 'Lire la sourate',
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
