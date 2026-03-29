import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/noor_card.dart';
import '../../data/models/ayah_model.dart';

Future<void> showAyahActionSheet(
  BuildContext context, {
  required AyahModel ayah,
  required Future<void> Function() onBookmark,
}) async {
  final l10n = context.l10n;
  final tabs = [
    l10n.tr('translation'),
    l10n.tr('tafsir'),
  ];

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (context) {
      return DefaultTabController(
        length: tabs.length,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ayah.text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'KFGQPCUthmanTahaHafs',
                  fontSize: 24,
                  height: 2.0,
                ),
              ),
              const SizedBox(height: 12),
              TabBar(
                tabs: tabs.map((title) => Tab(text: title)).toList(),
              ),
              SizedBox(
                height: 110,
                child: TabBarView(
                  children: [
                    NoorCard(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        '${l10n.tr('translation')}: ${ayah.text}',
                        textAlign: TextAlign.right,
                      ),
                    ),
                    NoorCard(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        l10n.tr('tafsirUnavailableOffline'),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () async {
                      await onBookmark();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.tr('bookmarkSaved'))),
                        );
                      }
                    },
                    icon: const Icon(Icons.bookmark_add_outlined),
                    label: Text(l10n.tr('addBookmark')),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: ayah.text));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.tr('ayahCopied'))),
                        );
                      }
                    },
                    icon: const Icon(Icons.copy_rounded),
                    label: Text(l10n.tr('copyAyah')),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(l10n.tr('playAyah')),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
