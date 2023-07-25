import 'package:analyzer/dart/ast/ast.dart';
import 'package:chili_custom_lints/utils/extension/edge_insets_parameter_extension.dart';
import 'package:chili_custom_lints/utils/extension/sized_box_parameter_extension.dart';
import 'package:chili_custom_lints/widget_helper/src/design_system/model/design_system_element.dart';
import 'package:chili_custom_lints/widget_helper/src/material/edge_insets/model/edge_insets_parameter.dart';
import 'package:chili_custom_lints/widget_helper/src/material/sized_box/model/sized_box_parameter.dart';
import 'package:collection/collection.dart';

class WidgetNodeHandler {
  static String getCorrectionName(
    String prefix,
    double? value,
    DesignSystemElement element,
  ) =>
      '$prefix${element.name}${value?.toInt()}';

  static String getCorrectionMessage(String correctionName) =>
      "Use common design system widget '$correctionName' instead";

  static bool hasLintError(
    double? horizontal,
    double? vertical,
    NodeList<Expression> arguments,
  ) {
    final isHorizontalDivisibleBy4 = horizontal != null && horizontal % 4 == 0;
    final isVerticalDivisibleBy4 = vertical != null && vertical % 4 == 0;
    final hasArguments = arguments.isNotEmpty;

    return isHorizontalDivisibleBy4 || isVerticalDivisibleBy4 || !hasArguments;
  }

  static (double? width, double? height) getMarginArgumentValues(
    InstanceCreationExpression node,
  ) {
    final width = _getArgumentValue(
      node: node,
      parameterName: SizedBoxParameter.width.name,
      valueStartPosition: SizedBoxParameter.width.valueStartPosition,
    );

    final height = _getArgumentValue(
      node: node,
      parameterName: SizedBoxParameter.height.name,
      valueStartPosition: SizedBoxParameter.height.valueStartPosition,
    );

    return (width, height);
  }

  static (double? horizontal, double? vertical) getPaddingArgumentValues(
    InstanceCreationExpression node,
  ) {
    final horizontal = _getArgumentValue(
      node: node,
      parameterName: EdgeInsetsParameter.horizontal.name,
      valueStartPosition: EdgeInsetsParameter.horizontal.valueStartPosition,
    );
    final vertical = _getArgumentValue(
      node: node,
      parameterName: EdgeInsetsParameter.vertical.name,
      valueStartPosition: EdgeInsetsParameter.vertical.valueStartPosition,
    );

    return (horizontal, vertical);
  }

  static double? _getArgumentValue({
    required InstanceCreationExpression node,
    required String parameterName,
    required int valueStartPosition,
  }) {
    // For handling unnamed parameter value.
    final allArguments = node.argumentList.arguments.toSet();
    final unnamedValue = double.tryParse(allArguments.firstOrNull.toString());

    if (allArguments.length == 1 && unnamedValue != null) {
      return unnamedValue;
    }

    final argument = node.argumentList.arguments.toSet().firstWhereOrNull(
          (arg) =>
              arg is NamedExpression && arg.name.label.name == parameterName,
        );

    if (argument == null) return null;

    final resolvedArgument = argument.toString();
    final valueStr = resolvedArgument.substring(valueStartPosition);
    final value = double.tryParse(valueStr);

    return value;
  }
}