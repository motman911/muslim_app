import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/localization/app_localizations.dart';
import '../core/themes/app_theme.dart';
import '../services/firebase_messaging_service.dart';
import '../shared/providers/app_settings_providers.dart';
import 'router/app_router.dart';

class NoorApp extends ConsumerStatefulWidget {
  const NoorApp({super.key});

  @override
  ConsumerState<NoorApp> createState() => _NoorAppState();
}

class _NoorAppState extends ConsumerState<NoorApp> {
  late final FirebaseMessagingService _messagingService;
  StreamSubscription<String>? _deepLinkSubscription;

  @override
  void initState() {
    super.initState();
    _messagingService = FirebaseMessagingService();
    _messagingService.setupForegroundHandlers();

    _deepLinkSubscription =
        _messagingService.deepLinkRouteStream.listen((route) {
      if (!mounted) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        ref.read(appRouterProvider).go(route);
      });
    });
  }

  @override
  void dispose() {
    _deepLinkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    final textScale = ref.watch(textScaleControllerProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Noor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: TextScaler.linear(textScale)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      routerConfig: router,
    );
  }
}
