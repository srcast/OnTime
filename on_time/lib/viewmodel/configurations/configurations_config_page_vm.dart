import 'package:flutter/material.dart';
import 'package:on_time/helpers/app_feedback.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/utils/enums.dart';

class ConfigConfigurationsPageVM extends ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.system;
  LanguageOptions _language = LanguageOptions.english;
  bool _isLoaded = false;
  final ConfigsService _configsService;

  ConfigConfigurationsPageVM(this._configsService) {
    _getConfigs();
  }

  // Public Properties
  AppThemeMode get themeMode => _themeMode;

  LanguageOptions get language => _language;

  bool get isLoaded => _isLoaded;

  ThemeMode get flutterThemeMode {
    return switch (_themeMode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };
  }

  Locale get appLanguage {
    return GenericHelper.getLocaleFromDBLang(_language);
  }
  //

  void _getConfigs() async {
    try {
      var configs = await _configsService.getConfigs();

      if (configs != null) {
        _themeMode = GenericHelper.getAppThemefromString(configs.themeMode);
        _language = GenericHelper.getALanguageOptfromString(configs.language);
      }

      _isLoaded = true;
      notifyListeners();
    } catch (e, s) {
      // not loaded -> keeps the language the app started with
      AppFeedback.logError('ConfigConfigurationsPageVM._getConfigs', e, s);
    }
  }

  // state only changes after saving -> screen never shows an option that wasn't saved
  void setTheme(AppThemeMode themeMode) async {
    try {
      await _configsService.setTheme(themeMode);
      _themeMode = themeMode;
      notifyListeners();
    } catch (e, s) {
      AppFeedback.showError('ConfigConfigurationsPageVM.setTheme', e, s);
    }
  }

  void setLanguage(LanguageOptions lang) async {
    try {
      await _configsService.setLanguage(lang);
      _language = lang;
      notifyListeners();
    } catch (e, s) {
      AppFeedback.showError('ConfigConfigurationsPageVM.setLanguage', e, s);
    }
  }
}
