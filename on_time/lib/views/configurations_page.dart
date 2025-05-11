import 'package:flutter/material.dart';

class ConfigurationsPage extends StatelessWidget {
  final List<Map<String, dynamic>> settingsOptions = [
    {'label': 'Definir valor/hora', 'icon': Icons.euro},
    {'label': 'Valor/hora dias especiais', 'icon': Icons.star},
    {'label': 'Gerar relatório PDF', 'icon': Icons.picture_as_pdf},
    {'label': 'Definir horário padrão', 'icon': Icons.access_time},
    {'label': 'Notificações', 'icon': Icons.notifications},
    {'label': 'Sobre a app', 'icon': Icons.info},
  ];

  ConfigurationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        itemCount: settingsOptions.length,
        separatorBuilder: (_, __) => Divider(),
        itemBuilder: (context, index) {
          final item = settingsOptions[index];
          return ListTile(
            leading: Icon(item['icon'], color: Colors.blue),
            title: Text(item['label']),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          );
        },
      ),
    );
  }
}
