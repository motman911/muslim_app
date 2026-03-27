import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/providers/app_settings_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final themeMode = ref.watch(themeModeControllerProvider);
    final locale = ref.watch(localeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tr('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.tr('theme'),
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.system,
                label: Text(l10n.tr('system')),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text(l10n.tr('light')),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text(l10n.tr('dark')),
              ),
            ],
            selected: {themeMode},
            onSelectionChanged: (selected) {
              ref
                  .read(themeModeControllerProvider.notifier)
                  .setThemeMode(selected.first);
            },
          ),
          const SizedBox(height: 24),
          Text(l10n.tr('language'),
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: locale.languageCode,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'ar', child: Text('العربية')),
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'fr', child: Text('Francais')),
            ],
            onChanged: (value) {
              if (value == null) {
                return;
              }
              ref
                  .read(localeControllerProvider.notifier)
                  .setLocale(Locale(value));
            },
          ),
        ],
      ),
    );
  }
}
