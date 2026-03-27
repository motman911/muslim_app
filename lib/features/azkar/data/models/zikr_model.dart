import '../../domain/entities/zikr_entity.dart';

class ZikrModel extends ZikrEntity {
  const ZikrModel({
    required super.id,
    required super.category,
    required super.text,
    required super.repeat,
  });

  factory ZikrModel.fromMap(Map<String, dynamic> map) {
    return ZikrModel(
      id: map['id'] as int,
      category: map['category'] as String,
      text: map['text'] as String,
      repeat: map['repeat'] as int,
    );
  }
}
