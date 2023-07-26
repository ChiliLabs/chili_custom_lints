import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

// This lint should be overriden by this: https://dart.dev/tools/linter-rules/avoid_types_on_closure_parameters
class OmitFunctionParamsTypesRule extends DartLintRule {
  OmitFunctionParamsTypesRule() : super(code: _code);

  static final _code = LintCode(
    name: 'omit_explicit_parameters_types',
    problemMessage: 'Omit explicit parameters types',
    correctionMessage:
        'Omit explicit parameters types, e.g. from `void foo(int a, String b) { }` to `void foo(a, b) { }`',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addNamedExpression((node) {
      final expression = node.expression;
      if (expression is FunctionExpression) {
        final params = expression.parameters?.parameters ?? [];
        for (var param in params) {
          if (param is SimpleFormalParameter) {
            if (param.type != null) {
              reporter.reportErrorForNode(_code, param);
            }
          }
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [_OmitFunctionParamsTypesFix()];
}

class _OmitFunctionParamsTypesFix extends DartFix {
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

      final expression = node.expression;
      if (expression is! FunctionExpression) {
        return;
      }

      final params = expression.parameters?.parameters ?? [];
      for (var param in params) {
        if (param is SimpleFormalParameter) {
          final type = param.type;
          if (type != null) {
            final changeBuilder = reporter.createChangeBuilder(
              message: 'Omit explicit parameters types',
              priority: 1,
            );
            changeBuilder.addDartFileEdit((builder) {
              builder.addSimpleReplacement(
                SourceRange(
                  type.offset,
                  type.length + 1,
                ),
                '',
              );
            });
          }
        }
      }
    });
  }
}
