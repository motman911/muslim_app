import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../services/audio_service.dart';
import '../widgets/reciter_card.dart';

class ReciterPage extends StatelessWidget {
  const ReciterPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final reciter = QuranAudioService.reciters.firstWhere(
      (item) => item.id == id,
      orElse: () => QuranAudioService.reciters.first,
    );

    return Scaffold(
      appBar: AppBar(title: Text(reciter.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ReciterCard(
            name: reciter.name,
            subtitle: 'ID: ${reciter.id}',
            onTap: () => context.push('/audio/player'),
          ),
        ],
      ),
    );
  }
}
