enum EdgeInsetsParameter {
  horizontal,
  vertical;

  int get valueStartPosition {
    switch (this) {
      case EdgeInsetsParameter.horizontal:
      case EdgeInsetsParameter.vertical:
        return '$name: '.length;
    }
  }
}
