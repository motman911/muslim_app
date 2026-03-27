import '../entities/zikr_entity.dart';

abstract class AzkarRepository {
  Future<List<ZikrEntity>> getAzkar();
}
