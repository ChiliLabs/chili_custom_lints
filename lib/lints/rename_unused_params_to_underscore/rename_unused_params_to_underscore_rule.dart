import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:chili_custom_lints/lints/rename_unused_params_to_underscore/named_expression_parameter_usage_visitor.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// A lint that renames unused parameters to _.
/// There is no limit on the number of parameters that can be renamed.
/// Example:
/// ```dart
/// // Before
/// ListView.builder(
///  itemBuilder: (context, index) {
///  return Text('Hello');
///  });
///  // After
///  ListView.builder(
///  itemBuilder: (_, __) {
///  return Text('Hello');
///  });
class RenameUnusedParamsToUnderscoreRule extends DartLintRule {
  RenameUnusedParamsToUnderscoreRule() : super(code: _code);

  static final _code = LintCode(
    name: 'rename_unused_params_to_underscore',
    problemMessage:
        'The convention is to use _ as a prefix for unused parameters',
    correctionMessage:
        'Rename unused parameters to _ to improve readability, e.g. from `itemBuilder: (context, index) { }` to `itemBuilder: (_, __) { }`',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addNamedExpression((node) {
      node.expression.visitChildren(
        NamedExpressionParameterUsageVisitor(
          onVisit: (token, _) {
            reporter.reportErrorForToken(_code, token);
          },
        ),
      );
    });
  }

  @override
  List<Fix> getFixes() => [_RenameUnusedParamsToUnderscoreFix()];
}

class _RenameUnusedParamsToUnderscoreFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addNamedExpression((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) {
        return;
      }

      node.expression.visitChildren(
        NamedExpressionParameterUsageVisitor(
          onVisit: (
            token,
            renameTo,
          ) {
            final changeBuilder = reporter.createChangeBuilder(
              message: 'Rename to $renameTo',
              priority: 1,
            );
            changeBuilder.addDartFileEdit((builder) {
              builder.addSimpleReplacement(
                SourceRange(
                  token.offset,
                  token.length,
                ),
                renameTo,
              );
            });
          },
        ),
      );
    });
  }
}
