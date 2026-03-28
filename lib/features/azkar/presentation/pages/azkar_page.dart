import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/noor_card.dart';
import '../providers/azkar_providers.dart';

class AzkarPage extends ConsumerWidget {
  const AzkarPage({super.key});

  static const int _tasbeehDailyGoal = 33;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final azkarAsync = ref.watch(azkarProvider);
    final counter = ref.watch(tasbeehCounterProvider);
    final selectedCategory = ref.watch(zikrCategoryProvider);
    final progress = (counter % _tasbeehDailyGoal) / _tasbeehDailyGoal;

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
            padding: EdgeInsets.zero,
            highlight: true,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: Theme.of(context).brightness == Brightness.dark
                    ? const LinearGradient(
                        colors: [Color(0xFF1B3A2E), Color(0xFF102720)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: [Color(0xFFEAF5F0), Color(0xFFE0F0E8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: azkarAsync.when(
                data: (azkar) {
                  final filteredCount = azkar
                      .where((item) => item.category == selectedCategory)
                      .length;
                  final progressCount = counter % _tasbeehDailyGoal;
                  final goalRemaining = progressCount == 0
                      ? 0
                      : _tasbeehDailyGoal - progressCount;
                  final categoryLabel = selectedCategory == 'morning'
                      ? l10n.tr('morning')
                      : l10n.tr('evening');

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.tr('azkar')} - $categoryLabel',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${l10n.tr('azkarAvailable')}: $filteredCount',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${l10n.tr('dailyTasbeehGoal')} $_tasbeehDailyGoal',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          Text(
                            '${l10n.tr('remainingToGoal')}: $goalRemaining',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          minHeight: 9,
                          value: progress,
                        ),
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => const SizedBox(
                  height: 56,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ),
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
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => incrementTasbeehCounter(ref),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  child: Text('${index + 1}'),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    zikr.text,
                                    style: const TextStyle(
                                      fontFamily: 'Amiri',
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Chip(label: Text('x${zikr.repeat}')),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.tr('tapToCount'),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
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
