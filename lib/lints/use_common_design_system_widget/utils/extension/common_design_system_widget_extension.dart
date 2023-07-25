import 'package:chili_custom_lints/lints/use_common_design_system_widget/model/common_design_system_widget.dart';

extension CommonDesignSystemWidgetExtension on CommonDesignSystemWidget {
  String get errorCode {
    switch (this) {
      case CommonDesignSystemWidget.margin:
        return 'prefer_common_design_system_margin';
      case CommonDesignSystemWidget.padding:
        return 'prefer_common_design_system_padding';
      case CommonDesignSystemWidget.emptyPadding:
        return 'prefer_common_design_system_empty_padding';
      default:
        return '';
    }
  }

  String get problemMessage {
    switch (this) {
      case CommonDesignSystemWidget.margin:
        return 'Prefer using common design system margin';
      case CommonDesignSystemWidget.padding:
        return 'Prefer using common design system padding';
      case CommonDesignSystemWidget.emptyPadding:
        return 'Prefer using common design system widget';
      default:
        return '';
    }
  }

  String get correctionName {
    switch (this) {
      case CommonDesignSystemWidget.emptyWidget:
        return 'emptyWidget';
      case CommonDesignSystemWidget.emptyPadding:
        return 'emptyPadding';
      case CommonDesignSystemWidget.allPadding:
        return 'allPadding';
      default:
        return '';
    }
  }

  String get instanceName {
    switch (this) {
      case CommonDesignSystemWidget.sizedBox:
        return 'SizedBox';
      default:
        return '';
    }
  }
}
