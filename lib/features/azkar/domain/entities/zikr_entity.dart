class ZikrEntity {
  const ZikrEntity({
    required this.id,
    required this.category,
    required this.text,
    required this.repeat,
  });

  final int id;
  final String category;
  final String text;
  final int repeat;
}
