import 'package:flutter/material.dart';
import 'package:on_time/router/routes.dart';
import 'package:on_time/utils/labels.dart';

class ConfigOption {
  const ConfigOption({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route; // relative to Routes.configurationsPage
}

final configs = [
  ConfigOption(
    label: Labels.configsListHourValue,
    icon: Icons.payments_outlined,
    route: Routes.configDegineHourValuePage,
  ),
  ConfigOption(
    label: Labels.configurationsTab,
    icon: Icons.settings,
    route: Routes.configConfigurationsPage,
  ),
  ConfigOption(
    label: Labels.configsInfo,
    icon: Icons.info_outline,
    route: Routes.configInfoPage,
  ),
];
