import 'package:flutter/material.dart';

import '../../../../shared/widgets/noor_card.dart';

class ReciterCard extends StatelessWidget {
  const ReciterCard({
    super.key,
    required this.name,
    required this.subtitle,
    this.onTap,
  });

  final String name;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return NoorCard(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(child: Icon(Icons.person_rounded)),
        title: Text(name),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }
}
