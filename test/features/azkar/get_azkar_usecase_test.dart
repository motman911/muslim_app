import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_app/features/azkar/domain/entities/zikr_entity.dart';
import 'package:muslim_app/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:muslim_app/features/azkar/domain/usecases/get_azkar_usecase.dart';

class FakeAzkarRepository implements AzkarRepository {
  @override
  Future<List<ZikrEntity>> getAzkar() async {
    return const [
      ZikrEntity(
        id: 1,
        category: 'morning',
        text: 'سبحان الله',
        repeat: 33,
      ),
    ];
  }
}

void main() {
  test('GetAzkarUseCase returns data from repository', () async {
    final useCase = GetAzkarUseCase(FakeAzkarRepository());

    final result = await useCase();

    expect(result.length, 1);
    expect(result.first.category, 'morning');
  });
}
