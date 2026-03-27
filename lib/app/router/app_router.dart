import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/azkar/presentation/pages/azkar_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/prayer_times/presentation/pages/prayer_times_page.dart';
import '../../features/qibla/presentation/pages/qibla_page.dart';
import '../../features/quran/presentation/pages/bookmarks_page.dart';
import '../../features/quran/presentation/pages/quran_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../shared/providers/app_settings_providers.dart';
import '../widgets/main_shell_scaffold.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final onboardingSeen = ref.watch(onboardingControllerProvider);

  return GoRouter(
    initialLocation: onboardingSeen ? '/quran' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShellScaffold(child: child),
        routes: [
          GoRoute(
            path: '/quran',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: QuranPage(),
            ),
          ),
          GoRoute(
            path: '/bookmarks',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BookmarksPage(),
            ),
          ),
          GoRoute(
            path: '/prayer-times',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PrayerTimesPage(),
            ),
          ),
          GoRoute(
            path: '/azkar',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AzkarPage(),
            ),
          ),
          GoRoute(
            path: '/qibla',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: QiblaPage(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsPage(),
            ),
          ),
        ],
      ),
    ],
  );
});
