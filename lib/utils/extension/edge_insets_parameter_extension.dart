import 'package:chili_custom_lints/widget_helper/src/material/edge_insets/model/edge_insets_parameter.dart';

extension EdgeInsetsParameterExtension on EdgeInsetsParameter {
  int get valueStartPosition {
    switch (this) {
      case EdgeInsetsParameter.horizontal:
      case EdgeInsetsParameter.vertical:
        return '$name: '.length;
      default:
        return 0;
    }
  }
}
