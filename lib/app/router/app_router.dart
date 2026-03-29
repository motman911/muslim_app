import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/audio/presentation/pages/audio_home_page.dart';
import '../../features/audio/presentation/pages/full_player_page.dart';
import '../../features/audio/presentation/pages/reciter_page.dart';
import '../../features/azkar/presentation/pages/azkar_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/prayer_times/presentation/pages/prayer_times_page.dart';
import '../../features/qibla/presentation/pages/qibla_page.dart';
import '../../features/quran/presentation/pages/bookmarks_page.dart';
import '../../features/quran/presentation/pages/downloads_management_page.dart';
import '../../features/quran/presentation/pages/quran_home_page.dart';
import '../../features/quran/presentation/pages/surah_reading_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/profile_page.dart';
import '../../shared/providers/app_settings_providers.dart';
import '../widgets/main_shell_scaffold.dart';

CustomTransitionPage<void> _buildTransitionPage(Widget child) {
  return CustomTransitionPage<void>(
    child: child,
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      final offsetTween = Tween<Offset>(
        begin: const Offset(0.02, 0.0),
        end: Offset.zero,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: offsetTween.animate(curved),
          child: child,
        ),
      );
    },
  );
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final onboardingSeen = ref.watch(onboardingControllerProvider);

  return GoRouter(
    initialLocation: onboardingSeen ? '/home' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShellScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) =>
                _buildTransitionPage(const HomePage()),
          ),
          GoRoute(
            path: '/quran',
            pageBuilder: (context, state) =>
                _buildTransitionPage(const QuranHomePage()),
          ),
          GoRoute(
            path: '/audio',
            pageBuilder: (context, state) =>
                _buildTransitionPage(const AudioHomePage()),
          ),
          GoRoute(
            path: '/audio/reciter/:id',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return _buildTransitionPage(ReciterPage(id: id));
            },
          ),
          GoRoute(
            path: '/audio/player',
            pageBuilder: (context, state) =>
                _buildTransitionPage(const FullPlayerPage()),
          ),
          GoRoute(
            path: '/downloads',
            pageBuilder: (context, state) {
              final reciterId = state.uri.queryParameters['reciterId'];
              return _buildTransitionPage(
                DownloadsManagementPage(initialReciterId: reciterId),
              );
            },
          ),
          GoRoute(
            path: '/bookmarks',
            pageBuilder: (context, state) =>
                _buildTransitionPage(const BookmarksPage()),
          ),
          GoRoute(
            path: '/prayer-times',
            pageBuilder: (context, state) =>
                _buildTransitionPage(const PrayerTimesPage()),
          ),
          GoRoute(
            path: '/azkar',
            pageBuilder: (context, state) =>
                _buildTransitionPage(const AzkarPage()),
          ),
          GoRoute(
            path: '/qibla',
            pageBuilder: (context, state) =>
                _buildTransitionPage(const QiblaPage()),
          ),
          GoRoute(
            path: '/quran/surah/:surahId',
            pageBuilder: (context, state) {
              final surahIdRaw = state.pathParameters['surahId'] ?? '1';
              final surahId = int.tryParse(surahIdRaw) ?? 1;
              return _buildTransitionPage(SurahReadingPage(surahId: surahId));
            },
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) =>
                _buildTransitionPage(const SettingsPage()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                _buildTransitionPage(const ProfilePage()),
          ),
        ],
      ),
    ],
  );
});
