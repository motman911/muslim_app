extension NullableStringX on String? {
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;
}

extension IntX on int {
  String twoDigits() => toString().padLeft(2, '0');
}
