import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/models/config_option.dart';
import 'package:on_time/router/routes.dart';
import 'package:on_time/utils/labels.dart';

class ConfigurationsPageVM {
  late List<ConfigOption> _options;
  ConfigurationsPageVM() {
    _options = configs;
  }

  List<ConfigOption> get options => _options;

  void openConfig(BuildContext context, String option) {
    switch (option) {
      case Labels.configsListHourValue:
        context.push(Routes.configDegineHourValuePage);
        break;

      case Labels.configsInfo:
        context.push(Routes.configInfoPage);
        break;

      case Labels.configsListNotifications:
        break;

      default:
        break;
    }
  }
}
