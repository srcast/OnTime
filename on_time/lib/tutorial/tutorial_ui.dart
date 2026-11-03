import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/utils/enums.dart';
import 'package:on_time/utils/labels.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

TargetFocus tutorialTarget(
  BuildContext context,
  TutorialIdentifiers identify,
  GlobalKey key,
  String label, {
  ContentAlign align = ContentAlign.bottom,
  double radius = 16,
  double? paddingFocus,
  double? fontSize,
  AlignmentGeometry? alignSkip,
}) {
  return TargetFocus(
    identify: identify,
    keyTarget: key,
    shape: ShapeLightFocus.RRect,
    radius: radius,
    paddingFocus: paddingFocus,
    alignSkip: alignSkip,
    // dark theme -> focused widget is as dark as the shadow, the border shows it
    borderSide:
        Theme.of(context).brightness == Brightness.dark
            ? const BorderSide(color: Colors.white, width: 3)
            : null,
    contents: [
      TargetContent(
        align: align,
        child: Text(
          label.tr(),
          style: TextStyle(color: Colors.white, fontSize: fontSize),
        ),
      ),
    ],
  );
}

void showTutorial(
  BuildContext context, {
  required List<TargetFocus> targets,
  required VoidCallback onFinish,
  required VoidCallback onSkip,
}) {
  TutorialCoachMark(
    targets: targets,
    colorShadow: Colors.black54,
    textSkip: TutorialLabels.skip.tr(),
    opacityShadow: 0.6,
    onFinish: onFinish,
    onSkip: () {
      onSkip();
      return true;
    },
  ).show(context: context, rootOverlay: true); // over the bottom navigation bar
}

// tutorial finished (or skipped) outside the home page, also used to restart it
// -> configurations branch back to its first page and home showing today
Future<void> goHomeAfterTutorial(BuildContext context) async {
  context.read<HomePageVM>().goToToday();

  final shell = StatefulNavigationShell.of(context);
  shell.goBranch(2, initialLocation: true); // clean current branch
  await Future.delayed(const Duration(milliseconds: 300));
  shell.goBranch(0);
}
