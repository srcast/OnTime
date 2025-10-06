import 'package:flutter/material.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/utils/enums.dart';

class ConfigConfigurationsPageVM extends ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.system;
  LanguageOptions _language = LanguageOptions.english;
  late ConfigsService _configsService;

  ConfigConfigurationsPageVM(this._configsService) {
    getConfigs();
  }

  // Public Properties
  AppThemeMode get themeMode => _themeMode;

  LanguageOptions get language => _language;

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

  void getConfigs() async {
    var configs = await _configsService.getConfigs();

    if (configs != null) {
      _themeMode = GenericHelper.getAppThemefromString(configs.themeMode);
      _language = GenericHelper.getALanguageOptfromString(configs.language);
    }

    notifyListeners();
  }

  void setTheme(AppThemeMode themeMode) async {
    _themeMode = themeMode;
    await _configsService.setTheme(themeMode);
    notifyListeners();
  }

  void setLanguage(LanguageOptions lang) async {
    _language = lang;
    await _configsService.setLanguage(lang);
    notifyListeners();
  }
}
