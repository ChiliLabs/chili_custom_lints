import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class NamedExpressionParameterUsageVisitor extends RecursiveAstVisitor<void> {
  final ParamNameVisitorCallback onVisit;

  const NamedExpressionParameterUsageVisitor({
    required this.onVisit,
  });

  @override
  void visitNamedExpression(NamedExpression node) {
    final expression = node.expression;

    if (expression is! FunctionExpression) {
      return;
    }

    final parameters = expression.parameters;

    if (parameters == null) {
      return;
    }

    var renameTo = '_';
    for (FormalParameter parameter in parameters.parameters) {
      if (parameter is SimpleFormalParameter) {
        final paramNameToken = parameter.name;
        if (paramNameToken == null) {
          continue;
        }

        var paramName = paramNameToken.lexeme;
        if (_isValidName(paramName)) {
          renameTo += '_';
        } else if (_parameterIsUnused(paramName, expression.body)) {
          onVisit.call(paramNameToken, renameTo);
        }
      }
    }
  }

  bool _isValidName(String name) => name.replaceAll('_', '').isEmpty;

  bool _parameterIsUnused(String parameterName, FunctionBody body) {
    var visitor = _ParameterUsageVisitor(
      parameterName: parameterName,
    );
    body.visitChildren(visitor);
    return !visitor.parameterIsUsed;
  }
}

class _ParameterUsageVisitor extends RecursiveAstVisitor<void> {
  final String parameterName;
  bool parameterIsUsed = false;

  _ParameterUsageVisitor({
    required this.parameterName,
  });

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    if (node.token.lexeme == parameterName) {
      parameterIsUsed = true;
    }
  }
}

typedef ParamNameVisitorCallback = void Function(Token token, String renameTo);
