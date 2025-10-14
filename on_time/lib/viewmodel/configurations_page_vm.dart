import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/database/locator.dart';
import 'package:on_time/models/config_option.dart';
import 'package:on_time/router/routes.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/utils/enums.dart';
import 'package:on_time/utils/labels.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ConfigurationsPageVM {
  late List<ConfigOption> _options;
  late ConfigsService _configsService;
  bool _tutorialOngoing = false;

  ConfigurationsPageVM() {
    _options = configs;
    _configsService = locator<ConfigsService>();
  }

  // public props

  List<ConfigOption> get options => _options;

  final GlobalKey keyConfigs = GlobalKey();
  bool tutorialHasStarted = false;

  //

  void checkTutorial(BuildContext context) async {
    if (!_tutorialOngoing) {
      final uri = Uri.parse(GoRouterState.of(context).uri.toString());
      final startTutorial = uri.queryParameters['startTutorial'] == 'true';

      if (startTutorial) {
        _tutorialOngoing = true;
        _startTutorial(context);
      }
    }
  }

  void _startTutorial(BuildContext context) {
    TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: TutorialIdentifiers.configOption,
          keyTarget: keyConfigs,
          shape: ShapeLightFocus.RRect,
          radius: 16,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                TutorialLabels.configHourValueOption.tr(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
      colorShadow: Colors.black54,
      textSkip: TutorialLabels.skip.tr(),
      opacityShadow: 0.6,
      onSkip: () {
        _cancelTutorial();
        return true;
      },
      onFinish: () => _navigateToHourValuePage(context),
    ).show(context: Overlay.of(context).context);
  }

  Future<void> _cancelTutorial() async {
    _tutorialOngoing = false;
    await _configsService.updateHasSeenTutorial(true);
  }

  bool _navigateToHourValuePage(BuildContext context) {
    context.push('${Routes.configDegineHourValuePage}?startTutorial=true');
    _tutorialOngoing = false;
    return false;
  }

  void openConfig(BuildContext context, String option) {
    switch (option) {
      case Labels.configsListHourValue:
        context.push(Routes.configDegineHourValuePage);
        break;

      case Labels.configurationsTab:
        context.push(Routes.configConfigurationsPage);
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
