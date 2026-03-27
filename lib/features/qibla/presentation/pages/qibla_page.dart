import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';

class QiblaPage extends StatelessWidget {
  const QiblaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tr('qibla'))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.explore_rounded, size: 100),
              const SizedBox(height: 16),
              Text(
                l10n.tr('qiblaHint'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              const Text(
                  'Qibla compass integration is ready for sensor binding.'),
            ],
          ),
        ),
      ),
    );
  }
}
