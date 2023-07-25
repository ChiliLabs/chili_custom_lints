import 'package:chili_custom_lints/widget_helper/src/material/sized_box/model/sized_box_parameter.dart';

extension SizedBoxParameterExtension on SizedBoxParameter {
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