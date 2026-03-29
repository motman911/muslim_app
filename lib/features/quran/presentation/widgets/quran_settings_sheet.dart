import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/providers/app_settings_providers.dart';

Future<void> showQuranSettingsSheet(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      final textScale = ref.watch(textScaleControllerProvider);
      final lineHeight = ref.watch(lineHeightControllerProvider);

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.tr('readingSettings'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text('${l10n.tr('textSize')}: ${textScale.toStringAsFixed(2)}'),
            Slider(
              min: 0.9,
              max: 1.3,
              divisions: 8,
              value: textScale,
              onChanged: (value) {
                ref.read(textScaleControllerProvider.notifier).setScale(value);
              },
            ),
            const SizedBox(height: 8),
            Text('${l10n.tr('lineHeight')}: ${lineHeight.toStringAsFixed(2)}'),
            Slider(
              min: 1.2,
              max: 2.0,
              divisions: 8,
              value: lineHeight,
              onChanged: (value) {
                ref
                    .read(lineHeightControllerProvider.notifier)
                    .setHeight(value);
              },
            ),
          ],
        ),
      );
    },
  );
}
