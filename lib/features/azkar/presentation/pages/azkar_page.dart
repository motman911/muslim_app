import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../providers/azkar_providers.dart';

class AzkarPage extends ConsumerWidget {
  const AzkarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final azkarAsync = ref.watch(azkarProvider);
    final counter = ref.watch(tasbeehCounterProvider);
    final selectedCategory = ref.watch(zikrCategoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tr('azkar'))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => incrementTasbeehCounter(ref),
        icon: const Icon(Icons.touch_app_rounded),
        label: Text('${l10n.tr('counter')}: $counter'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment<String>(
                value: 'morning',
                icon: Icon(Icons.wb_sunny_rounded),
                label: Text('Morning'),
              ),
              ButtonSegment<String>(
                value: 'evening',
                icon: Icon(Icons.dark_mode_rounded),
                label: Text('Evening'),
              ),
            ],
            selected: {selectedCategory},
            onSelectionChanged: (selected) {
              ref.read(zikrCategoryProvider.notifier).state = selected.first;
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: azkarAsync.when(
              data: (azkar) {
                final filtered = azkar
                    .where((item) => item.category == selectedCategory)
                    .toList();

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final zikr = filtered[index];
                    return ListTile(
                      title: Text(
                        zikr.text,
                        style:
                            const TextStyle(fontFamily: 'Amiri', fontSize: 20),
                      ),
                      subtitle: Text('x${zikr.repeat}'),
                    );
                  },
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
