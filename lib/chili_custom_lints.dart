// This is the entrypoint of our custom linter
import 'package:chili_custom_lints/lints/rename_unused_params_to_underscore/rename_unused_params_to_underscore_rule.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => _ChiliCustomLinter();

class _ChiliCustomLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        RenameUnusedParamsToUnderscoreRule(),
      ];
}
