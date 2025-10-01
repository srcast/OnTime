import 'package:flutter/material.dart';
import 'package:on_time/utils/labels.dart';

class ConfigOption {
  const ConfigOption({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

final configs = [
  ConfigOption(label: Labels.configsListHourValue, icon: Icons.euro),
  ConfigOption(label: Labels.configurationsTab, icon: Icons.settings),
  ConfigOption(label: Labels.configsInfo, icon: Icons.info_outline),
  // ConfigOption(
  //   label: Labels.configsListNotifications,
  //   icon: Icons.notifications,
  // ),
];
