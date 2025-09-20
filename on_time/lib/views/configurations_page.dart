import 'package:flutter/material.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/viewmodel/configurations_page_vm.dart';

class ConfigurationsPage extends StatelessWidget {
  const ConfigurationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = ConfigurationsPageVM();

    return SafeArea(
      minimum: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: ListView.separated(
        itemCount: vm.options.length,
        separatorBuilder: (_, _) => Divider(),
        itemBuilder: (context, index) {
          final option = vm.options[index];
          return ListTile(
            leading: Icon(option.icon, color: AppColors.labelMediumGray),
            title: Text(option.label),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => vm.openConfig(context, option.label),
          );
        },
      ),
    );
  }
}
