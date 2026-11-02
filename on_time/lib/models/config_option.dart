import 'package:flutter/material.dart';
import 'package:on_time/utils/labels.dart';

class ConfigOption {
  const ConfigOption({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

final configs = [
  ConfigOption(
    label: Labels.configsListHourValue,
    icon: Icons.payments_outlined,
  ),
  ConfigOption(label: Labels.configurationsTab, icon: Icons.settings),
  ConfigOption(label: Labels.configsInfo, icon: Icons.info_outline),
];
