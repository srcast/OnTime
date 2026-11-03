import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/router/routes.dart';
import 'package:on_time/tutorial/tutorial_flow.dart';
import 'package:on_time/tutorial/tutorial_ui.dart';
import 'package:on_time/utils/enums.dart';
import 'package:on_time/utils/labels.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomeTutorialKeys {
  final checkIn = GlobalKey();
  final listItem = GlobalKey();
  final listItemContent = GlobalKey();
  final pointEdit = GlobalKey();
  final pointDelete = GlobalKey();
}

Ponto homeTutorialExamplePoint() {
  final now = DateTime.now();
  return Ponto(
    id: 1,
    date: DateTime(now.year, now.month, now.day, 10),
    sessionId: '1',
    getIn: true,
  );
}

void showHomeTutorial(
  BuildContext context,
  HomeTutorialKeys keys,
  TutorialFlow flow,
) {
  showTutorial(
    context,
    targets: [
      tutorialTarget(
        context,
        TutorialIdentifiers.checkIn,
        keys.checkIn,
        TutorialLabels.point,
        align: ContentAlign.top,
        fontSize: 18,
        alignSkip: Alignment.topRight,
      ),
      tutorialTarget(
        context,
        TutorialIdentifiers.listItem,
        keys.listItem,
        TutorialLabels.pointList,
      ),
    ],
    onFinish: () => _showItemActions(context, keys, flow),
    onSkip: flow.skip,
  );
}

Future<void> _showItemActions(
  BuildContext context,
  HomeTutorialKeys keys,
  TutorialFlow flow,
) async {
  if (keys.listItem.currentContext != null) {
    await Scrollable.ensureVisible(
      keys.listItem.currentContext!,
      duration: const Duration(milliseconds: 300),
      alignment: 0.4,
    );
  }

  await Future.delayed(const Duration(milliseconds: 200));
  if (!context.mounted) return;

  final itemContext = keys.listItemContent.currentContext;
  final slidable = itemContext == null ? null : Slidable.of(itemContext);
  if (slidable != null) {
    slidable.openEndActionPane(duration: const Duration(milliseconds: 300));
    await Future.delayed(const Duration(milliseconds: 360));
  }

  if (!context.mounted) return;

  showTutorial(
    context,
    targets: [
      tutorialTarget(
        context,
        TutorialIdentifiers.editPoint,
        keys.pointEdit,
        TutorialLabels.pointEdit,
        radius: 8,
        paddingFocus: 6,
      ),
      tutorialTarget(
        context,
        TutorialIdentifiers.deletePoint,
        keys.pointDelete,
        TutorialLabels.pointDelete,
        radius: 8,
        paddingFocus: 6,
      ),
    ],
    onFinish: () {
      flow.advance();
      context.go(Routes.configurationsPage);
    },
    onSkip: flow.skip,
  );
}
