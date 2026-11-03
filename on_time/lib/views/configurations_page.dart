import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/models/config_option.dart';
import 'package:on_time/router/routes.dart';
import 'package:on_time/tutorial/configurations_tutorials.dart';
import 'package:on_time/tutorial/tutorial_flow.dart';
import 'package:provider/provider.dart';

class ConfigurationsPage extends StatefulWidget {
  const ConfigurationsPage({super.key});

  @override
  State<ConfigurationsPage> createState() => _ConfigurationsPageState();
}

class _ConfigurationsPageState extends State<ConfigurationsPage> {
  final _hourValueOptionKey = GlobalKey(); // highlighted by the tutorial
  bool _tutorialStarted = false;

  // tutorial at this page -> shown once (not on every build)
  void _startTutorialOnce(TutorialFlow tutorial) {
    if (!tutorial.isAt(TutorialStep.configurations)) {
      _tutorialStarted = false;
      return;
    }
    if (_tutorialStarted) return;
    _tutorialStarted = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showConfigurationsTutorial(context, _hourValueOptionKey, tutorial);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _startTutorialOnce(context.watch<TutorialFlow>());

    return SafeArea(
      minimum: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: ListView.separated(
        itemCount: configs.length,
        separatorBuilder: (_, _) => Divider(),
        itemBuilder: (context, index) {
          final option = configs[index];
          return ListTile(
            key: index == 0 ? _hourValueOptionKey : null,
            leading: Icon(option.icon, color: context.colors.titleText),
            title: Text(option.label.tr()),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap:
                () =>
                    context.go('${Routes.configurationsPage}/${option.route}'),
          );
        },
      ),
    );
  }
}
