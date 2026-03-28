import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/noor_card.dart';
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
          NoorCard(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${l10n.tr('counter')}: $counter',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        ref.read(tasbeehCounterProvider.notifier).state = 0;
                      },
                      icon: const Icon(Icons.restart_alt_rounded),
                      label: Text(l10n.tr('resetCounter')),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment<String>(
                      value: 'morning',
                      icon: const Icon(Icons.wb_sunny_rounded),
                      label: Text(l10n.tr('morning')),
                    ),
                    ButtonSegment<String>(
                      value: 'evening',
                      icon: const Icon(Icons.dark_mode_rounded),
                      label: Text(l10n.tr('evening')),
                    ),
                  ],
                  selected: {selectedCategory},
                  onSelectionChanged: (selected) {
                    ref.read(zikrCategoryProvider.notifier).state =
                        selected.first;
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: azkarAsync.when(
              data: (azkar) {
                final filtered = azkar
                    .where((item) => item.category == selectedCategory)
                    .toList();

                if (filtered.isEmpty) {
                  return Center(child: Text(l10n.tr('noResults')));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final zikr = filtered[index];
                    return NoorCard(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          zikr.text,
                          style: const TextStyle(
                              fontFamily: 'Amiri', fontSize: 22),
                        ),
                        subtitle: Text('x${zikr.repeat}'),
                        trailing: const Icon(Icons.chevron_left_rounded),
                        onTap: () => incrementTasbeehCounter(ref),
                      ),
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
