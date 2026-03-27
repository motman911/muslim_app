import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/providers/app_settings_providers.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selectedLocale = ref.watch(localeControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                l10n.tr('onboardingTitle'),
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.tr('onboardingBody'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: [
                  _LocaleChip(
                    code: 'ar',
                    active: selectedLocale.languageCode == 'ar',
                    onTap: () => ref
                        .read(localeControllerProvider.notifier)
                        .setLocale(const Locale('ar')),
                  ),
                  _LocaleChip(
                    code: 'en',
                    active: selectedLocale.languageCode == 'en',
                    onTap: () => ref
                        .read(localeControllerProvider.notifier)
                        .setLocale(const Locale('en')),
                  ),
                  _LocaleChip(
                    code: 'fr',
                    active: selectedLocale.languageCode == 'fr',
                    onTap: () => ref
                        .read(localeControllerProvider.notifier)
                        .setLocale(const Locale('fr')),
                  ),
                ],
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () async {
                  await ref
                      .read(onboardingControllerProvider.notifier)
                      .complete();
                  if (context.mounted) {
                    context.go('/quran');
                  }
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(l10n.tr('startNow')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocaleChip extends StatelessWidget {
  const _LocaleChip({
    required this.code,
    required this.active,
    required this.onTap,
  });

  final String code;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(code.toUpperCase()),
      selected: active,
      onSelected: (_) => onTap(),
    );
  }
}
