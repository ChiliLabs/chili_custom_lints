enum EdgeInsetsType {
  zero('EdgeInsets.zero'),
  symmetric('EdgeInsets.symmetric'),
  all('EdgeInsets.all'),
  none('');

  final String name;

  const EdgeInsetsType(this.name);

  factory EdgeInsetsType.fromRawValue(String? rawValue) =>
      EdgeInsetsType.values.firstWhere(
        (item) => item.name == rawValue,
        orElse: () => EdgeInsetsType.none,
      );

  static List<EdgeInsetsType> validMethods = [
    EdgeInsetsType.symmetric,
    EdgeInsetsType.all,
  ];
}
