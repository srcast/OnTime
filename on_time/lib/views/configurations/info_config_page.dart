import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/utils/labels.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InfoConfigPage extends StatefulWidget {
  const InfoConfigPage({super.key});

  @override
  State<InfoConfigPage> createState() => _InfoConfigPage();
}

class _InfoConfigPage extends State<InfoConfigPage> {
  String _version = "";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Labels.configsInfo),
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
              Labels.appVersion,
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
              Labels.lastUpdate,
              style: TextStyle(fontSize: 22, color: context.colors.titleText),
            ),
            const SizedBox(height: 6),
            Text(
              Labels.lastUpdateDate,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: context.colors.focusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
