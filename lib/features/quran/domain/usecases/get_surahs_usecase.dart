import '../entities/surah_entity.dart';
import '../repositories/quran_repository.dart';

class GetSurahsUseCase {
  GetSurahsUseCase(this._repository);

  final QuranRepository _repository;

  Future<List<SurahEntity>> call() {
    return _repository.getSurahs();
  }
}
