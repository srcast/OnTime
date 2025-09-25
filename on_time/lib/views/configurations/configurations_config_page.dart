import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/enums.dart';
import 'package:on_time/utils/labels.dart';
import 'package:on_time/viewmodel/configurations/configurations_config_page_vm.dart';
import 'package:provider/provider.dart';

class ConfigsConfigurationsPage extends StatelessWidget {
  const ConfigsConfigurationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConfigConfigurationsPageVM>();

    return Scaffold(
      appBar: AppBar(
        title: Text(Labels.configurationsTab),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: context.colors.scaffoldBackground,
        foregroundColor: context.colors.titleText,
        elevation: 0,
      ),
      backgroundColor: context.colors.scaffoldBackground,
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            Labels.theme,
            style: TextStyle(fontSize: 22, color: context.colors.titleText),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: context.colors.scaffoldBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildThemeOption(
                  context,
                  title: AppThemeOptions.automatic,
                  value: AppThemeMode.system,
                  groupValue: vm.themeMode,
                  onChanged: vm.setTheme,
                ),
                _buildThemeOption(
                  context,
                  title: AppThemeOptions.light,
                  value: AppThemeMode.light,
                  groupValue: vm.themeMode,
                  onChanged: vm.setTheme,
                ),
                _buildThemeOption(
                  context,
                  title: AppThemeOptions.dark,
                  value: AppThemeMode.dark,
                  groupValue: vm.themeMode,
                  onChanged: vm.setTheme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required AppThemeMode value,
    required AppThemeMode groupValue,
    required Function(AppThemeMode) onChanged,
  }) {
    return RadioListTile<AppThemeMode>(
      value: value,
      groupValue: groupValue,
      onChanged: (val) {
        if (val != null) onChanged(val);
      },
      title: Text(
        title,
        style: TextStyle(
          color: context.colors.defaultText,
          fontWeight: FontWeight.w500,
        ),
      ),
      activeColor: context.colors.focusColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
