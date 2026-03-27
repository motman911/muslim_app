import '../../domain/entities/zikr_entity.dart';
import '../../domain/repositories/azkar_repository.dart';
import '../datasources/azkar_local_data_source.dart';

class AzkarRepositoryImpl implements AzkarRepository {
  AzkarRepositoryImpl(this._localDataSource);

  final AzkarLocalDataSource _localDataSource;

  @override
  Future<List<ZikrEntity>> getAzkar() {
    return _localDataSource.getAzkar();
  }
}
