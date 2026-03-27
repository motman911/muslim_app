import '../entities/zikr_entity.dart';
import '../repositories/azkar_repository.dart';

class GetAzkarUseCase {
  GetAzkarUseCase(this._repository);

  final AzkarRepository _repository;

  Future<List<ZikrEntity>> call() {
    return _repository.getAzkar();
  }
}
