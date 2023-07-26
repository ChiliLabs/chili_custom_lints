import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:chili_custom_lints/lints/use_common_design_system_widget/model/common_design_system_widget.dart';
import 'package:chili_custom_lints/lints/use_common_design_system_widget/node_handler/widget_node_handler.dart';
import 'package:chili_custom_lints/lints/use_common_design_system_widget/widget_helper/src/design_system/model/design_system_element.dart';
import 'package:chili_custom_lints/lints/use_common_design_system_widget/widget_helper/src/design_system/spacing/common_design_system_spacing.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class UseCommonDesignSystemMarginLintRule extends DartLintRule {
  UseCommonDesignSystemMarginLintRule() : super(code: _code);

  static final _code = LintCode(
    name: CommonDesignSystemWidget.margin.errorCode,
    problemMessage: CommonDesignSystemWidget.margin.problemMessage,
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final arguments = node.argumentList.arguments;
      if (arguments.length > 1) return;

      final instanceName = node.constructorName.toString();
      if (instanceName != CommonDesignSystemWidget.sizedBox.instanceName) {
        return;
      }

      final (width, height) = WidgetNodeHandler.getMarginArgumentValues(node);

      if (!WidgetNodeHandler.hasLintError(width, height, arguments)) return;

      reporter.reportErrorForOffset(code, node.offset, node.length);
    });
  }

  @override
  List<Fix> getFixes() => [_UseCommonDesignSystemMarginLintRuleFix()];
}

class _UseCommonDesignSystemMarginLintRuleFix extends DartFix {
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
      final isMatch = arguments.length <= 1;
      final isHighlighted = analysisError.sourceRange.intersects(
        node.sourceRange,
      );

      if (!isMatch) return;
      if (!isHighlighted) return;

      final (width, height) = WidgetNodeHandler.getMarginArgumentValues(node);

      if (!WidgetNodeHandler.hasLintError(width, height, arguments)) return;

      final correctionValue = width ?? height;
      final correctionPrefix = width != null
          ? CommonDesignSystemSpacing.horizontal
          : height != null
              ? CommonDesignSystemSpacing.vertical
              : CommonDesignSystemSpacing.empty;

      final isEmptyWidget = correctionPrefix == CommonDesignSystemSpacing.empty;
      final correctionName = isEmptyWidget
          ? CommonDesignSystemWidget.emptyWidget.correctionName
          : WidgetNodeHandler.getCorrectionName(
              correctionPrefix.name,
              correctionValue,
              DesignSystemElement.margin,
            );

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
