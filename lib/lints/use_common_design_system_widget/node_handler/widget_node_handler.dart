import 'package:analyzer/dart/ast/ast.dart';
import 'package:chili_custom_lints/lints/use_common_design_system_widget/widget_helper/widget_helper.dart';
import 'package:collection/collection.dart';

typedef DirectionalSpacing = (double? horizontal, double? vertical);

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
    bool hasArguments,
  ) {
    if (!hasArguments) return true;

    final isHorizontalDivisibleBy4 = horizontal != null && horizontal % 4 == 0;
    final isVerticalDivisibleBy4 = vertical != null && vertical % 4 == 0;

    return isHorizontalDivisibleBy4 || isVerticalDivisibleBy4;
  }

  static DirectionalSpacing getMarginArgumentValues(
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

  static DirectionalSpacing getPaddingArgumentValues(
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
    final allArguments = node.argumentList.arguments;
    final unnamedValue = double.tryParse(allArguments.firstOrNull.toString());

    if (allArguments.length == 1 && unnamedValue != null) {
      return unnamedValue;
    }

    final argument = allArguments.firstWhereOrNull(
      (arg) => arg is NamedExpression && arg.name.label.name == parameterName,
    );

    if (argument == null) return null;

    final resolvedArgument = argument.toString();
    final valueStr = resolvedArgument.substring(valueStartPosition);
    final value = double.tryParse(valueStr);

    return value;
  }
}
