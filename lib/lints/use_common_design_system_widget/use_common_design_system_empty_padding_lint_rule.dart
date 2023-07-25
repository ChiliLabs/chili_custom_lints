import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:chili_custom_lints/constants/lint_rule_constants.dart';
import 'package:chili_custom_lints/node_handler/widget_node_handler.dart';
import 'package:chili_custom_lints/widget_helper/src/material/edge_insets/model/edge_insets_type.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class UseCommonDesignSystemEmptyPaddingLintRule extends DartLintRule {
  UseCommonDesignSystemEmptyPaddingLintRule() : super(code: _code);

  static const _code = LintCode(
    name: LintRuleConstants.emptyPaddingErrorCode,
    problemMessage: LintRuleConstants.problemMessage,
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addIdentifier((node) {
      if (node.name != EdgeInsetsType.zero.name) return;

      reporter.reportErrorForOffset(code, node.offset, node.length);
    });
  }

  @override
  List<Fix> getFixes() => [_UseCommonDesignSystemEmptyPaddingLintRuleFix()];
}

class _UseCommonDesignSystemEmptyPaddingLintRuleFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addIdentifier((node) {
      if (node.name != EdgeInsetsType.zero.name) return;

      final correctionName = LintRuleConstants.emptyPaddingCorrectionName;
      final changeBuilder = reporter.createChangeBuilder(
        message: WidgetNodeHandler.getCorrectionMessage(correctionName),
        priority: 1,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          node.sourceRange,
          correctionName,
        );
      });
    });
  }
}
