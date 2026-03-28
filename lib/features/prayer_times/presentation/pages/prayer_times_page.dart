import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/noor_card.dart';
import '../providers/prayer_times_providers.dart';

class PrayerTimesPage extends ConsumerWidget {
  const PrayerTimesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final timesAsync = ref.watch(todayPrayerTimesProvider);
    final nextPrayerAsync = ref.watch(nextPrayerProvider);
    final todayLabel = DateFormat.yMMMMd().format(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tr('prayerTimes'))),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todayPrayerTimesProvider);
          await ref.read(todayPrayerTimesProvider.future);
        },
        child: timesAsync.when(
          data: (times) {
            return ListView(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              children: [
                NoorCard(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  highlight: true,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.notifications_active_rounded),
                    title: Text(l10n.tr('nextPrayer')),
                    trailing: Text(todayLabel),
                    subtitle: nextPrayerAsync.when(
                      data: (nextPrayer) {
                        if (nextPrayer == null) {
                          return Text(l10n.tr('noRemainingPrayer'));
                        }

                        final now = DateTime.now();
                        final remaining = nextPrayer.time.difference(now);
                        final remainingText = _formatDuration(remaining);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${nextPrayer.name} - ${DateFormat.Hm().format(nextPrayer.time)}',
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${l10n.tr('timeRemaining')}: $remainingText',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        );
                      },
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () => const Text('...'),
                    ),
                  ),
                ),
                ...times.map((prayer) {
                  final isNext = nextPrayerAsync.value?.name == prayer.name;
                  return NoorCard(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    highlight: isNext,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        isNext
                            ? Icons.access_time_filled_rounded
                            : Icons.access_time_rounded,
                      ),
                      title: Text(prayer.name),
                      trailing: Text(
                        DateFormat.Hm().format(prayer.time),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  );
                }),
              ],
            );
          },
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return '00:00';
    }
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}
