import 'package:flutter/material.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/utils/enums.dart';

class ConfigConfigurationsPageVM extends ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.system;
  late ConfigsService _configsService;

  ConfigConfigurationsPageVM(this._configsService) {
    getTheme();
  }

  // Public Properties
  AppThemeMode get themeMode => _themeMode;

  ThemeMode get flutterThemeMode {
    return switch (_themeMode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };
  }
  //

  void getTheme() async {
    _themeMode = await _configsService.getTheme();
    notifyListeners();
  }

  void setTheme(AppThemeMode themeMode) async {
    _themeMode = themeMode;
    await _configsService.setTheme(themeMode);
    notifyListeners();
  }
}
