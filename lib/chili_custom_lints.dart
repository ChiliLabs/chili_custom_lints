// This is the entrypoint of our custom linter
import 'package:chili_custom_lints/lints/omit_explicit_parameters_types/omit_explicit_parameters_types_rule.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => _ChiliCustomLinter();

class _ChiliCustomLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) =>
      [OmitFunctionParamsTypesRule()];
}
