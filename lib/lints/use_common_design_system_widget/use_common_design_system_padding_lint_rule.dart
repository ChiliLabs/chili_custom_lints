import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:chili_custom_lints/constants/lint_rule_constants.dart';
import 'package:chili_custom_lints/node_handler/widget_node_handler.dart';
import 'package:chili_custom_lints/widget_helper/src/design_system/model/design_system_element.dart';
import 'package:chili_custom_lints/widget_helper/src/design_system/spacing/common_design_system_spacing.dart';
import 'package:chili_custom_lints/widget_helper/src/material/edge_insets/model/edge_insets_type.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class UseCommonDesignSystemPaddingLintRule extends DartLintRule {
  UseCommonDesignSystemPaddingLintRule() : super(code: _code);

  static const _code = LintCode(
    name: LintRuleConstants.paddingErrorCode,
    problemMessage: LintRuleConstants.problemMessage,
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final instanceName = node.constructorName.toString();
      final arguments = node.argumentList.arguments;
      if (arguments.length > 1) return;

      final paddingMethod = EdgeInsetsType.fromRawValue(instanceName);
      if (!EdgeInsetsType.validMethods.contains(paddingMethod)) return;

      final (horizontal, vertical) = WidgetNodeHandler.getPaddingArgumentValues(
        node,
      );

      if (!WidgetNodeHandler.hasLintError(horizontal, vertical, arguments)) {
        return;
      }

      reporter.reportErrorForOffset(code, node.offset, node.length);
    });
  }

  @override
  List<Fix> getFixes() => [_UseCommonDesignSystemPaddingLintRuleFix()];
}

class _UseCommonDesignSystemPaddingLintRuleFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final arguments = node.argumentList.arguments;
      if (node.argumentList.arguments.length > 1) return;

      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final (horizontal, vertical) = WidgetNodeHandler.getPaddingArgumentValues(
        node,
      );

      final isAllPadding = horizontal == vertical;

      final correctionValue = horizontal ?? vertical;
      final correctionPrefix = isAllPadding
          ? CommonDesignSystemSpacing.all
          : horizontal != null
              ? CommonDesignSystemSpacing.horizontal
              : CommonDesignSystemSpacing.vertical;

      final correctionName = WidgetNodeHandler.getCorrectionName(
        correctionPrefix.name,
        correctionValue,
        DesignSystemElement.padding,
      );

      if (!WidgetNodeHandler.hasLintError(horizontal, vertical, arguments)) {
        return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        message: WidgetNodeHandler.getCorrectionMessage(correctionName),
        priority: 1,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(node.sourceRange, correctionName);
      });
    });
  }
}
