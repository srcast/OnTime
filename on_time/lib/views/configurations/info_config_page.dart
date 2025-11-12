import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/database/locator.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/models/global_data.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/utils/labels.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
                  await _disableAds();
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
    await locator<ConfigsService>().updateShowAds(
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
          ],
        ),
      ),
    );
  }
}
