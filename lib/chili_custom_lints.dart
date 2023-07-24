// This is the entrypoint of our custom linter
import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => _ChiliCustomLinter();

class _ChiliCustomLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [];
}
