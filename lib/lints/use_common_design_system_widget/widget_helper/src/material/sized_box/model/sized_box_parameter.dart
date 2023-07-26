enum SizedBoxParameter {
  width,
  height,
  child;

  int get valueStartPosition {
    switch (this) {
      case SizedBoxParameter.width:
      case SizedBoxParameter.height:
        return '$name: '.length;
      default:
        return 0;
    }
  }
}
