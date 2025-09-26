// lib/presentation/screens/adhkar_screen.dart
import 'package:flutter/material.dart';
import '../../core/constants/color_scheme.dart';

class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({super.key});

  final List<String> sampleAdhkar = const [
    'سبحان الله',
    'الحمد لله',
    'لا إله إلا الله',
    'الله أكبر',
    'أستغفر الله',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('الأذكار')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sampleAdhkar.length,
        itemBuilder: (context, index) {
          final dhikr = sampleAdhkar[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
                child:
                    const Icon(Icons.favorite, color: AppColors.primaryGreen),
              ),
              title: Text(dhikr, style: theme.textTheme.bodyLarge),
              onTap: () {
                // TODO: إضافة العد أو الإحصاء
              },
            ),
          );
        },
      ),
    );
  }
}
