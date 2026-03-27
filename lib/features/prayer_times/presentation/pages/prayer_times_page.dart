import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_localizations.dart';
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
      body: Column(
        children: [
          const SizedBox(height: 12),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.notifications_active_rounded),
              title: Text(l10n.tr('nextPrayer')),
              trailing: Text(todayLabel),
              subtitle: nextPrayerAsync.when(
                data: (nextPrayer) {
                  if (nextPrayer == null) {
                    return Text(l10n.tr('noRemainingPrayer'));
                  }
                  return Text(
                    '${nextPrayer.name} - ${DateFormat.Hm().format(nextPrayer.time)}',
                  );
                },
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => const Text('...'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: timesAsync.when(
              data: (times) {
                return ListView.builder(
                  itemCount: times.length,
                  itemBuilder: (context, index) {
                    final prayer = times[index];
                    return ListTile(
                      leading: const Icon(Icons.access_time_filled_rounded),
                      title: Text(prayer.name),
                      trailing: Text(DateFormat.Hm().format(prayer.time)),
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
