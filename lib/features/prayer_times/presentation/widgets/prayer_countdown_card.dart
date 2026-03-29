import 'package:flutter/material.dart';

import '../../../../shared/widgets/noor_card.dart';

class PrayerCountdownCard extends StatelessWidget {
  const PrayerCountdownCard({
    super.key,
    required this.prayerName,
    required this.remaining,
  });

  final String prayerName;
  final String remaining;

  @override
  Widget build(BuildContext context) {
    return NoorCard(
      margin: EdgeInsets.zero,
      highlight: true,
      child: Row(
        children: [
          const Icon(Icons.access_time_filled_rounded),
          const SizedBox(width: 10),
          Expanded(child: Text(prayerName)),
          Text(remaining),
        ],
      ),
    );
  }
}
