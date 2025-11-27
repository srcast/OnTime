import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/helpers/tutorial_helper.dart';
import 'package:on_time/models/config_option.dart';
import 'package:on_time/router/routes.dart';
import 'package:on_time/utils/enums.dart';
import 'package:on_time/utils/labels.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ConfigurationsPageVM {
  late List<ConfigOption> _options;

  ConfigurationsPageVM() {
    _options = configs;
  }

  // public Properties

  List<ConfigOption> get options => _options;

  final GlobalKey keyConfigs = GlobalKey();
  bool tutorialHasStarted = false;

  //

  void checkTutorial(BuildContext context) async {
    if (!TutorialHelper.hasSeenTutorial &&
        !TutorialHelper.tutorialOngoingConfigsPage) {
      TutorialHelper.tutorialOngoingConfigsPage = true;
      _startTutorial(context);
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
        _cancelTutorial(context);
        return true;
      },
      onFinish: () => _navigateToHourValuePage(context),
    ).show(context: Overlay.of(context).context);
  }

  Future<void> _cancelTutorial(BuildContext context) async {
    await TutorialHelper.cancelTutorial();
    context.read<HomePageVM>().initPage();
    final shell = StatefulNavigationShell.of(context);
    shell.goBranch(0);
  }

  bool _navigateToHourValuePage(BuildContext context) {
    openConfig(context, Labels.configsListHourValue);
    TutorialHelper.tutorialOngoing = false;
    return false;
  }

  void openConfig(BuildContext context, String option) {
    switch (option) {
      case Labels.configsListHourValue:
        context.go(
          '${Routes.configurationsPage}/${Routes.configDegineHourValuePage}',
        );
        break;

      case Labels.configurationsTab:
        context.go(
          '${Routes.configurationsPage}/${Routes.configConfigurationsPage}',
        );
        break;

      case Labels.configsInfo:
        context.go('${Routes.configurationsPage}/${Routes.configInfoPage}');
        break;

      case Labels.configsListNotifications:
        break;

      default:
        break;
    }
  }
}
