import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/layout/themes.dart';
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
        title: Text(Labels.configurationsTab.tr()),
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
            Labels.theme.tr(),
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
                  title: AppThemeOptions.automatic.tr(),
                  value: AppThemeMode.system,
                  groupValue: vm.themeMode,
                  onChanged: vm.setTheme,
                ),
                _buildThemeOption(
                  context,
                  title: AppThemeOptions.light.tr(),
                  value: AppThemeMode.light,
                  groupValue: vm.themeMode,
                  onChanged: vm.setTheme,
                ),
                _buildThemeOption(
                  context,
                  title: AppThemeOptions.dark.tr(),
                  value: AppThemeMode.dark,
                  groupValue: vm.themeMode,
                  onChanged: vm.setTheme,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            Labels.language.tr(),
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
                _buildLanguageOption(
                  context,
                  title: AppLanguageOptions.english.tr(),
                  value: LanguageOptions.english,
                  groupValue: vm.language,
                  onChanged: vm.setLanguage,
                ),
                _buildLanguageOption(
                  context,
                  title: AppLanguageOptions.portuguese.tr(),
                  value: LanguageOptions.portuguese,
                  groupValue: vm.language,
                  onChanged: vm.setLanguage,
                ),
                _buildLanguageOption(
                  context,
                  title: AppLanguageOptions.french.tr(),
                  value: LanguageOptions.french,
                  groupValue: vm.language,
                  onChanged: vm.setLanguage,
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
    return Theme(
      data: Theme.of(context).copyWith(
        radioTheme: RadioThemeData(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
            // Se estiver selecionado → usa a tua cor
            if (states.contains(WidgetState.selected)) {
              return context.colors.focusColor;
            }
            // Caso contrário → usa a cor padrão (preta/branca)
            return null;
          }),
        ),
      ),
      child: RadioMenuButton<AppThemeMode>(
        value: value,
        groupValue: groupValue,
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: TextStyle(
              color: context.colors.defaultText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // activeColor: context.colors.focusColor,
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String title,
    required LanguageOptions value,
    required LanguageOptions groupValue,
    required Function(LanguageOptions) onChanged,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        radioTheme: RadioThemeData(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
            // Se estiver selecionado → usa a tua cor
            if (states.contains(WidgetState.selected)) {
              return context.colors.focusColor;
            }
            // Caso contrário → usa a cor padrão (preta/branca)
            return null;
          }),
        ),
      ),
      child: RadioMenuButton<LanguageOptions>(
        value: value,
        groupValue: groupValue,
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: TextStyle(
              color: context.colors.defaultText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // activeColor: context.colors.focusColor,
      ),
    );
  }
}
