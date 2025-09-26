// lib/presentation/screens/audio_screen.dart
import 'package:flutter/material.dart';
// ignore: unused_import
import '../../core/constants/color_scheme.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  final List<String> sampleAudio = const [
    'سورة الفاتحة - القارئ محمد صديق المنشاوي',
    'سورة البقرة - القارئ عبد الباسط عبد الصمد',
    'سورة الكهف - القارئ محمود خليل الحصري',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('التلاوات')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sampleAudio.length,
        itemBuilder: (context, index) {
          final audio = sampleAudio[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple.withOpacity(0.2),
                child: const Icon(Icons.audiotrack, color: Colors.deepPurple),
              ),
              title: Text(audio, style: theme.textTheme.bodyLarge),
              trailing: IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () {
                  // TODO: تشغيل التلاوة
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
