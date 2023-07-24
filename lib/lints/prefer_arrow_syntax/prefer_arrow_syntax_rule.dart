import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class PreferArrowSyntaxRule extends DartLintRule {
  PreferArrowSyntaxRule() : super(code: _code);

  static final _code = LintCode(
    name: 'prefer_arrow_syntax',
    problemMessage: '⚠️ Warning: this lint is under construction and is experimental. ⚠️ Prefer arrow syntax for single line functions',
    correctionMessage:
        'Replace with arrow syntax, e.g. from void foo() { return 1; } to void foo() => 1;',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addFunctionDeclaration((node) {
      _reportError(body: node.functionExpression.body, reporter: reporter);
    });

    context.registry.addMethodDeclaration((node) {
      _reportError(body: node.body, reporter: reporter);
    });
  }

  void _reportError({
    required FunctionBody body,
    required ErrorReporter reporter,
  }) {
    if (body is BlockFunctionBody && body.block.statements.length == 1) {
      final statement = body.block.statements.first;
      reporter.reportErrorForOffset(
        code,
        statement.offset,
        statement.length,
      );
    }
  }

  @override
  List<Fix> getFixes() => [_PreferArrowSyntaxFix()];
}

class _PreferArrowSyntaxFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addFunctionDeclaration((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) {
        return;
      }
      _addFix(body: node.functionExpression.body, reporter: reporter);
    });

    context.registry.addMethodDeclaration((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) {
        return;
      }
      _addFix(body: node.body, reporter: reporter);
    });
  }

  void _addFix({
    required FunctionBody body,
    required ChangeReporter reporter,
  }) {
    if (body is BlockFunctionBody && body.block.statements.length == 1) {
      final statement = body.block.statements.first;
      final source = statement.toSource().replaceAll('return', '').trim();

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Convert to arrow syntax',
        priority: 10,
      );
      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          SourceRange(
            body.offset,
            body.length,
          ),
          '=> $source',
        );
      });
    }
  }
}
