import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/noor_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tr('account'))),
      body: ListView(
        padding: EdgeInsets.all(16.r),
        children: const [
          NoorCard(
            margin: EdgeInsets.zero,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(child: Icon(Icons.person_rounded)),
              title: Text('Noor User'),
              subtitle: Text('user@noor.app'),
            ),
          ),
        ],
      ),
    );
  }
}
