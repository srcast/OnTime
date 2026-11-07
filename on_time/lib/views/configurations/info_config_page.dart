import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/helpers/app_feedback.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/models/global_data.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/tutorial/tutorial_flow.dart';
import 'package:on_time/tutorial/tutorial_ui.dart';
import 'package:on_time/utils/labels.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class InfoConfigPage extends StatefulWidget {
  const InfoConfigPage({super.key});

  @override
  State<InfoConfigPage> createState() => _InfoConfigPage();
}

class _InfoConfigPage extends State<InfoConfigPage> {
  String _version = "";
  int _tapCount = 0;

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  Future<void> _onSecretTap() async {
    _tapCount++;

    if (_tapCount == 5) {
      _tapCount = 0;
      _showSecretCodeDialog();
    }
  }

  Future<void> _showSecretCodeDialog() async {
    final controller = TextEditingController();
    var secretCode =
        '${DateTime.now().minute}${DateTime.now().hour + DateTime.now().minute + 17}';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              child: Text(Labels.ok.tr()),
              onPressed: () async {
                if (controller.text == secretCode) {
                  Navigator.pop(context);
                  try {
                    await _disableAds();
                  } catch (e, s) {
                    AppFeedback.showError('InfoConfigPage._disableAds', e, s);
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(Labels.adsDisabled.tr())),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _disableAds() async {
    GlobalData.showInterstitialAds = false;
    await context.read<ConfigsService>().updateShowAds(
      GlobalData.showInterstitialAds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Labels.configsInfo.tr()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: context.colors.scaffoldBackground,
        foregroundColor: context.colors.titleText,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Labels.appVersion.tr(),
              style: TextStyle(fontSize: 22, color: context.colors.titleText),
            ),
            const SizedBox(height: 6),
            Text(
              _version.isEmpty ? "..." : "v$_version",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: context.colors.focusColor,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              Labels.lastUpdate.tr(),
              style: TextStyle(fontSize: 22, color: context.colors.titleText),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _onSecretTap,
              child: Text(
                Labels.lastUpdateDate.tr(),
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: context.colors.focusColor,
                ),
              ),
            ),
            const SizedBox(height: 40),
            OutlinedButton.icon(
              onPressed: _replayTutorial,
              icon: Icon(
                Icons.school_outlined,
                color: context.colors.titleText,
              ),
              label: Text(
                TutorialLabels.replay.tr(),
                style: TextStyle(color: context.colors.titleText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // starts again at the home page
  Future<void> _replayTutorial() async {
    await context.read<TutorialFlow>().restart();
    if (mounted) await goHomeAfterTutorial(context);
  }
}
