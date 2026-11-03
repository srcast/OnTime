import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/router/routes.dart';
import 'package:on_time/tutorial/tutorial_flow.dart';
import 'package:on_time/tutorial/tutorial_ui.dart';
import 'package:on_time/utils/enums.dart';
import 'package:on_time/utils/labels.dart';

void showConfigurationsTutorial(
  BuildContext context,
  GlobalKey hourValueOption,
  TutorialFlow flow,
) {
  showTutorial(
    context,
    targets: [
      tutorialTarget(
        context,
        TutorialIdentifiers.configOption,
        hourValueOption,
        TutorialLabels.configHourValueOption,
      ),
    ],
    onFinish: () {
      flow.advance();
      context.go(
        '${Routes.configurationsPage}/${Routes.configDegineHourValuePage}',
      );
    },
    onSkip: () {
      flow.skip();
      goHomeAfterTutorial(context);
    },
  );
}

// widgets of the hour value page highlighted by the tutorial
class HourValueTutorialKeys {
  final hourValueInput = GlobalKey();
  final saveHourValue = GlobalKey();
  final specialRules = GlobalKey();
}

void showHourValueTutorial(
  BuildContext context,
  HourValueTutorialKeys keys,
  TutorialFlow flow,
) {
  showTutorial(
    context,
    targets: [
      tutorialTarget(
        context,
        TutorialIdentifiers.hourValueInput,
        keys.hourValueInput,
        TutorialLabels.configHourValueInput,
        fontSize: 18,
      ),
      tutorialTarget(
        context,
        TutorialIdentifiers.saveHourValue,
        keys.saveHourValue,
        TutorialLabels.configSaveHourValue,
        fontSize: 18,
      ),
      tutorialTarget(
        context,
        TutorialIdentifiers.specialRules,
        keys.specialRules,
        TutorialLabels.configSpecialRules,
        fontSize: 18,
      ),
    ],
    onFinish: () {
      flow.advance();
      goHomeAfterTutorial(context);
    },
    onSkip: () {
      flow.skip();
      goHomeAfterTutorial(context);
    },
  );
}
