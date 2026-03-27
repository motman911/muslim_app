import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_app/features/quran/domain/entities/surah_entity.dart';
import 'package:muslim_app/features/quran/domain/repositories/quran_repository.dart';
import 'package:muslim_app/features/quran/domain/usecases/get_surahs_usecase.dart';

class FakeQuranRepository implements QuranRepository {
  @override
  Future<List<SurahEntity>> getSurahs() async {
    return const [
      SurahEntity(
        id: 1,
        arabicName: 'الفاتحة',
        englishName: 'Al-Fatihah',
        revelationType: 'makki',
        ayahCount: 7,
      ),
    ];
  }
}

void main() {
  test('GetSurahsUseCase returns data from repository', () async {
    final useCase = GetSurahsUseCase(FakeQuranRepository());

    final result = await useCase();

    expect(result.length, 1);
    expect(result.first.arabicName, 'الفاتحة');
  });
}
