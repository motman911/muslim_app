import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/azkar_local_data_source.dart';
import '../../data/repositories/azkar_repository_impl.dart';
import '../../domain/entities/zikr_entity.dart';
import '../../domain/repositories/azkar_repository.dart';
import '../../domain/usecases/get_azkar_usecase.dart';

final azkarLocalDataSourceProvider = Provider<AzkarLocalDataSource>(
  (ref) => AzkarLocalDataSource(),
);

final azkarRepositoryProvider = Provider<AzkarRepository>(
  (ref) => AzkarRepositoryImpl(ref.watch(azkarLocalDataSourceProvider)),
);

final getAzkarUseCaseProvider = Provider<GetAzkarUseCase>(
  (ref) => GetAzkarUseCase(ref.watch(azkarRepositoryProvider)),
);

final azkarProvider = FutureProvider<List<ZikrEntity>>((ref) {
  final useCase = ref.watch(getAzkarUseCaseProvider);
  return useCase();
});

final tasbeehCounterProvider = StateProvider<int>((ref) => 0);

final zikrCategoryProvider = StateProvider<String>((ref) => 'morning');

Future<void> incrementTasbeehCounter(WidgetRef ref) async {
  ref.read(tasbeehCounterProvider.notifier).state++;
  await HapticFeedback.lightImpact();
}
