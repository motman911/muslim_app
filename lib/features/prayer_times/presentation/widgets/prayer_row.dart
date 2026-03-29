import 'package:flutter/material.dart';

class PrayerRow extends StatelessWidget {
  const PrayerRow({
    super.key,
    required this.name,
    required this.time,
    this.highlight = false,
  });

  final String name;
  final String time;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        highlight
            ? Icons.access_time_filled_rounded
            : Icons.access_time_rounded,
      ),
      title: Text(name),
      trailing: Text(time),
    );
  }
}
