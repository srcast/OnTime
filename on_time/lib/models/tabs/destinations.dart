import 'package:flutter/material.dart';
import 'package:on_time/utils/labels.dart';

class Destination {
  const Destination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

const destinations = [
  Destination(label: Labels.homeTab, icon: Icons.home),
  Destination(label: Labels.analysisTab, icon: Icons.bar_chart),
  Destination(label: Labels.consigurationsTab, icon: Icons.settings),
];
